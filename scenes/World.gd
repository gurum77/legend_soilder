extends Node2D

var pausePanel = preload("res://scenes/Pause.tscn")

func _on_PauseButton_pressed():
	var ins = pausePanel.instance()
	
	get_tree().root.add_child(ins)
	
