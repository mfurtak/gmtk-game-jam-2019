extends Area2D

var attacking setget set_sword_attacking, get_sword_attacking
var facing_direction = Vector2()
var current_rotation = 0

var time_left = 0
func _ready():
	connect('body_entered', self, '_on_entered')
	connect('area_entered', self, '_on_entered')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var attack_string = "idle"
	if time_left > 0:
		attack_string = "slash"
	if facing_direction.y < 0:
		$Sword/Down.show()
		$Sword/Right.hide()
		$Sword/Down.play(attack_string)
		$Sword/Down.flip_v = true
		$Sword/Down.position = Vector2(22,10)
		$HitBox.position = $Sword/Down.position + Vector2(-20, -20)
	if facing_direction.y > 0:
		$Sword/Down.show()
		$Sword/Right.hide()
		$Sword/Down.play(attack_string)
		$Sword/Down.flip_v = false
		$Sword/Down.position = Vector2(0,16)
		$HitBox.position = $Sword/Down.position + Vector2(-20, 20)
	if facing_direction.x < 0:
		$Sword/Down.hide()
		$Sword/Right.show()
		$Sword/Right.play(attack_string)
		$Sword/Right.flip_h = true
		$Sword/Right.position = Vector2(-24,13)
		$HitBox.position = $Sword/Right.position + Vector2(-20, 0)
	if facing_direction.x > 0:
		$Sword/Down.hide()
		$Sword/Right.show()
		$Sword/Right.play(attack_string)
		$Sword/Right.flip_h = false
		$Sword/Right.position =  Vector2(-13,16)
		$HitBox.position = $Sword/Right.position + Vector2(20, 0)
	
	$HitBox.rotation = current_rotation
	pass

func _physics_process(delta):
	pass

func _on_entered(body):
	if visible and body.has_method('on_sword_attacked'):
		body.on_sword_attacked(10)
		print("sword attacked")
		
func set_sword_attacking(new_attacking):
    attacking = new_attacking

func get_sword_attacking():
    return attacking
