extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var stone_nums = 0
	for si_key in StaticData.stage_informations:
		var si = StaticData.stage_informations[si_key]
		if si.is_cleared():
			stone_nums += 1
	$StoneLabel.text = str(stone_nums) + "/" + str(StaticData.stage_informations.size())
