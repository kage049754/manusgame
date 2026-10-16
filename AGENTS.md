# Mandatory AI Development Instructions

These instructions are the canonical project contract. Read README.md, AGENTS.md, and ROADMAP.md at the start of every work session before editing code.

## Non-negotiable rules
1. **Inspect before editing.** Check current branch, latest commit, repository tree, roadmap status, and latest relevant GitHub Actions result. Never assume an earlier chat reflects current code.
2. **Work directly in the repository.** Implement requested changes in source files; do not respond with instructions alone when repository tools are available.
3. **Use Godot 4 + GDScript.** Keep the project Android-friendly and offline-first. Do not introduce paid services, cloud dependencies, or online requirements for the core game.
4. **Maintain the design.** 2D gothic-fantasy blackjack roguelite; fixed table view; black/crimson/ivory/gold palette; lethal 1v1 duels; five encounters and a boss; classes Knight/Rogue/Dealer; Trump Cards, passives, and combos.
5. **Correctness before polish.** Blackjack scoring handles Aces as 1 or 11, face cards as 10, and busts over 21. Separate rules/engine logic from UI. Prevent invalid actions, double resolution, stale enemy turns, and rewards being granted twice.
6. **No false progress claims.** Distinguish planned, implemented, locally tested, CI-passed, and APK-artifact-verified. A queued/running workflow is not a pass. A successful workflow without an APK artifact is not an APK build.
7. **Tests are part of features.** Add or update automated checks for rules and combat behavior. Run validation; inspect real logs after failures, fix the cause, commit, and rerun.
8. **Update the roadmap.** After each meaningful commit, update phase status, changes, remaining work, and exact next step in ROADMAP.md.
9. **No copied assets.** Use original characters, art, text, and UI. High-level genre inspiration is acceptable; do not extract proprietary assets or reproduce another game's exact content.
10. **Keep changes scoped.** Avoid unrelated repositories/projects. Do not add online PvP until offline single-player is stable and tested.

## Required work loop
- Read README.md, AGENTS.md, and ROADMAP.md.
- Inspect code and recent workflow runs.
- Choose the smallest meaningful milestone.
- Implement code and tests.
- Run validation; report failures honestly and fix them.
- Commit source and roadmap update.
- Inspect the resulting workflow run and logs until completed.
- Verify any APK artifact by its exact workflow artifact record before claiming it is available.
- Leave a concise status summary: completed, tested, not yet done, next step, commit, workflow/artifact status.

## Game rules contract
- Standard 52-card deck; number cards face value, J/Q/K = 10, Ace = 1 or 11.
- Bust above 21.
- Never fudge a hand score to force a win.
- Trump Cards must have explicit rules, target, cost, duration, and limits.
- Enemy AI uses the same scoring engine.
- All random draws come from deck/shuffle logic, not UI-specific random values.
- Offline mode works without network access.

## Scope order
1. Playable blackjack duel and readable mobile UI.
2. Correct combat outcomes, HP, enemy AI, and encounter progression.
3. Abilities, passives, combos, rewards, and classes.
4. Save/load, progression, five encounters, and boss.
5. Visual/audio polish, accessibility, Android export, and verification.
6. Optional online PvP only after offline game stability.

If a design change is necessary, explain it in the roadmap rather than silently discarding the agreed plan.
