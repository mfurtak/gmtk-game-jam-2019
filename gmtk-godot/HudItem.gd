extends ColorRect

export var active_item = false

var text setget set_text, get_text

# Called when the node enters the scene tree for the first time.
func _ready():
	if active_item:
		color = Color("#d4bc1d")
	else:
		color = Color("#978248")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_text(new_text):
    $Label.text = new_text

func get_text():
    return $Label.text