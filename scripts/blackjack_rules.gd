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

static func add_shield(existing_shield: int, gained_shield: int) -> int:
	return maxi(0, existing_shield) + maxi(0, gained_shield)

static func absorb_damage(raw_damage: int, available_shield: int) -> Dictionary:
	var incoming := maxi(0, raw_damage)
	var shield_pool := maxi(0, available_shield)
	var absorbed := mini(incoming, shield_pool)
	return {
		"damage": incoming - absorbed,
		"shield": shield_pool - absorbed,
		"absorbed": absorbed,
	}

static func resolve_hand_result(player_total: int, enemy_total: int, enemy_busted: bool = false, player_bust_limit: int = 21) -> String:
	# Resolve the player's bust first. An enemy bust must not rescue a player
	# who exceeded their own limit. Trump Cards may temporarily raise that limit.
	if player_total > player_bust_limit:
		return "player_bust"
	if enemy_busted or enemy_total > 21:
		return "enemy_bust"
	if player_total > enemy_total:
		return "player_win"
	if player_total < enemy_total:
		return "enemy_win"
	return "push"

static func resolve_next_action(encounter: int, max_encounters: int, enemy_hp: int, run_over: bool, round_active: bool, reward_claimed: bool) -> String:
	if run_over:
		return "restart_run"
	if round_active:
		return "blocked_active_hand"
	if enemy_hp <= 0:
		if encounter >= max_encounters:
			return "finish_run"
		if not reward_claimed:
			return "claim_reward"
		return "next_encounter"
	return "next_hand"

static func is_boss_enraged(encounter: int, max_encounters: int, enemy_hp: int, boss_max_hp: int) -> bool:
	return encounter == max_encounters and enemy_hp > 0 and enemy_hp <= int(boss_max_hp / 2)

static func validate_saved_terminal_state(player_hp: int, enemy_hp: int, encounter: int, max_encounters: int, run_over: bool) -> bool:
	if player_hp <= 0:
		return run_over
	if run_over:
		return encounter == max_encounters and enemy_hp <= 0
	if encounter == max_encounters and enemy_hp <= 0:
		return false
	return true

static func validate_saved_run(data: Dictionary, starting_hp: int, max_enemy_hp: int, max_encounters: int, allow_zero_player_hp: bool = false) -> Dictionary:
	var player_hp := int(data.get("player_hp", starting_hp))
	var minimum_player_hp := 0 if allow_zero_player_hp else 1
	var enemy_hp := int(data.get("enemy_hp", starting_hp))
	var encounter := int(data.get("encounter", 1))
	var shield := int(data.get("shield", 0))
	var bonus := int(data.get("next_bonus_damage", 0))
	var start_shield := int(data.get("next_start_shield", 0))
	var valid := player_hp >= minimum_player_hp and player_hp <= starting_hp and enemy_hp >= 0 and enemy_hp <= max_enemy_hp and encounter >= 1 and encounter <= max_encounters and shield >= 0 and shield <= 999 and bonus >= 0 and bonus <= 999 and start_shield >= 0 and start_shield <= 999
	return {"valid": valid, "player_hp": player_hp, "enemy_hp": enemy_hp, "encounter": encounter, "shield": shield, "next_bonus_damage": bonus, "next_start_shield": start_shield}

static func validate_saved_hand(cards: Variant, minimum_cards: int = 2, maximum_cards: int = 24) -> bool:
	if not cards is Array or cards.size() < minimum_cards or cards.size() > maximum_cards:
		return false
	for card in cards:
		if not card is Dictionary:
			return false
		if str(card.get("rank", "")) not in RANKS or str(card.get("suit", "")) not in SUITS:
			return false
	return true

static func validate_saved_deck(cards: Variant) -> bool:
	if not cards is Array or cards.size() > 52:
		return false
	var seen := {}
	for card in cards:
		if not card is Dictionary:
			return false
		var rank := str(card.get("rank", ""))
		var suit := str(card.get("suit", ""))
		if rank not in RANKS or suit not in SUITS:
			return false
		var key := rank + "|" + suit
		if seen.has(key):
			return false
		seen[key] = true
	return true

static func validate_saved_cards(deck: Variant, player_hand: Variant, enemy_hand: Variant) -> bool:
	if not validate_saved_deck(deck):
		return false
	if not validate_saved_hand(player_hand) or not validate_saved_hand(enemy_hand):
		return false
	var seen := {}
	for group in [deck, player_hand, enemy_hand]:
		for card in group:
			var key := str(card["rank"]) + "|" + str(card["suit"])
			if seen.has(key):
				return false
			seen[key] = true
	return true

static func reset_run_resources() -> Dictionary:
	return {"shield": 0, "next_bonus_damage": 0, "next_start_shield": 0}
