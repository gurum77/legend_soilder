extends Node

var _play_services = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_init()
	_connect_signals()
	sign_in()

	
func sign_in()->void:
	if _play_services:
		_play_services.signIn()

func _init()->void:
	if Engine.has_singleton("GodotPlayGamesServices"):
		_play_services = Engine.get_singleton("GodotPlayGamesServices")
		_play_services.init(true)

func _connect_signals()->void:
	if _play_services:
		_play_services.connect("_on_sign_in_success", self, "_on_sign_in_success")
		_play_services.connect("_on_sign_in_failed", self, "_on_sign_in_failed")

func _on_sign_in_success(account_id : String):
	print("Successful sign in")
	pass
func _on_sign_in_failed(error_code:int):
	print("Failed to sign in with error code %s" % error_code)
	pass
	
	
