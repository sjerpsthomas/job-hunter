extends Label


var velocity := -5.0


func _ready() -> void:
	rotation_degrees = randf_range(-5, 5)


func _process(delta: float) -> void:
	velocity += delta * 30
	
	position.y += velocity
	
	if position.y > 1000:
		queue_free()
