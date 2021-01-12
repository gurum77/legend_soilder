class_name WeaponInformation

var enable = false	# 구매를 해야 true가 됨(pistol은 처음부터 enable을 한다)
var power_level = 1
var range_level = 1
var interval_level = 1

func is_max_power_level()->bool:
	if power_level >= Define.max_power_level:
		return true
	return false

func is_max_range_level()->bool:
	if range_level >= Define.max_range_level:
		return true
	return false

func is_max_interval_level()->bool:
	if interval_level >= Define.max_interval_level:
		return true
	return false
	
func upgrade_power_level():
	if power_level < Define.max_power_level:
		power_level += 1
		
func upgrade_range_level():
	if range_level < Define.max_range_level:
		range_level += 1
		
func upgrade_interval_level():
	if interval_level < Define.max_interval_level:
		interval_level += 1		
