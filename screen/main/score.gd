extends Label

@onready var main_screen: MainScreen = get_parent()


func _process(_delta: float) -> void:
	if main_screen.state == MainScreen.State.GAME_OVER:
		modulate.a = lerpf(modulate.a, 0.0, 0.15)
