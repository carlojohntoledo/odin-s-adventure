extends Area2D

var start = false
@onready var speed = get_parent().get_node("ParallaxBackground").duck_speed

func _process(delta):
	if start:
		position += Vector2.LEFT * speed * delta
		$AnimatedSprite2D.play("fly")
	if !start:
		$AnimatedSprite2D.stop()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
