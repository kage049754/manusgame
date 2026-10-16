# Blackjack Test Plan

The current CI smoke test confirms the Godot project opens and the main scene can initialize. It does not yet prove all gameplay rules; these are the next automated tests to add as the rules engine is extracted from the UI script.

- Ace scoring: A+K = 21; A+9+A = 21; A+A+9 = 21.
- Face cards: J/Q/K each count as 10.
- Bust: any hand whose best legal total exceeds 21 is bust.
- Deck: 52 unique suit/rank combinations before shuffle.
- Hit: only accepted while the player's hand is active.
- Stand: enemy draws until at least 17 and resolves exactly once.
- Trump: Aegis can be activated once per hand and absorbs up to 8 damage.
- Hand progression: a non-lethal win, loss, push, or bust enables NEXT HAND; a defeated enemy enables NEXT DUEL.
- Run end: player HP zero causes defeat; surviving duel five completes the run.
- Restart: restart restores player HP, enemy HP, encounter index, and usable Trump Card.

Do not mark these tests as automated or passing until executable test code exists and CI runs it.
