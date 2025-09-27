extends Node2D


var duplicate_weakness: int
var link_weakness: int
var duplicate_tag_weakness: int
var card_num_weakness: int

var health: int


func get_weakness(zero_chance: float, options: Array[int]) -> int:
	return 0 if randf() < zero_chance else options.pick_random()

func _ready() -> void:
	duplicate_weakness = get_weakness(0.7, [1, 1, 1, 2, 2, 3])
	link_weakness = get_weakness(0.7, [1, 1, 1, 2, 2, 3])
	duplicate_tag_weakness = get_weakness(0.7, [1, 1, 1, 2, 2, 3])
	card_num_weakness = get_weakness(0.7, [1, 1, 1, 2, 2, 3])
	
	health = 100
