class_name PlayerInformation

var enable = false	# 구매를 해야 true가 됨(Evan은 처음부터 활성화 됨)
var power_level = 1
var hp_level = 1

# game data 저장용 dic을 리턴
func get_save_dic()->Dictionary:
	var save_dic={
		"enable" : enable,
		"power_level" : power_level,
		"hp_level" : hp_level
	}
	return save_dic

# game data를 load한다.
func load_gamedata(var dic):
	enable = StaticData.get_gamedata(dic, "enable", enable)
	power_level = StaticData.get_gamedata(dic, "power_level", power_level)
	hp_level = StaticData.get_gamedata(dic, "hp_level", hp_level)
	
	
func is_max_power_level()->bool:
	if power_level >= Define.max_player_power_level:
		return true
	return false

func is_max_hp_level()->bool:
	if hp_level >= Define.max_player_hp_level:
		return true
	return false

func upgrade_power_level():
	if power_level < Define.max_player_power_level:
		power_level += 1
		
func upgrade_hp_level():
	if hp_level < Define.max_player_hp_level:
		hp_level += 1
