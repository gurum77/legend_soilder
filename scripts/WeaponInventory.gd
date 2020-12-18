extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/WeaponButton1.weapon = StaticData.get_inventory_item(0).weapon
	$HBoxContainer/WeaponButton1.update()
	$HBoxContainer/WeaponButton2.weapon = StaticData.get_inventory_item(1).weapon
	$HBoxContainer/WeaponButton2.update()
	$HBoxContainer/WeaponButton3.weapon = StaticData.get_inventory_item(2).weapon
	$HBoxContainer/WeaponButton3.update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
