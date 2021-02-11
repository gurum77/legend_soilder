extends TextureRect

export var is_cleared = false

func _ready():
	update()

func update():
	$ClearedTexture.visible = is_cleared
