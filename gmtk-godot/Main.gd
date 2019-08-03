extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Main ready")
	for node in get_tree().get_nodes_in_group('ItemSwap'):
		$Player/ItemSwapTimer.connect("timeout", node, "_on_ItemSwapTimer_timeout")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
