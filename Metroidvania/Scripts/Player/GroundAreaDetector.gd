extends Area2D

var w_globals

# Called when the node enters the scene tree for the first time.
func _ready():
	w_globals = get_node("/root/WorldGlobals")
	
	touching = w_globals.player.touching_ground

var touching
var detected

var first_enter = false
var first_exit = false

func _process(delta):
	if(detected):
		touching = true
	else:
		touching = false
	
	
	w_globals.player.touching_ground = touching


func _on_GroundArea_body_entered(body):
	detected = true
	print("ground detected")

func _on_GroundArea_body_exited(body):
	detected = false
	print("no ground detected")
