extends Area2D

var direction = Vector2()
var velocity = Vector2()
var is_ghosting = false
const MAX_HEALTH = 30.0
const SPEED = 5
const TOP_SPEED = 60

var current_health = MAX_HEALTH

onready var player = get_node("/root/Main/Player")
# Called when the node enters the scene tree for the first time.

func _ready():
	connect('body_entered', self, '_on_body_entered')
	connect('body_exited', self, '_on_body_exited')
	
func _on_body_entered(body):
	if body.name == "Player":
		is_ghosting = true
		
func _on_body_exited(body):
	if body.name == "Player":
		is_ghosting = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_direction = (lerp(player.position, position, .5) - position).normalized()
	
	velocity.x = max(min(player_direction.x * SPEED + velocity.x, TOP_SPEED), -TOP_SPEED)
	velocity.y =  max(min(player_direction.y * SPEED + velocity.y, TOP_SPEED), -TOP_SPEED)
	position += velocity * delta
	if(is_ghosting):
		player.on_player_attacked(self)
	$DamagedAnimation.flip_h = velocity.x < 0
	
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
