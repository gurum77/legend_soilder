extends ProgressBar

func init(max_hp):
	set_max(max_hp)
	set_value(max_hp)
	set_step(1)
	
func set_hp(hp):
	set_value(hp)
