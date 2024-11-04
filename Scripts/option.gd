extends CanvasLayer


@onready var music_instance = $Option_container/Sliders/Musicvol
@onready var sfx_instance = $Option_container/Sliders/Soundfxvol

func _ready():
	var config = ConfigFile.new()
	var error = config.load("user://audio_settings.cfg")  # Load the settings file from the user directory
	if error == OK:
		GlobalVariables.music_volume = config.get_value("Audio", "music_volume", music_instance.value)
		GlobalVariables.soundfx_volume = config.get_value("Audio", "soundfx_volume", sfx_instance.value)
	SliderValues.save_slider_values()

func _on_musicvol_value_changed(value):
	var bus_idx = AudioServer.get_bus_index("Music")

	AudioServer.set_bus_mute(bus_idx, value == music_instance.min_value)
	AudioServer.set_bus_volume_db(bus_idx, GlobalVariables.music_volume)

func _on_soundfxvol_value_changed(value):
	var bus_idx2 = AudioServer.get_bus_index("SoundFx")

	AudioServer.set_bus_mute(bus_idx2, value == sfx_instance.min_value)
	AudioServer.set_bus_volume_db(bus_idx2, GlobalVariables.soundfx_volume)



func _on_button_5_pressed():
	$".".visible = false
	$Sound/AudioStreamPlayer2D.play()
	await $Sound/AudioStreamPlayer2D.finished



func _on_button_4_pressed():
	$Sound/AudioStreamPlayer2D.play()
	await $Sound/AudioStreamPlayer2D.finished
	var file_path = "user://highscore.cfg"  # Replace with the path to the file you want to delete
# Create a File object
	var file = ConfigFile.new()
	if file.load(file_path) == OK: # Open the file for writing (you can also open it for reading if needed)
		file.set_value("HighScore", "score", 0)
		if file.save(file_path) == OK: # Delete the file
			print("File deleted successfully!")
			file.load(file_path)
			file.get_value("HighScore", "score", 0)
		else:
			print("Failed to delete the file.")
	else:
		print("Failed to open the file for writing.")
