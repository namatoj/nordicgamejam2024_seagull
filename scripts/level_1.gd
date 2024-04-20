extends Node2D
var trail_marker = preload("res://entities/trail_marker.tscn")

@export var max_trail_length = 100
var trail_markers = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if trail_has_loop():
		for trail_marker in trail_markers:
			
			trail_marker.queue_free()
		trail_markers.clear()
	
func trail_has_loop():
	for i in len(trail_markers) - 1:
		# + 2 since we dont want to compare to itself and we dont
		# want to compare to the immediate neighbour. (That will always match)
		for j in range(i+2, len(trail_markers) - 1):
			if Geometry2D.segment_intersects_segment(
				trail_markers[i].position, trail_markers[i+1].position,
				trail_markers[j].position, trail_markers[j+1].position
			):
				return true
	return false


func _on_player_flock_place_marker(position, rotation):
	var marker = trail_marker.instantiate()
	marker.position = position
	marker.rotation = rotation
	trail_markers.append(marker)
	add_child(marker)
	
	if len(trail_markers) > max_trail_length:
		var last_marker = trail_markers.pop_front()
		last_marker.queue_free()
