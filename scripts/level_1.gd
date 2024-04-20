extends Node2D
var trail_marker = preload("res://entities/trail_marker.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_flock_place_marker(position, rotation):
	var marker = trail_marker.instantiate()
	marker.position = position
	marker.rotation = rotation
	add_child(marker)
