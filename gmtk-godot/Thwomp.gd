extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player = get_node("/root/Main/Player")
# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	print(player.global_position)
	print(get_position())
    # detect player overlap in x or y?
	print("ASDF" + str(player))
	#print("facebook.com" + str(player.translation))
	pass