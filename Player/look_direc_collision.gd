extends CollisionShape2D

const DEPTH = 4
const MARGIN = 4

var looking = Vector2.ZERO

var p_width
var p_height

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = Vector2(p_width/2, p_height/2) * looking
	
	if looking == Vector2.LEFT or looking == Vector2.RIGHT:
		shape.size = Vector2(DEPTH, p_height + MARGIN)
	elif looking == Vector2.UP or looking == Vector2.DOWN:
		shape.size = Vector2(p_width + MARGIN, DEPTH)
	else:
		shape.size = Vector2.ZERO
	
	$MeshInstance2D.mesh.size.x = shape.size.x
	$MeshInstance2D.mesh.size.y = shape.size.y 
