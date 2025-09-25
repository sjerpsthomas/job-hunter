extends Node2D


var id := 0

@onready var size := PortfolioItemsCollection.portfolio_items.size()


func _ready() -> void:
	apply()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		id = posmod(id - 1, size)
		apply()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_right"):
		id = posmod(id + 1, size)
		apply()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_accept"):
		if $Card.collapsed:
			$Card.expand()
		else: $Card.collapse()
		get_viewport().set_input_as_handled()


func apply() -> void:
	$Card.initialize(PortfolioItemsCollection.portfolio_items[id])
