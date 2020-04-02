extends Node


var player
var cam
var levels


func _ready():
	player = Player.new()
	cam = Cam.new()
	levels = Levels.new()
	
	player.moving = "not"
	player.jumping = "not"



#func _process(delta):
	
	
	#pass




class Player:
	# General Variables
	var base_hp = 100
	var hp_max = base_hp
	var hp = hp_max
	
	#Physics Variables
	var pos = Vector2(1024,600)
	var rot_deg = 0
	var target_deg = 0
	var cont_rot_pos = 0
	var ang_vel = 0
	var lin_vel = Vector2(0,0)
	var reset_player = false
	
	var gravity = 5000
	var run_speed_max = 3000
	var moving = {"not":0,"left":1, "right":2}
	var jumping = {"not":0, "up":1, "down":2}
	
	var touching_ground = false
	var touching_wall_right = false
	var touching_wall_left = false
	var touching_roof = false
	
	# Weapon Variables
	var fire_main = false;
	var frames_since_main_fire = 0
	
	var turret_target = 0
	
	var bullet_regular = Bullet_regular.new()
	

class Bullet_regular:
	var starting_position
	var starting_velocities
	var starting_rotation


class Cam:
	var X_follow_power = 5 # inversely related - higher number = slower movement, where 1 is instant tracking
	var Y_follow_power = 3
	var start_pos = Vector2(512,300)
	var pos = Vector2(512,300)
	var lin_vel = Vector2(0,0)
	var ang_vel = 0
	var rot_deg = 0
	var scale = Vector2(1,1)
	var cam_follow_X = true
	var cam_follow_Y = true
	var reset_cam = false

class Levels: #the level mananger
	var active_level = -1 #creates a variable for the active levels (-1 = test, 0 = hub, 1 = Lvl-1-1)
	var queue_level = -2 #creates a variable for the queued levels plus a "no queue" index (-2)
	var level = [Level.new("TestStone Manager", "res://Scenes/World/zTest Stone/TestStone Manager.tscn", Vector2(3840, 2160), Vector2(3840, 2160))] 
	#adds all the levels and their info to an array (the enum can be used as an index)
	

class Level:
	var level_name
	var path
	var reset_pos = Vector2(3840, 2160)
	var cam_reset_pos = Vector2(3840, 2160)
	
	func _init(n, p, r, c):
		level_name = n
		path = p
		reset_pos = r
		cam_reset_pos = c
	
