extends Panel

var weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	$WeaponTexture.texture = Define.get_weapon_texture(weapon)


func _on_ExitButton_pressed():
	self.queue_free()


func _on_WeaponButton1_pressed():
	if !StaticData.get_inventory_item(0).enabled:
		return
	StaticData.get_inventory_item(0).weapon = weapon
	_on_ExitButton_pressed()


func _on_WeaponButton2_pressed():
	if !StaticData.get_inventory_item(1).enabled:
		return
	StaticData.get_inventory_item(1).weapon = weapon
	_on_ExitButton_pressed()


func _on_WeaponButton3_pressed():
	if !StaticData.get_inventory_item(2).enabled:
		return
	StaticData.get_inventory_item(2).weapon = weapon
	_on_ExitButton_pressed()
