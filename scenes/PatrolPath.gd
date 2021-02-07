extends Path2D


onready var fix_global_position:Vector2

func _process(delta):
	global_position = fix_global_position
