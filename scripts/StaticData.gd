extends Node
var initialized:bool = false

# settings
var music_enabled:bool = true
var sound_enabled:bool = true

# 인벤토리 정보(최대 3개)
var inventory_item1 = null
var inventory_item2 = null
var inventory_item3 = null


# 현재 무기
var current_weapon_index = 0
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
