class_name StageInformation

func _init(var scene_path, var position):
	self.scene_path = scene_path
	self.position = position
	
# clear 했는지?
func is_cleard()->bool:
	if current_step > max_step:
		return true
	return false
	
# 정보를 저장하기 위한 dic을 리턴
# current_step만 저장하면 됨
# 다른 정보는 게임이 정해주는 것임
func get_save_dic()->Dictionary:
	var save_dic={
		"current_step" : current_step
	}
	return save_dic
	
# game data를 불러온다.
func load_gamedata(var dic):
	current_step = StaticData.get_gamedata(dic, "current_step", current_step)
	
	
var level = 1	# stage의 등(난이도에 해당함. 높을수록 어렵다)
var current_step = 1	# 현재 플레이어가 진행중인 step이다.(current_step 보다 크면 클리어 한 것이다)
var max_step = 0		# stage의 최대 step 이다
var scene_path = "res://maps/BattleField_Focus.tscn"
var position = Vector2(30, 30)
