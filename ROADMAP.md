# Dungeon Dealer Roadmap

Source of truth for implementation progress. Update after every meaningful commit. Status labels: **Not started**, **In progress**, **Implemented**, **Verified**. “Implemented” means code exists; “Verified” means a relevant test or build passed.

## Current status
- [x] Repository design contract and AI instructions written.
- [x] Initial Godot project and playable prototype source added.
- [x] Godot headless validation and main-scene smoke test passed in GitHub Actions.
- [x] Nine automated blackjack rules checks passed in GitHub Actions.
- [x] First Android debug APK artifact produced and verified for commit `208fc4b667eb5e51e95e7bc578ab8af5ba5b885b` (artifact `DungeonDealer-debug-apk`, 23,903,011 bytes).
- [ ] Re-verify APK artifact for the latest Trump Card implementation commit.
- **Current phase:** Phase 1 — playable prototype; initial APK export verified.
- **Next step:** Verify CI for the six-card Trump implementation, then expand automated tests and implement class/passive/combo systems.

## Phase 0 — Foundation
Status: **In progress**
- [x] Define game concept, genre, engine, language, and platform.
- [x] Record mandatory AI rules in AGENTS.md.
- [x] Record design and long-term roadmap in README.md.
- [x] Create Godot project structure and first table prototype.
- [x] Verify project opens/runs in Godot 4 headless mode.
- [x] Add automated test harness for scoring and deck behavior.

## Phase 1 — Playable blackjack duel
Status: **In progress**
- [x] Create/shuffle a standard 52-card deck.
- [x] Implement Ace-aware scoring, face-card values, hit, stand, and bust.
- [x] Add player/enemy health and turn resolution.
- [x] Add basic offline enemy draw strategy.
- [ ] Prevent repeated resolution/state-transition bugs.
- [x] Add automated tests for scoring, busts, deck uniqueness, and natural blackjack detection (9 checks).
- [ ] Add touch-friendly card layout and responsive phone sizing.
- [ ] Add enemy intent and clear combat result messages.

## Phase 2 — Classes, abilities, and builds
Status: **Not started**
- [ ] Knight, Rogue, and Dealer class selection.
- [ ] Implement all eight active Trump Cards with explicit rules/costs (Aegis, Perfect Draw, Exchange, Destroy, Executioner’s Mark, and Cursed Hand are implemented in the prototype; two remain).
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
- Extracted blackjack scoring/deck rules into `scripts/blackjack_rules.gd` and added nine automated checks.
- Added six selectable Trump Cards: Aegis, Perfect Draw, Exchange, Destroy, Executioner’s Mark, and Cursed Hand.
- Initial Godot validation and Android APK artifact succeeded; latest Trump Card commit still requires its own CI verification.
