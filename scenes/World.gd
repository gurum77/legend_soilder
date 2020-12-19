extends Node2D

var pausePanel = preload("res://scenes/Pause.tscn")

# pause
func _on_PauseButton_pressed():
	get_tree().paused = true
	
	var ins = pausePanel.instance()
	get_tree().root.add_child(ins)
	
