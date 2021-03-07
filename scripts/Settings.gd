extends Panel

var locales:Array

func _ready():
	$ItemList.visible = false
	
	if SoundManager.get_music_volume() > 0:
		$Background/VBoxContainer/MusicButton.pressed = true
	else:
		$Background/VBoxContainer/MusicButton.pressed = false
	
	if SoundManager.get_sound_volume() > 0:
		$Background/VBoxContainer/SoundButton.pressed = true
	else:
		$Background/VBoxContainer/SoundButton.pressed = false

	
func _on_OkButton_pressed():
	SoundManager.play_ui_click_audio()
	SettingsStaticData.save_settings()
	self.queue_free()


func _on_MusicButton_toggled(button_pressed):
	SoundManager.play_ui_click_audio()
	if button_pressed:
		SoundManager.set_music_volume(3)
	else:
		SoundManager.set_music_volume(0)


func _on_SoundButton_toggled(button_pressed):
	SoundManager.play_ui_click_audio()
	if button_pressed:
		SoundManager.set_sound_volume(3)
	else:
		SoundManager.set_sound_volume(0)
	


func _on_LanguageButton_pressed():
	SoundManager.play_ui_click_audio()
	$ItemList.visible = true
	$ItemList.clear()
	locales.clear()
	var idx = 0
	var selected_idx = 0
	for locale in TranslationServer.get_loaded_locales():
		$ItemList.add_item(tr(TranslationServer.get_locale_name(locale)))
		$ItemList.set_item_tooltip_enabled(idx, false)
		locales.append(locale)
		if TranslationServer.get_locale() == locale:
			selected_idx = idx
		idx += 1
	
	$ItemList.select(selected_idx)

func _on_ItemList_item_selected(index):
	SoundManager.play_ui_click_audio()
	$ItemList.visible = false
	TranslationServer.set_locale(locales[index])
	
