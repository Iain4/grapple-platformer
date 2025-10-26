extends CharacterBody2D


const SPEED = 400.0
const LOOK_DIRECTIONS = {
	"look_right": Vector2.RIGHT, 
	"look_left": Vector2.LEFT, 
	"look_up": Vector2.UP, 
	"look_down": Vector2.DOWN,
	}

var looking = Vector2.ZERO

var _jumped = false
var _jump_state = 0

func _ready() -> void:
	$LookArea/LookDirecCollision.p_width = $GeometryBodyCollision.shape.size[0]
	$LookArea/LookDirecCollision.p_height = $GeometryBodyCollision.shape.size[1]


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_from_inputer()
	move_and_slide()


func _process(delta: float) -> void:
	looking = Vector2.ZERO
	for direc in LOOK_DIRECTIONS.keys():
		if Input.is_action_pressed(direc):
			looking = LOOK_DIRECTIONS[direc]
	# done like this so just_preesed has higher priority
	for direc in LOOK_DIRECTIONS.keys():
		if Input.is_action_just_pressed(direc):
			looking = LOOK_DIRECTIONS[direc]

	$AnimatedSprite2D.looking = looking
	$LookArea/LookDirecCollision.looking = looking


func move_from_inputer():
	jumper(_jump_state)
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	# adjusting speed if looking in same / oposite direction
	if ( # same
			(direction < 0 and looking == Vector2.LEFT) or
			(direction > 0 and looking == Vector2.RIGHT)
	):
		direction *= 1.2
	elif ( # opposite
			(direction > 0 and looking == Vector2.LEFT) or
			(direction < 0 and looking == Vector2.RIGHT)
	):
		direction *= 0.8
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func jumper(state) -> void:
	# _jump_state measures physics ticks since the jump left the ground
	# allowing for the arc and feel of the jump to be tweaked
	# initail jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity = 2000 * (Vector2.UP + velocity.normalized())
		_jumped = true
	# inflight jump
	elif not is_on_floor() and _jumped:
		_jump_state += 1
		if state == 2: # arc at the top
			velocity *= 0.15
		elif state >= 18: # quick snap back down
			velocity += 0.2 * get_gravity()
		elif state >= 25:
			_jumped = false
	#back on ground
	else:
		_jump_state = 0
		_jumped = false
