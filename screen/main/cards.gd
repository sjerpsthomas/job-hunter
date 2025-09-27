extends Node2D

var card_id := 0


func _ready() -> void:
	for i in range(4):
		add_random_card()
	
	set_card_id(0)


func add_random_card() -> void:
	var size := PortfolioItemsCollection.portfolio_items.size()
	
	var card := preload("res://core/card/card.tscn").instantiate() as Card
	add_child(card)
	
	card.initialize(PortfolioItemsCollection.portfolio_items[randi_range(0, size - 1)])
	
	card.collapse()
	card.position.x = 50 * (get_child_count() - 1)


func discard_and_redraw() -> void:
	# Free picked cards, reposition old cards
	var i := 0
	var picked_count := 0
	
	for card: Card in get_children():
		if card.picked:
			card.free()
			picked_count += 1
		else:
			card.position.x = 50 * i
			i += 1
	
	for j in range(picked_count):
		add_random_card()
	
	set_card_id(0)


# -
func _process(_delta: float) -> void:
	var res_pos := Vector2(450 - 50 * card_id, 700)
	
	position = position.lerp(res_pos, 0.2)


func _unhandled_input(event: InputEvent) -> void:
	var size := get_children().size()
	
	if event.is_action_pressed("ui_left"):
		set_card_id(posmod(card_id - 1, size))
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_right"):
		set_card_id(posmod(card_id + 1, size))
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_card_info"):
		reveal_card(get_child(card_id))
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_accept"):
		pick_card(get_child(card_id))
		get_viewport().set_input_as_handled()


func set_card_id(new_card_id: int) -> void:
	card_id = new_card_id
	collapse_all()
	(get_children()[card_id] as Card).z_index = 1
	
	for i in range(get_child_count()):
		var card: Card = get_child(i)
		card.z_index = -abs(i - card_id)
		card.set_border(i == card_id)


func collapse_all(card_to_keep: Card = null) -> void:
	for c: Card in get_children():
		if not card_to_keep or c != card_to_keep:
			c.collapse()


func reveal_card(card: Card) -> void:
	collapse_all(card)
	
	if card.collapsed:
		card.expand()
	else:
		card.collapse()


func pick_card(card: Card) -> void:
	if not card.collapsed:
		return
	
	if card.picked:
		card.picked = false
	else:
		card.picked = true
