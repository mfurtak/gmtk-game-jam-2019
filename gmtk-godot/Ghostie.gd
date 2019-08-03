extends Area2D

var direction = Vector2()
var velocity = Vector2()
const MAX_HEALTH = 30.0
const SPEED = 8
const TOP_SPEED = 30
const DECELERATION = 0.9

var current_health = MAX_HEALTH

onready var player = get_node("/root/Main/Player")
# Called when the node enters the scene tree for the first time.

func _ready():
	connect('body_entered', self, '_on_body_entered')
	
func _on_body_entered(body):
	if body.name == "Player":
		print("BOO!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_direction = (lerp(player.position, position, .5) - position).normalized()
	
	velocity.x = max(min(player_direction.x * SPEED + velocity.x, TOP_SPEED), -TOP_SPEED)
	velocity.y =  max(min(player_direction.y * SPEED + velocity.y, TOP_SPEED), -TOP_SPEED)
	position += velocity * delta

func on_attacked():
	pass

func on_shot(damage):
	current_health -= damage
	$DamagedAnimation.modulate = Color(1, 1, 1, current_health / MAX_HEALTH)
	$DamagedAnimation.play()
	$DamageAnimationTimer.start()
	if (current_health <= 0):
		self.queue_free()

func _on_DamageAnimation_timeout():
	$DamagedAnimation.stop()
