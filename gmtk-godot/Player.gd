extends KinematicBody2D

enum Items {SWORD, BOW, SHIELD}

var moving_direction = Vector2()
var facing_direction = Vector2(1,0)
var velocity = Vector2()
var is_action_pressed = false

const SPEED = 10
const TOP_SPEED = 200
const DECELERATION = .2
const ARROW_OFFSET = 48

const BASE_ITEMS_PERIOD = 3 # seconds
const PER_ITEM_PERIOD = 1

const MAX_HEALTH = 100
const MIN_HEALTH = 0
var current_health = 100

var is_pink = false
var is_attacking = false
var is_shield_attacking = false
var bow_cool = true

#var items_queue = [Items.BOW, Items.SHIELD, Items.SWORD]
var items_queue = [Items.SHIELD]
var current_item = items_queue[-1]
var sprites = null
var current_sprite = null
var current_rotation = 0

onready var arrow_scene = preload("res://Arrow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	sprites = [$sword, $shield, $bow]
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

func on_player_attacked():
	match current_item:
		Items.SWORD:
			current_health = max(MIN_HEALTH, current_health - 1)
		Items.BOW:
			current_health = max(MIN_HEALTH, current_health - 1)
		Items.SHIELD:
			pass
		_:
			print("spillover in get_item_name")
			
	
func _on_attack():
	match current_item:
		Items.SWORD:
			if not is_attacking:
				print("SWORD ATTACK!!")
				is_attacking = true
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

func _on_ItemSwapTimer_timeout():
	# Rotate the item
	items_queue.push_back(items_queue.pop_front())
	# Set the current item to the front of the queue
	current_item = items_queue[0]
	_render()

func _render():
	_render_color()
	_render_facing_direction()
	if is_attacking:
		$AttackSprite.show()
	else:
		$AttackSprite.hide()

	if current_item == Items.SHIELD:
		$Equipped/Shield.show()
		if $ShieldAttackTimer.time_left > 0:
			$Equipped/Shield.set_attacking(true)
		else:
			$Equipped/Shield.set_attacking(false)
			
		$Equipped/Shield.rotation = current_rotation
		$Equipped/Shield.position = $ShieldAttackTimer.time_left * 10 * facing_direction + facing_direction*16
	else:
		$Equipped/Shield.hide()
	
func _render_color():
	var next_sprite = _get_item_sprite()
	if next_sprite != current_sprite:
		current_sprite = next_sprite
		for sprite in sprites:
			sprite.hide()
		current_sprite.show()

func _get_item_sprite():
	match current_item:
		Items.SWORD:
			return $sword
		Items.BOW:
			return $bow
		Items.SHIELD:
			return $shield
		_:
			print("spillover in _set_color")
			return $sword

func _render_facing_direction():
	var next_rotation = _get_rotation()
	if current_rotation != next_rotation:
		current_rotation = next_rotation
	current_sprite.rotation = current_rotation


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

func _on_SwordAttackTimer_timeout():
	is_attacking = false
	
func _on_ShieldAttackTimer_timeout():
	is_shield_attacking = false

func _on_BowCooldown_timeout():
	bow_cool = true
