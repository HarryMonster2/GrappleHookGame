extends AudioStreamPlayer2D
class_name Sound_script

func sound_bit(sound):
	var s = load(sound)
	stream = s

func _on_finished():
	queue_free()
