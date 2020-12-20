extends Node
enum Weapon{None, Pistol, SMG, RPG, FlameThrower, MG}



export (Texture) var FlameThrower_texture = null
export (Texture) var MG_texture = null
export (Texture) var Pistol_texture = null
export (Texture) var RPG_texture = null
export (Texture) var SMG_texture = null

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
	
