extends Node2D

var high_score = 0
var config_file_path = "res://cfg/highscore.cfg"
var config_file = ConfigFile.new()

func _ready():
	load_high_score()
	update_ui()

func load_high_score():
	if ResourceLoader.exists(config_file_path):
		config_file.load(config_file_path)
		high_score = config_file.get_value("HighScore", "score", 0)

func save_high_score():
	config_file.set_value("HighScore", "score", high_score)
	config_file.save(config_file_path)

func update_ui():
	# Update the UI element displaying the high score (you need to create this UI element).
	# For example, if you have a label named 'high_score_label':
	$high_score_label.text = "High Score: " + str(high_score)

func set_high_score(new_score):
	if new_score > high_score:
		high_score = new_score
		save_high_score()
		update_ui()

