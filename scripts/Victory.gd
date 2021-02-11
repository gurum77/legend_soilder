extends Panel

onready var si  = StaticData.get_current_stage_information()
func _ready():
	$TextureRect/Coins.text = String(StaticData.current_stage_money)
	if is_cleared():
		$TextureRect/NextButton/Label.text = "CLEAR"
	else:
		$TextureRect/NextButton/Label.text = "NEXT"

func is_cleared()->bool:
	if si != null and si.is_cleard():
		return true
	return false
	
func _on_HomeButton_pressed():
	var err = get_tree().change_scene("res://scenes/Home.tscn")
	if err != OK:
		push_error("change_scene failed")


func _on_NextButton_pressed():
	# 모든 step을 완료 했다면 stage selector로 가서 결과를 본다
	var err = OK
	if si != null and si.is_cleard():
		err = get_tree().change_scene("res://scenes/StageSelector.tscn")
	else:
		err = get_tree().change_scene("res://scenes/World.tscn")
	if err != OK:
		push_error("change_scene failed")
