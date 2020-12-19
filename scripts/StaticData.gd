extends Node
var initialized:bool = false

# settings
var music_enabled:bool = true
var sound_enabled:bool = true

# 인벤토리 정보(최대 3개)
var inventory_item1 = null
var inventory_item2 = null
var inventory_item3 = null


func init():
	if initialized == true:
		return
	
	inventory_item1 = WeaponInventoryItem.new()
	inventory_item2 = WeaponInventoryItem.new()
	inventory_item3 = WeaponInventoryItem.new()
	initialized = true

func get_inventory_item(index) -> WeaponInventoryItem:
	init()
	if index == 0:
		return inventory_item1
	elif index == 1:
		return inventory_item2
	else:
		return inventory_item3
