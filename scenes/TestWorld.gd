extends Node2D

func _ready():
	StaticData.game_state = Define.GameState.play
	SettingsStaticData.load_settings()

