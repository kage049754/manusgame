# Dungeon Dealer Roadmap

Source of truth for implementation progress. Update after every meaningful commit. Status labels: **Not started**, **In progress**, **Implemented**, **Verified**. “Implemented” means code exists; “Verified” means a relevant test or build passed.

## Current status
- [x] Repository design contract and AI instructions written.
- [x] Initial Godot project and playable prototype source added.
- [x] Godot headless validation and main-scene smoke test passed in GitHub Actions.
- [x] Nine automated blackjack rules checks passed in GitHub Actions.
- [x] First Android debug APK artifact produced and verified for commit `208fc4b667eb5e51e95e7bc578ab8af5ba5b885b` (artifact `DungeonDealer-debug-apk`, 23,903,011 bytes).
- [x] Verified Android debug APK artifact for the six-Trump/class/passive build (commit `617fdad23ccb9519cba69b5c4c76d4a4e47d6792`).
- [x] Verified APK artifact for local save/load and three combo synergies (commit `c8276e9054cdc6a3c455efd3faa2a6521c423159`).
- [x] Verified APK artifact for all eight Trump Cards and ten passive choices (commit `a35dd7067865d61dd02a6387230612f4edc88d70`).
- [x] Verified Android debug APK artifact for the current playable prototype with card-panel UI (commit `34088cab24a2ffa4b3c097fc1a233917801db9b3`).
- **Current phase:** Phase 4 — mobile presentation and stabilization in progress; core five-encounter run, rewards, eight Trump Cards, ten passives, six combos, and local persistence are implemented.
- **Latest verified milestone:** Android debug APK artifact verified for responsive mobile layout commit `b955274a3e4dee6bcf8c67f45e0d361cd7c20ce8` (23,915,083 bytes; SHA-256 `a8688415d7784c8248029b3eef70b7442ebdcbf047f32ee497b73e7200764a63`). Godot validation and the 18-rule test suite passed.
- **Latest verified milestone:** Final boss Double or Nothing phase is implemented and verified. At half health, The House draws to a higher target and deals +2 damage on wins; phase entry is announced once. Godot validation passed run `38922794359`; Android APK artifact passed run `38922794395` for code commit `ff3bbc8aa4e2af6ab5c789e95092332f6be40827` (23,916,741 bytes; SHA-256 `101ea68488afa30ea3a77d576bf8cf83c2667243452e6ef294d82213f1f11961`).

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
- [x] Add four automated shield-absorption checks and use the shared helper for incoming damage.
- [ ] Add touch-friendly card layout and responsive phone sizing.
- [ ] Add enemy intent and clear combat result messages.

## Phase 2 — Classes, abilities, and builds
Status: **Not started**
- [x] Knight, Rogue, and Dealer class selection with gameplay effects.
- [x] Implement eight active Trump Cards: Aegis, Perfect Draw, Exchange, Destroy, Executioner’s Mark, Cursed Hand, Raise the Limit, and Rebirth.
- [x] Implement ten passive choices with effects: Steel Nerve, Second Wind, High Roller, Boss Hunter, Card Reader, Quick Reflex, Steady Hand, Collector’s Instinct, Shadow Dealer, and Last Stand.
- [x] Implement all six combo synergies with gameplay effects (Unbreakable Fate, Dealer’s Trap, Perfect Execution, Cursed Reversal, Second Chance, and Demon’s Bargain); improve combo feedback and balance through testing.
- [x] Add between-encounter reward choice: Mend (+8 HP), Power (+3 damage), or Guard (+6 starting shield).
- [ ] Add relics/equipment and class synergies.

## Phase 3 — Roguelite campaign and saves
Status: **Not started**
- [x] Five encounters per run with escalating enemy HP, distinct enemy names, and scaling AI draw targets.
- [x] Final boss encounter with higher draw target and increased bust punishment; additional unique boss mechanics still planned.
- [x] Add version metadata to local ConfigFile saves and reject unsupported versions.
- [x] Guard malformed health/encounter values during save recovery; full save corruption and force-close recovery tests remain open.
- [ ] Run restart, unlocks, and progression.
- [ ] Validate offline behavior after force close/relaunch.

## Phase 4 — Presentation and Android
Status: **Not started**
- [ ] Original character portraits and card art.
- [ ] Gothic table backdrop, card reveal, damage, shield, bust, victory, and defeat feedback.
- [ ] Sound/music controls, reduced-motion option, readable contrast.
- [ ] Test phone aspect ratios, touch input, card-row overflow, and reward selection.
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
- Added Knight/Rogue/Dealer class selection and ten passive choices with gameplay effects.
- Implemented all eight Trump Cards, three combo synergies, and basic local run persistence.
- Godot validation passed for the latest passive fixes; APK export for commit `a35dd7067865d61dd02a6387230612f4edc88d70` is still running.

### Versioned saves and shield rules
- Added `meta.version = 1` to local saves; unsupported save versions are ignored rather than partially loaded.
- Added bounds checks for player HP, enemy HP, and encounter index before resuming a run.
- Extracted shield absorption into the rules module and added tests for partial block, full block, no shield, and invalid negative inputs.
- Godot validation passed and the Android APK artifact was verified for code commit `ae77c9c980062217293c111aeed1b6c27c6c9a50`.

### Deterministic combat outcomes (Verified)
- Added a shared hand-outcome resolver and routed the stand action through it.
- Added five automated outcome checks: enemy bust, player win, enemy win, push, and player bust.
- Godot validation and Android APK export passed for the current main-branch build.

### Responsive layout work (CI verified; device test pending)
- Added vertical scrolling and wrapping flow rows for narrow screens.
- Godot validation and Android APK export passed for commit `b955274a3e4dee6bcf8c67f45e0d361cd7c20ce8`.
- Physical Android device testing is still required.

### Combat transition safety (Verified)
- Centralized next-action decisions for restart, active-hand blocking, reward gating, encounter progression, and next-hand progression in the rules module.
- Six transition tests passed in Godot validation run `38922382191`.
- Android APK artifact for the same code commit passed build and upload verification in run `38922382326`.

### Final boss phase (Verified)
- The House enters a Double or Nothing phase at half health: it draws to a higher target and deals +2 damage when it wins a hand.
- Added a one-time phase-entry status message and four pure rules checks for phase boundaries.
- The 28-check suite and Android APK build passed in CI. Physical device testing remains outstanding.
