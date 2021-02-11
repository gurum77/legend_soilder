extends Node

# audio
var Pistol_shot_audio = preload("res://assets/sounds/Pistol_shot.ogg")
var MG_shot_audio = preload("res://assets/sounds/MG_shot.ogg")
var SMG_shot_audio = preload("res://assets/sounds/SMG_shot.ogg")
var RPG_shot_audio = preload("res://assets/sounds/RPG_shot.ogg")
var FlameThrower_shot_audio = preload("res://assets/sounds/FlameThrower_shot.ogg")

var footstep_audio = preload("res://assets/sounds/footstep.ogg")

# settings
func set_music_volume(volume):
	var bus_index = AudioServer.get_bus_index("music")
	if volume == 0:
		AudioServer.set_bus_mute(bus_index, true) 
	else:
		AudioServer.set_bus_mute(bus_index, false) 
		AudioServer.set_bus_volume_db(bus_index, volume) 
	

func set_sound_volume(volume):	
	var bus_index = AudioServer.get_bus_index("sound")
	if volume == 0:
		AudioServer.set_bus_mute(bus_index, true) 
	else:
		AudioServer.set_bus_mute(bus_index, false) 
		AudioServer.set_bus_volume_db(bus_index, volume)
		
func get_sound_volume()->float:
	var bus_index = AudioServer.get_bus_index("sound")
	if AudioServer.is_bus_mute(bus_index):
		return 0.0
	else:
		return AudioServer.get_bus_volume_db(bus_index)

func get_music_volume()->float:
	var bus_index = AudioServer.get_bus_index("music")
	if AudioServer.is_bus_mute(bus_index):
		return 0.0
	else:
		return AudioServer.get_bus_volume_db(bus_index)		
		
func _ready():
	# audio 설정
	Pistol_shot_audio.loop = false
	MG_shot_audio.loop = false
	SMG_shot_audio.loop = false
	RPG_shot_audio.loop = false
	FlameThrower_shot_audio.loop = false
	
	# sound, music 셋팅 초기화
	set_sound_volume(0)
	set_music_volume(0)
		
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
	
