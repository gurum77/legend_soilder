extends Node
var initialized:bool = false

# state clear에 필요한 내용들
var game_state = Define.GameState.ready
var current_stage_name = "Focus"
var current_score_for_stage = 0
var requirement_score_for_stage = 10000
var spawned_score_for_stage = 0	# 현재 spawn되어 있는 전체 점수(필요한 만큼만 스폰되어야 한다)
var total_money = 0	
var current_stage_money = 0	# 현재 stage에서 모은 돈

func get_current_stage_path()->String:
	var si = get_stage_information(current_stage_name)
	if si == null:
		return ""
	return si.scene_path

# stage 정보
var stage_informations:Dictionary={
	"Focus" : StageInformation.new("res://maps/BattleField_Focus.tscn", Vector2(1200, 450)),
	"SideWater" : StageInformation.new("res://maps/BattleField_SideWater.tscn", Vector2(1286, 425)),
	"SideWater1" : StageInformation.new("res://maps/BattleField_SideWater.tscn", Vector2(1130, 426)),
	"SideWater2" : StageInformation.new("res://maps/BattleField_SideWater.tscn", Vector2(1245, 692)),
	"SideWater3" : StageInformation.new("res://maps/BattleField_SideWater.tscn", Vector2(997, 678)),
	"SideWater4" : StageInformation.new("res://maps/BattleField_SideWater.tscn", Vector2(892, 675)),
	"SideWater5" : StageInformation.new("res://maps/BattleField_SideWater.tscn", Vector2(1027, 564)),
	"SideWater6" : StageInformation.new("res://maps/BattleField_SideWater.tscn", Vector2(974, 480)),
	"Surround" : StageInformation.new("res://maps/BattleField_Surround.tscn", Vector2(918, 449))
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
var inventory_items = [WeaponInventoryItem.new(), WeaponInventoryItem.new(), WeaponInventoryItem.new()]


# 현재 무기
var current_weapon_index = 0

# revival 정보
var has_revival_chance = true

# 게임 데이타 저장 / 읽기
# game data를을 reset한다
func reset_game():
	game_state = Define.GameState.ready
	current_score_for_stage = 0
	requirement_score_for_stage = 10000
	current_weapon_index = 0

# stage_informations game data save용 dic을 리턴
func get_save_dic_stage_informations()->Dictionary:
	var save_dic:Dictionary
	for si_key in stage_informations.keys():
		save_dic[si_key] = stage_informations[si_key].get_save_dic()
	return save_dic
	
func get_save_dic_weapon_informations()->Dictionary:
	var save_dic:Dictionary
	for wi_key in weapon_informations.keys():
		save_dic[wi_key] = weapon_informations[wi_key].get_save_dic()
	return save_dic
	
func get_save_dic_inventory_items()->Dictionary:
	var save_dic:Dictionary
	for i in inventory_items.size():
		save_dic["inventory_item_"+str(i)] = inventory_items[i].get_save_dic()
	return save_dic
	
func save_game():
	var save_dic={
		"game_state" : game_state,
		"current_stage_nme" : current_stage_name,
		"current_score_for_stage" : current_score_for_stage,
		"requirement_score_for_stage" : requirement_score_for_stage,
		"current_weapon_index" : current_weapon_index,
		"total_money" : total_money,
		"current_stage_money" : current_stage_money,
		"stage_informations" : get_save_dic_stage_informations(),
		"weapon_informations" : get_save_dic_weapon_informations(),
		"inventory_items" : get_save_dic_inventory_items()
	}
	var save_file = File.new()
	save_file.open("user://legend_soldier.save", File.WRITE)
	save_file.store_line(to_json(save_dic))
	save_file.close()
	
func load_game():
	var laod_file = File.new()
	if not laod_file.file_exists("user://legend_soldier.save"):
		return
	laod_file.open("user://legend_soldier.save", File.READ)
	if laod_file.get_position() < laod_file.get_len():
		var dic = parse_json(laod_file.get_line())
		game_state = get_gamedata(dic, "game_state", game_state)
		current_stage_name = get_gamedata(dic, "current_stage_nme", current_stage_name)
		current_score_for_stage = get_gamedata(dic, "current_score_for_stage", current_score_for_stage)
		requirement_score_for_stage = get_gamedata(dic, "requirement_score_for_stage", requirement_score_for_stage)
		current_weapon_index = get_gamedata(dic, "current_weapon_index", current_weapon_index)
		total_money = get_gamedata(dic, "total_money", total_money)
		current_stage_money = get_gamedata(dic, "current_stage_money", current_stage_money)
		load_gamedata_stage_informations(dic)
		load_gamedata_weapon_informations(dic)
		load_gamedata_inventory_items(dic)
	laod_file.close()
	total_money = 100000

# inventory_items game data를 불러온다
func load_gamedata_inventory_items(var dic:Dictionary):
	if !dic.has("inventory_items"):
		return
	var dic_inventory_items:Dictionary = dic["inventory_items"]
	if dic_inventory_items == null:
		return
	
	var index = 0
	for ii_key in dic_inventory_items.keys():
		inventory_items[index].load_gamedata(dic_inventory_items[ii_key])
		index+=1
		
# weapon_informations game data를 불러온다
func load_gamedata_weapon_informations(var dic:Dictionary):
	if !dic.has("weapon_informations"):
		return
	var dic_weapon_informations:Dictionary = dic["weapon_informations"]
	if dic_weapon_informations == null:
		return
	
	for wi_key in dic_weapon_informations.keys():
		# 있는 것만 불러온다.(없는건 게임에서 지원하지 않는 stage이므로 제거대상)
		var wi = weapon_informations[wi_key]
		if wi == null:
			continue
		wi.load_gamedata(dic_weapon_informations[wi_key])
		
# stage_informations game data를 불러온다
func load_gamedata_stage_informations(var dic:Dictionary):
	if !dic.has("stage_informations"):
		return
	var dic_stage_informations:Dictionary = dic["stage_informations"]
	if dic_stage_informations == null:
		return
	
	for si_key in dic_stage_informations.keys():
		# 있는 것만 불러온다.(없는건 게임에서 지원하지 않는 stage이므로 제거대상)
		var si = stage_informations[si_key]
		if si == null:
			continue
		si.load_gamedata(dic_stage_informations[si_key])


# dic에서 gamedata를 가져옴
func get_gamedata(var dic:Dictionary, var key, var default_value):
	if !dic.has(key):
		return default_value
	return dic[key]
	
func _ready():
	init()


	
func init():
	if initialized == true:
		return
	
	initialized = true
	
	# 첫번째 인벤토리는 기본으로 권총을 넣어준다
	inventory_items[0].weapon = Define.Weapon.Pistol
	
	# 첫번째 stage를 current로 설정
	current_stage_name = stage_informations.keys()[0]
	
	# stage level을 순서대로 결정한다.
	var level = 1
	for si_key in stage_informations.keys():
		stage_informations[si_key].level = level
		level += 1
	
	# pistol은 항상 enable
	get_weapon_information(Define.Weapon.Pistol).enable = true
	
#	# 이건 테스트용이다
#	inventory_item2.weapon = Define.Weapon.RPG
#	inventory_item3.weapon = Define.Weapon.SMG
	

func get_current_inventory_item() -> WeaponInventoryItem:
	return get_inventory_item(current_weapon_index)
	
# 
func get_inventory_item(index) -> WeaponInventoryItem:
	init()
	if inventory_items.size() <= index:
		return null
	return inventory_items[index]

func get_current_stage_information()->StageInformation:
	return get_stage_information(current_stage_name)
	
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
