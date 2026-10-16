class_name BlackjackRules
extends RefCounted

const SUITS: Array[String] = ["♠", "♥", "♦", "♣"]
const RANKS: Array[String] = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

static func create_deck() -> Array[Dictionary]:
	var cards: Array[Dictionary] = []
	for suit in SUITS:
		for rank in RANKS:
			cards.append({"suit": suit, "rank": rank})
	return cards

static func card_value(card: Dictionary) -> int:
	var rank := str(card.get("rank", "2"))
	if rank == "A":
		return 11
	if rank in ["J", "Q", "K"]:
		return 10
	return int(rank)

static func hand_total(hand: Array[Dictionary]) -> int:
	var total := 0
	var aces := 0
	for card in hand:
		total += card_value(card)
		if str(card.get("rank", "")) == "A":
			aces += 1
	while total > 21 and aces > 0:
		total -= 10
		aces -= 1
	return total

static func is_bust(hand: Array[Dictionary]) -> bool:
	return hand_total(hand) > 21

static func is_blackjack(hand: Array[Dictionary]) -> bool:
	return hand.size() == 2 and hand_total(hand) == 21

static func absorb_damage(raw_damage: int, available_shield: int) -> Dictionary:
	var incoming := maxi(0, raw_damage)
	var shield_pool := maxi(0, available_shield)
	var absorbed := mini(incoming, shield_pool)
	return {
		"damage": incoming - absorbed,
		"shield": shield_pool - absorbed,
		"absorbed": absorbed,
	}
