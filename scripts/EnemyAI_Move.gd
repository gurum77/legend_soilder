extends Node2D

onready var enemy_ai:EnemyAI = get_parent()

# ai 상태
enum {patrol, move, avoid}
var state = patrol
