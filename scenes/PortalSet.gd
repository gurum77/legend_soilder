extends Node2D

func _ready():
	$Portal1.other_portal = $Portal2
	$Portal2.other_portal = $Portal1
