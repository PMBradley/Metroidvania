extends KinematicBody2D



var playerActive = true

var viewport
const angVelMax = 12


var lin_vel = Vector2(0, 0)

var side_thrust_force = 50
var jump_thrust_force = 2400

var ground_ranges = [100, 100, 100]
var ground_detect_offsets = [Vector2(-200, 430), Vector2(0, 430), Vector2(200, 430)]
#var touching_ground_margin = 5
#var max_ground_detect_range = 150
var ground_decect_precision = 1

const bullet_regular_speed = 5000

var hp_max = 100
var hp = hp_max

var can_fire_regular = true
var fire_regular = false


var w_globals

# Called when the node enters the scene tree for the first time.
func _ready():
	w_globals = get_node("/root/WorldGlobals")
	
	
	pull_globals() #ensures the proper starting values




var trans_pid_b = 11

var first_ground_touch = true
var first_wall_right_touch = true
var first_wall_left_touch = true

#var ground_touch_margin = 1
#var frames_since_ground_touch = ground_touch_margin + 1


func _physics_process(delta):# the main loop for player
	pull_globals()
	
	update_ray_ranges()
	
	
	
#	if (not (result_l and result_r)):
#		get_node("RayDetectors/GroundDetectors/GroundDetector_right").cast_to.y = 50
#		get_node("RayDetectors/GroundDetectors/GroundDetector_left").cast_to.y = 50
#		result_l = get_node("RayDetectors/GroundDetectors/GroundDetector_left").is_colliding()
#		result_r = get_node("RayDetectors/GroundDetectors/GroundDetector_right").is_colliding()
#
#		if(result_l):
#			self.rotate(.08)
#		elif(result_r):
#			self.rotate(-.08)
#		get_node("RayDetectors/GroundDetectors/GroundDetector_right").cast_to.y = ground_touch_range
#		get_node("RayDetectors/GroundDetectors/GroundDetector_left").cast_to.y = ground_touch_range
#
#		result_l = get_node("RayDetectors/GroundDetectors/GroundDetector_left").is_colliding()
#		result_r = get_node("RayDetectors/GroundDetectors/GroundDetector_right").is_colliding()
#
#	if(is_on_ceiling()):
#		w_globals.player.touching_roof = true
#	else:
#		var result_l = get_node("RayDetectors/RoofDetectors/RoofDetector_left").is_colliding()
#		var result_r = get_node("RayDetectors/RoofDetectors/RoofDetector_right").is_colliding()
#		var result_m = get_node("RayDetectors/RoofDetectors/RoofDetector_mid").is_colliding()
#
#		if(result_l or result_r or result_m):
#			w_globals.player.touching_roof = true
#		else:
#			w_globals.player.touching_roof = false
	
	
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
		rotation_degrees = 0
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
	
	update_notifiers()
	
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


func update_ray_ranges():
	var relative_pos = position
	var space_state = get_world_2d().direct_space_state
	for i in range(3):
		var result = space_state.intersect_ray(relative_pos + ground_detect_offsets[i], relative_pos + Vector2(0, 100), [self], collision_mask)
		if(result):
			print(result.position)
		
	
#	for i in range(3): #get ground ranges
#		var ray_node
#		if(i == 0):
#			ray_node = get_node("RayDetectors/GroundDetectors/GroundDetector_left")
#		elif(i == 1):
#			ray_node = get_node("RayDetectors/GroundDetectors/GroundDetector_mid")
#		else:
#			ray_node = get_node("RayDetectors/GroundDetectors/GroundDetector_right")
#
#		var range_found = false
#		var current_range = 1
#		for j in range(max_ground_detect_range):
#			if(!range_found):
#				ray_node.cast_to.y = current_range
#
#				if(ray_node.is_colliding()):
#					ground_ranges[i] = current_range
#					range_found = true
#					print(i, ": ", ground_ranges[i])
#
#				current_range += ground_decect_precision
		
		

func update_notifiers():
	if(w_globals.player.touching_ground):
		get_node("Notifiers/True").visible = true
		get_node("Notifiers/False").visible = false
	else:
		get_node("Notifiers/True").visible = false
		get_node("Notifiers/False").visible = true


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
