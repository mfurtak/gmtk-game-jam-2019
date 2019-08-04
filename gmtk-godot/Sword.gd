extends Area2D

var attacking setget set_sword_attacking, get_sword_attacking

func _ready():
	connect('body_entered', self, '_on_entered')
	connect('area_entered', self, '_on_entered')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	pass

func _on_entered(body):
	if visible and body.has_method('on_sword_attacked'):
		body.on_sword_attacked(10)
		
func set_sword_attacking(new_attacking):
    attacking = new_attacking

func get_sword_attacking():
    return attacking
