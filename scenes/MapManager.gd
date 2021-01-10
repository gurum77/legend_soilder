extends Node2D

export var disabled = false

var maps = [
	"res://maps/HorizontalVillidgeMap.tscn", 
	"res://maps/VerticalVillidgeMap.tscn"]



func _ready():
	if disabled:
		return
	# 기존 maps 은 제거
	var exist_maps = get_children()
	for map in exist_maps:
		map.queue_free()
		
	# 나눠서 남는거의 -1을 한다.
	# -1이 되면 마지막 인덱스로 사용
	var idx = StaticData.current_stage / maps.size() as int
	idx = StaticData.current_stage - (maps.size() * idx)
	if idx < 0:
		idx = maps.size() - 1
	var ins = load(maps[idx]).instance()
	add_child(ins)
		
