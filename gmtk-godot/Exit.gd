extends Area2D

signal exited

export(String, FILE, "*.tscn") var next_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	connect('body_entered', self, '_on_entered')


func _on_entered(body):
	if body.name == "Player":
		print("Exiting into ", next_scene)
		emit_signal("exited", next_scene)
