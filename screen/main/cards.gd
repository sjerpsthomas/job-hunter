extends Node2D

var card_id := 0


func _ready() -> void:
	var size := PortfolioItemsCollection.portfolio_items.size()
	
	for i in range(size):
		var card := preload("res://core/card/card.tscn").instantiate() as Card
		add_child(card)
		
		#card.clicked.connect(_on_card_clicked)
		
		card.initialize(PortfolioItemsCollection.portfolio_items[randi_range(0, size - 1)])
		
		card.collapse()
		card.position.x = 480 * i


# -
func _process(_delta: float) -> void:
	var res_pos := Vector2(450 - 480 * card_id, 700)
	
	position = position.lerp(res_pos, 0.2)


func _unhandled_input(event: InputEvent) -> void:
	var size := get_children().size()
	
	if event.is_action_pressed("ui_left"):
		card_id = posmod(card_id - 1, size)
		collapse_all()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_right"):
		card_id = posmod(card_id + 1, size)
		collapse_all()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_card_info"):
		reveal_card(get_child(card_id))
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_accept"):
		pick_card(get_child(card_id))
		get_viewport().set_input_as_handled()


func collapse_all(card_to_keep: Card = null) -> void:
	for c: Card in get_children():
		if not card_to_keep or c != card_to_keep:
			c.collapse()
			c.z_index = 0


func reveal_card(card: Card) -> void:
	collapse_all(card)
	
	if card.collapsed:
		card.expand()
		card.z_index = 1
	else:
		card.collapse()


func pick_card(card: Card) -> void:
	if not card.collapsed:
		return
	
	if card.picked:
		card.picked = false
	else:
		card.picked = true
