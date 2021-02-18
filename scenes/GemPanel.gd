extends TextureRect

onready var tween = $Tween
onready var last_total_gem:int = StaticData.total_gem
onready var gem_label = $GemLabel
var tween_duration = 0.5
func _ready():
	gem_label.text = String(last_total_gem)
	
func _process(_delta):
	if tween != null and !tween.is_active():
		if last_total_gem != StaticData.total_gem:
			tween.interpolate_property(self, "last_total_gem", last_total_gem, StaticData.total_gem, tween_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tween.start()
	gem_label.text = String(last_total_gem)	
