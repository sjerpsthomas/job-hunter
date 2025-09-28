extends Node2D



func _ready() -> void:
	if PortfolioLoader.is_finished:
		_on_loader_finished()
	else:
		PortfolioLoader.finished.connect(_on_loader_finished)
		PortfolioLoader.errored.connect(_on_loader_errored)
	
	%Loading.text = Locale.txt('loading')
	%PlayButton.text = Locale.txt('play')


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://screen/main/main_screen.tscn")


func _on_loader_finished() -> void:
	%Loading.visible = false
	%PlayButton.disabled = false

func _on_loader_errored() -> void:
	%Loading.text = Locale.txt('error')
