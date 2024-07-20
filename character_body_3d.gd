extends CharacterBody3D

const SPEED = 70
const JUMP_VELOCITY = 70
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 75

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		$Pivot/BaCharacter/AnimationPlayer.play("Jump")

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$Pivot/BaCharacter/AnimationPlayer.play("Jump")
	
	if Input.is_action_just_pressed("punch"):
		$Pivot/BaCharacter/AnimationPlayer.play("Punch")
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if is_on_floor():
			$Pivot/BaCharacter/AnimationPlayer.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if is_on_floor():
			$Pivot/BaCharacter/AnimationPlayer.queue("FightPosition")
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		var look_rotation = Vector3(0, atan2(direction.x, direction.z), 0)
		$Pivot.rotation = look_rotation
	
	move_and_slide()
