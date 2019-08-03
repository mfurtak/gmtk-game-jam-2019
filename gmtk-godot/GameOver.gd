extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property($BlackMask, "color", Color(0, 0, 0, 1),
	Color(0, 0, 0, 0),4,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
	$GameRestartTimer.start()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GameRestartTimer_timeout():	
	get_tree().change_scene("res://menus/MainMenu.tscn")
