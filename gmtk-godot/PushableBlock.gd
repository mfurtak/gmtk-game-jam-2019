extends KinematicBody2D

var direction = Vector2()
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_shield_attacked(damage):
	print("Shield ouch")
	velocity.x = -velocity.x * damage
	velocity.y = -velocity.y * damage

