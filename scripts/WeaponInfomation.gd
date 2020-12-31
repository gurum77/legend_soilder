class_name WeaponInformation

var power_level = 1
var range_level = 1

func upgrade_power_level():
	if power_level < Define.max_power_level:
		power_level += 1
		
func upgrade_range_level():
	if range_level < Define.max_range_level:
		range_level += 1
