extends KinematicBody2D

var direction = Vector2()
var velocity = Vector2()

const SPEED = 30
const TOP_SPEED = 40
const DECELERATION = .7

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player = get_node("/root/Main/Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var normal_direction = direction.normalized()
	
	# velocity.x += max(min(normal_direction.x * SPEED, TOP_SPEED), -TOP_SPEED)
	# velocity.y +=  max(min(normal_direction.y * SPEED, TOP_SPEED), -TOP_SPEED)
	#print(normal_direction)
	if normal_direction.x == 0:
		velocity.x = lerp(velocity.x, 0, DECELERATION)
	#if normal_direction.y == 0:
	#	velocity.y = lerp(velocity.y, 0, DECELERATION)
	
	velocity = move_and_slide(velocity)
	if $LeftRayCast.is_colliding():
		direction.x += -1
		velocity.x += max(min(normal_direction.x * SPEED, TOP_SPEED), -TOP_SPEED)
	if $RightRayCast.is_colliding():
		direction.x += 1
		velocity.x += max(min(normal_direction.x * SPEED, TOP_SPEED), TOP_SPEED)



func _physics_process(delta):
	#print(player.global_position)
	#print(get_position())
    # detect player overlap in x or y?
	#print("ASDF" + str(player))
	#print("facebook.com" + str(player.translation))
	pass