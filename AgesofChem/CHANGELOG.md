# Ages of Chemistry — Changelog

## v0.9.1 (2026-02-21)

### Text & Lore Updates — The Accuracy & Quality Pass
- **Scientific Precision:** Corrected reaction descriptions to be technically accurate (e.g., specifying carbothermic reduction produces CO gas instead of CO₂, and matching exact electrolysis stoichiometry).
- **Historical Context:** Credited diverse global cultures (e.g., Ancient Indian Wootz steel, Jōmon and Nok pottery, Islamic Golden Age alembic refinement, ancient Zawar zinc metallurgists).
- **Writing Polish:** Improved text flow and fixed grammar across dozens of elements and achievements without altering the underlying gameplay discovery logic.
## v0.9.0 (2026-02-20)

### Engine Optimizations
- **O(1) Data Architecture:** Refactored the core element lookup engines (`isExhausted` and `getRecipesFor`) to use precomputed lookup caches. This eliminates an O(N²) CPU spiking issue (over 48,000 loop iterations) that occurred on every keystroke in the search box.
- **Eliminated DOM Thrashing:** Rebuilt the sidebar `renderElementList` function. Instead of completely destroying and recreating hundreds of HTML nodes on every category click or search stroke (causing massive garbage collection stutter), the app now caches DOM nodes exactly once. Filtering is now handled instantly and natively by toggling CSS `display` and sorting via Flexbox `order`.

## v0.8.9 (2026-02-20)

### Audio — Multi-Track BGM System
- **New Track**: Added "Ascension" (an uplifting, forward-moving BGM track inspired by the finale of Sogno di Volare) to the background music rotation.
- **Track Selector**: Added a long-press quick action to the Sound (🔊) button to manually skip to the next track.
- **Track Selection UI**: Added a brief toast notification showing the track name when music starts or when switching tracks manually.

### UI & Layout — Desktop Sidebar
- **Wider Sidebar**: The element sidebar on desktop is now 60px wider (480px).
- **Strict 2-Column Packing**: Element buttons now tightly pack into a clean 2-column grid natively without unpredictable text-wrapping, severely reducing unnecessary vertical scrolling on desktop.

## v0.8.8 (2026-02-20)

### UI & Layout — Sidebar Overhaul
- **Desktop Sidebar:** Expanded width from 320px to 420px. Categories ("Ages") are now separated into their own persistent vertical column on the left side of the sidebar, ensuring they are always visible and clickable without horizontal scrolling.
- **Mobile Sidebar:** Compacted the horizontal category tabs. Reduced padding, font size, and gap allow all unlocked categories to stack closely together in wrapped rows, ensuring they remain entirely visible simultaneously without crushing the vertical workspace of the element list.

## v0.8.7 (2026-02-20)

### Branding & About
- About modal now introduces **LemChem** as the project home with **Jessy M. Lemieux, Ph.D.** credited as creator
- Mentions Ages of Chemistry as the flagship project with more games on the way
- Donate button updated to "☕ Donate on Ko-fi"

### Achievements — Quality Pass
- Achievement counter corrected from 25 to **26** (Quicksilver was missing from the count)
- **Descriptions** tightened and polished across all 26 achievements
- Removed all em dashes from achievement text
- All **hints now point forward** to help players through upcoming bottlenecks, rather than describing the achievement just earned

### Hints — Bottleneck Coverage
Reworked hints to address unintuitive combinations players commonly get stuck on:

- **Midas Touch** → now hints at cinnabar (`sulfur+earth`) and silver ore (`stone+furnace`)
- **Halfway There** → now hints at fossil fuels (`swamp/peat+pressure`) and fermentation (`fruit+water`)
- **Black Powder** → now hints at static electricity (`glass+fiber`), the gateway to the Enlightenment age
- **Davy's Legacy** → now hints at bauxite (`clay+water`) for the aluminum path, alongside silicon
- **Feed the World** → now hints at refrigeration (`ammonia+pressure`) and liquid air, the gateway to noble gases
- **Noble Pursuit** → now hints at semiconductors (`silicon+phosphorus`) and plastics (`methane+chlorine`)
- Fixed duplicate hints where Halfway There, Black Powder, and Spark of Genius all previously pointed to the same combo

### Version
- Bumped to v0.8.7 in workspace footer and About modal
