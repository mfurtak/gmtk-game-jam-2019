extends Node

var current_level = "res://Level1.tscn"
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
		var old_exit = level.get_node("Exit")
		if old_exit:
			old_exit.disconnect("exited", self, "_on_exited")
			old_exit.disconnect("won", self, "_on_won")
		level.queue_free()
	
	level = load(level_file).instance() 
	level.set_name("CurrentLevel")
	add_child(level)
	
	var exit = level.get_node("Exit")
	if exit:
		exit.connect("exited", self, "_on_exited")
		exit.connect("won", self, "_on_won")
		
	var spawn = level.get_node("PlayerSpawn")
	if spawn:
		$Player.set_position(spawn.position)
	else:
		$Player.set_position(Vector2(-64, -64))

func _on_exited(next_level):
	print(next_level)
	initialize_level(next_level)

func _on_shake_requested(duration = 0.2, frequency = 15, amplitude = 16):
	$Camera2D/ScreenShake.start(duration, frequency, amplitude)

func _on_won():
	get_tree().change_scene("res://YouWin.tscn")

func _on_game_over():
	get_tree().change_scene("res://GameOver.tscn")
