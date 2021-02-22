extends Node

# stage 클리어 점수 펙터
var stage1_clear_store = 6000
var stage_clear_score_factor = 1.15

# 적 체력 증가 펙터
var enemy_hp_factor = 1.05

# player hp factor
var player_hp_factor = 0.1

# weapon power factor
var weapon_power_factor = 1.2

# weapon interval factor
var weapon_interval_factor = 0.965

# upgrade cost factor
var upgrade1_cost = 1000	# 첫번째 upgrade 비용
var upgrade_cost_factor = 1.3	# 이후 upgrade시 늘어나는 비용 factor

# 무기별 interval
var interval_Pistol = 0.4
var interval_SMG = 0.25
var interval_MG = 0.2
var interval_FlameThrower = 0.15
var interval_RPG = 1

# player의 기본 공격력
var player_power = 500
# player의 기본 체력
var player_hp = 3000#300000

# 무기별 기본 파워
var power_Pistol = 700
var power_SMG = 500
var power_MG = 700
var power_FlameThrower = 300
var power_RPG = 1200

# level별 upgrade factor
var factor_by_level = 0.1

# 적 hp / power의 최대 업그레이드 level
var max_enemy_level = 200


# 무기별 interval
func get_weapon_interval_by_level(weapon):
	if weapon == null:
		return 100
	var weapon_information = StaticData.get_weapon_information(weapon)
	var interval_level = weapon_information.interval_level
	var interval_basic = 1
	if weapon == Define.Weapon.Pistol:
		interval_basic = interval_Pistol
	elif weapon == Define.Weapon.SMG:
		interval_basic = interval_SMG
	elif weapon == Define.Weapon.MG:
		interval_basic = interval_MG
	elif weapon == Define.Weapon.FlameThrower:
		interval_basic = interval_FlameThrower
	elif weapon == Define.Weapon.RPG:
		interval_basic = interval_RPG
	return get_weapon_interval(interval_basic, interval_level)	
	
# hp level이 반영된 player의 hp 리턴
func get_player_hp_by_level()->int:
	var hp_level =  StaticData.get_player_information().hp_level
	return player_hp + (player_hp * player_hp_factor) * hp_level
	 
#	var hp_level =  StaticData.get_player_information().hp_level
#	var hp = player_hp
#	for _i in range(hp_level):
#		hp = hp * player_hp_factor
#
#	return hp as int
	
# power level이 반영된 palyer의 공격력 리턴
func get_player_power_by_level():
	return get_player_power(Table.player_power, StaticData.get_player_information().power_level)
	
# power level이 반영된 무기의 공격력 리턴
func get_weapon_power_by_level(weapon):
	if weapon == Define.Weapon.Pistol:
		return get_weapon_power(power_Pistol, StaticData.get_weapon_information(Define.Weapon.Pistol).power_level)
	elif weapon == Define.Weapon.SMG:
		return get_weapon_power(power_SMG, StaticData.get_weapon_information(Define.Weapon.SMG).power_level)
	elif weapon == Define.Weapon.MG:
		return get_weapon_power(power_MG, StaticData.get_weapon_information(Define.Weapon.MG).power_level)
	elif weapon == Define.Weapon.FlameThrower:
		return get_weapon_power(power_FlameThrower, StaticData.get_weapon_information(Define.Weapon.FlameThrower).power_level)
	elif weapon == Define.Weapon.RPG:
		return get_weapon_power(power_RPG, StaticData.get_weapon_information(Define.Weapon.RPG).power_level)
	
# 공격다음 폭파가 있는지?
func get_weapon_bullet_next_bomb(weapon) -> bool:
	if weapon == Define.Weapon.Pistol:
		return false
	elif weapon == Define.Weapon.SMG:
		return false
	elif weapon == Define.Weapon.MG:
		return false
	elif weapon == Define.Weapon.FlameThrower:
		return false
	elif weapon == Define.Weapon.RPG:
		return true
	return false
	
