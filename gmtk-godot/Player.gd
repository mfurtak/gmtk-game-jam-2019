extends KinematicBody2D

signal shake_requested

enum Items {SWORD, BOW, SHIELD}

var sword_resource =  preload("res://sprites/sword.png")
var bow_resource =  preload("res://sprites/bow.png")
var shield_resource =  preload("res://sprites/shield.png")

var items_to_images = {}

var moving_direction = Vector2()
var facing_direction = Vector2(1,0)
var velocity = Vector2()
var is_action_pressed = false
var is_dead = false

signal game_over

const SPEED = 20
const TOP_SPEED = 275
const DECELERATION = .2
const ARROW_OFFSET = 48

const BASE_ITEMS_PERIOD = 2.5 # seconds
const PER_ITEM_PERIOD = 1

const MAX_HEALTH = 100
const MIN_HEALTH = 0
var current_health = MAX_HEALTH
var can_take_damage = true

var is_pink = false
var is_attacking = false
var is_sword_attacking = false
var is_shield_attacking = false
var bow_cool = true

var items_queue = [Items.SWORD]

var current_item = items_queue[-1]
var sprites = null
var current_sprite = null
var current_rotation = 0

onready var arrow_scene = preload("res://Arrow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	sprites = [$sword, $shield, $bow]
	items_to_images = {
		Items.SWORD: sword_resource,
		Items.SHIELD: shield_resource,
		Items.BOW: bow_resource
	}
	_render()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var normal_moving_direction = moving_direction.normalized()
	
	var delta_velocity_x = normal_moving_direction.x * SPEED
	var delta_velocity_y = normal_moving_direction.y * SPEED
	
	velocity.x = clamp(velocity.x + delta_velocity_x, -TOP_SPEED, TOP_SPEED)
	velocity.y = clamp(velocity.y + delta_velocity_y, -TOP_SPEED, TOP_SPEED)

	if normal_moving_direction.x == 0:
		velocity.x = lerp(velocity.x, 0, DECELERATION)
	if normal_moving_direction.y == 0:
		velocity.y = lerp(velocity.y, 0, DECELERATION)
	
	velocity = move_and_slide(velocity)
#	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
			
		if is_attacking and collision.collider.has_method("on_attacked"):
			collision.collider.on_attacked()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_dead:
		return
	
	moving_direction.x = 0
	moving_direction.y = 0
	is_action_pressed = false
	if Input.is_action_pressed("ui_up"):
		moving_direction.y += -1
	if Input.is_action_pressed("ui_down"):
		moving_direction.y += 1
	if Input.is_action_pressed("ui_left"):
		moving_direction.x += -1
	if Input.is_action_pressed("ui_right"):
		moving_direction.x += 1
	if Input.is_action_just_pressed("ui_select"):
		is_action_pressed = true
	
	if Input.is_action_pressed("ui_up"):
		facing_direction = Vector2(0,-1)
	elif Input.is_action_pressed("ui_down"):
		facing_direction = Vector2(0,1)
	elif Input.is_action_pressed("ui_left"):
		facing_direction = Vector2(-1,0)
	elif Input.is_action_pressed("ui_right"):
		facing_direction = Vector2(1,0)
		
	if is_action_pressed:
		_on_attack()

	var total_item_period = float(BASE_ITEMS_PERIOD + (PER_ITEM_PERIOD * items_queue.size()))
	var item_duration = total_item_period / float(items_queue.size())
	
	$ItemSwapTimer.wait_time = item_duration
	_render()

func on_player_attacked(damage = 1):
	if can_take_damage:
		match current_item:
			Items.SHIELD:
				pass
			_:
				take_damage(damage)
		can_take_damage = false
		$InjuryRecoveryTimer.start()
			
	if (current_health <= 0 && !is_dead):
		on_death()

func take_damage(damage):
	current_health = max(MIN_HEALTH, current_health - damage)
	emit_signal("shake_requested", 0.2, 15, damage)

func _on_attack():
	match current_item:
		Items.SWORD:
			if not is_sword_attacking:
				print("SWORD ATTACK!!")
				is_sword_attacking = true
				$SwordAttackTimer.start()
		Items.BOW:
			if bow_cool:
				bow_cool = false
				$BowCooldown.start()
				var arrow = arrow_scene.instance() 
				arrow.set_name("arrow") 
				get_parent().add_child(arrow)
				arrow.position = position + (facing_direction*ARROW_OFFSET)
				arrow.direction = facing_direction
				
				print("BOW ATTACK!!")
		Items.SHIELD:
			if not is_shield_attacking:
				$ShieldAttackTimer.start()
		_:
			print("spillover in get_item_name")
			
			
func pickup(item_enum):
	items_queue.push_back(item_enum)

func get_item_name(item_enum):
	match item_enum:
		Items.SWORD:
			return 'sword'
		Items.BOW:
			return 'bow'
		Items.SHIELD:
			return 'shield'
		_:
			print("spillover in get_item_name")
			
func get_item_image(item):
	return items_to_images.get(item)

func _on_ItemSwapTimer_timeout():
	# Rotate the item
	items_queue.push_back(items_queue.pop_front())
	# Set the current item to the front of the queue
	current_item = items_queue[0]
	_render()

func _render():
	_render_facing_direction()
	
	var moving = false
	if abs(moving_direction.x) > 0 || abs(moving_direction.y) > 0:
		moving = true
	
	var animation_suffix = "_idle"
	if moving:
		animation_suffix = "_walk"
	
	var animation_prefix = "up"
	if facing_direction.y < 0:
		animation_prefix = "up"
	elif facing_direction.y > 0:
		animation_prefix = "down"
	elif facing_direction.x < 0:
		animation_prefix = "left"
	elif facing_direction.x > 0:
		animation_prefix = "right"
	else:
		animation_prefix = "up"
	
	$GnomeSprite.play(animation_prefix + animation_suffix)
	var player_pos = $GnomeSprite.get_position_in_parent()
	var equipment_pos = $Equipped.get_position_in_parent()
	
	if facing_direction.y < 0 or facing_direction.x < 0:
		move_child($Equipped, min(player_pos, equipment_pos))
		move_child($GnomeSprite, max(player_pos, equipment_pos))
	if facing_direction.y > 0 or facing_direction.x > 0:
		move_child($Equipped, max(player_pos, equipment_pos))
		move_child($GnomeSprite, min(player_pos, equipment_pos))
			
	_do_sword_stuff()
	_do_shield_stuff()
	_do_bow_stuff()

func _do_sword_stuff():
	if current_item == Items.SWORD:
		$Equipped/Sword.show()
		if $SwordAttackTimer.time_left > 0:
			$Equipped/Sword.set_sword_attacking(true)
		else:
			$Equipped/Sword.set_sword_attacking(false)
		$Equipped/Sword.facing_direction = facing_direction
		$Equipped/Sword.current_rotation = current_rotation
		$Equipped/Sword.time_left = $SwordAttackTimer.time_left
	else:
		$Equipped/Sword.hide()
		
func _do_shield_stuff():
	if current_item == Items.SHIELD:
		$Equipped/Shield.show()
		if $ShieldAttackTimer.time_left > 0:
			$Equipped/Shield.set_shield_attacking(true)
		else:
			$Equipped/Shield.set_shield_attacking(false)
		$Equipped/Shield.facing_direction = facing_direction
		$Equipped/Shield.current_rotation = current_rotation
		$Equipped/Shield.time_left = $ShieldAttackTimer.time_left
	else:
		$Equipped/Shield.hide()

func _do_bow_stuff():
	if current_item == Items.BOW:
		$Equipped/Bow.show()
		$Equipped/Bow.rotation = current_rotation
		if not bow_cool:
			$Equipped/Bow.position = $BowCooldown.time_left * 5 * facing_direction + facing_direction*16
	else:
		$Equipped/Bow.hide()

func _render_facing_direction():
	var next_rotation = _get_rotation()
	if current_rotation != next_rotation:
		current_rotation = next_rotation


func _get_rotation():
	if facing_direction.y < 0:
		return 0
	elif facing_direction.y > 0:
		return PI
	elif facing_direction.x < 0:
		return (3.0 * PI) / 2.0
	elif facing_direction.x > 0:
		return PI / 2.0
	else:
		return current_rotation
		
func on_death():
	is_dead = true
	velocity = Vector2()
	
	#$Tween.interpolate_property(self, "position", position, 
	#	Vector2(position.x, position.y + 1000), 1,
	#	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$DeathTimer.start()
	
func _on_DeathTimer_timeout():
	emit_signal("game_over")

func _on_SwordAttackTimer_timeout():
	is_sword_attacking = false
	
func _on_ShieldAttackTimer_timeout():
	is_shield_attacking = false

func _on_BowCooldown_timeout():
	bow_cool = true

func _on_InjuryRecoveryTimer_timeout():
	can_take_damage = true