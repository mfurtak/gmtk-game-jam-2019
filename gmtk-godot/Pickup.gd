extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player" and self.visible:
			var player = body
			match self.name:
				'BowPickup':
					player.get_item(player.Items.BOW)
				'SwordPickup':
					player.get_item(player.Items.SWORD)
				'ShieldPickup':
					player.get_item(player.Items.SHIELD)
				_:
					pass

			self.queue_free()
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