# 관통공격인지?
func get_weapon_bullet_penetrate(weapon) -> bool:
	if weapon == Define.Weapon.Pistol:
		return false
	elif weapon == Define.Weapon.SMG:
		return false
	elif weapon == Define.Weapon.MG:
		return false
	elif weapon == Define.Weapon.FlameThrower:
		return true
	elif weapon == Define.Weapon.RPG:
		return false
	return false	

# 마지막에 도달했을때 스케일
func get_weapon_bullet_last_scale(weapon) -> float:
	if weapon == Define.Weapon.Pistol:
		return 1.0
	elif weapon == Define.Weapon.SMG:
		return 1.0
	elif weapon == Define.Weapon.MG:
		return 1.0
	elif weapon == Define.Weapon.FlameThrower:
		return 1.7
	elif weapon == Define.Weapon.RPG:
		return 1.0
	return 1.0
	
# 무기별 총알 속도
func get_weapon_bullet_speed(var weapon) -> int:
	if weapon == Define.Weapon.FlameThrower:
		return 200
	elif weapon == Define.Weapon.MG:
		return 350
	elif weapon == Define.Weapon.Pistol:
		return 350
	elif weapon == Define.Weapon.RPG:
		return 300
	elif weapon == Define.Weapon.SMG:
		return 350
	return 300
		
# 무기 가격
func get_weapon_price(weapon)->int:
	if weapon == Define.Weapon.Pistol:
		return 0
	elif weapon == Define.Weapon.SMG:
		return 3000
	elif weapon == Define.Weapon.MG:
		return 7000
	elif weapon == Define.Weapon.FlameThrower:
		return 15000
	elif weapon == Define.Weapon.RPG:
		return 35000
	return 100000
	
# 무기 사거리
func get_weapon_bullet_distance(weapon) -> int:
	if weapon == Define.Weapon.Pistol:
		return 250
	elif weapon == Define.Weapon.SMG:
		return 300
	elif weapon == Define.Weapon.MG:
		return 300
	elif weapon == Define.Weapon.FlameThrower:
		return 200
	elif weapon == Define.Weapon.RPG:
		return 350
	return 100
		
# stage clear에 필요한 점수 리턴
# stage 의 level과 step으로 계산한다.
func get_stage_clear_score(si:StageInformation)->int:
	var pos = get_stage_position(si)
	var score = stage1_clear_store
	for _i in range(pos):
		score = score * stage_clear_score_factor
	return score
	
# to_level로 업그레이드 하는데 필요한 비용 리턴
func get_upgrade_cost(to_level)->int:
	var cost = upgrade1_cost
	for _i in range(to_level-1):
		cost = cost * upgrade_cost_factor
	return cost as int
	

# stage의 난이도 위치 
# 이걸로 적HP와 clear score가 결정된다.
func get_stage_position(si:StageInformation)->int:
	var pos = (si.level * 1.5) + si.current_step
	if pos > max_enemy_level:
		pos = max_enemy_level
	return pos
#	return (si.level * 3) + si.current_step
	
# stage별 적 hp를 리턴
func get_enemy_hp(hp, si:StageInformation)->int:
	var pos = get_stage_position(si)
	return hp + (hp * factor_by_level) * pos
#	var pos = get_stage_position(si)
#	for _i in range(pos):
#		hp = hp * enemy_hp_factor
#	return hp as int
	
# player의 level별 기본 공격력 리턴
func get_player_power(power, power_level)->int:
	return get_weapon_power(power, power_level)
	
# power level별 무기 공격력 리턴
func get_weapon_power(power, power_level)->int:
	return power + (power * factor_by_level) * power_level
#	for _i in range(power_level-1):
#		power = power * weapon_power_factor
#	return power as int
	
# interval level별 무기 inerval 리턴
func get_weapon_interval(interval, interval_level)->int:
	for _i in range(interval_level-1):
		interval = interval * weapon_interval_factor
	return interval	
	
	
	
