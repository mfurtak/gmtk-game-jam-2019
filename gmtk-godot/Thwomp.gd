extends KinematicBody2D

var direction = Vector2()
var velocity = Vector2()

const SPEED = 10
const TOP_SPEED = 40
const DECELERATION = 0.9

const something = {
	'LeftRayCast': Vector2(-1, 0),
	'RightRayCast': Vector2(1, 0),
	'UpRayCast': Vector2(0, -1),
	'DownRayCast': Vector2(0, 1),
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
	var caster_hit = false
	for key in something:
		var caster = get_node(key)
		if is_active_caster(caster):
			caster_hit = true
			direction = something.get(key)
			velocity.x += max(min(direction.x * SPEED, TOP_SPEED), -TOP_SPEED)
			velocity.y += max(min(direction.y * SPEED, TOP_SPEED), -TOP_SPEED)

	if !caster_hit:
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