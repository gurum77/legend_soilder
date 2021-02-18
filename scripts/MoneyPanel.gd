extends TextureRect

onready var tween = $Tween
onready var last_total_money:int = StaticData.total_money
onready var money_label = $MoneyLabel
var tween_duration = 0.5
func _ready():
	money_label.text = String(last_total_money)
	
func _process(_delta):
	if tween != null and !tween.is_active():
		if last_total_money != StaticData.total_money:
			tween.interpolate_property(self, "last_total_money", last_total_money, StaticData.total_money, tween_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tween.start()
	money_label.text = String(last_total_money)	
