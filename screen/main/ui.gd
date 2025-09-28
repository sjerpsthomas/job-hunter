extends Control


func press(action: String) -> void:
	var event = InputEventAction.new()
	event.action = action
	event.pressed = true
	Input.parse_input_event(event)


func _on_discard_button_pressed() -> void:
	press("ui_card_discard")


func _on_left_button_pressed() -> void:
	press("ui_left")


func _on_right_button_pressed() -> void:
	press("ui_right")


func _on_inspect_button_pressed() -> void:
	press("ui_card_info")


func _on_select_button_pressed() -> void:
	press("ui_accept")

func _on_start_button_pressed() -> void:
	press("ui_execute")
