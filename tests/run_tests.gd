extends SceneTree

const Rules = preload("res://scripts/blackjack_rules.gd")

func _initialize() -> void:
	var failures: Array[String] = []
	_check(Rules.create_deck().size() == 52, "deck contains 52 cards", failures)
	var seen := {}
	for card in Rules.create_deck():
		var key := str(card["rank"]) + str(card["suit"])
		_check(not seen.has(key), "deck has unique cards", failures)
		seen[key] = true
	_check(Rules.hand_total([{"rank":"A","suit":"♠"},{"rank":"K","suit":"♥"}]) == 21, "Ace plus King totals 21", failures)
	_check(Rules.hand_total([{"rank":"A","suit":"♠"},{"rank":"9","suit":"♥"},{"rank":"A","suit":"♦"}]) == 21, "two Aces can soften to 1", failures)
	_check(Rules.hand_total([{"rank":"A","suit":"♠"},{"rank":"A","suit":"♥"},{"rank":"9","suit":"♦"}]) == 21, "multiple Aces score correctly", failures)
	_check(Rules.hand_total([{"rank":"J","suit":"♠"},{"rank":"Q","suit":"♥"}]) == 20, "face cards count as 10", failures)
	_check(Rules.is_bust([{"rank":"K","suit":"♠"},{"rank":"Q","suit":"♥"},{"rank":"5","suit":"♦"}]), "totals over 21 bust", failures)
	_check(not Rules.is_bust([{"rank":"A","suit":"♠"},{"rank":"9","suit":"♥"}]), "legal soft total is not bust", failures)
	_check(Rules.is_blackjack([{"rank":"A","suit":"♠"},{"rank":"K","suit":"♥"}]), "two-card blackjack detected", failures)
	_check(not Rules.is_blackjack([{"rank":"7","suit":"♠"},{"rank":"7","suit":"♥"},{"rank":"7","suit":"♦"}]), "three-card 21 is not natural blackjack", failures)
	var shielded := Rules.absorb_damage(8, 5)
	_check(shielded["damage"] == 3 and shielded["shield"] == 0 and shielded["absorbed"] == 5, "shield absorbs only its available amount", failures)
	var fully_blocked := Rules.absorb_damage(4, 9)
	_check(fully_blocked["damage"] == 0 and fully_blocked["shield"] == 5 and fully_blocked["absorbed"] == 4, "shield remains after fully blocking damage", failures)
	var unshielded := Rules.absorb_damage(7, 0)
	_check(unshielded["damage"] == 7 and unshielded["shield"] == 0, "damage passes through without shield", failures)
	var invalid_damage := Rules.absorb_damage(-3, -2)
	_check(invalid_damage["damage"] == 0 and invalid_damage["shield"] == 0, "negative damage and shield are safely clamped", failures)
	_check(Rules.resolve_hand_result(18, 23) == "enemy_bust", "enemy bust is resolved as player victory", failures)
	_check(Rules.resolve_hand_result(20, 18) == "player_win", "higher player total wins the hand", failures)
	_check(Rules.resolve_hand_result(17, 19) == "enemy_win", "higher enemy total wins the hand", failures)
	_check(Rules.resolve_hand_result(19, 19) == "push", "equal totals resolve as a push", failures)
	_check(Rules.resolve_hand_result(22, 18) == "player_bust", "player bust outcome is classified safely", failures)
	_check(Rules.resolve_next_action(2, 5, 18, true, false, true) == "restart_run", "restart takes priority after a finished run", failures)
	_check(Rules.resolve_next_action(2, 5, 18, false, true, true) == "blocked_active_hand", "cannot advance while a hand is active", failures)
	_check(Rules.resolve_next_action(2, 5, 0, false, false, false) == "claim_reward", "defeated encounter requires reward before advancing", failures)
	_check(Rules.resolve_next_action(2, 5, 0, false, false, true) == "next_encounter", "claimed reward allows next encounter", failures)
	_check(Rules.resolve_next_action(5, 5, 0, false, false, true) == "finish_run", "final encounter does not advance beyond campaign", failures)
	_check(Rules.resolve_next_action(3, 5, 18, false, false, true) == "next_hand", "living enemy advances to next hand", failures)
	if failures.is_empty():
		print("PASS: 24 blackjack, combat, and transition checks")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)

func _check(condition: bool, description: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(description)
