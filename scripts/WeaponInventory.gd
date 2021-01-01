extends Panel


var initialized = false

# Called when the node enters the scene tree for the first time.
func _ready():
	update()
	
func _process(delta):
	if !initialized and StaticData.game_state == Define.GameState.play:
		update()
		initialized = true

# weapon inventory의 무기들을 갱신한다.
func update():
	$HBoxContainer/WeaponButton1.update()
	$HBoxContainer/WeaponButton2.update()
	$HBoxContainer/WeaponButton3.update()	


func _on_WeaponButton1_pressed():
	StaticData.current_weapon_index = 0
	update()


func _on_WeaponButton2_pressed():
	StaticData.current_weapon_index = 1
	update()


func _on_WeaponButton3_pressed():
	StaticData.current_weapon_index = 2
	update()
