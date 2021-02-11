extends Panel
export (Texture) var icon
export (String) var title
export (float) var price
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect.texture = icon
	$Title.text = title
	$BuyButton.text = "$" + str(stepify(price, 0.01))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
