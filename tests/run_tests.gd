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
	if failures.is_empty():
		print("PASS: 9 blackjack rules checks")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)

func _check(condition: bool, description: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(description)
