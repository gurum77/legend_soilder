class_name StageInformation

func _init(var scene_path_param, var position_param):
	self.scene_path = scene_path_param
	self.position = position_param
	

	
# 정보를 저장하기 위한 dic을 리턴
# current_step만 저장하면 됨
# 다른 정보는 게임이 정해주는 것임
func get_save_dic()->Dictionary:
	var save_dic={
		"current_step" : current_step
	}
	return save_dic

# 이번 stage에서 획득한 별의 개수	
func get_star_nums()->int:
	var nums = current_step-1
	if nums > max_step:
		nums = max_step;
		
	return nums
	
	
# game data를 불러온다.
func load_gamedata(var dic):
	current_step = StaticData.get_gamedata(dic, "current_step", current_step)
	
# 잠겨 있는지?
func is_locked()->bool:
	# 진행 중이면 잠그지 않는다
	if current_step > 1:
		return false
	# clear 했으면 잠그지 않는다
	if is_cleared():
		return false
	# 이전 stage가 clear되었으면 잠그지 않는다
	if is_cleared_prev_stage():
		return false
	return true
	
# clear 했는지?
func is_cleared()->bool:
	if current_step > max_step:
		return true
	return false
# 이전 stage를 clear했는지?
func is_cleared_prev_stage()->bool:
	if prev_stage == null:
		return true
	return prev_stage.is_cleared()
	
var level = 1	# stage의 등(난이도에 해당함. 높을수록 어렵다)
var current_step = 1	# 현재 플레이어가 진행중인 step이다.(current_step 보다 크면 클리어 한 것이다)
var max_step = 5		# stage의 최대 step 이다
var scene_path = "res://maps/BattleField_Focus.tscn"
var position = Vector2(30, 30)
var prev_stage:StageInformation = null	# 이전 stage
