extends RayCast2D
	
func _ready():
	collision_mask = 0b10010
func _process(delta):
	$Line2D.points[0] = Vector2(0, 0)
	if !is_colliding():
		$Line2D.points[1] = cast_to
		return
	$Line2D.points[1] = to_local(get_collision_point())
		
