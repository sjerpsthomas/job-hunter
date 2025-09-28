extends Node2D

var card_id := 0
var cards: Array[Card]


func _ready() -> void:
	for i in range(5):
		add_random_card()
	
	set_card_id(2)


func add_random_card() -> void:
	var size := PortfolioItemsCollection.portfolio_items.size()
	
	var card := preload("res://core/card/card.tscn").instantiate() as Card
	cards.append(card)
	add_child(card)
	
	card.initialize(PortfolioItemsCollection.portfolio_items[randi_range(0, size - 1)])
	
	card.collapse()
	card.position.x = 50 * (cards.size() - 1)


func discard_and_redraw() -> void:
	# Free picked cards, reposition old cards
	for card in cards:
		if card.picked:
			card.queue_free()
	
	cards.assign(cards.filter(func(it: Card): return not it.picked))
	
	for i in range(cards.size()):
		var card := cards[i]
		card.position.x = 50 * i
	
	while cards.size() < 5:
		add_random_card()
	
	set_card_id(2)


# -
func _process(_delta: float) -> void:
	var res_pos := Vector2(450 - 50 * card_id, 700)
	
	position = position.lerp(res_pos, 0.25)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		set_card_id(posmod(card_id - 1, cards.size()))
		get_viewport().set_input_as_handled()
	
	elif event.is_action_pressed("ui_right"):
		set_card_id(posmod(card_id + 1, cards.size()))
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
	
	for i in range(cards.size()):
		var card := cards[i]
		card.z_index = -absi(i - card_id)
		
		card.position.y = 4 * absi(i - card_id)
		
		card.set_border(i == card_id)


func collapse_all(card_to_keep: Card = null) -> bool:
	var res := false
	
	for card in cards:
		if not card_to_keep or card != card_to_keep:
			res = res or not card.collapsed
			card.collapse()
	
	return res


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
