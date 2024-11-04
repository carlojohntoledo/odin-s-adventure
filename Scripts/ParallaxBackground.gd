extends ParallaxBackground

@export var playing =  false
@export var cloud_speed = 10
@export var landscape_speed = 30
@export var trees_speed = 150
@export var ground_speed = 400
@export var duck_speed = 200
@export var object_speed = 400

func _process(delta):
	if playing:
		$Clouds.motion_offset += Vector2.LEFT * cloud_speed * delta
		$Landscape.motion_offset += Vector2.LEFT * landscape_speed * delta
		$Trees.motion_offset += Vector2.LEFT * trees_speed * delta
		$Ground.motion_offset += Vector2.LEFT * ground_speed * delta
		$duckspeed.motion_offset += Vector2.LEFT * duck_speed * delta
		$objectspeed.motion_offset += Vector2.LEFT * object_speed * delta
