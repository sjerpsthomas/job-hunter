extends Node2D


func spawn_text(text_str: String) -> void:
	var text = preload("res://core/card_sequence/card_sequence_text.tscn").instantiate()
	
	add_child(text)
	text.text = text_str
