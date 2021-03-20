extends Node2D


var player:Player
onready var label = get_node_or_null("Label")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if player == null:
		return
	if player.power_posion_nums == 0:
		self.visible = false
		return
	
	self.visible = true
	label.text = str(player.power_posion_nums)
	
	
	
