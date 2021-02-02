extends ProgressBar


func _ready():
	update()	
	

func update():
	max_value = StaticData.requirement_score_for_stage
	var si = StaticData.get_current_stage_information()
	if si != null:
		$CurrentStage/Label.text = String(si.current_step)
		if si.current_step < si.max_step:
			$NextStage/Label.visible = true
			$NextStage/Label.text = String(si.current_step+1)
			$NextStage/Stone.visible = false
		else:
			$NextStage/Label.visible = false
			$NextStage/Stone.visible = true
	
func _process(delta):
	if abs(value - StaticData.current_score_for_stage) <= 1:
		value = StaticData.current_score_for_stage
	else:
		value = lerp(value, StaticData.current_score_for_stage, 0.3)
