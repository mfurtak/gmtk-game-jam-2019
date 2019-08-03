extends Area2D

signal shake_requested

var attacking setget set_attacking, get_attacking
var player_velocity setget set_player_velocity, get_player_velocity


func _ready():
	connect('body_entered', self, '_on_entered')
	connect('area_entered', self, '_on_entered')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	pass

func _on_entered(body):
	if body.has_method('on_shield_attacked'):
		var damage = 0
		if attacking:
			damage = 2
		else:
			damage = 1.2
			
		body.on_shield_attacked(damage)
		emit_signal("shake_requested")
		
func set_attacking(new_attacking):
    attacking = new_attacking

func get_attacking():
    return attacking
	
func set_player_velocity(new_player_velocity):
    player_velocity = new_player_velocity

func get_player_velocity():
    return player_velocity