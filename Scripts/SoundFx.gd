extends Node2D


func  button_click():
	if $Node2D/Buttonsoundx:
		$Node2D/Buttonsoundx.play()
	else:
		print("Node 'Buttonsound' not found.")
