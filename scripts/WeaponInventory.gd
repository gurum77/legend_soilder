extends Panel


var initialized = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# 장착되지 않은 inventory가 선택되어 있다면 첫번째로 변경
	var iv = StaticData.get_inventory_item(StaticData.current_weapon_index)
	if iv == null || iv.weapon == Define.Weapon.None:
		StaticData.current_weapon_index = 0
	update()
	
func _process(_delta):
	if !initialized and StaticData.game_state == Define.GameState.play:
		update()
		initialized = true

# weapon inventory의 무기들을 갱신한다.
func update():
	$HBoxContainer/WeaponButton1.update()
	$HBoxContainer/WeaponButton2.update()
	$HBoxContainer/WeaponButton3.update()	


func _on_WeaponButton1_pressed():
	if StaticData.get_inventory_item(0).weapon == Define.Weapon.None:
		return
	StaticData.current_weapon_index = 0
	update()


func _on_WeaponButton2_pressed():
	if StaticData.get_inventory_item(1).weapon == Define.Weapon.None:
		return
	StaticData.current_weapon_index = 1
	update()


func _on_WeaponButton3_pressed():
	if StaticData.get_inventory_item(2).weapon == Define.Weapon.None:
		return
	StaticData.current_weapon_index = 2
	update()
