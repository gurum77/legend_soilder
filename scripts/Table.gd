extends Node

# stage 클리어 점수 펙터
var stage1_clear_store = 6000
var stage_clear_score_factor = 1.12

# 적 체력 증가 펙터
var enemy_hp_factor = 1.05

# weapon power factor
var weapon_power_factor = 1.2

# weapon interval factor
var weapon_interval_factor = 0.965

# upgrade cost factor
var upgrade1_cost = 1000	# 첫번째 upgrade 비용
var upgrade_cost_factor = 1.3	# 이후 upgrade시 늘어나는 비용 factor

# 무기별 interval
var interval_Pistol = 0.5
var interval_SMG = 0.25
var interval_MG = 0.2
var interval_FlameThrower = 0.15
var interval_RPG = 1

# 무기별 기본 파워
var power_Pistol = 700
var power_SMG = 500
var power_MG = 700
var power_FlameThrower = 400
var power_RPG = 2000

# 무기별 interval
func get_weapon_interval_by_level(weapon):
	match weapon:
		Define.Weapon.Pistol:
			return get_weapon_interval(interval_Pistol, StaticData.get_weapon_information(Define.Weapon.Pistol).interval_level)
		Define.Weapon.SMG:
			return get_weapon_interval(interval_SMG, StaticData.get_weapon_information(Define.Weapon.SMG).interval_level)
		Define.Weapon.MG:
			return get_weapon_interval(interval_MG, StaticData.get_weapon_information(Define.Weapon.MG).interval_level)
		Define.Weapon.FlameThrower:
			return get_weapon_interval(interval_FlameThrower, StaticData.get_weapon_information(Define.Weapon.FlameThrower).interval_level)
		Define.Weapon.RPG:
			return get_weapon_interval(interval_RPG, StaticData.get_weapon_information(Define.Weapon.RPG).interval_level)
			
# power level이 반영된 무기의 공격력 리턴
func get_weapon_power_by_level(weapon):
	match weapon:
		Define.Weapon.Pistol:
			return get_weapon_power(power_Pistol, StaticData.get_weapon_information(Define.Weapon.Pistol).power_level)
		Define.Weapon.SMG:
			return get_weapon_power(power_SMG, StaticData.get_weapon_information(Define.Weapon.SMG).power_level)
		Define.Weapon.MG:
			return get_weapon_power(power_MG, StaticData.get_weapon_information(Define.Weapon.MG).power_level)
		Define.Weapon.FlameThrower:
			return get_weapon_power(power_FlameThrower, StaticData.get_weapon_information(Define.Weapon.FlameThrower).power_level)
		Define.Weapon.RPG:
			return get_weapon_power(power_RPG, StaticData.get_weapon_information(Define.Weapon.RPG).power_level)
	
# 공격다음 폭파가 있는지?
func get_weapon_bullet_next_bomb(weapon) -> bool:
	match weapon:
		Define.Weapon.Pistol:
			return false
		Define.Weapon.SMG:
			return false
		Define.Weapon.MG:
			return false
		Define.Weapon.FlameThrower:
			return false
		Define.Weapon.RPG:
			return true
	return false
	
# 관통공격인지?
func get_weapon_bullet_penetrate(weapon) -> bool:
	match weapon:
		Define.Weapon.Pistol:
			return false
		Define.Weapon.SMG:
			return false
		Define.Weapon.MG:
			return false
		Define.Weapon.FlameThrower:
			return true
		Define.Weapon.RPG:
			return false
	return false	

# 마지막에 도달했을때 스케일
func get_weapon_bullet_last_scale(weapon) -> float:
	match weapon:
		Define.Weapon.Pistol:
			return 1.0
		Define.Weapon.SMG:
			return 1.0
		Define.Weapon.MG:
			return 1.0
		Define.Weapon.FlameThrower:
			return 1.7
		Define.Weapon.RPG:
			return 1.0
	return 1.0
	
# 무기별 총알 속도
func get_weapon_bullet_speed(var weapon) -> int:
	match weapon:
		Define.Weapon.FlameThrower:
			return 200
		Define.Weapon.MG:
			return 350
		Define.Weapon.Pistol:
			return 350
		Define.Weapon.RPG:
			return 300
		Define.Weapon.SMG:
			return 350
	return 300
		
# 무기 사거리
func get_weapon_bullet_distance(weapon) -> int:
	match weapon:
		Define.Weapon.Pistol:
			return 250
		Define.Weapon.SMG:
			return 300
		Define.Weapon.MG:
			return 300
		Define.Weapon.FlameThrower:
			return 200
		Define.Weapon.RPG:
			return 400
	return 100
		
# stage clear에 필요한 점수 ㄹ ㅣ턴
func get_stage_clear_score(stage)->int:
	var score = stage1_clear_store
	for i in range(stage-1):
		score = score * stage_clear_score_factor
	return score
	
# to_level로 업그레이드 하는데 필요한 비용 리턴
func get_upgrade_cost(to_level)->int:
	var cost = upgrade1_cost
	for i in range(to_level-1):
		cost = cost * upgrade_cost_factor
	return cost as int
	

# stage별 적 hp를 리턴
func get_enemy_hp(hp, stage)->int:
	for i in range(stage-1):
		hp = hp * enemy_hp_factor
	return hp as int

# power level별 무기 공격력 리턴
func get_weapon_power(power, power_level)->int:
	for i in range(power_level-1):
		power = power * weapon_power_factor
	return power as int
	
# interval level별 무기 inerval 리턴
func get_weapon_interval(interval, interval_level)->int:
	for i in range(interval_level-1):
		interval = interval * weapon_interval_factor
	return interval	
	
	
	
