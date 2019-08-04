extends KinematicBody2D

signal sfx_requested

var direction = Vector2(1,0)
var velocity = Vector2(0,0)
var shield_attacked = false

const SPEED = 4
const TOP_SPEED = 90
const DECELERATION = 0.2

func on_sword_attacked(damage):
	request_death_sfx()
	self.queue_free()

func on_shot(damage):
	request_death_sfx()
	self.queue_free()

func on_shield_attacked(damage):
	shield_attacked = true
	$ShieldAttackReactionTimer.start()

func request_death_sfx():
	emit_signal("sfx_requested", "res://audio/blob_death.wav", self.position)

func _physics_process(delta):
	if shield_attacked:
		velocity.x = 0
		velocity.y = 0
	else:
		velocity.x = clamp(direction.x * SPEED + velocity.x, -TOP_SPEED, TOP_SPEED)
		velocity.y = clamp(direction.y * SPEED + velocity.y, -TOP_SPEED, TOP_SPEED)

		if direction.x == 0:
			velocity.x = lerp(velocity.x, 0, DECELERATION)
		if direction.y == 0:
			velocity.y = lerp(velocity.y, 0, DECELERATION)

	var collision = move_and_collide(velocity * delta)
	if collision:
		if  collision.collider.has_method("on_player_attacked"):
			collision.collider.on_player_attacked(self)

func _on_Timer_timeout():
	direction = _randomize_direction()
	$Timer.start()
	$Timer.wait_time = (randf()/2.0) + .5

func _randomize_direction():
	var directions = [
		Vector2(0,-1),
		Vector2(0,1),
		Vector2(-1,0),
		Vector2(1,0)
	]
	directions.shuffle()
	return directions[0]


func _on_ShieldAttackReactionTimer_timeout():
	shield_attacked = false
