extends Node


func save_slider_values():
	var config = ConfigFile.new()
	config.set_value("Audio", "music_volume", GlobalVariables.music_volume)
	config.set_value("Audio", "soundfx_volume", GlobalVariables.soundfx_volume)
	var error = config.save("res://cfg/audio_settings.cfg")  # Save the settings file in the user directory
	if error != OK:
		print("Error saving audio settings:", error)
