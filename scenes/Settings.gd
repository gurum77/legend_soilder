extends Panel

func _ready():
	$Background/MusicButton.pressed = StaticData.music_enabled
	$Background/SoundButton.pressed = StaticData.sound_enabled

func _on_OkButton_pressed():
	self.queue_free()


func _on_MusicButton_toggled(button_pressed):
	StaticData.music_enabled = button_pressed


func _on_SoundButton_toggled(button_pressed):
	StaticData.sound_enabled = button_pressed
