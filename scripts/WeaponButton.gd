extends TextureButton

export (Define.Weapon) var weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	update()

func update():
	if weapon == null:
		$TextureRect.visible = false
		$Label.visible = true
	else:
		$TextureRect.visible = true
		$TextureRect.texture = Define.get_weapon_texture(weapon)
		$Label.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
