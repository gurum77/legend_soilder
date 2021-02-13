extends Control


func _ready():
	_on_PlayerButton_pressed()
	
func _on_BackButton_pressed():
	var err = get_tree().change_scene("res://scenes/Home.tscn")
	if err != OK:
		push_error("change_scene failed")

# 빠져 나갈때 마다 저장한다
func _exit_tree():
	StaticData.save_game()

# player를 누르면 player 정보를 표시한다.
func _on_PlayerButton_pressed():
	var desc_panel = get_tree().root.get_node("Equipment/Control/WeaponDescriptionPanel")
	if desc_panel == null:
		return

	desc_panel.get_node("WeaponTexture").visible = false
	desc_panel.get_node("WeaponNameLabel").text = Define.get_player_name()
	desc_panel.get_node("Information").text = Define.get_player_description()
	desc_panel.get_node("PowerPanel").set_upgrade_item(UpgradePanel.UpgradeItem.player_power)
	desc_panel.get_node("IntervalPanel").set_upgrade_item(UpgradePanel.UpgradeItem.player_hp)
