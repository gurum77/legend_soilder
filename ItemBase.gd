extends Area2D
class_name ItemBase

func _ready():
	add_to_group("item")
	
# 가상함수 
# player가 item을 get할때 적용할 효과를 코딩한다.
# 모든 item은 이 함수가 정의 되어 있어야 한다
func get_item():
	pass
