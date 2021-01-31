extends Panel


var stage_button = preload("res://scenes/StageButton.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var dummy_buttons = $HBoxContainer.get_children()
	for db in dummy_buttons:
		db.queue_free()
	
	for si_key in StaticData.stage_informations.keys():
		var si = StaticData.get_stage_information(si_key)
		if si == null:
			continue
		var ins = stage_button.instance()
		ins.stage_name = si_key
		ins.stage_scene_path = si.scene_path
		$HBoxContainer.add_child(ins)
