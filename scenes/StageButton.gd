extends Button

export var stage_name = "res://maps/BattleField_Focus.tscn"


func _on_Button_BattleField_Focus_pressed():
	StaticData.current_stage_path = stage_name
	get_tree().change_scene("res://scenes/World.tscn")
