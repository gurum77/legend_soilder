extends Panel

var settings = preload("res://scenes/Settings.tscn")

func _ready():
	# home이 시작되면 game을 loading한다
	StaticData.load_game()

# equipment 버튼 클릭
func _on_EquipmentButton_pressed():
	get_tree().change_scene("res://scenes/Equipment.tscn")

# play 버튼 클릭
func _on_PlayButton_pressed():
	get_tree().change_scene("res://scenes/World.tscn")


func _on_SettingsButton_pressed():
	var ins = settings.instance()
	get_tree().root.add_child(ins)


func _on_ExitButton_pressed():
	var dlg = AcceptDialog.new()
	dlg.dialog_text = "Quit?"
	dlg.add_cancel("cancel")
	dlg.get_ok().connect("pressed", self, "on_ExitButton_ok_pressed")
	add_child(dlg)
	dlg.popup_centered()
	
func on_ExitButton_ok_pressed():
	get_tree().quit()
	
# reset
func _on_ResetButton_pressed():
	var dlg = AcceptDialog.new()
	dlg.dialog_text = "Reset?"
	dlg.add_cancel("cancel")
	dlg.get_ok().connect("pressed", self, "on_ResetButton_ok_pressed")
	add_child(dlg)
	dlg.popup_centered()
	
func on_ResetButton_ok_pressed():
	StaticData.reset_game()
	StaticData.save_game()

	
	
