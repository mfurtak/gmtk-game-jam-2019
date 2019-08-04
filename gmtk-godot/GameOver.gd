extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property($BlackMask, "color", Color(0, 0, 0, 1),
	Color(0, 0, 0, 0),4,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()

func _on_GameOverAudio_finished():
	get_tree().change_scene("res://menus/MainMenu.tscn")
