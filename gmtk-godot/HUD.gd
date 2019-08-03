extends CanvasLayer

onready var player = get_node("/root/Main/Player")

# Item Labels
onready var active_item = get_node("ItemCards/ActiveItem")
onready var second_item = get_node("ItemCards/SecondItem")
onready var third_item = get_node("ItemCards/ThirdItem")
onready var fourth_item = get_node("ItemCards/FourthItem")

onready var item_stack_node = get_node("ItemCards/ItemStack")

var hud_items = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Item Timer Progress Bar
	$CurrentItemProgress.min_value = 0
	$CurrentItemProgress.max_value = 1
	$CurrentItemProgress.value = 0
	
	# Health
	$HealthProgress.min_value = player.MIN_HEALTH
	$HealthProgress.max_value = player.MAX_HEALTH
	
	hud_items = [
		active_item,
		second_item,
		third_item,
		fourth_item
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Health
	$HealthProgress.value = player.current_health
	
	# Items
	var timer = get_parent().get_node("Player/ItemSwapTimer")
	var progress = (timer.wait_time - timer.time_left) / timer.wait_time
	$CurrentItemProgress.value = progress
	
	_set_cards()

func _set_cards():
	var items_queue = player.items_queue
	
	for i in range(4):
		var hud_item = hud_items[i]
		if items_queue.size() > i:
			var item = items_queue[i]
			hud_item.show()
			hud_item.set_image(player.get_item_image(item))
		else:
			hud_item.hide()

	if items_queue.size() >= 5:
		item_stack_node.show()
	else:
		item_stack_node.hide()
	

func _on_ItemSwapTimer_timeout():
	pass
	#print("HUD timed out")
