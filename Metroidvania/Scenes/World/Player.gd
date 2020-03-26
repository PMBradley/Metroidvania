extends KinematicBody2D



var playerActive = true

var viewport



const angVelMax = 12


var lin_vel = Vector2(0, 0)

var side_thrust_force = 50
var jump_thrust_force = 2400





const bullet_regular_speed = 5000

var hp_max = 100
var hp = hp_max

var can_fire_regular = true
var fire_regular = false


var w_globals

# Called when the node enters the scene tree for the first time.
func _ready():
	w_globals = get_node("/root/WorldGlobals")
	
	last_pos = position # change
	
	pull_globals() #ensures the proper starting values




var trans_pid_b = 11

var first_ground_touch = true

#var ground_touch_margin = 1
#var frames_since_ground_touch = ground_touch_margin + 1
var ground_touch_range = 1.0


func _physics_process(delta):# the main loop for player
	pull_globals()
	
	get_node("RayDetectors/GroundDetector_right").cast_to.x = 10
	get_node("RayDetectors/GroundDetector_left").cast_to.x = 10
	var result_l = get_node("RayDetectors/GroundDetector_left").is_colliding()
	var result_r = get_node("RayDetectors/GroundDetector_right").is_colliding()
	
	if(is_on_floor()):
		w_globals.player.touching_ground = true
	else:
		if(result_l and result_r):
			self.rotate(0)
			w_globals.player.touching_ground = true
			
		else:
			get_node("RayDetectors/GroundDetector_right").cast_to.x = 50
			get_node("RayDetectors/GroundDetector_left").cast_to.x = 50
			if(result_l):
				self.rotate(-PI/16)
			elif(result_r):
				self.rotate(PI/16)
			get_node("RayDetectors/GroundDetector_right").cast_to.x = 10
			get_node("RayDetectors/GroundDetector_left").cast_to.x = 10
		
		if(result_l and result_r):
			print("raycast collision")
			w_globals.player.touching_ground = true
		else:
			w_globals.player.touching_ground = false
	
	
	if(is_on_ceiling()):
		w_globals.player.touching_roof = true
	else:
		var result_l = get_node("RayDetectors/RoofDetectors/RoofDetector_left").is_colliding()
		var result_r = get_node("RayDetectors/RoofDetectors/RoofDetector_right").is_colliding()
		var result_m = get_node("RayDetectors/RoofDetectors/RoofDetector_mid").is_colliding()
		
		if(result_l or result_r or result_m):
			w_globals.player.touching_roof = true
		else:
			w_globals.player.touching_roof = false
	
	
	var right_result_t = get_node("RayDetectors/RightWallDetectors/RightWallDetector_top").is_colliding()
	var right_result_b = get_node("RayDetectors/RightWallDetectors/RightWallDetector_bottom").is_colliding()
	var right_result_m = get_node("RayDetectors/RightWallDetectors/RightWallDetector_mid").is_colliding()
	
	if(right_result_t or right_result_b or right_result_m):
		w_globals.player.touching_wall_right= true
	else:
		w_globals.player.touching_wall_right = false
	
	
	var left_result_t = get_node("RayDetectors/LeftWallDetectors/LeftWallDetector_top").is_colliding()
	var left_result_b = get_node("RayDetectors/LeftWallDetectors/LeftWallDetector_bottom").is_colliding()
	var left_result_m = get_node("RayDetectors/LeftWallDetectors/LeftWallDetector_mid").is_colliding()
	
	if(left_result_t or left_result_b or left_result_m):
		w_globals.player.touching_wall_left = true
	else:
		w_globals.player.touching_wall_left = false
	
	
	
	if (w_globals.player.reset_player):
		position = w_globals.levels.level[w_globals.levels.active_level + 1].reset_pos
		w_globals.cam.pos = w_globals.levels.level[w_globals.levels.active_level + 1].cam_reset_pos
		lin_vel = Vector2(0,0)
		
		w_globals.player.reset_player = false
	
	
	var target_vel = 0
	if(w_globals.player.moving == "left"): # horizontal movement
		target_vel = -w_globals.player.run_speed_max
	elif(w_globals.player.moving == "right"):
		target_vel = w_globals.player.run_speed_max
	
	var error = target_vel - lin_vel.x
	
	lin_vel.x += error * trans_pid_b * delta
	
	
	if(w_globals.player.touching_ground):
		if(first_ground_touch):
			lin_vel.y = 0
			first_ground_touch = false
		
		if(w_globals.player.jumping == "up"):
			lin_vel.y -= jump_thrust_force
		
	else:
		lin_vel.y += w_globals.player.gravity * delta #add to gravity when in the air
		first_ground_touch = true
	
	
	if(w_globals.player.touching_roof):
		if(first_roof_touch):
			lin_vel.y = 0
			first_roof_touch = false
	else:
		first_roof_touch = true
	
	
	if(w_globals.player.touching_wall_right):
		if(first_wall_right_touch):
			lin_vel.x = 0
			first_wall_right_touch = false
	else:
		first_wall_right_touch = true
	
	
	if(w_globals.player.touching_wall_left):
		if(first_wall_left_touch):
			lin_vel.x = 0
			first_wall_left_touch = false
	else:
		first_wall_left_touch = true
	
	
	move_and_slide(lin_vel, Vector2(0, -1))
	
	print(position - last_pos) # change
	last_pos = position
	
	
	push_globals()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("ui_home")):
		w_globals.player.reset_player = true
	
	if(Input.is_action_pressed("ui_left")):
		w_globals.player.moving = "left"
	elif(Input.is_action_pressed("ui_right")):
		w_globals.player.moving = "right"
	else:
		w_globals.player.moving = "not"
	
	if(Input.is_action_just_pressed("ui_jump")):
		w_globals.player.jumping = "up"
	else:
		w_globals.player.jumping = "not"
	
	

#var rotate_pid_a = .01
#var rotate_pid_b = 1

#func rotate_to_target(var target):
#	var x = target - rotation_degrees
#
#	angular_velocity = (rotate_pid_a * pow(x, 2)) + (rotate_pid_b * x)

#func at_ang_vel_max() -> bool:
#	var output = false
#	if (angular_velocity >= angVelMax):
#		output = true
#	elif (angular_velocity <= -angVelMax):
#		output = true
#
#	return output


func get_bullet_velocities(var bullet_type):
	var output = Vector2(0, 0)
	var cam_error_from_start = w_globals.cam.pos - w_globals.cam.start_pos  # accounts for the fact that the camera moves but the xy of the frame does not
	
	if(bullet_type == "player_regular"):
		var error = ((get_viewport().get_mouse_position() + cam_error_from_start) - position)
		
		
		output = normalize2D(error) * bullet_regular_speed
		
	
	
	return output


func normalize2D(var input):
	var hypotenuse = sqrt(pow(input.x, 2) + pow(input.y, 2)) # get the hypotenuse formed by a right triangle with these two values as sides
	
	var output = input / Vector2(hypotenuse, hypotenuse) # divide the original values by the hypotenuse
	
	return output


func pull_globals():
	
	
	hp = w_globals.player.hp
	hp_max = w_globals.player.hp_max


func push_globals():
	
	# Updating main player variables
	w_globals.player.hp = hp
	w_globals.player.pos = position
	w_globals.player.lin_vel = lin_vel
	w_globals.player.rot_deg = rotation_degrees
	
	# Updating weapon variables
	w_globals.player.bullet_regular.starting_position = position
	w_globals.player.bullet_regular.starting_velocities = get_bullet_velocities("player_regular")
	# starting rotation is set in the player follower to avoid rotation errors (as it is a rolling spaceship)
