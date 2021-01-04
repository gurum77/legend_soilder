extends Panel

enum UpgradeItem{power, interval, fire_range}
export (UpgradeItem) var upgrade_item = UpgradeItem.power
export (Define.Weapon) var weapon = Define.Weapon.Pistol

onready var weapon_information:WeaponInformation = StaticData.get_weapon_information(weapon)

func _ready():
	update()
	
func change_weapon(w):
	weapon = w
	weapon_information = StaticData.get_weapon_information(weapon)
	update()
	
func update():
	var title_text
	var value_text
	var level
	var is_max_level = false
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
			
	$Title.text = title_text
	$Value.text = value_text
	update_bar(level)
	if is_max_level:
		$Button.text = "MAX"
	else:
		$Button.text = "UP"			
		

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
func _on_Button_pressed():
	var wi:WeaponInformation = StaticData.get_weapon_information(weapon)
	if wi == null:
		return
	match upgrade_item:
		UpgradeItem.power:
			wi.upgrade_power_level()
		UpgradeItem.fire_range:			
			wi.upgrade_range_level()
		UpgradeItem.interval:
			wi.upgrade_interval_level()
	update()
