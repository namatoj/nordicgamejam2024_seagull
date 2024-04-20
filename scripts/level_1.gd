extends Node2D
var trail_marker = preload("res://entities/trail_marker.tscn")
var loop_summon = preload("res://entities/loop_summon.tscn")

@export var max_trail_length = 100
var trail_markers = []
var first_marker_in_loop_index = -1
var last_marker_in_loop_index = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if trail_has_loop():
		var polygon_points = []
		for marker_in_loop in trail_markers.slice(first_marker_in_loop_index, last_marker_in_loop_index+1):
			polygon_points.append(marker_in_loop.position)
		
		var summon = loop_summon.instantiate()
		summon.picked_up_seagull.connect(_on_picked_up_seagull)
		summon.polygon_points = polygon_points
		add_child(summon)
		
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
				first_marker_in_loop_index = i
				last_marker_in_loop_index = j
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

func _on_picked_up_seagull():
	$"Player Flock".add_seagull()
