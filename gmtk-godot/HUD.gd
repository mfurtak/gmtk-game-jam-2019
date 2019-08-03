extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$CurrentItemProgress.min_value = 0
	$CurrentItemProgress.max_value = 1
	$CurrentItemProgress.value = .5
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var timer = get_parent().get_node("Player/ItemSwapTimer")
	var progress = (timer.wait_time - timer.time_left) / timer.wait_time
	print("progress: ", progress)
	$CurrentItemProgress.value = progress
	


func _on_ItemSwapTimer_timeout():
	print("HUD timed out")
