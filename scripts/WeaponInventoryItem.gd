class_name WeaponInventoryItem

var enabled = true
var weapon = Define.Weapon.None

# game data 저장용 dic을 리턴
func get_save_dic()->Dictionary:
	var save_dic={
		"enabled" : enabled,
		"weapon" : weapon
	}
	return save_dic

# game data를 load한다.
func load_gamedata(var dic):
	enabled = StaticData.get_gamedata(dic, "enabled", enabled)
	weapon = StaticData.get_gamedata(dic, "weapon", weapon)
