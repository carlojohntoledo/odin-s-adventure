extends Node2D

var start = false
var Obstacles_scene = preload("res://Scene/obstacles.tscn")
var Duck_scene = preload("res://Scene/duck.tscn")
var ButtonSound = preload("res://Assets/Soundtracks/jump.mp3")
var copy_r = preload("res://Scene/copy_right.tscn")
var option = preload("res://Scene/option.tscn")
@export var score = 0
@export var high_score = 0
var spawn_timer = Timer.new()
var global_speed = 1.0
var max_global_speed = 1.5
var speed_increment = 0.1
var score_milestone = 1000
var is_options_open = false
var is_options_visible = false
@onready var current_score = $Scores/score_label
@onready var background_soundtrack = $Soundtracks/Backgroundmusic
@onready var buttonsound = $Soundtracks/ButtonSound
@export var bus_name: String
@onready var start_button = $Start
var opt = option.instantiate()

func _ready():
	
	add_child(opt)
	load_high_score()
	update_high_score_label()

func _process(_delta):
	load_high_score()
	update_high_score_label()
	if !start:
		if Input.is_action_just_pressed("jump"):
			$Soundtracks/Backgroundmusic.play()
			$Soundtracks/BarkSound.play()
			start = true
			$ParallaxBackground.playing = true
			$Odin.playing = true
			$Timer.start()
			$Buttons/SettingsButton.disabled = true
	if $Odin.playing == true:
		score += 1
		current_score.text = str(score)
		if high_score > 0 and start == true:
			HighScoreManager.high_score = high_score
	if score > score_milestone:
		print("Score is a multiple of 1000")
		increase_global_speed()


func _on_timer_timeout():
	# Generate a random delay between spawns, e.g., between 1 and 3 seconds.
	$Timer.wait_time = randf_range(0.6, 3.0)
	$Timer2.wait_time = randf_range(2.0,5.0)
	spawn_tree()
	spawn_duck()

func spawn_tree():
	var tree = Obstacles_scene.instantiate()
	tree.connect("body_entered",Callable(self, "_on_game_over"))
	var _tree_position = Vector2(1100,530)
	tree.start = true
	add_child(tree)


func spawn_duck():
	var duck = Duck_scene.instantiate()
	var _duck_position = Vector2(randf_range(1300,1400), randf_range(100, 300))
	duck.start = true
	duck.position= _duck_position
	add_child(duck)


func _on_game_over(_body):
	$Soundtracks/HitSound.play()
	$Soundtracks/SadSound2.play()
	$Soundtracks/PantSound.stop()
	$Soundtracks/Backgroundmusic.stop()
	$Buttons/SettingsButton.disabled = false
	if score > high_score:
		high_score = score
		HighScoreManager.high_score = high_score 
		HighScoreManager.save_high_score()  # Call a function to save the high score to a file
		save_slider_values()
		load_high_score()
		update_high_score_label()
	$Buttons/Restart.show()
	$Timer.stop()
	$ParallaxBackground.playing = false
	var trees = get_tree().get_nodes_in_group('tree')
	for tree in trees:
		tree.start = false


func _on_restart_pressed():
	buttonsound.play()
	await buttonsound.finished
	HighScoreManager.save_high_score()
	load_high_score()
	update_high_score_label()
	save_slider_values()  # Save the slider values to a file
	SceneReload.reload_scene()


func load_high_score():
	var config = ConfigFile.new()
	var error = config.load("user://highscore.cfg")
	if error == OK:
		high_score = config.get_value("HighScore", "score", HighScoreManager.high_score)
	else:
		print("Error loading high score:", error)
	update_high_score_label()


func update_high_score_label():
	if score > high_score:
		HighScoreManager.high_score = score
	else:
		HighScoreManager.high_score = high_score
	if $HighScore/high_score_label != null:
		$HighScore/high_score_label.text = "High Score: " + str(HighScoreManager.high_score)
	else:
		$HighScore/high_score_label.text = "High Score: " + str("0")


func increase_global_speed():
	if global_speed < max_global_speed:
		global_speed += speed_increment  # Increase the global speed by 0.1 (you can adjust this value)
		# Update the speed of animations or any other elements affected by global speed
		$ParallaxBackground.cloud_speed *= global_speed
		$ParallaxBackground.landscape_speed *= global_speed
		$ParallaxBackground.trees_speed *= global_speed
		$ParallaxBackground.ground_speed *= global_speed
		$ParallaxBackground.duck_speed *= global_speed
		$ParallaxBackground.object_speed *= global_speed
		$Soundtracks/BarkSound.play()


	score_milestone += 1000
	# Adjust the rate of score increment as well if needed
	# For example, if you want to double the score increment rate, you can do:
	# score_increment_rate *= global_speed
	print("Global Speed Increased to:", global_speed)


func _on_menu_button_pressed():
	buttonsound.play()
	await buttonsound.finished
	SceneTransition.change_scene("res://Scene/menu.tscn")


func _on_settings_button_pressed():
	buttonsound.play()
	await buttonsound.finished
	save_slider_values()
	var options_scene = get_node("Option_Node")
	if options_scene.visible == false:
		options_scene.visible = true
	else:
		options_scene.visible = false

func _on_musicvol_value_changed(value):
	GlobalVariables.music_volume = value
	emit_signal("volume_changed", GlobalVariables.music_volume, GlobalVariables.soundfx_volume)

func _on_soundfxvol_value_changed(value):
	GlobalVariables.soundfx_volume = value
	emit_signal("volume_changed", GlobalVariables.music_volume, GlobalVariables.soundfx_volume)

func save_slider_values():
	var config = ConfigFile.new()
	config.set_value("Audio", "music_volume", GlobalVariables.music_volume)
	config.set_value("Audio", "soundfx_volume", GlobalVariables.soundfx_volume)
	var error = config.save("res://cfg/audio_settings.cfg")  # Save the settings file in the user directory
	if error != OK:
		print("Error saving audio settings:", error)
