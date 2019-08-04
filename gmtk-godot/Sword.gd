extends Area2D

var attacking setget set_sword_attacking, get_sword_attacking
var facing_direction = Vector2()
var current_rotation = 0

var sword1_sfx = preload("res://audio/sword1.wav")
var sword2_sfx = preload("res://audio/sword2.wav")
var sword3_sfx = preload("res://audio/sword3.wav")
var sword_sfx = [sword1_sfx, sword2_sfx, sword3_sfx]

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
	if time_left > 0 and visible and body.has_method('on_sword_attacked'):
		body.on_sword_attacked(10)
		print("sword attacked")

func get_random_sword_sfx():
	return sword_sfx[randi() % 3]

func play_sword_sfx():
	if $SfxPlayer.playing:
		$SfxPlayer.stop()
	$SfxPlayer.stream = get_random_sword_sfx()
	$SfxPlayer.play()

func set_sword_attacking(new_attacking):
	attacking = new_attacking
	if attacking:
		for body in get_overlapping_bodies():
			if body.has_method('on_sword_attacked'):
				body.on_sword_attacked(10)
		print("sword attacked")
		play_sword_sfx()

func get_sword_attacking():
    return attacking
