# Dungeon Dealer Roadmap

Source of truth for implementation progress. Update after every meaningful commit. Status labels: **Not started**, **In progress**, **Implemented**, **Verified**. “Implemented” means code exists; “Verified” means a relevant test or build passed.

## Current status
- [x] Repository design contract and AI instructions written.
- [x] Initial Godot project and playable prototype source added.
- [x] Godot headless validation and main-scene smoke test passed in GitHub Actions (commit `160dc757fd969f2e7786f5d3b9bc362d7221be50`).
- [ ] Android APK produced and artifact verified; latest export attempt is still running, and no APK artifact is confirmed.
- **Current phase:** Phase 1 — playable prototype.
- **Next step:** Confirm the Android export workflow result. If export fails, inspect the exact logs and repair the preset; once an APK artifact is verified, expand automated blackjack tests and implement classes/abilities.

## Phase 0 — Foundation
Status: **In progress**
- [x] Define game concept, genre, engine, language, and platform.
- [x] Record mandatory AI rules in AGENTS.md.
- [x] Record design and long-term roadmap in README.md.
- [x] Create Godot project structure and first table prototype.
- [ ] Verify project opens/runs in Godot 4 headless mode.
- [ ] Add a clean test harness for scoring and deck behavior.

## Phase 1 — Playable blackjack duel
Status: **In progress**
- [x] Create/shuffle a standard 52-card deck.
- [x] Implement Ace-aware scoring, face-card values, hit, stand, and bust.
- [x] Add player/enemy health and turn resolution.
- [x] Add basic offline enemy draw strategy.
- [ ] Prevent repeated resolution/state-transition bugs.
- [ ] Add automated tests for scoring, busts, deck uniqueness, and outcomes.
- [ ] Add touch-friendly card layout and responsive phone sizing.
- [ ] Add enemy intent and clear combat result messages.

## Phase 2 — Classes, abilities, and builds
Status: **Not started**
- [ ] Knight, Rogue, and Dealer class selection.
- [ ] Implement all eight active Trump Cards with explicit rules/costs.
- [ ] Implement ten passives as real mechanics, not placeholder labels.
- [ ] Implement six combos with visible activation and limits.
- [ ] Add rewards and a choice after each encounter.
- [ ] Add relics/equipment and class synergies.

## Phase 3 — Roguelite campaign and saves
Status: **Not started**
- [ ] Five encounters per run with escalating enemy profiles.
- [ ] One boss encounter and unique boss behavior.
- [ ] Local save/load with versioned save data.
- [ ] Run restart, unlocks, and progression.
- [ ] Validate offline behavior after force close/relaunch.

## Phase 4 — Presentation and Android
Status: **Not started**
- [ ] Original character portraits and card art.
- [ ] Gothic table backdrop, card reveal, damage, shield, bust, victory, and defeat feedback.
- [ ] Sound/music controls, reduced-motion option, readable contrast.
- [ ] Test phone aspect ratios and touch input.
- [ ] Configure Android export templates and SDK/JDK.
- [ ] Build debug APK in CI and verify artifact can be downloaded/installed.
- [ ] Run gameplay smoke tests on an Android device.

## Phase 5 — Stabilization
Status: **Not started**
- [ ] Balance enemy AI, ability costs, damage, rewards, and run length.
- [ ] Test deck exhaustion, Ace conversions, simultaneous defeat, save corruption, interrupted turns.
- [ ] Fix high-severity crashes and softlocks.
- [ ] Update README with actually tested features and release instructions.

## Phase 6 — Optional online PvP
Status: **Not started; blocked until offline release is stable**
- [ ] Define authoritative match protocol and hidden-card handling.
- [ ] Server-side validation for draws, turns, abilities, and outcomes.
- [ ] Reconnection, timeout, and anti-cheat handling.
- [ ] Privacy/security review and dedicated online tests.

## Change log
### Initial repository setup
- Added design, AI development contract, and phased roadmap.
- Added initial Godot 4 blackjack table prototype with deck logic, hit/stand, enemy response, HP, and encounter progression.
- Godot validation passed. Android export has not yet produced a verified artifact; export configuration is being debugged from workflow logs.
