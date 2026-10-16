extends Control

const MAX_ENCOUNTERS := 5
const STARTING_HP := 30
const SAVE_VERSION := 1

const Rules = preload("res://scripts/blackjack_rules.gd")

var deck: Array[Dictionary] = []
var player_hand: Array[Dictionary] = []
var enemy_hand: Array[Dictionary] = []
var player_hp := STARTING_HP
var enemy_hp := STARTING_HP
var encounter := 1
var enemy_names: Array[String] = ["THE PIT DEALER", "IRON JACK", "MIRROR WITCH", "BLOOD COUNT", "THE HOUSE — BOSS"]
var round_active := false
var run_over := false
var shield := 0
var trump_ready := true
var status_text := "A challenger waits across the table."

var root_box: VBoxContainer
var encounter_label: Label
var health_label: Label
var enemy_hand_label: Label
var player_hand_label: Label
var enemy_cards_row: HBoxContainer
var player_cards_row: HBoxContainer
var status_label: Label
var hit_button: Button
var stand_button: Button
var trump_button: Button
var trump_select: OptionButton
var next_button: Button
var class_select: OptionButton
var passive_select: OptionButton
var second_wind_used := false
var rebirth_available := true
var rebirth_armed := false
var safe_limit := 21
var executioner_mark := false
var cursed_enemy := false
var boss_phase_announced := false

func _ready() -> void:
	_build_ui()
	_load_progress()
	_start_encounter()

func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color("#100b12")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var scroll := ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	add_child(scroll)

	var margins := MarginContainer.new()
	margins.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margins.add_theme_constant_override("margin_left", 16)
	margins.add_theme_constant_override("margin_right", 16)
	margins.add_theme_constant_override("margin_top", 16)
	margins.add_theme_constant_override("margin_bottom", 16)
	scroll.add_child(margins)

	root_box = VBoxContainer.new()
	root_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root_box.add_theme_constant_override("separation", 12)
	margins.add_child(root_box)

	var title := _label("DUNGEON DEALER", 28, Color("#d7b56d"))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root_box.add_child(title)
	encounter_label = _label("", 16, Color("#c8becb"))
	encounter_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root_box.add_child(encounter_label)
	health_label = _label("", 18, Color("#f1e8df"))
	health_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root_box.add_child(health_label)
	root_box.add_child(HSeparator.new())

	enemy_hand_label = _label("", 18, Color("#f0d7d7"))
	enemy_hand_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root_box.add_child(enemy_hand_label)
	enemy_cards_row = HBoxContainer.new()
	enemy_cards_row.alignment = BoxContainer.ALIGNMENT_CENTER
	enemy_cards_row.add_theme_constant_override("separation", 8)
	root_box.add_child(enemy_cards_row)
	player_hand_label = _label("", 18, Color("#fff3d8"))
	player_hand_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root_box.add_child(player_hand_label)
	player_cards_row = HBoxContainer.new()
	player_cards_row.alignment = BoxContainer.ALIGNMENT_CENTER
	player_cards_row.add_theme_constant_override("separation", 8)
	root_box.add_child(player_cards_row)
	status_label = _label("", 16, Color("#d7b56d"))
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root_box.add_child(status_label)

	var build_row := HFlowContainer.new()
	build_row.alignment = BoxContainer.ALIGNMENT_CENTER
	build_row.add_theme_constant_override("separation", 10)
	root_box.add_child(build_row)
	var class_label := _label("CLASS", 14, Color("#d7b56d"))
	build_row.add_child(class_label)
	class_select = OptionButton.new()
	class_select.custom_minimum_size = Vector2(150, 44)
	for class_option in ["Knight", "Rogue", "Dealer"]:
		class_select.add_item(class_option)
	build_row.add_child(class_select)
	var passive_label := _label("PASSIVE", 14, Color("#d7b56d"))
	build_row.add_child(passive_label)
	passive_select = OptionButton.new()
	passive_select.custom_minimum_size = Vector2(180, 44)
	for passive_name in ["Steel Nerve", "Second Wind", "High Roller", "Boss Hunter", "Card Reader", "Quick Reflex", "Steady Hand", "Collector's Instinct", "Shadow Dealer", "Last Stand"]:
		passive_select.add_item(passive_name)
	build_row.add_child(passive_select)

	reward_row = HFlowContainer.new()
	reward_row.alignment = BoxContainer.ALIGNMENT_CENTER
	reward_row.add_theme_constant_override("separation", 10)
	root_box.add_child(reward_row)
	var reward_label := _label("VICTORY REWARD", 14, Color("#d7b56d"))
	reward_row.add_child(reward_label)
	reward_select = OptionButton.new()
	reward_select.custom_minimum_size = Vector2(200, 44)
	for reward_name in ["Mend (+8 HP)", "Power (+3 damage)", "Guard (+6 shield)"]:
		reward_select.add_item(reward_name)
	reward_row.add_child(reward_select)
	claim_reward_button = _button("CLAIM", Color("#3e6651"))
	claim_reward_button.pressed.connect(_on_claim_reward)
	reward_row.add_child(claim_reward_button)
	reward_row.visible = false

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_box.add_child(spacer)

	var buttons := HFlowContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	buttons.add_theme_constant_override("separation", 12)
	root_box.add_child(buttons)
	hit_button = _button("HIT", Color("#7f293d"))
	hit_button.pressed.connect(_on_hit)
	buttons.add_child(hit_button)
	stand_button = _button("STAND", Color("#67502d"))
	stand_button.pressed.connect(_on_stand)
	buttons.add_child(stand_button)
	trump_select = OptionButton.new()
	trump_select.custom_minimum_size = Vector2(180, 54)
	trump_select.add_theme_font_size_override("font_size", 15)
	for card_name in ["Aegis", "Perfect Draw", "Exchange", "Destroy", "Executioner's Mark", "Cursed Hand", "Raise the Limit", "Rebirth"]:
		trump_select.add_item(card_name)
	buttons.add_child(trump_select)
	trump_button = _button("USE TRUMP", Color("#344e52"))
	trump_button.pressed.connect(_on_trump)
	buttons.add_child(trump_button)
	next_button = _button("NEXT DUEL", Color("#60435e"))
	next_button.pressed.connect(_on_next)
	buttons.add_child(next_button)

