extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	# 기본값 설정
	# sound, music 셋팅 초기화
	SoundManager.set_sound_volume(0)
	SoundManager.set_music_volume(0)
		
	
func save_settings():
	var save_dic={
		"sound_volume" : SoundManager.get_sound_volume(),
		"music_volume" : SoundManager.get_music_volume()
	}
	var save_file = File.new()
	save_file.open("user://legend_soldier_settings.save", File.WRITE)
	save_file.store_line(to_json(save_dic))
	save_file.close()
	
func load_settings():
	var laod_file = File.new()
	if not laod_file.file_exists("user://legend_soldier_settings.save"):
		return
	laod_file.open("user://legend_soldier_settings.save", File.READ)
	if laod_file.get_position() < laod_file.get_len():
		var dic = parse_json(laod_file.get_line())
		SoundManager.set_sound_volume(StaticData.get_gamedata(dic, "sound_volume", SoundManager.get_sound_volume()))
		SoundManager.set_music_volume(StaticData.get_gamedata(dic, "music_volume", SoundManager.get_music_volume()))
	laod_file.close()
