extends KinematicBody2D
# X-direction Goomba

const SPEED = 1
const TOP_SPEED = 1

# Go right
var direction = Vector2()
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = Vector2(-1,0)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var delta_velocity_x = direction.x * SPEED
	velocity.x = clamp(velocity.x + delta_velocity_x, -TOP_SPEED, TOP_SPEED)
	
	var collision = move_and_collide(velocity)	
	if collision:
		$GoombaWaitTimer.start()
		velocity.x = 0
		direction.x = -direction.x

func on_shot(damage):
	self.queue_free()
	
func on_sword_attacked(damage):
	self.queue_free()

func on_shield_attacked(damage):
	pass
#	self.queue_free()
	