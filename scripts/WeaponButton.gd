extends TextureButton

# weapon  index
export (int) var weapon_index

# Called when the node enters the scene tree for the first time.
func _ready():
	update()
	
	
func update():
	var item = StaticData.get_inventory_item(weapon_index)
	if item == null:
		return;
	
	var weapon = item.weapon
	if weapon == null:
		$TextureRect.visible = false
		$Label.visible = true
	else:
		$TextureRect.visible = true
		$TextureRect.texture = Define.get_weapon_texture(weapon)
		$Label.visible = false
		
	if StaticData.game_state == Define.GameState.play:
		var m = 3.0
		if StaticData.current_weapon_index == weapon_index:
			m = 3
#			$TextureRect/Light2D.visible = true
		else:
			m = 1
#			$TextureRect/Light2D.visible = false		
		modulate.r = m
		modulate.g = m
		modulate.b = m
		
