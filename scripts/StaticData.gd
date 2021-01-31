extends Node
var initialized:bool = false

# state clear에 필요한 내용들
var game_state = Define.GameState.ready
var current_stage = 1
var current_stage_path = "res://maps/BattleField_Focus.tscn"
var current_level_on_stage = 1	# 현재 stage에서 진행중인 level(1~5)
var current_score_for_stage = 0
var requirement_score_for_stage = 10000
var spawned_score_for_stage = 0	# 현재 spawn되어 있는 전체 점수(필요한 만큼만 스폰되어야 한다)
var total_money = 0	
var current_stage_money = 0	# 현재 stage에서 모은 돈

# stage 정보
var stage_informations:Dictionary={
	"Focus" : StageInformation.new("res://maps/BattleField_Focus.tscn"),
	"SideWater" : StageInformation.new("res://maps/BattleField_SideWater.tscn"),
	"Surround" : StageInformation.new("res://maps/BattleField_Surround.tscn")
}
# weapon 정보
var weapon_informations:Dictionary = {
	Define.get_weapon_name(Define.Weapon.Pistol) : WeaponInformation.new(),
	Define.get_weapon_name(Define.Weapon.SMG) : WeaponInformation.new(),
	Define.get_weapon_name(Define.Weapon.RPG) : WeaponInformation.new(),
	Define.get_weapon_name(Define.Weapon.FlameThrower) : WeaponInformation.new(),
	Define.get_weapon_name(Define.Weapon.MG) : WeaponInformation.new()
}


# 인벤토리 정보(최대 3개)
var inventory_item1 = null
var inventory_item2 = null
var inventory_item3 = null


# 현재 무기
var current_weapon_index = 0

# revival 정보
var has_revival_chance = true

# 게임 데이타 저장 / 읽기
# game data를을 reset한다
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
		"current_weapon_index" : current_weapon_index,
		"total_money" : total_money,
		"current_stage_money" : current_stage_money
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
		total_money = get_gamedata(dic, "total_money", total_money)
		current_stage_money = get_gamedata(dic, "current_stage_money", current_stage_money)
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
	
	# pistol은 항상 enable
	get_weapon_information(Define.Weapon.Pistol).enable = true
	
	# 이건 테스트용이다
	inventory_item2.weapon = Define.Weapon.RPG
	inventory_item3.weapon = Define.Weapon.SMG
	

func get_current_inventory_item() -> WeaponInventoryItem:
	return get_inventory_item(current_weapon_index)
	
# 
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

# stage 정보 리턴
func get_stage_information(stage_name)->StageInformation:
	if stage_informations.has(stage_name):
		return stage_informations[stage_name]
	return null
	
# 무기 정보를 리턴한다
# 없으면 만들어서 리턴한다
func get_weapon_information(weapon)->WeaponInformation:
	if weapon_informations.has(Define.get_weapon_name(weapon)):
		return weapon_informations[Define.get_weapon_name(weapon)]
	else:
		weapon_informations[Define.get_weapon_name(weapon)] = WeaponInformation.new()
		
			
	return weapon_informations[Define.get_weapon_name(weapon)]		
