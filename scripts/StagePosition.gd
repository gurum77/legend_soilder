extends Node2D
class_name StagePosition
var stage_name:String = "Unknown"
var pressed_position
var is_locked = true
onready var stage_selector = get_tree().root.get_node_or_null("StageSelector")
func _ready():
	
	var si = StaticData.get_stage_information(stage_name)
	if si != null:
		$Circle/Stone.visible = si.is_cleared()
		$Label.text = stage_name
		$Circle/Lock.visible = si.is_locked()
		is_locked = si.is_locked()
		
	$StageStepStatus.stage_name = stage_name
	$StageStepStatus.update()



func _on_Circle_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			pressed_position = event.position
		else:
			if Util.is_equal_vector2(pressed_position, event.position, 1) and stage_selector != null:
				SoundManager.play_ui_click_audio()
				# 이 스테이지가 잠겨 있다면 이동하지 않는다.
				if !is_locked:
					StaticData.current_stage_name = stage_name
					stage_selector.move_to_stage_position(stage_name)
			