func _label(value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label

func _button(value: String, color: Color) -> Button:
	var button := Button.new()
	button.text = value
	button.custom_minimum_size = Vector2(150, 54)
	button.add_theme_font_size_override("font_size", 16)
	button.add_theme_color_override("font_color", Color("#fff7eb"))
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 14
	style.content_margin_right = 14
	button.add_theme_stylebox_override("normal", style)
	var hover := style.duplicate()
	hover.bg_color = color.lightened(0.15)
	button.add_theme_stylebox_override("hover", hover)
	return button

func _start_encounter() -> void:
	run_over = false
	boss_phase_announced = false
	reward_claimed = false
	second_wind_used = false
	_build_deck()
	_start_hand()

func _start_hand() -> void:
	round_active = true
	shield = next_start_shield
	next_start_shield = 0
	trump_ready = true
	safe_limit = 21
	executioner_mark = false
	cursed_enemy = false
	player_hand.clear()
	enemy_hand.clear()
	_draw_to(player_hand, 2)
	_draw_to(enemy_hand, 2)
	status_text = "Encounter %d: reach 21 without busting." % encounter
	_refresh()

func _build_deck() -> void:
	deck = Rules.create_deck()
	deck.shuffle()

func _draw_card() -> Dictionary:
	if deck.is_empty():
		_build_deck()
	return deck.pop_back()

func _draw_to(hand: Array[Dictionary], count: int) -> void:
	for _i in range(count):
		hand.append(_draw_card())

func _card_value(card: Dictionary) -> int:
	return Rules.card_value(card)

func _hand_total(hand: Array[Dictionary]) -> int:
	return Rules.hand_total(hand)

func _populate_cards(row: HBoxContainer, hand: Array[Dictionary], hide_first: bool, emphasize_last: bool = true) -> void:
	for child in row.get_children():
		child.queue_free()
	for i in range(hand.size()):
		var hidden := hide_first and i == 0
		var panel := PanelContainer.new()
		panel.custom_minimum_size = Vector2(48, 58)
		var style := StyleBoxFlat.new()
		style.bg_color = Color("#4c263c") if hidden else Color("#f3ead8")
		style.border_color = Color("#f3c96b") if emphasize_last and i == hand.size() - 1 and not hidden else Color("#c6a45e")
		style.set_border_width_all(3 if emphasize_last and i == hand.size() - 1 and not hidden else 2)
		style.set_corner_radius_all(6)
		panel.add_theme_stylebox_override("panel", style)
		row.add_child(panel)
		var face := Label.new()
		if hidden:
			face.text = "✦\n✦"
			face.add_theme_color_override("font_color", Color("#f3ead8"))
		else:
			var card: Dictionary = hand[i]
			face.text = "%s\n%s" % [str(card["rank"]), str(card["suit"])]
			var suit := str(card["suit"])
			face.add_theme_color_override("font_color", Color("#a12d45") if suit in ["♥", "♦"] else Color("#17131b"))
		face.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		face.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		face.add_theme_font_size_override("font_size", 18)
		panel.add_child(face)

func _hand_text(hand: Array[Dictionary], hide_first: bool = false) -> String:
	var parts: Array[String] = []
	for i in range(hand.size()):
		if hide_first and i == 0:
			parts.append("[ hidden ]")
		else:
			var card: Dictionary = hand[i]
			parts.append("%s%s" % [str(card["rank"]), str(card["suit"])])
	return "   ".join(parts)

func _on_hit() -> void:
	if not round_active or run_over:
		return
	player_hand.append(_draw_card())
	var total := _hand_total(player_hand)
	if total > safe_limit:
		round_active = false
		var damage := 10 if encounter == MAX_ENCOUNTERS else 8
		if class_select.get_item_text(class_select.selected) == "Knight" or passive_select.get_item_text(passive_select.selected) == "Steel Nerve":
			damage = maxi(0, damage - 2)
		if passive_select.get_item_text(passive_select.selected) == "Quick Reflex":
			damage = maxi(0, damage - 1)
		if passive_select.get_item_text(passive_select.selected) == "High Roller":
			damage += 2
		var damage_result := Rules.absorb_damage(damage, shield)
		damage = int(damage_result["damage"])
		shield = int(damage_result["shield"])
		player_hp = maxi(0, player_hp - damage)
		status_text = "BUST at %d. You take %d damage." % [total, damage]
		_check_run_end(false)
		if not run_over:
			status_text += " Press NEXT HAND to continue the duel."
	_refresh()

func _enemy_draw_target() -> int:
	var target := 17 + int((encounter - 1) / 2)
	if Rules.is_boss_enraged(encounter, MAX_ENCOUNTERS, enemy_hp, STARTING_HP + (MAX_ENCOUNTERS - 1) * 6):
		target += 1
	if cursed_enemy:
		target += 1
		if passive_select.get_item_text(passive_select.selected) == "Card Reader":
			target += 1
	return target

func _on_stand() -> void:
	if not round_active or run_over:
		return
	round_active = false
	var enemy_target := _enemy_draw_target()
	while _hand_total(enemy_hand) < enemy_target:
		enemy_hand.append(_draw_card())
	var player_total := _hand_total(player_hand)
	var enemy_total := _hand_total(enemy_hand)
	var hand_result := Rules.resolve_hand_result(player_total, enemy_total)
	if hand_result == "enemy_bust":
		var bust_damage := 10 + next_bonus_damage
		next_bonus_damage = 0
		enemy_hp = maxi(0, enemy_hp - bust_damage)
		status_text = "The challenger busts at %d. You deal %d damage." % [enemy_total, bust_damage]
	elif hand_result == "player_win":
		var damage := 12 if player_total == 21 else 8
		if class_select.get_item_text(class_select.selected) == "Rogue":
			damage += 2
		damage += next_bonus_damage
		next_bonus_damage = 0
		if passive_select.get_item_text(passive_select.selected) == "High Roller":
			damage += 4
		if passive_select.get_item_text(passive_select.selected) == "Last Stand" and player_hp <= 10:
			damage += 3
		if passive_select.get_item_text(passive_select.selected) == "Collector's Instinct":
			player_hp = mini(STARTING_HP, player_hp + 1)
		if passive_select.get_item_text(passive_select.selected) == "Boss Hunter" and encounter == MAX_ENCOUNTERS:
			damage += 4
		if passive_select.get_item_text(passive_select.selected) == "Second Wind" and not second_wind_used:
			player_hp = mini(STARTING_HP, player_hp + 2)
			second_wind_used = true
		if executioner_mark:
			damage += 6
			if passive_select.get_item_text(passive_select.selected) == "Boss Hunter" and encounter == MAX_ENCOUNTERS:
				damage += 4
			executioner_mark = false
		enemy_hp = maxi(0, enemy_hp - damage)
		status_text = "You win the hand (%d to %d) and deal %d damage." % [player_total, enemy_total, damage]
	elif hand_result == "enemy_win":
		var damage := 8
		if Rules.is_boss_enraged(encounter, MAX_ENCOUNTERS, enemy_hp, STARTING_HP + (MAX_ENCOUNTERS - 1) * 6):
			damage += 2
		if class_select.get_item_text(class_select.selected) == "Knight" or passive_select.get_item_text(passive_select.selected) == "Steel Nerve":
			damage = maxi(0, damage - 2)
		if passive_select.get_item_text(passive_select.selected) == "High Roller":
			damage += 2
		if passive_select.get_item_text(passive_select.selected) == "Quick Reflex":
			damage = maxi(0, damage - 1)
		if passive_select.get_item_text(passive_select.selected) == "Steady Hand" and player_total >= 18 and player_total <= 20:
			damage = maxi(0, damage - 2)
		var damage_result := Rules.absorb_damage(damage, shield)
		damage = int(damage_result["damage"])
		shield = int(damage_result["shield"])
		player_hp = maxi(0, player_hp - damage)
		status_text = "The challenger wins (%d to %d). You take %d damage." % [enemy_total, player_total, damage]
	else:
		status_text = "Push: both hands total %d. No damage." % player_total
	_check_run_end(enemy_hp <= 0)
	if not run_over and Rules.is_boss_enraged(encounter, MAX_ENCOUNTERS, enemy_hp, STARTING_HP + (MAX_ENCOUNTERS - 1) * 6) and not boss_phase_announced:
		boss_phase_announced = true
		status_text += " THE HOUSE enters DOUBLE OR NOTHING: it draws harder and deals +2 damage."
	if not run_over and enemy_hp > 0 and player_hp > 0:
		status_text += " Press NEXT HAND to continue the duel."
	_refresh()

func _on_trump() -> void:
	if not round_active or run_over or not trump_ready:
		return
	var selected := trump_select.get_item_text(trump_select.selected)
	match selected:
		"Aegis":
			var shield_gain := 12 if passive_select.get_item_text(passive_select.selected) == "Steel Nerve" else 8
			shield += shield_gain
			status_text = "UNBREAKABLE FATE combo: gain %d shield." % shield_gain if shield_gain == 12 else "AEGIS: gain 8 shield against your next incoming damage."
		"Perfect Draw":
			var candidates: Array[Dictionary] = []
			var draw_count := 4 if class_select.get_item_text(class_select.selected) == "Dealer" else 3
			if passive_select.get_item_text(passive_select.selected) == "Shadow Dealer":
				draw_count += 1
			for _i in range(draw_count):
				candidates.append(_draw_card())
			var chosen: Dictionary = candidates[0]
			var best_total := 99
			for candidate in candidates:
				var candidate_hand: Array[Dictionary] = player_hand.duplicate()
				candidate_hand.append(candidate)
				var candidate_total := _hand_total(candidate_hand)
				if candidate_total <= 21 and candidate_total < best_total:
					chosen = candidate
					best_total = candidate_total
			if best_total == 99:
				status_text = "PERFECT DRAW: no safe card found among %d cards; no card added." % draw_count
			else:
				player_hand.append(chosen)
				status_text = "PERFECT DRAW: selected %s%s from %d cards." % [chosen["rank"], chosen["suit"], draw_count]
		"Exchange":
			if player_hand.size() < 2:
				return
			var highest_index := 0
			for i in range(1, player_hand.size()):
				if _card_value(player_hand[i]) > _card_value(player_hand[highest_index]):
					highest_index = i
			var replacement_card := _draw_card()
			var test_hand: Array[Dictionary] = player_hand.duplicate()
			test_hand[highest_index] = replacement_card
			if _hand_total(test_hand) <= 21:
				var old_card: Dictionary = player_hand[highest_index]
				player_hand[highest_index] = replacement_card
				if passive_select.get_item_text(passive_select.selected) == "Quick Reflex":
					shield += 4
					status_text = "CURSED REVERSAL combo: exchange succeeded and gained 4 shield."
				else:
					status_text = "EXCHANGE: %s%s replaced by %s%s." % [old_card["rank"], old_card["suit"], replacement_card["rank"], replacement_card["suit"]]
			else:
				status_text = "EXCHANGE failed safely: replacement would bust. Your hand is unchanged."
		"Destroy":
			if player_hand.size() <= 2:
				return
			var highest_index := 0
			for i in range(1, player_hand.size()):
				if _card_value(player_hand[i]) > _card_value(player_hand[highest_index]):
					highest_index = i
			var removed: Dictionary = player_hand.pop_at(highest_index)
			status_text = "DESTROY: removed %s%s from your hand." % [removed["rank"], removed["suit"]]
		"Executioner's Mark":
			executioner_mark = true
			status_text = "PERFECT EXECUTION combo: +10 damage on your next win against the boss." if passive_select.get_item_text(passive_select.selected) == "Boss Hunter" and encounter == MAX_ENCOUNTERS else "EXECUTIONER'S MARK: your next winning hand deals +6 damage."
		"Cursed Hand":
			cursed_enemy = true
			status_text = "DEALER'S TRAP combo: challenger draws to %d." % _enemy_draw_target() if passive_select.get_item_text(passive_select.selected) == "Card Reader" else "CURSED HAND: challenger must draw to %d this hand." % _enemy_draw_target()
		"Raise the Limit":
			safe_limit = 24 if passive_select.get_item_text(passive_select.selected) == "High Roller" else 23
			status_text = "DEMON'S BARGAIN combo: your hand can reach 24 this hand." if safe_limit == 24 else "RAISE THE LIMIT: your hand can reach 23 before busting this hand."
		"Rebirth":
			if not rebirth_available:
				status_text = "REBIRTH has already been spent this run."
				_refresh()
				return
			rebirth_armed = true
			status_text = "REBIRTH armed: survive one otherwise-lethal hit with 8 HP."
	trump_ready = false
	_refresh()

func _check_run_end(enemy_defeated: bool) -> void:
	if player_hp <= 0 and rebirth_armed and rebirth_available:
		var rebirth_hp := 12 if passive_select.get_item_text(passive_select.selected) == "Last Stand" else 8
		player_hp = rebirth_hp
		rebirth_armed = false
		rebirth_available = false
		round_active = false
		status_text = "SECOND CHANCE combo: Rebirth triggered at %d HP." % rebirth_hp if rebirth_hp == 12 else "REBIRTH triggered: you return with 8 HP."
	elif player_hp <= 0:
		run_over = true
		round_active = false
		status_text = "DEFEAT. The table claims another soul. Restart to try again."
	elif enemy_defeated:
		round_active = false
		if encounter >= MAX_ENCOUNTERS:
			run_over = true
			status_text = "THE HOUSE FALLS. You survived all five duels. Restart for another run."
		else:
			status_text = "Victory. Duel %d cleared. Press NEXT DUEL to continue." % encounter

func _on_next() -> void:
	var action := Rules.resolve_next_action(encounter, MAX_ENCOUNTERS, enemy_hp, run_over, round_active, reward_claimed)
	match action:
		"restart_run":
			encounter = 1
			player_hp = STARTING_HP
			enemy_hp = STARTING_HP
			rebirth_available = true
			rebirth_armed = false
			_start_encounter()
		"blocked_active_hand", "claim_reward", "finish_run":
			return
		"next_encounter":
			encounter += 1
			enemy_hp = STARTING_HP + (encounter - 1) * 6
			player_hp = mini(STARTING_HP, player_hp + 5)
			_start_encounter()
		"next_hand":
			_start_hand()

func _on_claim_reward() -> void:
	if round_active or run_over or enemy_hp > 0 or encounter >= MAX_ENCOUNTERS or reward_claimed:
		return
	match reward_select.get_item_text(reward_select.selected):
		"Mend (+8 HP)":
			player_hp = mini(STARTING_HP, player_hp + 8)
			status_text = "Reward claimed: restored up to 8 HP."
		"Power (+3 damage)":
			next_bonus_damage += 3
			status_text = "Reward claimed: +3 damage on your next successful hand."
		"Guard (+6 shield)":
			next_start_shield += 6
			status_text = "Reward claimed: +6 shield at the start of your next hand."
	reward_claimed = true
	_refresh()

func _save_progress() -> void:
	var save := ConfigFile.new()
	save.set_value("meta", "version", SAVE_VERSION)
	save.set_value("run", "player_hp", player_hp)
	save.set_value("run", "enemy_hp", enemy_hp)
	save.set_value("run", "encounter", encounter)
	save.set_value("run", "shield", shield)
	save.set_value("run", "run_over", run_over)
	save.set_value("run", "class_index", class_select.selected)
	save.set_value("run", "passive_index", passive_select.selected)
	save.set_value("run", "rebirth_available", rebirth_available)
	save.set_value("run", "rebirth_armed", rebirth_armed)
	save.set_value("run", "reward_claimed", reward_claimed)
	save.set_value("run", "next_bonus_damage", next_bonus_damage)
	save.set_value("run", "next_start_shield", next_start_shield)
	save.save("user://run_save.cfg")

func _load_progress() -> void:
	var save := ConfigFile.new()
	if save.load("user://run_save.cfg") != OK:
		return
	var save_version := int(save.get_value("meta", "version", 0))
	if save_version != SAVE_VERSION:
		return
	var saved_run := {"player_hp": save.get_value("run", "player_hp", STARTING_HP), "enemy_hp": save.get_value("run", "enemy_hp", STARTING_HP), "encounter": save.get_value("run", "encounter", 1), "shield": save.get_value("run", "shield", 0), "next_bonus_damage": save.get_value("run", "next_bonus_damage", 0), "next_start_shield": save.get_value("run", "next_start_shield", 0)}
	var checked_run: Dictionary = Rules.validate_saved_run(saved_run, STARTING_HP, STARTING_HP + (MAX_ENCOUNTERS - 1) * 6, MAX_ENCOUNTERS)
	if not bool(checked_run["valid"]):
		return
	player_hp = int(checked_run["player_hp"])
	enemy_hp = int(checked_run["enemy_hp"])
	encounter = int(checked_run["encounter"])
	shield = int(checked_run["shield"])
	next_bonus_damage = int(checked_run["next_bonus_damage"])
	next_start_shield = int(checked_run["next_start_shield"])
	rebirth_available = bool(save.get_value("run", "rebirth_available", true))
	rebirth_armed = bool(save.get_value("run", "rebirth_armed", false))
	reward_claimed = bool(save.get_value("run", "reward_claimed", false))
	if bool(save.get_value("run", "run_over", false)) or player_hp <= 0 or encounter > MAX_ENCOUNTERS:
		player_hp = STARTING_HP
		enemy_hp = STARTING_HP
		encounter = 1
		rebirth_available = true
		rebirth_armed = false
	elif enemy_hp <= 0:
		if encounter >= MAX_ENCOUNTERS:
			player_hp = STARTING_HP
			enemy_hp = STARTING_HP
			encounter = 1
		else:
			encounter += 1
			enemy_hp = STARTING_HP + (encounter - 1) * 6
			player_hp = mini(STARTING_HP, player_hp + 5)
	class_select.select(clampi(int(save.get_value("run", "class_index", 0)), 0, class_select.item_count - 1))
	passive_select.select(clampi(int(save.get_value("run", "passive_index", 0)), 0, passive_select.item_count - 1))

func _refresh() -> void:
	encounter_label.text = "DUEL %d / %d  •  %s" % [encounter, MAX_ENCOUNTERS, enemy_names[clampi(encounter - 1, 0, enemy_names.size() - 1)]]
	var shield_text := "  (SHIELD %d)" % shield if shield > 0 else ""
	health_label.text = "YOU  %d HP%s     |     CHALLENGER  %d HP" % [player_hp, shield_text, enemy_hp]
	var enemy_total_text := "?" if round_active else str(_hand_total(enemy_hand))
	if round_active and passive_select.get_item_text(passive_select.selected) == "Card Reader":
		enemy_total_text = "Intent: draw to %d" % _enemy_draw_target()
	enemy_hand_label.text = "CHALLENGER  •  Total: %s" % enemy_total_text
	player_hand_label.text = "YOUR HAND  •  Total: %d" % _hand_total(player_hand)
	_populate_cards(enemy_cards_row, enemy_hand, round_active)
	_populate_cards(player_cards_row, player_hand, false)
	status_label.text = status_text
	if status_text.begins_with("BUST") or status_text.begins_with("DEFEAT") or status_text.begins_with("The challenger wins"):
		status_label.add_theme_color_override("font_color", Color("#ef7c86"))
	elif status_text.begins_with("You win") or status_text.begins_with("The challenger busts") or status_text.begins_with("Victory") or status_text.begins_with("THE HOUSE FALLS"):
		status_label.add_theme_color_override("font_color", Color("#8ee0a2"))
	elif status_text.begins_with("Push"):
		status_label.add_theme_color_override("font_color", Color("#c8becb"))
	else:
		status_label.add_theme_color_override("font_color", Color("#d7b56d"))
	hit_button.disabled = not round_active or run_over
	stand_button.disabled = not round_active or run_over
	trump_button.disabled = not round_active or run_over or not trump_ready
	trump_select.disabled = not round_active or run_over or not trump_ready
	class_select.disabled = round_active or run_over
	passive_select.disabled = round_active or run_over
	reward_row.visible = not round_active and enemy_hp <= 0 and encounter < MAX_ENCOUNTERS and not run_over
	claim_reward_button.disabled = reward_claimed
	reward_select.disabled = reward_claimed
	next_button.disabled = round_active or (enemy_hp <= 0 and encounter < MAX_ENCOUNTERS and not reward_claimed)
	next_button.text = "RESTART RUN" if run_over else ("CLAIM REWARD FIRST" if enemy_hp <= 0 and encounter < MAX_ENCOUNTERS and not reward_claimed else ("NEXT DUEL" if enemy_hp <= 0 else "NEXT HAND"))
	if not round_active and not (enemy_hp <= 0 and encounter < MAX_ENCOUNTERS and not reward_claimed):
		_save_progress()
