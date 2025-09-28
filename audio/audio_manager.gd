extends Node2D


func play_sfx(effect_name: String) -> void:
	var player := AudioStreamPlayer.new()
	$SFX.add_child(player)
	
	player.stream = load(str('res://audio/snd_', effect_name, '.wav'))
	player.bus = 'SFX'
	
	player.play()
	
	player.finished.connect(func(): player.queue_free())


func play_score(pitch: int) -> void:
	var player := AudioStreamPlayer.new()
	$SFX.add_child(player)
	
	player.stream = load('res://audio/snd_score.wav')
	player.bus = 'SFX'
	player.pitch_scale = pow(1.05946, pitch + 2)
	
	player.play()
	
	player.finished.connect(func(): player.queue_free())
