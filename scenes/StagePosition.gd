extends Node2D
class_name StagePosition
var stage_name:String = "Unknown"


func _ready():
	var si = StaticData.get_stage_information(stage_name)
	if si != null:
		$Stone.visible = si.is_cleard()

