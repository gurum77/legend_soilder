extends ProgressBar


func _ready():
	max_value = StaticData.requirement_score_for_stage
	$CurrentStage/Label.text = String(StaticData.current_stage)
	$NextStage/Label.text = String(StaticData.current_stage+1)
	
	
func _process(delta):
	value = lerp(value, StaticData.current_score_for_stage, 0.3)
	
