extends Panel
class_name UpgradePanel

enum UpgradeItem{power, interval, fire_range, player_power, player_hp}
export (UpgradeItem) var upgrade_item = UpgradeItem.power
export (Define.Weapon) var weapon = Define.Weapon.Pistol

onready var weapon_information:WeaponInformation = StaticData.get_weapon_information(weapon)
onready var player_information:PlayerInformation = StaticData.get_player_information()

var need_more_money_to_upgrade = false	# upgrade하기 위해서 돈이 더 필요한지?
var upgrade_cost = 100000000 # 혹시라도 오류가 발생하면 구매하지 못하게 하려고 초기값을 크게
var is_max_level = false
func _ready():
	update()
	
func set_upgrade_item(_upgrade_item):
	upgrade_item = _upgrade_item
	update()

	
func change_weapon(w):
	weapon = w
	weapon_information = StaticData.get_weapon_information(weapon)
	update()
	
# 비용을 계산하고 button, bar, text를 갱신한다
func update():
	var title_text
	var value_text
	var level
	match upgrade_item:
		UpgradeItem.power:
			title_text = "POWER"
			value_text = str(stepify(Table.get_weapon_power_by_level(weapon), 1))
			level = weapon_information.power_level
			is_max_level = weapon_information.is_max_power_level()
		UpgradeItem.interval:
			title_text = "INT."
			value_text = str(stepify(Table.get_weapon_interval_by_level(weapon), 0.01))
			level = weapon_information.interval_level
			is_max_level = weapon_information.is_max_interval_level()
		UpgradeItem.fire_range:
			title_text = "RANGE"
			level = weapon_information.range_level
			is_max_level = weapon_information.is_max_range_level()
		UpgradeItem.player_power:
			title_text = "POWER"
			value_text = str(stepify(Table.get_player_power_by_level(), 1))
			level = player_information.power_level
			is_max_level = player_information.is_max_power_level()
		UpgradeItem.player_hp:
			title_text = "HP"
			value_text = str(stepify(Table.get_player_hp_by_level(), 1))
			level = player_information.hp_level
			is_max_level = player_information.is_max_hp_level()			
	
	# 비용을 계산한다
	upgrade_cost = Table.get_upgrade_cost(level+1)		
	
	# text 표시
	$Title.text = title_text
	$Value.text = value_text
	
	# bar 갱신
	update_bar(level)

	# button text 표시
	update_button()
		
func _process(_delta):
	update_button()
	
func update_button():
	if is_max_level:
		$Button.disabled = true
		$Button.text = "MAX"
	else:
		$Button.disabled = false
		$Button.text = str(upgrade_cost)
		# 돈이 부족하면 text를 붉은색으로
		if is_need_more_money_to_upgrade():
			$Button.set("custom_colors/font_color", Color(1, 0, 0, 1))
			$Button.set("custom_colors/font_color_hover", Color(1, 0, 0, 1))
		else:
			$Button.set("custom_colors/font_color", Color(1, 1, 1, 1))
			$Button.set("custom_colors/font_color_hover", Color(1, 1, 1, 1))
			
func is_need_more_money_to_upgrade()->bool:
	if StaticData.total_money < upgrade_cost:
		return true
	else:
		return false
		
func update_bar(level):
	var bars = $HBoxContainer.get_children()
	for i in range(bars.size()):
		# 켠다
		if level > i:
			bars[i].modulate.r = 1
			bars[i].modulate.g = 1
			bars[i].modulate.b = 1
		else:
			bars[i].modulate.r = 0.2
			bars[i].modulate.g = 0.2
			bars[i].modulate.b = 0.2

# UP 버튼
# 돈이 부족하면 shop으로 이동할지 물어본다.
func _on_Button_pressed():
	SoundManager.play_ui_click_audio()
	if is_need_more_money_to_upgrade():
		var dlg = MyAcceptDialog.new()
		dlg.dialog_text = tr("You need more money.") + "\n" + tr("Go to shop?")
		dlg.add_cancel(tr("Cancel"))
		dlg.get_ok().connect("pressed", self, "on_GoToShopButton_pressed")
		add_child(dlg)
		dlg.popup_centered()
		return
		
	# 효과
	Util.blank_light($Light2D, $Tween)
	
	SoundManager.play_ui_upgrade_audio()
	
	# 비용만큼 가진 돈에서 뺀다
	StaticData.total_money -= upgrade_cost
	
	# level을 올린다
	match upgrade_item:
		UpgradeItem.power:
			weapon_information.upgrade_power_level()
		UpgradeItem.fire_range:			
			weapon_information.upgrade_range_level()
		UpgradeItem.interval:
			weapon_information.upgrade_interval_level()
		UpgradeItem.player_power:
			player_information.upgrade_power_level()
		UpgradeItem.player_hp:
			player_information.upgrade_hp_level()			
	# text, button, 비용을 갱신한다
	update()

func on_GoToShopButton_pressed():
	SoundManager.play_ui_click_audio()
	var err = get_tree().change_scene("res://scenes/Shop.tscn")
	if err != OK:
		push_error("change_scene failed")
