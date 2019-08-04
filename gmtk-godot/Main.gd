extends Node

var current_level = "res://LevelOmega.tscn"
var level

func _ready():
	print("Main ready")
	
	# TODO(mfurtak) this is still needed?
	for node in get_tree().get_nodes_in_group('ItemSwap'):
		$Player/ItemSwapTimer.connect("timeout", node, "_on_ItemSwapTimer_timeout")

	# Connect up to anything that can request a screen shake
	for node in get_tree().get_nodes_in_group('requests_shake'):
		node.connect("shake_requested", self, "_on_shake_requested")
	
	$Player.connect("game_over", self, "_on_game_over")
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
	$Player.connect("requests_shake", self, "_on_Player_requests_shake")

func _on_exited(next_level):
	print(next_level)
	initialize_level(next_level)

func _on_shake_requested(duration = 0.2, frequency = 15, amplitude = 16):
	$Camera2D/ScreenShake.start(duration, frequency, amplitude)

func _on_game_over():
	get_tree().change_scene("res://GameOver.tscn")
