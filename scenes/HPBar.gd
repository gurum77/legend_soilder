extends ProgressBar

func init(max_hp):
	set_max(max_hp)
	set_value(max_hp)
	set_step(1)
	
	# hp 바의 크기를 변경한다.
	# 3000 기준 20
	rect_size.x = (max_hp / 3000) * 20
	rect_position.x = rect_size.x * -0.5
	
func set_hp(hp):
	set_value(hp)
	
