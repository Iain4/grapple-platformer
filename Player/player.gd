extends CharacterBody2D


const SPEED = 400.0
const LOOK_DIRECTIONS = ["look_right", "look_left", "look_up", "look_down"]

var LOOKING = "none"
var JUMP_STAGE = 0
var JUMPED = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_from_inputer()
	move_and_slide()


func _process(delta: float) -> void:
	LOOKING = "none"
	for direc in LOOK_DIRECTIONS:
		if Input.is_action_pressed(direc):
			LOOKING = direc
	# done like this so just_preesed has higher priority
	for direc in LOOK_DIRECTIONS:
		if Input.is_action_just_pressed(direc):
			LOOKING = direc
	$AnimatedSprite2D.play_looking_direc(LOOKING)


func move_from_inputer():
	jumper(JUMP_STAGE)
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	# adjusting speed if looking in same / oposite direction
	if ( # same
		(direction < 0 and LOOKING == "look_left") or
		(direction > 0 and LOOKING == "look_right")
	):
		direction *= 1.2
	elif ( # opposite
		(direction > 0 and LOOKING == "look_left") or
		(direction < 0 and LOOKING == "look_right")
	):
		direction *= 0.8
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func jumper(jump_stage) -> void:
	# JUMP_STAGE measures physics ticks since the jump left the ground
	# allowing for the arc and feel of the jump to be tweaked
	# initail jumping
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity = 2000 * (Vector2.UP + velocity.normalized())
		JUMPED = true
	# inflight jump
	elif not is_on_floor() and JUMPED:
		JUMP_STAGE += 1
		if jump_stage == 2: # arc at the top
			velocity *= 0.2
		elif jump_stage >= 5: # quick snap back down
			velocity += 0.04 * get_gravity()
		elif jump_stage >= 8:
			JUMPED = false
	#back on ground
	else:
		JUMP_STAGE = 0
		JUMPED = false
