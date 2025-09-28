extends Node2D




func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://screen/main/main_screen.tscn")


func _on_loader_finished() -> void:
	%PlayButton.disabled = false
