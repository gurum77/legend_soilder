class_name StageInformation

func _init(var scene_path, var position):
	self.scene_path = scene_path
	self.position = position
	
var level = 1	# stage의 등(난이도에 해당함. 높을수록 어렵다)
var current_step = 1	# 현재 플레이어가 진행중인 step이다.(current_step 보다 크면 클리어 한 것이다)
var max_step = 5		# stage의 최대 step 이다
var scene_path = "res://maps/BattleField_Focus.tscn"
var position = Vector2(30, 30)
