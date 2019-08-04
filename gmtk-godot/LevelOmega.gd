extends Node2D
var blob = "res://Thwomp.tscn"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var newEnemy
	for enemy in $TileMap/EnemySpawnPoints.get_children():
		newEnemy = load(blob).instance()
		add_child(newEnemy) 
		newEnemy.set_position(enemy.position)
		print(newEnemy)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
