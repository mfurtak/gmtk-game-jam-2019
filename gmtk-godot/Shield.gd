extends Area2D

var attacking setget set_shield_attacking, get_shield_attacking

func _ready():
	connect('body_entered', self, '_on_entered')
	connect('area_entered', self, '_on_entered')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	pass

func _on_entered(body):
	if visible and body.has_method('on_shield_attacked'):
		var damage = 0
		if get_shield_attacking():
			damage = 2
		else:
			damage = 1.2
			
		body.on_shield_attacked(damage)
		
func set_shield_attacking(new_attacking):
    attacking = new_attacking

func get_shield_attacking():
    return attacking