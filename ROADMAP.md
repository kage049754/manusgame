# Dungeon Dealer Roadmap

Source of truth for implementation progress. Update after every meaningful commit. Status labels: **Not started**, **In progress**, **Implemented**, **Verified**. “Implemented” means code exists; “Verified” means a relevant test or build passed.

## Current status
- [x] Latest recovery fix preserves completed-duel victory/reward screens and terminal victory state across relaunch, rather than silently advancing to the next encounter.
- [x] Fixed hand resolution so Raise the Limit uses its temporary threshold and simultaneous busts correctly count as a player bust; four new rules checks added (52 total).
- [x] Restarting a run now clears pending damage, starting shield, and carried shield instead of leaking temporary rewards into the next run; reset state has an automated check (53 total).
- [x] Saved defeats with 0 HP can now be restored as terminal defeat screens, while zero-HP saves without the terminal flag remain rejected; one new validation check added (54 total).
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
- [x] Add enemy intent and clear combat result messages with result-specific status colors (CI verified).

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
- [x] Guard malformed health/encounter values and saved card data during recovery.
- [x] Persist deck, both hands, active-hand state, Trump availability, hand modifiers, and combat status so force-close/relaunch can restore an interrupted hand (CI verified; physical-device test pending).
- [ ] Run restart, unlocks, and progression.
- [ ] Validate offline behavior after force close/relaunch on a physical Android device.

## Phase 4 — Presentation and Android
Status: **Not started**
- [ ] Original character portraits and card art.
- [ ] Gothic table backdrop, damage/shield impact effects, and full victory/defeat presentation.
- [x] Add gold emphasis to newly drawn/revealed cards and color-code win, loss, bust, and push messages (CI verified).
- [ ] Sound/music controls, reduced-motion option, readable contrast.
- [x] Make player/enemy card rows wrap instead of overflowing horizontally on narrow screens (CI verification pending).
- [ ] Test phone aspect ratios, touch input, card-row overflow, and reward selection on a physical device.
- [ ] Configure Android export templates and SDK/JDK.
- [ ] Build debug APK in CI and verify artifact can be downloaded/installed.
- [ ] Run gameplay smoke tests on an Android device.

## Phase 5 — Stabilization
Status: **Not started**
- [ ] Balance enemy AI, ability costs, damage, rewards, and run length.
- [x] Add five automated checks for valid/malformed saved interrupted hands; rules suite now has 48 checks (CI verified on commit `e32aa9aa9bf7073c4222ae8632440b27f8abe92b`).
- [ ] Test deck exhaustion, Ace conversions, simultaneous defeat, save corruption, and physical-device interrupted-turn recovery.
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


### Save validation hardening (Verified on commit `0b9c045c703c750f03563e0f0c272c6d08a76ca4`)
- Extracted saved-run bounds checks into the shared rules module so malformed save values can be tested independently from the UI.
- Added six tests covering valid restoration and invalid player HP, enemy HP, encounter index, negative shield, and implausible bonus damage.
- Persisted current shield as part of the local run save. Invalid saved state is rejected before saved values are restored; initialized fresh-run defaults remain in place.


### Card reveal and combat feedback (CI verified)
- Newly drawn cards are emphasized with a thicker gold border; revealed enemy cards receive the same emphasis after the hand resolves.
- Card faces are centered consistently, including the hidden-card back, and card panels are slightly larger for touch readability.
- Combat status text now uses distinct colors for losses/busts, wins, and pushes.
- Added three saved-state edge cases: negative bonus damage, oversized shield, and negative starting shield. All 37 rules checks passed in run `38929155586`.
- Fixed missing declarations and flow-container enum mismatches found in the Godot log. Godot validation passed with zero GDScript parse errors in run `38929155586`.
- Android APK artifact `DungeonDealer-debug-apk` was verified in run `38929156007` (23,918,497 bytes; artifact ID `12058450847`, expires 2026-10-30).
- Force-close recovery of an in-progress hand and physical Android gameplay remain unverified and are still explicit roadmap items.


### Latest CI verification
- Current gameplay code commit `a127c525fad726f6a5004727ecbd4ebbecb52be8` passed Godot validation: https://github.com/kage049754/manusgame/actions/runs/38929155586
- Android debug APK build and artifact upload passed: https://github.com/kage049754/manusgame/actions/runs/38929156007
- Physical Android device testing and force-close recovery of an in-progress hand remain unverified.


