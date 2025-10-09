extends AnimatedSprite2D

var looking = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if looking == Vector2.RIGHT:
		flip_h = false
		play("LookingFront")
	elif looking == Vector2.LEFT:
		flip_h = true
		play("LookingFront")
	elif looking == Vector2.UP:
		play("LookingUp")
	elif looking == Vector2.DOWN:
		play("LookingDown")
	elif looking == Vector2.ZERO:
		play("Default")
	
