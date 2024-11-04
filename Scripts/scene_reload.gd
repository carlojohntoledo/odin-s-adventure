extends CanvasLayer


func reload_scene():
	$AnimationPlayer.play("DISSOLVE")
	await $AnimationPlayer.animation_finished
	get_tree().reload_current_scene()
	$AnimationPlayer.play_backwards("DISSOLVE")
