# Dungeon Dealer — Blackjack RPG

**Genre:** 2D gothic-fantasy blackjack card-battler RPG / roguelite  
**Engine:** Godot 4 | **Language:** GDScript | **Target:** Android APK  
**Mode:** Offline-first single-player. Online PvP is a later phase, not part of the initial release.

Dungeon Dealer is an original blackjack-inspired survival RPG. The player enters lethal card duels against increasingly dangerous opponents. Use standard blackjack decisions, active Trump Cards, passive abilities, and build-defining combos to survive a five-encounter run. The visual direction is a fixed card-table view, dark gothic atmosphere, black/crimson/ivory/gold palette, character portraits, and animated card reveals as art is added.

## Current progress

**Current phase: Phase 3 — roguelite progression in progress.** The playable prototype now includes a tested blackjack rules engine, eight Trump Cards, ten passive choices, three class choices, three combo synergies, local run persistence, five named/scaling encounters, a final boss, and between-encounter reward choices. A debug APK has been produced and verified for earlier commits; always check the latest GitHub Actions artifact before claiming the newest code is packaged. This remains an early prototype, not a finished or device-tested release.

## Core loop
1. Enter a duel against an enemy dealer or challenger.
2. Draw cards and choose **Hit** or **Stand**.
3. Use a limited **Trump Card** ability when the situation calls for it.
4. Resolve blackjack, busts, damage, passive effects, and enemy responses.
5. Choose Mend, Power, or Guard rewards and continue through five encounters, ending with a boss.
6. Save local progress on the device and resume the run after reopening.

## Gameplay rules
- Standard 52-card deck. Number cards count at face value; J/Q/K count as 10; Ace counts as 11 or 1 to avoid busting.
- A total over 21 is a bust.
- Player and enemy have health. Losing a duel costs health; reaching zero ends the run.
- Stand resolves the player's hand, then the enemy draws and resolves its hand.
- Keep combat deterministic and rules-driven; UI code must not own blackjack calculations.
- First release is fully playable offline. Do not add accounts, cloud saves, or online dependencies to the core loop.

## Classes
- **Knight:** defensive play, shields, controlled risk.
- **Rogue:** swaps, counters, and tactical card manipulation.
- **Dealer:** card control, enemy disruption, and combo setup.

## Active Trump Cards — implemented in the prototype
1. **Perfect Draw** — draw a controlled card or improve the current hand under a clear, bounded rule.
2. **Exchange** — replace a selected card with a fresh draw.
3. **Destroy** — remove one selected card from the current hand.
4. **Raise the Limit** — temporarily raise the safe hand threshold for a turn.
5. **Aegis** — gain a shield that absorbs incoming damage.
6. **Cursed Hand** — curse the opponent, making their next draw or resolution riskier.
7. **Rebirth** — once per run, recover from a lethal result with a small amount of health.
8. **Executioner's Mark** — mark an enemy so the next successful win deals bonus damage.

The prototype uses one Trump Card per hand. Rebirth is once per run; other card effects have explicit hand-level rules. Abilities must communicate their limitations in the UI.

## Passive abilities — ten selectable prototype effects
- **Steel Nerve:** reduces incoming damage and strengthens Aegis.
- **Second Wind:** restores a small amount of HP once per encounter after a win.
- **High Roller:** increases dealt damage but also increases incoming damage.
- **Boss Hunter:** adds damage against the final boss.
- **Card Reader:** shows the enemy draw target and strengthens Cursed Hand.
- **Quick Reflex:** reduces incoming damage.
- **Steady Hand:** reduces damage when losing with a total from 18 to 20.
- **Collector's Instinct:** restores 1 HP after a win.
- **Shadow Dealer:** adds another option to Perfect Draw.
- **Last Stand:** increases damage while at low HP.

Other planned passives and relic-related effects remain future work.

## Planned combos
- **Perfect Execution:** Perfect Draw + Executioner's Mark.
- **Unbreakable Fate:** Aegis + Steel Nerve.
- **Cursed Reversal:** Exchange + Counter Specialist.
- **Demon's Bargain:** Blood Pact + High Roller.
- **Second Chance:** Rebirth + Last Stand.
- **Dealer's Trap:** Cursed Hand + Card Reader.

Current functional synergies: **Unbreakable Fate** (Aegis + Steel Nerve), **Dealer's Trap** (Cursed Hand + Card Reader), and Executioner's Mark + Boss Hunter on the final boss. Three additional planned combos still need implementation and explicit UI presentation.

## Release scope

### First playable milestone
- One table scene and touch-friendly UI.
- Correct blackjack deck, shuffle, hit, stand, bust, and hand scoring.
- Player/enemy health and readable duel resolution.
- Basic offline enemy AI.
- Three class identities represented by starter abilities.
- Eight active Trump Cards, ten passives, and six combos as the target roster; implement incrementally, never pretend unimplemented entries work.
- Five encounters per run with a final boss.
- Local save/load and run restart.
- Automated project validation and Android export workflow.

### Later milestones
- **Phase 2:** reward choices, relics, class selection, progression, better enemy AI, and save/load.
- **Phase 3:** character portraits, card effects, sound, transitions, accessibility, and responsive Android layouts.
- **Phase 4:** balance passes, test coverage, crash fixes, and verified APK artifacts.
- **Phase 5:** optional online PvP only after offline combat is stable; authoritative server validation must prevent clients deciding hidden draws or match outcomes.

## Design direction
- 2D fixed table view, gothic dark fantasy.
- Black, crimson, ivory, and muted gold palette.
- Cards and combat feedback must remain legible on phone screens; touch targets must be large and spaced.
- Keep animations lightweight and optional for reduced-motion/performance settings.
- Use original names, writing, characters, art, and UI. This is inspired by the broad concept of lethal blackjack duels, not a copy of another game's proprietary assets or exact implementation.

## Build and test
The project uses Godot 4 and GDScript. Open project.godot in Godot 4. Use the headless validation workflow on every push. Android export requires matching Godot export templates and Android SDK/JDK configuration; do not claim an APK exists until a workflow artifact has actually been produced and inspected.

## Canonical AI instructions
Before changing code, read AGENTS.md and ROADMAP.md. Update roadmap status after each meaningful change. Do not mark planned features implemented without working code and a test. Keep the game offline-first, use GDScript/Godot 4, and preserve the decisions above unless the owner explicitly changes them.
