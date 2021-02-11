extends Node2D

export var disabled = false


func _ready():
	if disabled:
		return
		
	# 기존 maps 은 제거
	var exist_maps = get_children()
	for map in exist_maps:
		map.queue_free()
		
	# stage path에서 읽어온다
	var ins = load(StaticData.get_current_stage_path()).instance()
	add_child(ins)
	init_path_finders(ins)
	
# path finder를 초기화 한다.
func init_path_finders(tilemap):
	var path_finder = get_parent().get_node("PathFinder")
	if path_finder != null:
		path_finder.init_tilemap(tilemap)
		
	var path_finder64x64 = get_parent().get_node("PathFinder64x64")
	if path_finder64x64 != null:
		path_finder64x64.init_tilemap(tilemap)
		
