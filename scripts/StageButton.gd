extends TextureButton

var stage_scene_path = "res://maps/BattleField_Focus.tscn"
var stage_name = "한국"

func _ready():
	$Label.text = stage_name
	var si = StaticData.get_stage_information(stage_name)
	if si == null:
		return
	
	var step_node = load("res://scenes/StepByStageImage.tscn")
	for step in si.max_step:
		var ins = step_node.instance()
		ins.is_cleared = si.current_step > step + 1
		ins.update()
		$HBoxContainer.add_child(ins)
	

func _on_Button_BattleField_Focus_pressed():
	StaticData.current_stage_name = stage_name
	#get_tree().change_scene("res://scenes/World.tscn")
