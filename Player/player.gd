extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -200.0
const JUMP_KICK = 100.0
const LOOK_DIRECTIONS = ["look_right", "look_left", "look_up", "look_down"]

var LOOKING = "none"

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		var player_margin = $CollisionShape2D.shape.get_size() / 2
		player_margin.y = -player_margin.y # so it works in world coords
		var jump_vec = JUMP_KICK * (Vector2.UP + velocity.normalized())
		
		$JumpRay.target_position = jump_vec + player_margin
		
		if not $JumpRay.is_colliding():
			position += jump_vec
		else:
			position = $JumpRay.get_collision_point() - player_margin
		
		# velocity for coming back down
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

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
