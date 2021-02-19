extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var cleared_step_nums = 0
	var total_step_nums = 0
	for si_key in StaticData.stage_informations:
		var si:StageInformation = StaticData.stage_informations[si_key]
		total_step_nums += si.max_step
		cleared_step_nums += (si.current_step-1)
		
	$StepLabel.text = str(cleared_step_nums) + "/" + str(total_step_nums)
