extends ColorRect

export var active_item = false

var image setget set_image
var image_opacity setget set_image_opacity

# Called when the node enters the scene tree for the first time.
func _ready():
	if active_item:
		color = Color("#99d4bc1d")
	else:
		color = Color("#99978248")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_image(new_image):
	$ItemImage.texture = new_image

func set_image_opacity(new_opacity):
	$ItemImage.texture.opa = new_opacity
