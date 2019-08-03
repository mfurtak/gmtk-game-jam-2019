extends KinematicBody2D

enum Items {SWORD, BOW, SHIELD}

var direction = Vector2()
var velocity = Vector2()
var is_action_pressed = false

const SPEED = 30
const TOP_SPEED = 50
const DECELERATION = .7
const BASE_ITEMS_PERIOD = 3 # seconds
const PER_ITEM_PERIOD = 1

var is_pink = false
var is_attacking = false

var items_queue = [Items.SWORD, Items.SHIELD]
var current_item = Items.SWORD

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var normal_direction = direction.normalized()
	
	velocity.x += max(min(normal_direction.x * SPEED, TOP_SPEED), -TOP_SPEED)
	velocity.y +=  max(min(normal_direction.y * SPEED, TOP_SPEED), -TOP_SPEED)

	if normal_direction.x == 0:
		velocity.x = lerp(velocity.x, 0, DECELERATION)
	if normal_direction.y == 0:
		velocity.y = lerp(velocity.y, 0, DECELERATION)
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		# Do stuff
		if is_attacking:
			if collision.collider.has_method("on_attacked"):
				collision.collider.on_attacked()
	
	if is_pink:
		is_attacking = false
		
	if is_action_pressed and not is_pink:
		is_attacking = true
		
#	if is_attacking:
#		$AttackSprite.visible = true
#	elif not is_attacking:
#		$AttackSprite.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction.x = 0
	direction.y = 0
	is_action_pressed = false
	
	if Input.is_action_pressed("ui_up"):
		direction.y += -1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x += -1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_just_pressed("ui_select"):
		is_action_pressed = true
	
	var total_item_period = float(BASE_ITEMS_PERIOD + (PER_ITEM_PERIOD * items_queue.size()))
	var item_duration = total_item_period / float(items_queue.size())
	
	$ItemSwapTimer.wait_time = item_duration

func _on_ItemSwapTimer_timeout():
	current_item = items_queue.pop_front()
	items_queue.push_back(current_item)
	
	match current_item:
		Items.SWORD:
			$AnimatedSprite.play("pink")
		Items.BOW:
			$AnimatedSprite.play("green")
		Items.SHIELD:
			$AnimatedSprite.play("default")
		_:
			pass
