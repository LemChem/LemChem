# deploy.ps1
param (
    [string]$envFile = ".env"
)

if (-not (Test-Path $envFile)) {
    Write-Host "Error: .env file not found. Please copy .env.template to .env and fill in your details." -ForegroundColor Red
    exit 1
}

# Load credentials from .env safely
$envVars = @{}
Get-Content $envFile | Where-Object { $_ -match "^(?!#)(.+?)=(.*)$" } | ForEach-Object {
    $name, $value = $_ -split '=', 2
    $envVars[$name.Trim()] = $value.Trim()
}

$ftpServer = $envVars["FTP_SERVER"]
if (-not $ftpServer.EndsWith("/")) { $ftpServer += "/" }
$ftpUser = $envVars["FTP_USER"]
$ftpPass = $envVars["FTP_PASS"]
$remoteBaseDir = $envVars["FTP_REMOTE_DIR"]
if ($remoteBaseDir -and -not $remoteBaseDir.EndsWith("/")) { $remoteBaseDir += "/" }

$credentials = New-Object System.Net.NetworkCredential($ftpUser, $ftpPass)

function Create-RemoteDir {
    param ([string]$remoteUri)
    try {
        $request = [System.Net.FtpWebRequest]::Create($remoteUri)
        $request.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
        $request.Credentials = $credentials
        $request.EnableSsl = $true
        $response = $request.GetResponse()
        $response.Close()
    }
    catch {
        # Directory likely already exists, ignore
    }
}

function Upload-File {
    param ([string]$localPath, [string]$remoteUri)
    Write-Host "Uploading: $(Split-Path $localPath -Leaf) -> $remoteUri"
    try {
        $request = [System.Net.FtpWebRequest]::Create($remoteUri)
        $request.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
        $request.Credentials = $credentials
        $request.EnableSsl = $true
        $request.UseBinary = $true
        $request.KeepAlive = $false
        
        $content = [System.IO.File]::ReadAllBytes($localPath)
        $request.ContentLength = $content.Length
        
        $requestStream = $request.GetRequestStream()
        $requestStream.Write($content, 0, $content.Length)
        $requestStream.Close()
        
        $response = $request.GetResponse()
        $response.Close()
        Write-Host "[OK] Success" -ForegroundColor Green
    }
    catch {
        Write-Host "[ERROR] Failed uploading $localPath : $_" -ForegroundColor Red
    }
}

function Sync-Directory {
    param ([string]$localDir, [string]$remoteUri)
    
    # Ensure remote directory exists
    Create-RemoteDir -remoteUri $remoteUri
    
    $items = Get-ChildItem -Path $localDir
    foreach ($item in $items) {
        # Skip git, env, and workflows
        if ($item.Name -match "^(\.git|\.env|\.agents|deploy\.ps1|Version History)$") { continue }
        
        $itemRemoteUri = $remoteUri + $item.Name
        if ($item.PSIsContainer) {
            Sync-Directory -localDir $item.FullName -remoteUri ($itemRemoteUri + "/")
        }
        else {
            Upload-File -localPath $item.FullName -remoteUri $itemRemoteUri
        }
    }
}

Write-Host "Starting Secure FTP Deployment to $ftpServer..." -ForegroundColor Cyan

# Start sync from the current directory (LemChem root)
$baseUri = "ftp://" + $ftpServer + $remoteBaseDir
Sync-Directory -localDir $PWD.Path -remoteUri $baseUri

Write-Host "Deployment Complete!" -ForegroundColor Cyan
