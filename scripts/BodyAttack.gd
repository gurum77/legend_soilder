extends Area2D

export (bool) var destroy_obstacle = true
export (bool) var destroy_bush = true
export (int) var power = 1000
var entered_player:Node2D = null
const max_power = 10000000
func _on_BodyAttack_body_entered(body):
	if body is PlayerBody:
		var player = body.get_parent() as Player
		entered_player = player
		entered_player.damage(power)
		$Timer.start()
	elif body is ObstacleBody:
		if destroy_obstacle:
			var obstacle = body.get_parent() as Obstacle
			obstacle.damage(max_power)
	
			
	
		
		
func _on_Timer_timeout():
	entered_player.damage(power)


func _on_BodyAttack_body_exited(body):
	if body is PlayerBody:
		entered_player = null
		$Timer.stop()


func _on_BodyAttack_area_entered(area):
	if area is BushBody:
		if destroy_bush:
			var bush = area.get_parent() as Bush
			bush.die()
			
