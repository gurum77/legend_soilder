extends Node
var initialized:bool = false

# state clear에 필요한 내용들
var game_state = Define.GameState.ready
var current_stage = 1
var current_score_for_stage = 0
var requirement_score_for_stage = 10000


# 인벤토리 정보(최대 3개)
var inventory_item1 = null
var inventory_item2 = null
var inventory_item3 = null


# 현재 무기
var current_weapon_index = 0

# 게임 데이타 저장 / 읽기
# game data를을 reset한
func reset_game():
	game_state = Define.GameState.ready
	current_stage = 1
	current_score_for_stage = 0
	requirement_score_for_stage = 10000
	current_weapon_index = 0

func save_game():
	var save_dic={
		"game_state" : game_state,
		"current_stage" : current_stage,
		"current_score_for_stage" : current_score_for_stage,
		"requirement_score_for_stage" : requirement_score_for_stage,
		"current_weapon_index" : current_weapon_index
	}
	var save_file = File.new()
	save_file.open("user://legend_soldier.save", File.WRITE)
	save_file.store_line(to_json(save_dic))
	save_file.close()
	
func load_game():
	var save_file = File.new()
	if not save_file.file_exists("user://legend_soldier.save"):
		return
	save_file.open("user://legend_soldier.save", File.READ)
	if save_file.get_position() < save_file.get_len():
		var dic = parse_json(save_file.get_line())
		game_state = get_gamedata(dic, "game_state", game_state)
		current_stage = get_gamedata(dic, "current_stage", current_stage)
		current_score_for_stage = get_gamedata(dic, "current_score_for_stage", current_score_for_stage)
		requirement_score_for_stage = get_gamedata(dic, "requirement_score_for_stage", requirement_score_for_stage)
		current_weapon_index = get_gamedata(dic, "current_weapon_index", current_weapon_index)
	save_file.close()
	
func get_gamedata(var dic:Dictionary, var key, var default_value):
	if !dic.has(key):
		return default_value
	return dic[key]
	
func _ready():
	init()

func init():
	if initialized == true:
		return
	
	inventory_item1 = WeaponInventoryItem.new()
	inventory_item2 = WeaponInventoryItem.new()
	inventory_item3 = WeaponInventoryItem.new()
	initialized = true
	
	# 첫번째 인벤토리는 기본으로 권총을 넣어준다
	inventory_item1.weapon = Define.Weapon.Pistol
	
	# 이건 테스트용이다
	inventory_item2.weapon = Define.Weapon.RPG
	inventory_item3.weapon = Define.Weapon.SMG
	

func get_current_inventory_item() -> WeaponInventoryItem:
	return get_inventory_item(current_weapon_index)
	
func get_inventory_item(index) -> WeaponInventoryItem:
	init()
	if index == 0:
		return inventory_item1
	elif index == 1:
		return inventory_item2
	elif index == 2:
		return inventory_item3
	else:
		return null
