extends Panel

export (Define.Weapon) var weapon

var settingWeaponPanel = preload("res://scenes/SettingWeaponPanel.tscn")
var weaponInventory = preload("res://scenes/WeaponInventory.tscn")

onready var price = Table.get_weapon_price(weapon)
func _ready():
	update()
	$NameLabel.text = Define.get_weapon_name(weapon)

func _process(_delta):
	update()
	
func is_need_more_money()->bool:
	if StaticData.total_money < price:
		return true
	else:
		return false
		
func update():
	$WeaponButton/TextureRect.texture = Define.get_weapon_texture(weapon)
	# enable이 아니면 검게
	var wi = StaticData.get_weapon_information(weapon)
	if wi != null:
		if wi.enable:
			$WeaponButton/TextureRect.modulate = Color(1, 1, 1)
		else:
			$WeaponButton/TextureRect.modulate = Color(0, 0, 0)
		$WeaponButton/EquipmentButton.visible = wi.enable
		$WeaponButton/BuyButton.visible = !wi.enable
		# 돈이 부족하면 buy button의 글을 빨간색으로 한다
		if is_need_more_money():
			$WeaponButton/BuyButton.set("custom_colors/font_color", Color(1, 0, 0, 1))
			$WeaponButton/BuyButton.set("custom_colors/font_color_hover", Color(1, 0, 0, 1))
		else:
			$WeaponButton/BuyButton.set("custom_colors/font_color", Color(1, 1, 1, 1))
			$WeaponButton/BuyButton.set("custom_colors/font_color_hover", Color(1, 1, 1, 1))
	$WeaponButton/BuyButton.text = str(price)

			
# 무기를 클릭하면 상세창이 있는 경우에 상세창에 정보를 뿌린다.
func _on_WeaponButton_pressed():
	var desc_panel = get_tree().root.get_node("Equipment/Control/WeaponDescriptionPanel")
	if desc_panel == null:
		return
	desc_panel.get_node("WeaponTexture").visible = true
	desc_panel.get_node("WeaponTexture").texture = Define.get_weapon_texture(weapon)
	desc_panel.get_node("WeaponNameLabel").text = Define.get_weapon_name(weapon)
	desc_panel.get_node("Information").text = Define.get_weapon_description(weapon)
	desc_panel.get_node("PowerPanel").set_upgrade_item(UpgradePanel.UpgradeItem.power)
	desc_panel.get_node("PowerPanel").change_weapon(weapon)
	
	desc_panel.get_node("IntervalPanel").set_upgrade_item(UpgradePanel.UpgradeItem.interval)
	desc_panel.get_node("IntervalPanel").change_weapon(weapon)
	
	


# set 버튼을 누르면 setting weapon panel을 보여준다.
func _on_EquipmentButton_pressed():
	var ins = settingWeaponPanel.instance()
	ins.weapon = weapon
	get_tree().root.add_child(ins)

# 구매를 한다.
func _on_BuyButton_pressed():
	if StaticData.total_money < price:
		var dlg = AcceptDialog.new()
		dlg.dialog_text = "You need more money.\nGo to shop?"
		dlg.add_cancel("Cancel")
		dlg.get_ok().connect("pressed", self, "on_GoToShopButton_pressed")
		add_child(dlg)
		dlg.popup_centered()
		return
		
	var wi = StaticData.get_weapon_information(weapon)
	if wi != null:
		wi.enable = true
		StaticData.total_money -= price
		update()
	
func on_GoToShopButton_pressed():
	var err = get_tree().change_scene("res://scenes/Shop.tscn")
	if err != OK:
		push_error("change_scene failed")
