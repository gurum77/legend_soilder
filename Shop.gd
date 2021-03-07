extends Panel

var payment
# payment 초기화
# 제대로 동작하지 않아서 호출하지 않음
# 나중에 제대로 동작하도록 수정해야함(출시후)
func init_payment():
	if Engine.has_singleton("GodotGooglePlayBilling"):
		payment = Engine.get_singleton("GodotGooglePlayBilling")

		# These are all signals supported by the API
		# You can drop some of these based on your needs
		payment.connect("connected", self, "_on_connected") # No params
		payment.connect("disconnected", self, "_on_disconnected") # No params
		payment.connect("connect_error", self, "_on_connect_error") # Response ID (int), Debug message (string)
		payment.connect("purchases_updated", self, "_on_purchases_updated") # Purchases (Dictionary[])
		payment.connect("purchase_error", self, "_on_purchase_error") # Response ID (int), Debug message (string)
		payment.connect("sku_details_query_completed", self, "_on_sku_details_query_completed") # SKUs (Dictionary[])
		payment.connect("sku_details_query_error", self, "_on_sku_details_query_error") # Response ID (int), Debug message (string), Queried SKUs (string[])
		payment.connect("purchase_acknowledged", self, "_on_purchase_acknowledged") # Purchase token (string)
		payment.connect("purchase_acknowledgement_error", self, "_on_purchase_acknowledgement_error") # Response ID (int), Debug message (string), Purchase token (string)
		payment.connect("purchase_consumed", self, "_on_purchase_consumed") # Purchase token (string)
		payment.connect("purchase_consumption_error", self, "_on_purchase_consumption_error") # Response ID (int), Debug message (string), Purchase token (string)

		payment.startConnection()
	else:
		Util.show_message(self, "Android IAP support is not enabled. Make sure you have enabled 'Custom Build' and the GodotGooglePlayBilling plugin in your Android export settings! IAP will not work.")
		print("Android IAP support is not enabled. Make sure you have enabled 'Custom Build' and the GodotGooglePlayBilling plugin in your Android export settings! IAP will not work.")
	
func _ready():
	# 제대로 동작하지 않아서 막아둠
	#init_payment()
	pass
		
func _on_BackButton_pressed():
	SoundManager.play_ui_click_audio()
	var err = get_tree().change_scene("res://scenes/Home.tscn")
	if err != OK:
		push_error("change_scene failed")

func _on_connected():
	print("connected")
#	Util.show_message(self, "connected")
#	payment.querySkuDetails(["my_iap_item"], "inapp") # "subs" for subscriptions
