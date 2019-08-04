extends Area2D

signal exited
signal won

export(String, FILE, "*.tscn") var next_scene
export(bool) var you_win

# Called when the node enters the scene tree for the first time.
func _ready():
	connect('body_entered', self, '_on_entered')

func _on_entered(body):
	if body.name == "Player":
		if you_win:
			emit_signal("won")
		else:
			print("Exiting into ", next_scene)
			emit_signal("exited", next_scene)
