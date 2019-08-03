extends Area2D

var direction setget set_direction

func _ready():
	connect('body_entered', self, '_on_entered')
	connect('area_entered', self, '_on_entered')

func _physics_process(delta):
	pass

func _on_entered(body):
	print("SHIELDED, ", body.name)
	pass
		
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