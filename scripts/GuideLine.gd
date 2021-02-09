extends RayCast2D

export var is_draw_line = true
func _ready():
	if !is_draw_line:
		$Line2D.clear_points()
	
#func _ready():
#	collision_mask = 0b10010
func _process(delta):
	if !is_draw_line:
		return
	$Line2D.points[0] = Vector2(0, 0)
	if !is_colliding():
		$Line2D.points[1] = cast_to
		return
	$Line2D.points[1] = to_local(get_collision_point())
