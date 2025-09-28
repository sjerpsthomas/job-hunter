extends Control


func _ready() -> void:
	$InspectButton.text = Locale.txt('inspect')


func press(action: String) -> void:
	var event = InputEventAction.new()
	event.action = action
	event.pressed = true
	Input.parse_input_event(event)


func set_discard_count(new_discard_count: int) -> void:
	$DiscardButton.text = str(Locale.txt('discard'), "\n(", new_discard_count, " ", Locale.txt('left'), ")")


func set_select_count(new_select_count: int) -> void:
	$SelectButton.text = str(Locale.txt('select'), "\n(", new_select_count, " ", Locale.txt('left'), ")")


func _on_discard_button_pressed() -> void: press("ui_card_discard")

func _on_left_button_pressed() -> void: press("ui_left")

func _on_right_button_pressed() -> void: press("ui_right")

func _on_inspect_button_pressed() -> void: press("ui_card_info")

func _on_select_button_pressed() -> void: press("ui_accept")

func _on_start_button_pressed() -> void: press("ui_execute")
