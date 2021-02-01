extends TextureButton

var stage_scene_path = "res://maps/BattleField_Focus.tscn"
var stage_name = "name"

func _ready():
	$Label.text = stage_name
	var si = StaticData.get_stage_information(stage_name)
	if si == null:
		return
	var level_images = $HBoxContainer.get_children()
	var level = 1
	for li in level_images:
		if si.current_step > level:
			li.is_cleared = true
		else:
			li.is_cleared = false
		li.update()
		level += 1
		
		
		
	

func _on_Button_BattleField_Focus_pressed():
	StaticData.current_stage_path = stage_scene_path
	#get_tree().change_scene("res://scenes/World.tscn")
