extends Node

# audio
var Pistol_shot_audio = preload("res://assets/sounds/Pistol_shot.ogg")
var MG_shot_audio = preload("res://assets/sounds/MG_shot.ogg")
var SMG_shot_audio = preload("res://assets/sounds/SMG_shot.ogg")
var RPG_shot_audio = preload("res://assets/sounds/RPG_shot.ogg")
var FlameThrower_shot_audio = preload("res://assets/sounds/FlameThrower_shot.ogg")

var footstep_audio = preload("res://assets/sounds/footstep.ogg")


func _ready():
	# audio 설정
	Pistol_shot_audio.loop = false
	MG_shot_audio.loop = false
	SMG_shot_audio.loop = false
	RPG_shot_audio.loop = false
	FlameThrower_shot_audio.loop = false
		
# 총알 발사 소리 리
func get_bullet_shot_audio_stream(weapon)->AudioStream:
	match weapon:
		Define.Weapon.FlameThrower:
			return FlameThrower_shot_audio
		Define.Weapon.MG:
			return MG_shot_audio
		Define.Weapon.Pistol:
			return Pistol_shot_audio
		Define.Weapon.RPG:
			return RPG_shot_audio
		Define.Weapon.SMG:
			return SMG_shot_audio
	return null
	
