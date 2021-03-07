extends Panel


func _ready():
	$TextureRect/Coins.text = String(StaticData.current_stage_money)
	
	update_revival_button()
	
func update_revival_button():
	#  부활 기회가 있으면 버튼을 보여준다.
	if StaticData.has_revival_chance:
		$TextureRect/RevivalButton.visible = true
		$TextureRect/HomeButton.visible = true
		$TextureRect/HomeButtonCenter.visible = false
	else:
		$TextureRect/RevivalButton.visible = false
		$TextureRect/HomeButton.visible = false
		$TextureRect/HomeButtonCenter.visible = true
		
func _on_HomeButton_pressed():
	SoundManager.play_ui_click_audio()
	get_tree().change_scene("res://scenes/Home.tscn")


func _on_RetryButton_pressed():
	SoundManager.play_ui_click_audio()
	get_tree().change_scene("res://scenes/World.tscn")

# 부활을 누르면 reward video load를 한다.
func _on_RevivalButton_pressed():
	SoundManager.play_ui_click_audio()
	var os_name = OS.get_name()
	if os_name == "Windows":
		_on_AdMob_rewarded(0, 0)
	else:
		$Label.text = "_on_RevivalButton_pressed"
		$TextureRect/RevivalButton/Label.text = "loading..."
		$TextureRect/RevivalButton.disabled = true
		$TextureRect/RevivalButton.modulate.a = 0.5
		$AdMob.load_rewarded_video()
	
	
# 로드가 완료 되면 표시
func _on_AdMob_rewarded_video_loaded():
	$Label.text = "_on_AdMob_rewarded_video_loaded"
	$TextureRect/RevivalButton/Label.text = "..."
	$AdMob.show_rewarded_video()

# reward를 준다.
# 현재는 부활 밖에 없으니 부활만 한다.
func _on_AdMob_rewarded(currency, ammount):
	$Label.text = "_on_AdMob_rewarded"
	
	StaticData.has_revival_chance = false
	update_revival_button()
	
	# todo : world 신을 다시 호출하면 부활 찬스가 생김
	# 그냥 체력만 회복해줘야함
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		queue_free()
		players[0].revival()
	
#	get_tree().change_scene("res://scenes/World.tscn")

# 동영상을 보다가 취소한 경우
# 다시 부활시도할 수도 있으니 그냥 둔다.
func _on_AdMob_rewarded_video_left_application():
	$Label.text = "_on_AdMob_rewarded_video_left_application"
	pass

func _on_AdMob_rewarded_video_failed_to_load(error_code):
	$Label.text = "_on_AdMob_rewarded_video_failed_to_load. error_code : " + str(error_code)
	$TextureRect/RevivalButton/Label.text = "REVIVAL"
	update_revival_button()
