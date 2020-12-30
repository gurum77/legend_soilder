extends TextureRect


func _process(delta):
	$MoneyLabel.text = String(StaticData.total_money)
