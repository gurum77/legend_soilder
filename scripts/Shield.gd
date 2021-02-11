extends Sprite


var to_up = true
var gap = 0.1
var min_a = 0.2
var max_a = 0.4

func _ready():
	modulate.a = min_a
	end()
	
func start(life_time=3):
	$Timer.start(0.05)
	$EnableTimer.start(life_time)
	visible = true
	
func end():
	$Timer.stop()
	$EnableTimer.stop()
	visible = false


func _on_Timer_timeout():
	if to_up:
		if modulate.a >= max_a:
			to_up = false
		else:
			modulate.a += gap
	else:
		if modulate.a <= min_a:
			to_up = true
		else:
			modulate.a -= gap
		
		


func _on_EnableTimer_timeout():
	end()
