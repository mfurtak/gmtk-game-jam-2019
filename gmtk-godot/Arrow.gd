extends Area2D

const SPEED = 30
var direction setget set_direction
var dead = false

func _ready():
	connect('body_entered', self, '_on_entered')
	connect('area_entered', self, '_on_entered')

func _physics_process(delta):
	if not dead:
		position += direction*SPEED

func _on_entered(body):
	print(body.name)
	if not dead:
		if body.name == "TileMap":
			dead = true
		if body.has_method("on_shot"):
			body.on_shot()
			print(body.name)
			queue_free()
		
func set_direction(new_direction):
	direction = new_direction
	self.rotation = _get_rotation()

func _get_rotation():
	if direction.y < 0:
		return 0
	elif direction.y > 0:
		return PI
	elif direction.x < 0:
		return (3.0 * PI) / 2.0
	elif direction.x > 0:
		return PI / 2.0
	else:
		return 0