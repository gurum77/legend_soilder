extends Node
enum Weapon{None, Pistol, SMG, RPG, FlameThrower, MG}
enum GameState{ready, play, over}



# 최대 upgrade 레벨
var max_power_level = 20
var max_range_level = 20
var max_interval_level = 20

var max_player_power_level = 20
var max_player_hp_level = 20

# 기본 money 
var default_money_amount = 10

export (Texture) var Player_texture = null
export (Texture) var FlameThrower_texture = null
export (Texture) var MG_texture = null
export (Texture) var Pistol_texture = null
export (Texture) var RPG_texture = null
export (Texture) var SMG_texture = null

# player의 texture
func get_player_texture()->Texture:
	return Player_texture

# 무기의 texture
func get_weapon_texture(var weapon) -> Texture:
	if weapon == Weapon.FlameThrower:
		return FlameThrower_texture
	elif weapon == Weapon.MG:
		return MG_texture
	elif weapon == Weapon.Pistol:
		return Pistol_texture
	elif weapon == Weapon.RPG:
		return RPG_texture
	elif weapon == Weapon.SMG:
		return SMG_texture
	else:
		return null
		
		
func get_player_name()->String:
	return "Evan"
	
func get_weapon_name(var weapon) -> String:
	if weapon == Weapon.FlameThrower:
		return "FlameThrower"
	elif weapon == Weapon.MG:
		return "MG"
	elif weapon == Weapon.Pistol:
		return "Pistol"
	elif weapon == Weapon.RPG:
		return "RPG"
	elif weapon == Weapon.SMG:
		return "SMG"
	else:
		return "None"
	
func get_player_description()->String:
	return "He is legend soldier\n Nobody can block him."
	
func get_weapon_description(var weapon) -> String:
	if weapon == Weapon.FlameThrower:
		return "It is a terrifying weapon \nthat burns everything \naround it with a powerful flame. "
	elif weapon == Weapon.MG:
		return "Heavier than SMG, \nbut fires faster. \n\nFires a powerful bullet."
	elif weapon == Weapon.Pistol:
		return "A small gun that can be carried \nwith one hand. \n\nIt is convenient to carry \nand can be moved quickly."
	elif weapon == Weapon.RPG:
		return "It is heavy enough \nto carry on your shoulders, \nbut fires a powerful rocket cannon. \n\nInflicts damage to all nearby enemies."
	elif weapon == Weapon.SMG:
		return "It fires a pistol bullet quickly, \nand you have to hold it \nwith both hands."
	else:
		return "None"
