extends Panel

enum UpgradeItem{power, fire_range}
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
	if upgrade_item == UpgradeItem.power:
		$Title.text = "POWER"
		update_bar(weapon_information.power_level)
	elif upgrade_item == UpgradeItem.fire_range:
		$Title.text = "RANGE"
		update_bar(weapon_information.range_level)	

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
	if upgrade_item == UpgradeItem.power:
		wi.upgrade_power_level()
	elif upgrade_item == UpgradeItem.fire_range:
		wi.upgrade_range_level()
	update()
