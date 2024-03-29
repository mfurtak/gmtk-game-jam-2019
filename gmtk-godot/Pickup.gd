extends Area2D

export(Texture) var item_image

# Called when the node enters the scene tree for the first time.
func _ready():
	$icon.texture = item_image

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player" and self.visible:
			var player = body
			match self.name:
				'BowPickup':
					player.pickup(player.Items.BOW)
				'SwordPickup':
					player.pickup(player.Items.SWORD)
				'ShieldPickup':
					player.pickup(player.Items.SHIELD)
				_:
					pass

			self.queue_free()
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
