extends Node2D


@onready var title := %Title as AnimatedSprite2D

@onready var start_y = title.position.y
var time := 0.0


func _ready() -> void:
	title.frame = 1 if Locale.locale == 'nl' else 0
	
	%PlayButton.text = Locale.txt('play')


func _process(delta: float) -> void:
	time += delta
	
	title.position.y = start_y + 15 * sin(time * 2)


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://screen/tutorial/tutorial_screen.tscn")
