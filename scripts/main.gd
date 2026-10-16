extends Control

const MAX_ENCOUNTERS := 5
const STARTING_HP := 30

const Rules = preload("res://scripts/blackjack_rules.gd")

var deck: Array[Dictionary] = []
var player_hand: Array[Dictionary] = []
var enemy_hand: Array[Dictionary] = []
var player_hp := STARTING_HP
var enemy_hp := STARTING_HP
var encounter := 1
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
var status_label: Label
var hit_button: Button
var stand_button: Button
var trump_button: Button
var trump_select: OptionButton
var next_button: Button
var class_select: OptionButton
var passive_select: OptionButton
var second_wind_used := false
var executioner_mark := false
var cursed_enemy := false

func _ready() -> void:
	_build_ui()
	_start_encounter()

func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color("#100b12")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	root_box = VBoxContainer.new()
	root_box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root_box.add_theme_constant_override("separation", 12)
	root_box.add_theme_constant_override("margin_left", 24)
	root_box.add_theme_constant_override("margin_right", 24)
	root_box.add_theme_constant_override("margin_top", 18)
	root_box.add_theme_constant_override("margin_bottom", 18)
	add_child(root_box)

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

	enemy_hand_label = _label("", 22, Color("#f0d7d7"))
	enemy_hand_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root_box.add_child(enemy_hand_label)
	player_hand_label = _label("", 24, Color("#fff3d8"))
	player_hand_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root_box.add_child(player_hand_label)
	status_label = _label("", 16, Color("#d7b56d"))
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root_box.add_child(status_label)

	var build_row := HBoxContainer.new()
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
	for passive_name in ["Steel Nerve", "Second Wind", "High Roller", "Boss Hunter", "Card Reader"]:
		passive_select.add_item(passive_name)
	build_row.add_child(passive_select)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_box.add_child(spacer)

	var buttons := HBoxContainer.new()
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
	for card_name in ["Aegis", "Perfect Draw", "Exchange", "Destroy", "Executioner's Mark", "Cursed Hand"]:
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
	second_wind_used = false
	_build_deck()
	_start_hand()

func _start_hand() -> void:
	round_active = true
	shield = 0
	trump_ready = true
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
	if total > 21:
		round_active = false
		var damage := 8
		if class_select.get_item_text(class_select.selected) == "Knight" or passive_select.get_item_text(passive_select.selected) == "Steel Nerve":
			damage = maxi(0, damage - 2)
		if passive_select.get_item_text(passive_select.selected) == "High Roller":
			damage += 2
		var blocked: int = mini(shield, damage)
		damage -= blocked
		shield -= blocked
		player_hp = maxi(0, player_hp - damage)
		status_text = "BUST at %d. You take %d damage." % [total, damage]
		_check_run_end(false)
		if not run_over:
			status_text += " Press NEXT HAND to continue the duel."
	_refresh()

func _on_stand() -> void:
	if not round_active or run_over:
		return
	round_active = false
	var enemy_target := 19 if cursed_enemy else 17
	while _hand_total(enemy_hand) < enemy_target:
		enemy_hand.append(_draw_card())
	var player_total := _hand_total(player_hand)
	var enemy_total := _hand_total(enemy_hand)
	if enemy_total > 21:
		enemy_hp = maxi(0, enemy_hp - 10)
		status_text = "The challenger busts at %d. You deal 10 damage." % enemy_total
	elif player_total > enemy_total:
		var damage := 12 if player_total == 21 else 8
		if class_select.get_item_text(class_select.selected) == "Rogue":
			damage += 2
		if passive_select.get_item_text(passive_select.selected) == "High Roller":
			damage += 4
		if passive_select.get_item_text(passive_select.selected) == "Boss Hunter" and encounter == MAX_ENCOUNTERS:
			damage += 4
		if passive_select.get_item_text(passive_select.selected) == "Second Wind" and not second_wind_used:
			player_hp = mini(STARTING_HP, player_hp + 2)
			second_wind_used = true
		if executioner_mark:
			damage += 6
			executioner_mark = false
		enemy_hp = maxi(0, enemy_hp - damage)
		status_text = "You win the hand (%d to %d) and deal %d damage." % [player_total, enemy_total, damage]
	elif player_total < enemy_total:
		var damage := 8
		if class_select.get_item_text(class_select.selected) == "Knight" or passive_select.get_item_text(passive_select.selected) == "Steel Nerve":
			damage = maxi(0, damage - 2)
		if passive_select.get_item_text(passive_select.selected) == "High Roller":
			damage += 2
		var blocked: int = mini(shield, damage)
		damage -= blocked
		shield -= blocked
		player_hp = maxi(0, player_hp - damage)
		status_text = "The challenger wins (%d to %d). You take %d damage." % [enemy_total, player_total, damage]
	else:
		status_text = "Push: both hands total %d. No damage." % player_total
	_check_run_end(enemy_hp <= 0)
	if not run_over and enemy_hp > 0 and player_hp > 0:
		status_text += " Press NEXT HAND to continue the duel."
	_refresh()

func _on_trump() -> void:
	if not round_active or run_over or not trump_ready:
		return
	var selected := trump_select.get_item_text(trump_select.selected)
	match selected:
		"Aegis":
			shield += 8
			status_text = "AEGIS: gain 8 shield against your next incoming damage."
		"Perfect Draw":
			var candidates: Array[Dictionary] = []
			var draw_count := 4 if class_select.get_item_text(class_select.selected) == "Dealer" else 3
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
				status_text = "PERFECT DRAW: no safe card found among three; no card added."
			else:
				player_hand.append(chosen)
				status_text = "PERFECT DRAW: selected %s%s from three cards." % [chosen["rank"], chosen["suit"]]
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
			status_text = "EXECUTIONER'S MARK: your next winning hand deals +6 damage."
		"Cursed Hand":
			cursed_enemy = true
			status_text = "CURSED HAND: challenger must draw to 19 this hand."
	trump_ready = false
	_refresh()

func _check_run_end(enemy_defeated: bool) -> void:
	if player_hp <= 0:
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
	if run_over:
		encounter = 1
		player_hp = STARTING_HP
		enemy_hp = STARTING_HP
		_start_encounter()
		return
	if round_active:
		return
	if enemy_hp <= 0:
		encounter += 1
		enemy_hp = STARTING_HP + (encounter - 1) * 6
		player_hp = mini(STARTING_HP, player_hp + 5)
		_start_encounter()
	else:
		_start_hand()

func _refresh() -> void:
	encounter_label.text = "DUEL %d / %d" % [encounter, MAX_ENCOUNTERS]
	var shield_text := "  (SHIELD %d)" % shield if shield > 0 else ""
	health_label.text = "YOU  %d HP%s     |     CHALLENGER  %d HP" % [player_hp, shield_text, enemy_hp]
	enemy_hand_label.text = "CHALLENGER\n%s\nTotal: %s" % [_hand_text(enemy_hand, round_active), "?" if round_active else str(_hand_total(enemy_hand))]
	player_hand_label.text = "YOUR HAND\n%s\nTotal: %d" % [_hand_text(player_hand), _hand_total(player_hand)]
	status_label.text = status_text
	hit_button.disabled = not round_active or run_over
	stand_button.disabled = not round_active or run_over
	trump_button.disabled = not round_active or run_over or not trump_ready
	trump_select.disabled = not round_active or run_over or not trump_ready
	class_select.disabled = round_active or run_over
	passive_select.disabled = round_active or run_over
	next_button.disabled = round_active
	next_button.text = "RESTART RUN" if run_over else ("NEXT DUEL" if enemy_hp <= 0 else "NEXT HAND")
