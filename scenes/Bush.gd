extends Node2D


func _on_Body_body_entered(body):
	if body is PlayerBody:
		modulate.a = 0.5


func _on_Body_body_exited(body):
	if body is PlayerBody:
		modulate.a = 1.0
