extends Node2D

const TRANSITION = Tween.TRANS_SINE
const EASING = Tween.EASE_IN_OUT

var amplitude = 0

# always expect the camera to be the parent
onready var camera = get_parent()

func start(duration = 0.2, frequency = 15, amplitude = 16):
	self.amplitude = amplitude
	$ShakeDuration.wait_time = duration
	$ShakeFrequency.wait_time = 1 / float(frequency)
	$ShakeDuration.start()
	$ShakeFrequency.start()
	new_shake()

# Called when the node enters the scene tree for the first time.
func new_shake():
	var rand_vec = Vector2()
	rand_vec.x = rand_range(-amplitude, amplitude)
	rand_vec.y = rand_range(-amplitude, amplitude)
	
	$ShakeTween.interpolate_property(
		camera,
		"offset",
		camera.offset,
		rand_vec,
		$ShakeFrequency.wait_time,
		TRANSITION,
		EASING
	)
	$ShakeTween.start()

func reset():
	$ShakeTween.interpolate_property(
		camera,
		"offset",
		camera.offset,
		Vector2(), # zero vector resets the camera to neutral position
		$ShakeFrequency.wait_time,
		TRANSITION,
		EASING
	)
	$ShakeTween.start()

func _on_ShakeFrequency_timeout():
	new_shake()

func _on_ShareDuration_timeout():
	reset()
	$ShakeFrequency.stop()
