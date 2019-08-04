extends KinematicBody2D

var direction = Vector2()
var velocity = Vector2()

const SPEED = 10
const TOP_SPEED = 500
const DECELERATION = 0.1

const sight_boxes = [
	'LeftSight',
	'RightSight',
	'UpSight',
	'DownSight'
]

const sight_boxes_to_directions = {
	'LeftSight': Vector2(-1, 0),
	'RightSight': Vector2(1, 0),
	'UpSight': Vector2(0, -1),
	'DownSight': Vector2(0, 1),
}

const sight_boxes_to_velocity_masks = {
	'LeftSight': Vector2(1, 0),
	'RightSight': Vector2(1, 0),
	'UpSight': Vector2(0, 1),
	'DownSight': Vector2(0, 1),
}

onready var player = get_node("/root/Main/Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func is_active_caster(caster):
	if caster.is_colliding() and caster.get_collider() ==  null:
		return false
	else:
		return caster.is_colliding() and caster.get_collider().name == "Player" and !caster.get_collider().is_pink

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_seen = false

	for sight_box in sight_boxes_to_directions.keys():
		var bodies = get_node(sight_box).get_overlapping_bodies()
		if bodies.has(player):
			player_seen = true
			direction = sight_boxes_to_directions.get(sight_box)
			
			var delta_velocity_x = direction.x * SPEED
			var delta_velocity_y = direction.y * SPEED
			
			velocity.x = clamp(velocity.x + delta_velocity_x, -TOP_SPEED, TOP_SPEED)
			velocity.y = clamp(velocity.y + delta_velocity_y, -TOP_SPEED, TOP_SPEED)
			
			velocity *= sight_boxes_to_velocity_masks.get(sight_box)

			# It's now possible for the player to be overlapping more than one
			# sight line. To avoid creating diagonal movement, only process
			# the first overlap
			break

	if !player_seen:
		direction = Vector2()
		velocity = lerp(velocity, Vector2(), DECELERATION)

	var collision = move_and_collide(velocity * delta)
	if collision:
		if  collision.collider.has_method("on_player_attacked"):
			collision.collider.on_player_attacked()
			
			

func on_attacked():
	pass # self.queue_free()

func on_shot(damage):
	print("was shot!")

func on_sword_attacked(damage):
	print("Sword ouch")
	
func on_shield_attacked(damage):
	print("Shield ouch")
	velocity.x = -velocity.x * damage
	velocity.y = -velocity.y * damage

func _physics_process(delta):
	#print(player.global_position)
	#print(get_position())
    # detect player overlap in x or y?
	#print("ASDF" + str(player))
	#print("facebook.com" + str(player.translation))
	pass