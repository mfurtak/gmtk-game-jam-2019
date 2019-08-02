extends KinematicBody2D

var direction = Vector2()
var velocity = Vector2()

const SPEED = 10
const TOP_SPEED = 400
const DECELERATION = .1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.x += max(min(direction.x * SPEED, TOP_SPEED), -TOP_SPEED)
	velocity.y +=  max(min(direction.y * SPEED, TOP_SPEED), -TOP_SPEED)
	
	if direction.x == 0:
		velocity.x = lerp(velocity.x, 0, DECELERATION)
	if direction.y == 0:
		velocity.y = lerp(velocity.y, 0, DECELERATION)
	
	velocity = move_and_slide(velocity)

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
	