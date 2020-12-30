extends Panel

func _ready():
	$TextureRect/Coins.text = String(StaticData.current_stage_money)


func _on_HomeButton_pressed():
	get_tree().change_scene("res://scenes/Home.tscn")


func _on_RetryButton_pressed():
	get_tree().change_scene("res://scenes/World.tscn")
