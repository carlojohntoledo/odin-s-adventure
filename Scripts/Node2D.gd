extends Node2D

@export var ObjectScene : PackedScene  # Assign your object's scene in the inspector
var spawnInterval = 2.0  # Adjust the spawn interval as needed
var spawnPosition = Vector2(1100, 500)  # Set the initial spawn position

func _on_timer_ready():
	$Timer.wait_time = spawnInterval  # Set the timer's wait time

func _on_timer_timeout():
	spawn_object()

func spawn_object():
	var object_instance = ObjectScene.instantiate()
	object_instance.position = spawnPosition
	add_child(object_instance)
