extends Node

var current_level = "res://Level3.tscn"
var level

var blob_death_sfx = preload("res://audio/blob_death.wav")

var sfx_library = {
	"res://audio/blob_death.wav": blob_death_sfx
}

func get_sfx(res_path):
	return sfx_library[res_path]

func _ready():
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
	
	# Destroy all arrows that are stuck in places
	for node in get_tree().get_nodes_in_group('projectile'):
		node.queue_free()
		
	# Disconnect from anything that can request sfx
	for node in get_tree().get_nodes_in_group('requests_sfx'):
		node.disconnect("sfx_requested", self, "_on_sfx_requested")
	
	level = load(level_file).instance() 
	level.set_name("CurrentLevel")
	add_child(level)
	
		# Disconnect from anything that can request sfx
	for node in get_tree().get_nodes_in_group('requests_sfx'):
		node.connect("sfx_requested", self, "_on_sfx_requested")
	
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
	
func _on_sfx_requested(res_path, position):
	if $SfxPlayer.playing:
		$SfxPlayer.stop()
	$SfxPlayer.stream = get_sfx(res_path)
	$SfxPlayer.position = position
	$SfxPlayer.play()

func _on_shake_requested(duration = 0.2, frequency = 15, amplitude = 16):
	$Camera2D/ScreenShake.start(duration, frequency, amplitude)

func _on_won():
	get_tree().change_scene("res://YouWin.tscn")

func _on_game_over():
	get_tree().change_scene("res://GameOver.tscn")
