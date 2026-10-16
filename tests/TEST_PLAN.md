# Blackjack Test Plan

CI currently runs blackjack rules tests and a main-scene smoke test. The automated rules suite covers scoring, deck uniqueness, natural blackjack, shield absorption, and deterministic combat-result classification. Full UI-driven combat-transition and save/recovery integration tests remain open.

- Ace scoring: A+K = 21; A+9+A = 21; A+A+9 = 21.
- Face cards: J/Q/K each count as 10.
- Bust: any hand whose best legal total exceeds 21 is bust.
- Deck: 52 unique suit/rank combinations before shuffle.
- Hit: only accepted while the player's hand is active.
- Stand: enemy draws until at least 17 and resolves exactly once.
- Combat outcomes: enemy bust, player win, enemy win, push, and player bust are classified by the shared rules resolver and automated in `run_tests.gd`.
- Shield math: partial absorption, full absorption with leftover shield, no shield, and negative input clamping are automated in `run_tests.gd`.
- Trump: Aegis can be activated once per hand and absorbs up to 8 damage (activation/state-transition integration test still open).
- Hand progression: a non-lethal win, loss, push, or bust enables NEXT HAND; a defeated enemy enables NEXT DUEL.
- Run end: player HP zero causes defeat; surviving duel five completes the run.
- Restart: restart restores player HP, enemy HP, encounter index, and usable Trump Card (automated integration test still open).
- Save schema: saves record version 1; unsupported versions are ignored and malformed health/encounter values reset safely (runtime integration test still open).

Do not mark these tests as automated or passing until executable test code exists and CI runs it.
