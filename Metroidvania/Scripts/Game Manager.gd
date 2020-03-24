extends Node2D

var root

# Called when the node enters the scene tree for the first time.
func _ready():
	root = get_node(".") # sets root to this node (Game Manager)
	
	load_child("res://Scenes/World/World Manager.tscn")
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_pressed("ui_exit")):
		get_tree().quit() # close the game

func load_child(var path):
	var resource = load(path)
	var instance = resource.instance()
	root.add_child(instance)