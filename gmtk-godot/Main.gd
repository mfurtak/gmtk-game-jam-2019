extends Node

var current_level = "res://Level1.tscn"
var level

func _ready():
	print("Main ready")
	for node in get_tree().get_nodes_in_group('ItemSwap'):
		$Player/ItemSwapTimer.connect("timeout", node, "_on_ItemSwapTimer_timeout")
	
	initialize_level(current_level)

func initialize_level(level_file):
	if level != null:
		level.get_node("Exit").disconnect("exited", self, "_on_exited")
		level.queue_free()
		
	level = load(level_file).instance() 
	level.set_name("CurrentLevel")
	add_child(level)
	level.get_node("Exit").connect("exited", self, "_on_exited")
	$Player.set_position(level.get_node("PlayerSpawn").position)

func _on_exited(next_level):
	print(next_level)
	initialize_level(next_level)