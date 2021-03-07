extends Panel
# 구매품목
enum Product{money}
# 지불방법
enum PayMethod {gem, ad}

export (Texture) var icon
export (PayMethod) var pay_method = PayMethod.gem
export (Product) var product = Product.money
export (float) var price = 100000
export (float) var product_amount = 0
export (Texture) var gem_texture
export (Texture) var ad_texture

# 지불이 되었을때
var pay_completed:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect.texture = icon
	$Title.text = str(product_amount)
	$BuyButton.text = str(stepify(price, 0.01))
	if pay_method == PayMethod.gem:
		$BuyButton.icon = gem_texture
	elif pay_method == PayMethod.ad:
		$BuyButton.icon = ad_texture

func _on_BuyButton_pressed():
	SoundManager.play_ui_click_audio()
	# 지불방법이 gem인 경우
	if pay_method == PayMethod.gem:
		if StaticData.total_gem > price:
			pay_completed = true
			get_product()
			StaticData.total_gem -= price
		else:
			Util.show_message(self, "You need more gems")
	elif pay_method == PayMethod.ad:
		$AdMob.show_rewarded_video()
			
# 제품 get한다.
# 정상적으로 지불되었을때만 호출한다.
func get_product():
	# 지불이 정상적으로 되지 않으면 그냥 리턴
	if !pay_completed:
		return
		
	if product == Product.money:
		StaticData.total_money += product_amount
	
	pay_completed = false
		
# reward를 준다.
# 구매제품을 구매한다.
func _on_AdMob_rewarded(currency, ammount):
	pay_completed = true
	get_product()

# 광고가 제대로 load 되지 않음
func _on_AdMob_rewarded_video_failed_to_load(error_code):
	Util.show_message(self, "Sorry! AD is not ready yet.")


# 유저가 광고를 취소함
func _on_AdMob_rewarded_video_left_application():
	pass # Replace with function body.
