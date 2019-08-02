extends KinematicBody2D

var direction = Vector2()
var velocity = Vector2()

const SPEED = 30
const TOP_SPEED = 40
const DECELERATION = 0.9


onready var player = get_node("/root/Main/Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var normal_direction = direction.normalized()

	velocity = move_and_slide(velocity)
	if $LeftRayCast.is_colliding() and $LeftRayCast.get_collider().name == "Player":
		direction.x += -1
		velocity.x += max(min(normal_direction.x * SPEED, TOP_SPEED), -TOP_SPEED)
	elif $RightRayCast.is_colliding() and $RightRayCast.get_collider().name == "Player":
		direction.x += 1
		velocity.x += max(min(normal_direction.x * SPEED, TOP_SPEED), TOP_SPEED)
	else:
		direction.x = 0
		velocity.x = lerp(velocity.x, 0, DECELERATION)
	
	if $UpRayCast.is_colliding() and $UpRayCast.get_collider().name == "Player":
		direction.y += -1
		velocity.y += max(min(normal_direction.y * SPEED, TOP_SPEED), -TOP_SPEED)
	elif $DownRayCast.is_colliding() and $DownRayCast.get_collider().name == "Player":
		direction.y += 1
		velocity.y += max(min(normal_direction.y * SPEED, TOP_SPEED), TOP_SPEED)
	else:
		direction.y = 0
		velocity.y = lerp(velocity.y, 0, DECELERATION)



func _physics_process(delta):
	#print(player.global_position)
	#print(get_position())
    # detect player overlap in x or y?
	#print("ASDF" + str(player))
	#print("facebook.com" + str(player.translation))
	pass