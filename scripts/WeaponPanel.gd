extends Panel

export (Define.Weapon) var weapon

var settingWeaponPanel = preload("res://scenes/SettingWeaponPanel.tscn")
func _ready():
	$WeaponButton/TextureRect.texture = Define.get_weapon_texture(weapon)
	$NameLabel.text = Define.get_weapon_name(weapon)


# 무기를 클릭하면 상세창이 있는 경우에 상세창에 정보를 뿌린다.
func _on_WeaponButton_pressed():
	var desc_panel = get_tree().root.get_node("Equipment/Control/WeaponDescriptionPanel")
	if desc_panel == null:
		return
	desc_panel.get_node("WeaponTexture").texture = Define.get_weapon_texture(weapon)
	desc_panel.get_node("WeaponNameLabel").text = Define.get_weapon_name(weapon)


# set 버튼을 누르면 weapon inventory를 보여준다.
func _on_EquipmentButton_pressed():
	var ins = settingWeaponPanel.instance()
	ins.weapon = weapon
	get_tree().root.add_child(ins)
		
