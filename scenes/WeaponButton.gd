extends TextureButton

export (Texture) var weapon_texture

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect.texture = weapon_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
