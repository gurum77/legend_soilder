extends Node


# audio
var Pistol_shot_audio:AudioStreamOGGVorbis = preload("res://assets/sounds/Pistol_shot.ogg")
var MG_shot_audio:AudioStreamOGGVorbis = preload("res://assets/sounds/MG_shot.ogg")
var SMG_shot_audio:AudioStreamOGGVorbis = preload("res://assets/sounds/SMG_shot.ogg")
var RPG_shot_audio:AudioStreamOGGVorbis = preload("res://assets/sounds/RPG_shot.ogg")
var FlameThrower_shot_audio:AudioStreamOGGVorbis = preload("res://assets/sounds/FlameThrower_shot.ogg")

var footstep_audio:AudioStreamOGGVorbis = preload("res://assets/sounds/footstep.ogg")

# ui
var click_audio:AudioStreamOGGVorbis = preload("res://assets/sounds/click.ogg")
var bgm_audio:AudioStreamOGGVorbis = preload("res://assets/sounds/bgm.ogg")
var bgm_ingame_audio:AudioStreamOGGVorbis = preload("res://assets/sounds/bgm_ingame.ogg")

enum BgmType{ui, ingame}
onready var ui_stream_player = $UIStreamPlayer
onready var bgm_stream_player = $BGMStreamPlayer

func play_bgm(bgm_type):
	if bgm_type == BgmType.ui:
		bgm_stream_player.stream = bgm_audio
	elif bgm_type == BgmType.ingame:
		bgm_stream_player.stream = bgm_ingame_audio
	bgm_stream_player.play()
	
func play_ui_click_audio():
	play_ui_audio(click_audio)
	
func play_ui_audio(var stream):
	ui_stream_player.stream = stream
	ui_stream_player.play()

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
	
	click_audio.loop = false
	bgm_audio.loop = true
	

# 총알 발사 소리 리
func get_bullet_shot_audio_stream(weapon)->AudioStream:
	if weapon == Define.Weapon.FlameThrower:
		return FlameThrower_shot_audio
	elif weapon == Define.Weapon.MG:
		return MG_shot_audio
	elif weapon == Define.Weapon.Pistol:
		return Pistol_shot_audio
	elif weapon == Define.Weapon.RPG:
		return RPG_shot_audio
	elif weapon == Define.Weapon.SMG:
		return SMG_shot_audio
	return null
	
