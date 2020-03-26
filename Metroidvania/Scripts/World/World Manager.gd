extends Node2D


# Called when the node enters the scene tree for the first time.
var debug_per_sec = 1
var root
var game_globals
var w_globals


var run_time = 0.00 # seconds since program run
var last_debug_run_start = run_time
var fr_var_count = 3
var first_run = [1, 1, 1]



# Called when the node enters the scene tree for the first time.
func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#create_cursor()
	
	root = get_node(".") #sets root to this node (World Manager)
	game_globals = get_node("/root/Globals")
	w_globals = get_node("/root/WorldGlobals") #init globals locally
	add_level(-1) #sets the starting level to the MainMenu
	
	
	
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	run_time += delta # updates program timer
	
	
	if(run_time >= last_debug_run_start + (1.0/debug_per_sec) ): # Only runs so many times per second (determined by 'debugPerSec'), used for updating debug output
		first_run[0] = 0;
		last_debug_run_start = run_time;
		#print_debug(run_time)
		
	if(w_globals.levels.queue_level >= -1): # if there is a level change in the queue
		if(w_globals.levels.queue_level == -1):
			change_level(w_globals.levels.queue_level)
			w_globals.cam.cam_follow_X = true
			w_globals.cam.cam_follow_Y = true
		elif(w_globals.levels.queue_level == 0):
			change_level(w_globals.levels.queue_level)
			w_globals.cam.camFollowX = false
			w_globals.cam.pos = w_globals.levels.resetPos[0]
		
		w_globals.levels.queue_level = -2 #empty the queue
	
	fire_weapons()
	



func create_cursor():
	#var cursor_resource = load("res://Scripts/Player Scripts/Cursor.tscn")
	pass


func add_level(var new_scene_index):
	load_child(w_globals.levels.level[new_scene_index + 1].path)
	w_globals.levels.active_level = new_scene_index
	
	w_globals.player.reset_player = true



func change_level(var new_scene_index):
	# Remove the current level
	var level = root.get_node(w_globals.levels.level[w_globals.levels.activeLevel + 1].level_name) #get the current level
	level.call_deferred("free") #bye bye after done with running all code
	
	# Add the next level
	load_child(w_globals.levels.level[new_scene_index + 1].path)
	
	w_globals.levels.active_level = new_scene_index #update the activeLevel
	
	w_globals.player.reset_player = true

func fire_weapons():
	if(w_globals.player.fire_main == true):
		
		w_globals.player.frames_since_main_fire = 0
		w_globals.player.fire_main = false
	else:
		w_globals.player.frames_since_main_fire += 1
	

func load_child(var path): # adds a scene as a child of the current node
	var resource = load(path)
	var instance = resource.instance()
	root.add_child(instance)
func load_child_at_root(var path, var root_path): #add a scene as a child of the input node
	var temp_root = get_node(root_path)
	var resource = load(path)
	var instance = resource.instance()
	temp_root.add_child(instance)
