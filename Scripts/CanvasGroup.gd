extends CanvasGroup


# Parameters for the zooming effect.
var min_scale = 0.9 # Minimum scale
var max_scale = 1  # Maximum scale
var zoom_speed = 0.015  # Speed of the zooming effect
var scaling_up = true  # Flag to track whether we are currently scaling up
@onready var buttonsound = $"../ButtonSound"
var copy_r = preload("res://Scene/copy_right.tscn")


func _on_play_button_pressed():
	buttonsound.play()
	await buttonsound.finished
	SceneTransition.change_scene("res://Scene/main.tscn")


func _on_quit_button_pressed():
	buttonsound.play()
	await buttonsound.finished
	get_tree().Quit()


func _ready():
	$Sprite2D.scale = Vector2(min_scale, min_scale)  # Set the initial scale
	$"../MenuSound".play()
	display_copyright()

func display_copyright():
	var copy = copy_r.instantiate()
	add_child(copy)
	



func _process(delta):
	# Check if we are scaling up or down and update the scale accordingly.
	if scaling_up:
		$Sprite2D.scale += Vector2(zoom_speed * delta, zoom_speed * delta)
	else:
		$Sprite2D.scale -= Vector2(zoom_speed * delta, zoom_speed * delta)

	# Check if we have reached the maximum or minimum scale, then reverse direction.
	if $Sprite2D.scale.x >= max_scale:
		scaling_up = false
	elif $Sprite2D.scale.x <= min_scale:
		scaling_up = true

