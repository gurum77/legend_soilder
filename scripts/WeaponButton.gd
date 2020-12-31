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
		if StaticData.current_weapon_index == weapon_index:
			$TextureRect/Light2D.visible = true
		else:
			$TextureRect/Light2D.visible = false		
