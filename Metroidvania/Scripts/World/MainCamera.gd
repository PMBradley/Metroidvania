extends Camera2D



var game_globals
var w_globals



# Called when the node enters the scene tree for the first time.
func _ready():
	game_globals = get_node("/root/Globals")
	w_globals = get_node("/root/WorldGlobals")
	
	pull_globals()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pull_globals()
	
	if(w_globals.cam.reset_cam):
		position = w_globals.levels.level[w_globals.levels.active_level + 1].cam_reset_pos
		
		w_globals.cam.reset_cam = false
	
	cam_follow()
	
	update_phys_from_vel()
	
	
	push_globals()



func update_phys_from_vel(): # updates positions and rotation from the coustom velocity vars
	
	position.x = position.x as float + w_globals.cam.lin_vel.x as float
	position.y = position.y as float + w_globals.cam.lin_vel.y as float
	rotation_degrees = rotation_degrees as float + w_globals.cam.ang_vel as float


func cam_follow():
	if(w_globals.cam.cam_follow_X):
		w_globals.cam.lin_vel.x = (w_globals.player.pos.x as float - position.x as float) / w_globals.cam.X_follow_power # sets the x linear velocity to the difference in x between the player and the camera divided by the movement power
		#print_debug((globals.player.pos.x as float - position.x as float) / xFollowPower)
		
	else:
		w_globals.cam.lin_vel.x = 0
		
	if(w_globals.cam.cam_follow_Y):
		w_globals.cam.lin_vel.y = (w_globals.player.pos.y as float - position.y as float) / w_globals.cam.Y_follow_power # sets the y linear velocity to the difference in y between the player and the camera divided by the movement power
	else:
		w_globals.cam.lin_vel.y = 0

func pull_globals(): # get all variables from the global 'cloud' and update local variables with the values
	
	rotation_degrees = w_globals.player.rot_deg
	scale = w_globals.cam.scale


func push_globals(): # push all local variable values to the global 'cloud'
	
	w_globals.cam.pos = position
	w_globals.cam.rot_deg = rotation_degrees
	w_globals.cam.scale = scale
