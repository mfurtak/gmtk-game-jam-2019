extends Area2D

var direction = Vector2()
var velocity = Vector2()

const SPEED = 8
const TOP_SPEED = 30
const DECELERATION = 0.9

onready var player = get_node("/root/Main/Player")
# Called when the node enters the scene tree for the first time.

func _ready():
	connect('body_entered', self, '_on_body_entered')
	
func _on_body_entered(body):
	print("ghost entered: ", body.name)
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

func on_shot():
	self.queue_free()

func _physics_process(delta):
	#print(player.global_position)
	#print(get_position())
    # detect player overlap in x or y?
	#print("ASDF" + str(player))
	#print("facebook.com" + str(player.translation))
	pass