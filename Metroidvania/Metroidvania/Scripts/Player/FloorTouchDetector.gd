extends KinematicBody2D

var w_globals

# Called when the node enters the scene tree for the first time.
func _ready():
	w_globals = get_node("/root/WorldGlobals")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position = w_globals.player.pos
	
	var collision = move_and_collide(Vector2(0, 1))
	if collision:
		w_globals.player.touching_ground = true
	else:
		w_globals.player.touching_ground = false
	print(w_globals.player.touching_ground)
	
	position = w_globals.player.pos