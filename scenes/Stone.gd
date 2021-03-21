extends TextureRect

var min_r = 0.5
var max_r = 3
var offset = 0.1
var to_up = true
func _process(_delta):
	if to_up:
		modulate.r += offset
		if modulate.r > max_r:
			to_up = false
	else:
		modulate.r -= offset
		if modulate.r < min_r:
			to_up = true
