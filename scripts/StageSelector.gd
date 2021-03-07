extends Panel


var stage_button = preload("res://scenes/StageButton.tscn")
var stage_position = preload("res://scenes/StagePosition.tscn")
var stage_positions:Dictionary

func _ready():
	update_stage_buttons()
	draw_positions()
	move_to_stage_position(StaticData.current_stage_name)
	resize_map()
	
# map이 stage position전체의 범위 보다 작으면 늘려준다.
func resize_map():
	var max_x = 0.0
	var max_y = 0.0
	for si_key in StaticData.stage_informations.keys():
		var si = StaticData.get_stage_information(si_key)
		if si == null:
			continue
		max_x = max(si.position.x, max_x)
		max_y = max(si.position.y, max_y)
		
	var margin  = 50
	max_x += margin
	max_y += margin
	if $MapScrollContainer/Map.rect_min_size.x < max_x:
		$MapScrollContainer/Map.rect_min_size.x = max_x
	if $MapScrollContainer/Map.rect_min_size.y < max_y:
		$MapScrollContainer/Map.rect_min_size.y = max_y
	
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
		ins.stage_name = si_key
		
		$MapScrollContainer/Map.add_child(ins)
		path.add_point(ins.position)
		path_outline.add_point(ins.position)
		
# stage position 노드를 찾는다
func find_stage_position(stage_name)->Node2D:
	var nodes = $MapScrollContainer/Map.get_children()
	for node in nodes:
		if not node is StagePosition:
			continue
		if node.stage_name == stage_name:
			return node
	return null
	
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
	SoundManager.play_ui_click_audio()
	move_to_stage_position(button.stage_name)
		
# 지정한 station position으로 이동
func move_to_stage_position(stage_name):
	var si = StaticData.get_stage_information(stage_name)
	if si == null:
		return
	$Tween.interpolate_property($MapScrollContainer, "scroll_horizontal", $MapScrollContainer.scroll_horizontal, si.position.x - $MapScrollContainer.rect_size.x / 2, 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.interpolate_property($MapScrollContainer, "scroll_vertical", $MapScrollContainer.scroll_vertical, si.position.y - $MapScrollContainer.rect_size.y / 2, 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	
	# player 를 해당 위치로 이동
	var _stage_position = find_stage_position(stage_name)
	if not _stage_position == null:
		$Tween.interpolate_property($MapScrollContainer/Map/Player, "position", $MapScrollContainer/Map/Player.position, _stage_position.position, 0.3, Tween.TRANS_SINE, Tween.EASE_OUT)	
	$Tween.start()

func _on_TextureButton_pressed():
	SoundManager.play_ui_click_audio()
	var err = get_tree().change_scene("res://scenes/Home.tscn")
	if err != OK:
		push_error("change_scene failed")

# 게임 시작
# go 버튼 클릭
func _on_StartButton_pressed():
	SoundManager.play_ui_click_audio()
	# current_step이 max_step보다 크면 안됨
	var si = StaticData.get_current_stage_information()
	if si != null:
		si.current_step = min(si.current_step, si.max_step)
		
	var err = get_tree().change_scene("res://scenes/World.tscn")
	if err != OK:
		push_error("change_scene failed")
