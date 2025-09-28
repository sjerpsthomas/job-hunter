extends Panel

@onready var main_screen: MainScreen = get_parent()


func _process(_delta: float) -> void:
	if main_screen.state == MainScreen.State.GAME_OVER:
		position.y = lerpf(position.y, 130, 0.15)


func _on_replay_button_pressed() -> void:
	get_tree().change_scene_to_file("res://screen/main/main_screen.tscn")


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://screen/title/title_screen.tscn")
