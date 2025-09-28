extends Node2D

var text: String:
	set(new_text):
		$Label.text = new_text


func _ready() -> void:
	$AnimationPlayer.play("animation")
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)


func _on_animation_finished(anim_name: String) -> void:
	print(anim_name)
	queue_free()
