extends CanvasLayer

var player = null
var active_item_label_node = null
var second_item_label_node = null
var third_item_label_node = null
var fourth_item_label_node = null
var item_stack_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	
	# Item Labels
	active_item_label_node = get_node("ItemCards/ActiveItem/Label")
	second_item_label_node = get_node("ItemCards/FirstItem/Label")
	third_item_label_node = get_node("ItemCards/SecondItem/Label")
	fourth_item_label_node = get_node("ItemCards/ThirdItem/Label")
	item_stack_node = get_node("ItemCards/ItemStack")
	
	# Item Timer Progress Bar
	$CurrentItemProgress.min_value = 0
	$CurrentItemProgress.max_value = 1
	$CurrentItemProgress.value = 0
	
	# Health
	$HealthProgress.min_value = player.MIN_HEALTH
	$HealthProgress.max_value = player.MAX_HEALTH

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
	
	for item_index in range(4):
		match item_index:
			0:
				if items_queue.size() > item_index:
					active_item_label_node.set('text', str(items_queue[item_index]))
			1:
				if items_queue.size() > item_index:
					second_item_label_node.set('text', str(items_queue[item_index]))
			2:
				if items_queue.size() > item_index:
					third_item_label_node.set('text', str(items_queue[item_index])) 
			3:
				if items_queue.size() > item_index:
					fourth_item_label_node.set('text', str(items_queue[item_index]))
			_:
				pass

	if items_queue.size() >= 5:
		item_stack_node.show()
	else:
		item_stack_node.hide()
	

func _on_ItemSwapTimer_timeout():
	pass
	#print("HUD timed out")
