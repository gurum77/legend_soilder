extends ProgressBar


func _ready():
	update()	

func update():
	max_value = StaticData.requirement_score_for_stage
	$CurrentStage/Label.text = String(StaticData.current_stage)
	$NextStage/Label.text = String(StaticData.current_stage+1)
	
func _process(delta):
	if abs(value - StaticData.current_score_for_stage) <= 1:
		value = StaticData.current_score_for_stage
	else:
		value = lerp(value, StaticData.current_score_for_stage, 0.3)
