extends KinematicBody2D

var direction = Vector2(1, 0)
var velocity = Vector2()
var is_pushed = false
const FRICTION = .01

const something = {
	'LeftRayCast': Vector2(-1, 0),
	'RightRayCast': Vector2(1, 0),
	'UpRayCast': Vector2(0, -1),
	'DownRayCast': Vector2(0, 1),
}

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
	if is_pushed:
		velocity = lerp(velocity, Vector2(), FRICTION)
	if (velocity == Vector2(0, 0)):
		is_pushed = false
	move_and_collide(velocity * delta)


func on_attacked():
	pass

func on_shot(damage):
	print("was shot!")

func on_sword_attacked(damage):
	print("Sword ouch")

func on_shield_attacked(damage):
	is_pushed = true
	velocity.x = -direction.x * 70
	velocity.y = -direction.y * 70

func _physics_process(delta):
	#print(player.global_position)
	#print(get_position())
    # detect player overlap in x or y?
	#print("ASDF" + str(player))
	#print("facebook.com" + str(player.translation))
	pass