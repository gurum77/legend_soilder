extends TextureRect


func _process(_delta):
	$MoneyLabel.text = String(StaticData.total_money)
