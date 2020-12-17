extends Panel


export (Texture) var weapon_texture
export (String) var weapon_name
export (Texture) var weapon_desc_texture_rect
func _ready():
	$WeaponButton/TextureRect.texture = weapon_texture
	$NameLabel.text = weapon_name


# 무기를 클릭하면 상세창이 있는 경우에 상세창에 정보를 뿌린다.
func _on_WeaponButton_pressed():
	var desc_panel = get_tree().root.get_node("Equipment/Control/WeaponDescriptionPanel")
	if desc_panel == null:
		return
	desc_panel.get_node("WeaponTexture").texture = weapon_texture
	desc_panel.get_node("WeaponNameLabel").text = weapon_name
