extends Node2D

export var message = "2000"
export var color = Color.white

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = message
	modulate = color
	
	var dist = 30
	var new_position = position + Vector2(0, -30)
	var new_modulate = modulate
	new_modulate.a = 0
	
	# 커지면서 올라온다.
	$Tween.interpolate_property(self, "scale", Vector2(0.1, 0.1), scale, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "position", position, new_position, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	
	# 올라간 상태로 0.5초 대기 후 천천히 내려가면서 사라진다.
	$Tween.interpolate_property(self, "position", new_position, new_position+Vector2(0,15), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT, 1)
	$Tween.interpolate_property(self, "modulate", modulate, new_modulate, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT, 1)
	
	$Tween.start()
	$Tween.connect("tween_all_completed", self, "on_Tween_all_completed")

func on_Tween_all_completed():
	call_deferred("queue_free")
