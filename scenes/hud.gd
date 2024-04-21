extends CanvasLayer

var start_distance = 48000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_player_flock_flock_position(flock_position):
	var exit_direction = Vector2(2, 1).normalized()
	var distance_to_exit = start_distance - round(flock_position.dot(exit_direction) + 1318)
	GameStats.distance_to_exit = distance_to_exit
	$DistanceCounter.text = "Distance to exit: %d" % distance_to_exit

