extends Node2D

var game_globals # holds the game wide global variables
var w_globals # holds the world related global variables
var s_globals # holds the global variables only needed for this level

var root

# Called when the node enters the scene tree for the first time.
func _ready():
	root = get_node(".")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func load_child(var path): # adds a scene as a child of the current node
	var resource = load(path)
	var instance = resource.instance()
	root.add_child(instance)
func load_child_at_root(var path, var root_path): #add a scene as a child of the input node
	var temp_root = get_node(root_path)
	var resource = load(path)
	var instance = resource.instance()
	temp_root.add_child(instance)