### Interrupted-hand save recovery (CI verified; device test pending)
- Saves now include the current deck, player/enemy hands, active-hand flag, Trump readiness, hand modifiers, boss phase state, Second Wind state, and status message.
- Startup restores saved card state rather than unconditionally starting a new hand; malformed or legacy saves without card arrays fall back to a fresh hand safely.
- Validation checks saved cards against allowed rank/suit values. Five new checks bring the rules suite to 42, passed in GitHub Actions.
- Godot validation and all 42 rules checks passed for final recovery/documentation commit `f5cd5303ad9ffde3a2d8c21638c454890b52acc6` in run `38930681038`.
- Android debug APK artifact `DungeonDealer-debug-apk` was verified in run `38930681100` (23,921,009 bytes; artifact ID `12058433754`, expires 2026-10-30).
- Force-close/relaunch behavior on a physical Android device has not been tested.


### Latest interrupted-hand recovery build
- Godot validation: https://github.com/kage049754/manusgame/actions/runs/38930681038
- Android APK build and artifact: https://github.com/kage049754/manusgame/actions/runs/38930681100


### Saved-deck integrity hardening (in progress)
- Validate saved remaining-deck type, size, rank/suit values, and duplicate cards before restoring run state.
- Added six rules checks for full/empty valid decks and malformed/duplicate deck entries; expected suite size is 48 after CI verification.
- Invalid saved decks are rejected before saved run values are applied, allowing a clean fresh encounter rather than partially restoring corrupted card data.


### Victory/reward recovery correction (implementation committed; CI pending)
- Fixed interrupted-run loading so a saved defeated enemy remains on the victory/reward screen after app relaunch.
- Encounter advancement now waits for the player to press **NEXT DUEL** after claiming a reward; a saved terminal victory remains visible instead of being immediately replaced by a fresh run.
- Code commit: `c5da403276037aa0f0d7c583cbd030494d9943f5`.
- Next: confirm Godot validation and Android APK artifact for this commit. Physical-device recovery testing remains outstanding.


### Raised bust-limit combat correction (implementation committed; CI pending)
- Hand resolution now accepts the active bust limit rather than hard-coding 21.
- A player bust is resolved before an enemy bust, preventing a simultaneous bust from incorrectly awarding the player a win.
- Added four automated checks for simultaneous busts, safe totals of 22/23 under Raise the Limit, and busting above 23. Expected rules suite: 52 checks.
- Code commits: `f98711e8a4314591435730f1595d77d55563c35e`, `d198e8c23d369894094e2b80dab2e0480c3b1525`, `4a9b37a5b964f33681fd611af3023401d1258d30`.
- Next: confirm CI and Android APK artifact for the latest commit, then continue with the next stabilization issue.


### Fresh-run resource reset (implementation committed; CI pending)
- Restarting after defeat or a completed campaign now clears temporary shield and pending reward bonuses before the new run begins.
- Added a pure rules helper for the fresh-run resource baseline and a test confirming all temporary resources reset to zero.
- Code commits: `f98711e8a4314591435730f1595d77d55563c35e`, `d198e8c23d369894094e2b80dab2e0480c3b1525`, `4a9b37a5b964f33681fd611af3023401d1258d30`, `bb210e4d98ee82309ce2c05bea828206d8c1c578`, plus the current reset implementation and test commits.
- Next: verify CI and APK for the latest commit, then continue stabilization.


### Terminal defeat recovery (implementation committed; CI pending)
- Saved defeat state can now pass run validation only when the persisted run-over flag is set, allowing the defeat screen to remain visible after relaunch.
- A zero-HP save without terminal-run metadata remains invalid.
- Added an automated validation check; expected suite size is 54.
- Code commits: `88de90c4faadfaec0c7e10a347b3cf9da0faf746`, `2f7cac2ecd703dc392aa09a888c86939516c1862`, `8937b9e368979cbadbebe59ca0d3f6550d56572e`.
- Next: confirm latest Godot validation and Android APK artifact; continue with save-recovery edge cases.


### Narrow-screen card wrapping (implementation committed; CI pending)
- Replaced fixed horizontal card rows with wrapping flow containers for both player and enemy hands.
- Card rows now expand to available width and wrap cards onto additional lines instead of relying on horizontal overflow.
- Code commit: `665e6c09e148f36c820e22ae77b4a6fbba4dc3e9`.
- Next: verify Godot validation and APK artifact; physical-device layout testing is still required.
