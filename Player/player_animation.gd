extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func play_looking_direc(direc) -> void:
	if direc == "look_right":
		flip_h = false
		play("LookingFront")
	elif direc == "look_left":
		flip_h = true
		play("LookingFront")
	elif direc == "look_up":
		play("LookingUp")
	elif direc == "look_down":
		play("LookingDown")
	elif direc == "none":
		play("Default")
