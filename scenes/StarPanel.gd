extends TextureRect

func _physics_process(_delta):
	$StarLabel.text = str(StaticData.total_star)
