extends Panel

func _ready():
	if SoundManager.get_music_volume() > 0:
		$Background/MusicButton.pressed = true
	else:
		$Background/MusicButton.pressed = false
	
	if SoundManager.get_sound_volume() > 0:
		$Background/SoundButton.pressed = true
	else:
		$Background/SoundButton.pressed = false

func _on_OkButton_pressed():
	SettingsStaticData.save_settings()
	self.queue_free()


func _on_MusicButton_toggled(button_pressed):
	if button_pressed:
		SoundManager.set_music_volume(3)
	else:
		SoundManager.set_music_volume(0)


func _on_SoundButton_toggled(button_pressed):
	if button_pressed:
		SoundManager.set_sound_volume(3)
	else:
		SoundManager.set_sound_volume(0)
	
