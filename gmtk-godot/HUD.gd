extends CanvasLayer

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	
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
	print("HEALTH: ", player.current_health)
	
	# Items
	var timer = get_parent().get_node("Player/ItemSwapTimer")
	var progress = (timer.wait_time - timer.time_left) / timer.wait_time
	$CurrentItemProgress.value = progress
	


func _on_ItemSwapTimer_timeout():
	print("HUD timed out")
