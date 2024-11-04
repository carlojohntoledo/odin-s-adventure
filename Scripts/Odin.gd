extends CharacterBody2D

@export var playing = false
var JUMP_VELOCITY = -500.0
var grav = 800
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	
		# Skip processing when the restart button is visible.
	if $"../Buttons/Restart".visible:
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		$AnimatedSprite2D.play("jump")
	if is_on_floor() and playing == true:
		$AnimatedSprite2D.play("run")
	if is_on_floor() and playing == false:
		$AnimatedSprite2D.play("idle")
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$"../Soundtracks/JumpSound".play()
	if Input.is_action_just_pressed("down") and not is_on_floor():
		velocity.y += grav
		$"../Soundtracks/PantSound".play()
	move_and_slide()


func _process(_delta):
	var restart_button = $"../Buttons/Restart"
	var instruction_label = $"../Scores/Insruction"
	# Check if the character is playing, and update the animation accordingly.
	if playing:
		instruction_label.visible=false
	if restart_button.visible==true:
		$AnimatedSprite2D.play("hurt")
		playing = false
		JUMP_VELOCITY = 0



func _on_button_pressed():
	# Skip processing when the restart button is visible.
	if $"../Buttons/Restart".visible:
		return
	# Check if the character is playing, and update the animation accordingly.
	if !playing:
		$AnimatedSprite2D.play("idle")
		if Input.is_action_just_pressed("tap") and is_on_floor():
			$"..".start = true
			velocity.y = JUMP_VELOCITY
			$"../Soundtracks/JumpSound".play()
			$AnimatedSprite2D.play("jump")
			playing = true
			$"../Soundtracks/Backgroundmusic".play()
			$"../Soundtracks/BarkSound".play()
			$"../ParallaxBackground".playing = true
			$"../Timer".start()
			$"../Buttons/SettingsButton".disabled = true
	if playing:
		if Input.is_action_just_pressed("tap") and is_on_floor():
			$AnimatedSprite2D.play("jump")
			$"../Soundtracks/JumpSound".play()
			velocity.y = JUMP_VELOCITY
		if Input.is_action_just_pressed("doubletap") and not is_on_floor():
			velocity.y += grav
			$"../Soundtracks/PantSound".play()
