extends Node2D


@onready var frames := %Frames as AnimatedSprite2D


func _ready() -> void:
	if PortfolioLoader.is_finished:
		_on_loader_finished()
	else:
		PortfolioLoader.finished.connect(_on_loader_finished)
		PortfolioLoader.errored.connect(_on_loader_errored)
	
	%Loading.text = Locale.txt('loading')
	%PlayButton.text = Locale.txt('play')
	
	set_frame(0)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		set_frame(frames.frame - 1)
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_right"):
		set_frame(frames.frame + 1)
		get_viewport().set_input_as_handled()


func set_frame(new_frame: int) -> void:
	frames.frame = new_frame
	$UI/LeftButton.disabled = new_frame <= 0
	$UI/RightButton.disabled = new_frame > frames.sprite_frames.get_frame_count('default') - 2
	
	AudioManager.play_sfx('move')


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://screen/main/main_screen.tscn")


func _on_loader_finished() -> void:
	%Loading.visible = false
	%PlayButton.disabled = false

func _on_loader_errored() -> void:
	%Loading.text = Locale.txt('error')


func press(action: String) -> void:
	var event = InputEventAction.new()
	event.action = action
	event.pressed = true
	Input.parse_input_event(event)

func _on_left_button_pressed() -> void: press("ui_left")

func _on_right_button_pressed() -> void: press("ui_right")
