extends HBoxContainer

var stage_name

func update():
	var si = StaticData.get_stage_information(stage_name)
	if si == null:
		return
	
	var nodes = get_children()
	for node in nodes:
		remove_child(node)
		
	var step_node = load("res://scenes/StepByStageImage.tscn")
	for step in si.max_step:
		var ins = step_node.instance()
		ins.is_cleared = si.current_step > step + 1
		ins.update()
		add_child(ins)
		
func _ready():
	update()
