extends Panel

var settings = preload("res://scenes/Settings.tscn")

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
	get_tree().quit()
