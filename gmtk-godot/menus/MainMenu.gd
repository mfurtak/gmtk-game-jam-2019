extends MarginContainer

onready var new_game_button = $LeftRightSplit/LeftSide/MenuButtons/NewGame

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game_button.grab_focus()

func _on_NewGame_pressed():
	get_tree().change_scene("res://Main.tscn")
