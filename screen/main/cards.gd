extends Node2D

var card_id := 0
var cards: Array[Card]

@onready var main_screen := get_parent() as MainScreen

const CARD_COUNT := 5


func _ready() -> void:
	for i in range(CARD_COUNT):
		add_random_card()
	
	@warning_ignore("integer_division")
	set_card_id(CARD_COUNT / 2)
	
	position = Vector2(400 - 60 * card_id, 450)
	
	main_screen.select_count = 20
	main_screen.discard_count = 5


func add_random_card() -> void:
	var size := PortfolioItemsCollection.portfolio_items.size()
	
	var card_item: PortfolioItemsCollection.PortfolioItem
	
	if randf() < 0.13 and not cards.is_empty():
		card_item = cards.pick_random().item
	else:
		card_item = PortfolioItemsCollection.portfolio_items[randi_range(0, size - 1)]
	
	var card := preload("res://core/card/card.tscn").instantiate() as Card
	cards.append(card)
	add_child(card)
	
	card.clicked.connect(_on_card_clicked)
	
	card.initialize(card_item)
	
	card.position.x = 60 * (cards.size() - 1)
	card.position.y = 100
	
	card.collapse()


func discard_and_redraw() -> void:
	# Free picked cards, reposition old cards
	for card in cards:
		if card.picked:
			card.queue_free()
	
	cards.assign(cards.filter(func(it: Card): return not it.picked))
	
	while cards.size() < CARD_COUNT:
		add_random_card()
	
	@warning_ignore("integer_division")
	set_card_id(CARD_COUNT / 2)


# -
func _process(_delta: float) -> void:
	var res_pos := Vector2(400 - 60 * card_id, 400)
	
	position = position.lerp(res_pos, 0.25)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		set_card_id(posmod(card_id - 1, cards.size()))
		get_viewport().set_input_as_handled()
	
	elif event.is_action_pressed("ui_right"):
		set_card_id(posmod(card_id + 1, cards.size()))
		get_viewport().set_input_as_handled()
	
	elif event.is_action_pressed("ui_card_info"):
		reveal_card(cards[card_id])
		get_viewport().set_input_as_handled()
	
	elif event.is_action_pressed("ui_card_discard"):
		discard_card(card_id)
		get_viewport().set_input_as_handled()
	
	elif event.is_action_pressed("ui_accept"):
		pick_card(cards[card_id])
		get_viewport().set_input_as_handled()


func _on_card_clicked(card: Card) -> void:
	print(card)
	for i in range(cards):
		if cards[i] == card:
			set_card_id(i)
			return


func set_card_id(new_card_id: int) -> void:
	if main_screen.state == MainScreen.State.GAME_OVER:
		return
	
	card_id = new_card_id
	collapse_all()
	
	for i in range(cards.size()):
		var card := cards[i]
		card.z_index = -absi(i - card_id)
		
		card.target_move_position.x = 60 * i
		card.target_move_position.y = 5 * absi(i - card_id)
		
		card.set_border(i == card_id)


func collapse_all(card_to_keep: Card = null) -> bool:
	var res := false
	
	for card in cards:
		if not card_to_keep or card != card_to_keep:
			res = res or not card.collapsed
			card.collapse()
	
	return res


func reveal_card(card: Card) -> void:
	if main_screen.state != MainScreen.State.NORMAL:
		return
	
	collapse_all(card)
	
	if card.collapsed:
		card.expand()
	else:
		card.collapse()


func pick_card(card: Card) -> void:
	if main_screen.state != MainScreen.State.NORMAL:
		return
	
	if not card.collapsed:
		card.collapse()
	
	if card.picked:
		card.picked = false
		main_screen.select_count += 1
	elif main_screen.select_count > 0:
		card.picked = true
		main_screen.select_count -= 1
	
	card.set_border(true)


func discard_card(card_index: int) -> void:
	if main_screen.state != MainScreen.State.NORMAL:
		return
	
	if main_screen.discard_count <= 0:
		return
	
	var card := cards[card_index]
	
	card.queue_free()
	cards.remove_at(card_index)
	add_random_card()
	
	main_screen.discard_count -= 1
	
	set_card_id(card_id)
