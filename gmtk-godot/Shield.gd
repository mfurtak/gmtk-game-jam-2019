extends Area2D

signal shake_requested

var attacking setget set_shield_attacking, get_shield_attacking
var facing_direction = Vector2()
var current_rotation = 0
var time_left = 0

func _ready():
	connect('body_entered', self, '_on_entered')
	connect('area_entered', self, '_on_entered')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var attack_string = "idle"
	#if time_left > 0:
	#	attack_string = "slash"
	if facing_direction.y < 0:
		$Down.show()
		$Right.hide()
		$Down.play(attack_string)
		#$Down.flip_v = false
		$Down.position = Vector2(22,-10) + time_left * 10 * facing_direction
		#$HitBox.position = $Down.position + Vector2(-20, -20)
	if facing_direction.y > 0:
		$Down.show()
		$Right.hide()
		$Down.play(attack_string)
		#$Down.flip_v = false
		$Down.position = Vector2(0,0) + time_left * 10 * facing_direction
		#$HitBox.position = $Down.position + Vector2(-20, 20)
	if facing_direction.x < 0:
		$Down.hide()
		$Right.show()
		$Right.play(attack_string)
		$Right.flip_h = true
		$Right.position = Vector2(-4,-6) + time_left * 10 * facing_direction
		#$HitBox.position = $Sword/Right.position + Vector2(-20, 0)
	if facing_direction.x > 0:
		$Down.hide()
		$Right.show()
		$Right.play(attack_string)
		$Right.flip_h = false
		$Right.position =  Vector2(2,-2) + time_left * 10 * facing_direction
		#$HitBox.position = $Sword/Right.position + Vector2(20, 0)
		
	#$Equipped/Shield.rotation = current_rotation
	# $Equipped/Shield.position = $ShieldAttackTimer.time_left * 10 * facing_direction + facing_direction*16

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
		emit_signal("shake_requested")
		
func set_shield_attacking(new_attacking):
    attacking = new_attacking

func get_shield_attacking():
    return attacking