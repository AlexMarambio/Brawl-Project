extends CharacterBody3D

const SPEED = 100
const JUMP_VELOCITY = 80
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 75
@onready var animation:  AnimationTree = $AnimationTree
var direction
var jumps = 2
var punchs = ["parameters/conditions/punch","parameters/conditions/punch2"]
var airpunchs = ["parameters/conditions/airpunch","parameters/conditions/airpunch2"]

func _process(delta):
	direction = Vector3.ZERO
	animations()
	# Handle jump.
	if is_on_floor() or is_on_wall():
		jumps = 2
	
	if Input.is_action_just_pressed("move_up") and jumps>0:
		if not is_on_wall():
			velocity.y = JUMP_VELOCITY
			jumps-=1
		else:
			velocity.y=27
	if Input.is_action_pressed("move_left"):
		direction.z +=1
	if Input.is_action_pressed("move_right"):
		direction.z -=1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		var look_rotation = Vector3(0, atan2(direction.x, direction.z), 0)
		$Pivot.rotation += (look_rotation-$Pivot.rotation)*0.5
	velocity.z = direction.z * SPEED
	velocity.x=0
	move_and_slide()
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and not is_on_wall():
		velocity.y -= gravity * delta * 2
	elif not is_on_floor() and is_on_wall():
		velocity.y -= 32 * delta
	
	if velocity.y>30 and is_on_wall():
		if not Input.is_action_pressed("move_up"):
			velocity.y=10

func animations():
	if animation == null:
		return
	animation["parameters/conditions/idle"] = is_on_floor() and velocity == Vector3.ZERO
	animation["parameters/conditions/walk"] =  is_on_floor() and velocity.z != 0
	animation["parameters/conditions/jump"] = Input.is_action_just_pressed("move_up") and (is_on_floor() or (not is_on_floor() and jumps>0))
	animation["parameters/conditions/air"] = not is_on_floor() and not is_on_wall()
	animation[punchs.pick_random()] = Input.is_action_pressed("punch") and is_on_floor()
	animation[airpunchs.pick_random()] = Input.is_action_pressed("punch") and not is_on_floor()
	animation["parameters/conditions/onwall"] = is_on_wall()
	animation["parameters/conditions/climb"] = is_on_wall() and Input.is_action_just_pressed("move_up")
