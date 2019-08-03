extends KinematicBody2D

var direction = Vector2()
var velocity = Vector2()

const SPEED = 30
const TOP_SPEED = 50
const DECELERATION = .7

var is_pink = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var normal_direction = direction.normalized()
	
	velocity.x += max(min(normal_direction.x * SPEED, TOP_SPEED), -TOP_SPEED)
	velocity.y +=  max(min(normal_direction.y * SPEED, TOP_SPEED), -TOP_SPEED)

	if normal_direction.x == 0:
		velocity.x = lerp(velocity.x, 0, DECELERATION)
	if normal_direction.y == 0:
		velocity.y = lerp(velocity.y, 0, DECELERATION)
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		# Do stuff
    	print("PLAYER SLAP ", collision.collider.name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction.x = 0
	direction.y = 0
	
	if Input.is_action_pressed("ui_up"):
		direction.y += -1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x += -1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	

func _on_ItemSwapTimer_timeout():
	is_pink = !is_pink
	if is_pink:
		$AnimatedSprite.play("pink")
	else:
		$AnimatedSprite.play("default")
