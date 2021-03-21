extends Area2D

# bush가 들어오면 bush를 투명하게 만든다.
func _on_BushEyeSight_area_entered(area):
	if area is BushBody:
		var bush = area.get_parent() as Bush
		if !bush.dead:
			area.modulate.a = 0.3
		else:
			area.modulate.a = 1.0

func _on_BushEyeSight_area_exited(area):
	if area is BushBody:
		area.modulate.a = 1.0
