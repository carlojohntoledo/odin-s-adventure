# HighScoreManager.gd
extends Node

var high_score = 0

func _ready():
	if high_score == 0 or high_score == null:
		high_score = 0


func save_high_score():
	var config = ConfigFile.new()
	config.set_value("HighScore", "score", high_score)
	var error = config.save("user://highscore.cfg")  # Use the user directory for saving/loading
	if error != OK:
		print("Error saving high score:", error)


# Function to set the highscore
#func set_highscore(score):
	#high_score = score

# Function to get the highscore
#func get_highscore():
	#return high_score
