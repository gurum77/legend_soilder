extends Panel

var settings = preload("res://scenes/Settings.tscn")


func _ready():
	# home이 시작되면 game을 loading한다
	StaticData.load_game()
	SettingsStaticData.load_settings()
	SoundManager.play_bgm(SoundManager.BgmType.ui)

# equipment 버튼 클릭
func _on_EquipmentButton_pressed():
	SoundManager.play_ui_click_audio()
	var err = get_tree().change_scene("res://scenes/Equipment.tscn")
	if err != OK:
		push_error("change_scene failed!")

# play 버튼 클릭
func _on_PlayButton_pressed():
	SoundManager.play_ui_click_audio()
#	get_tree().change_scene("res://scenes/World.tscn")
	var err = get_tree().change_scene("res://scenes/StageSelector.tscn")
	if err != OK:
		push_error("change_scene failed!")


func _on_SettingsButton_pressed():
	SoundManager.play_ui_click_audio()
	var ins = settings.instance()
	get_tree().root.add_child(ins)


func _on_ExitButton_pressed():
	SoundManager.play_ui_click_audio()
	var dlg = MyAcceptDialog.new()
	dlg.dialog_text = tr("Quit?")
	dlg.add_cancel(tr("Cancel"))
	dlg.get_ok().connect("pressed", self, "on_ExitButton_ok_pressed")
	add_child(dlg)
	dlg.popup_centered()
	
func on_ExitButton_ok_pressed():
	get_tree().quit()
	
# reset
func _on_ResetButton_pressed():
	SoundManager.play_ui_click_audio()
	var dlg = MyAcceptDialog.new()
	dlg.dialog_text = tr("Reset?")
	dlg.add_cancel(tr("Cancel"))
	dlg.get_ok().connect("pressed", self, "on_ResetButton_ok_pressed")
	add_child(dlg)
	dlg.popup_centered()
	
func on_ResetButton_ok_pressed():
	SoundManager.play_ui_click_audio()
	StaticData.reset_game()
	StaticData.save_game()
	

# admob이 ready되면 초기화를 한다
func _on_AdMob_ready():
	$AdMob.init()
#	$AdMob.load_banner()

# banner 가 로드되면 보여준다.
func _on_AdMob_banner_loaded():
#	$AdMob.show_banner()
	pass

# shop
func _on_ShopButton_pressed():
	SoundManager.play_ui_click_audio()
	var err = get_tree().change_scene("res://scenes/Shop.tscn")
	if err != OK:
		push_error("change_scene failed")
