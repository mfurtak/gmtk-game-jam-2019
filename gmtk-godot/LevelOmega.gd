extends Node2D
var blob = load("res://Blob.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	for enemy in $TileMap/EnemySpawnPoints.get_children():
		var newEnemy = blob.instance()
		newEnemy.set_position(enemy.position)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
