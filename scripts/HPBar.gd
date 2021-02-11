extends ProgressBar

func init(max_hp):
	set_max(max_hp)
	set_value(max_hp)
	set_step(1)
	$Label.text = str(max_hp)
	# hp 바의 크기를 변경한다.
	# 3000 기준 20
	rect_scale.x = (max_hp / 3000)
	
	
func set_hp(hp):
#	var cur_val = value
#	$Tween.interpolate_property(self, "value", cur_val, hp, 0.1, Tween.EASE_OUT)
#	$Tween.start()
	value = hp
	$Label.text = str(hp)
	
