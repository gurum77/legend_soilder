extends Panel


var stage_button = preload("res://scenes/StageButton.tscn")
var stage_position = preload("res://scenes/StagePosition.tscn")


func _ready():
	update_stage_buttons()
	draw_positions()
	
func draw_positions():
	var path:Line2D = $MapScrollContainer/Map/Path
	var path_outline:Line2D = $MapScrollContainer/Map/PathOutline
	
	path.clear_points()
	path_outline.clear_points()
	
	for si_key in StaticData.stage_informations.keys():
		var si = StaticData.get_stage_information(si_key)
		if si == null:
			continue
		var ins = stage_position.instance()
		
		ins.position = si.position
		
		$MapScrollContainer/Map.add_child(ins)
		path.add_point(ins.position)
		path_outline.add_point(ins.position)
		
		
func update_stage_buttons():
	var dummy_buttons = $StageButtonScrollContainer/HBoxContainer.get_children()
	for db in dummy_buttons:
		db.queue_free()
	
	for si_key in StaticData.stage_informations.keys():
		var si = StaticData.get_stage_information(si_key)
		if si == null:
			continue
		var ins = stage_button.instance()
		ins.stage_name = si_key
		ins.stage_scene_path = si.scene_path
		$StageButtonScrollContainer/HBoxContainer.add_child(ins)
		
		ins.connect("pressed", self, "on_stage_button_pressed", [ins])

# 버튼을 누르면 해당 position을 찾아서 스크롤을 한다
func on_stage_button_pressed(button):
	StaticData.get_stage_information(button.stage_name)
	for si_key in StaticData.stage_informations.keys():
		if si_key != button.stage_name:
			continue
		var si = StaticData.get_stage_information(si_key)
		if si == null:
			continue
		$MapScrollContainer.scroll_horizontal = si.position.x
		$MapScrollContainer.scroll_vertical = si.position.y		

func _on_Map_gui_input(event):
	#print(event.as_text())
	
	pass # Replace with function body.
