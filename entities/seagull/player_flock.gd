extends Node2D

signal place_marker(position, rotation)
signal game_over
signal seven_seagulls_in_flock
signal flock_travelled_far
signal flock_position

@onready var seagulls : Node2D = $Seagulls
@onready var raycast: RayCast2D = $RayCast2D
@onready var flock_center: Marker2D = $FlockCenter
@onready var flight_manager: FlightManager = $FlightManager

@export var distance_between_markers = 60
@export var min_separation = 50 # Minimum distance between seagulls

var rotation_radians = 0
var target = Vector2.ZERO

var last_trail_marker_pos = Vector2.ZERO
var last_position = Vector2.ZERO
var accumulated_distance = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	last_trail_marker_pos = position
	last_position = position
	update_flock_center()
	flight_manager.target_pos = target


func _process(delta):
	target = get_global_mouse_position()
	flight_manager.target_pos = target

	if Input.is_action_just_pressed("Action"):
		add_seagull()

	update_seagulls()
	update_flock_center()
	update_distance_travelled()
	
	flock_position.emit(position)
	
	if should_add_trail_marker():
		place_marker.emit(position, rotation_radians)
	
	
		
func should_add_trail_marker():
	if last_trail_marker_pos.distance_to(position) > distance_between_markers:
		last_trail_marker_pos = position
		return true
	return false

func update_seagulls():
	if seagulls.get_child_count() == 0:
		game_over.emit()
		return
	if seagulls.get_child_count() >= 7:
		seven_seagulls_in_flock.emit()
		
	for seagull in seagulls.get_children():
		seagull.look_towards(rotation_radians)

func add_seagull():
	var retries = 100
	var placed = false
	var random_seagull
	while not placed and retries > 0:
		random_seagull = seagulls.get_children().pick_random()
		var new_pos = random_seagull.position + Vector2(randf_range(-100, 100), randf_range(-100, 100))
		if is_position_valid(new_pos):
			var new_seagull = preload("res://entities/seagull/seagull.tscn").instantiate()
			new_seagull.position = new_pos
			seagulls.add_child(new_seagull)
			new_seagull.add_to_group("seagulls")
			placed = true
		retries -= 1
	if not placed:
		print("Failed to place seagull")

func is_position_valid(check_pos):
	for seagull in seagulls.get_children():
		if seagull.position.distance_to(check_pos) < min_separation:
			return false
	return true

func update_flock_center():
	var center = Vector2()
	var count = seagulls.get_child_count()
	for seagull in seagulls.get_children():
		center += seagull.position
	flock_center.position = center / max(count, 1)  # Avoid division by zero
	
func update_distance_travelled():
	accumulated_distance += last_position.distance_to(position)
	last_position = position
	if accumulated_distance >= 5000:
		flock_travelled_far.emit()

func get_speed():
	var speed = Vector2(flight_manager.speed, 0).rotated(rotation_radians)
	return speed

# func _physics_process(delta):
# 	for seagull in seagulls.get_children():
# 		var direction_to_center = (flock_center.position - seagull.position).normalized()
# 		var distance_to_center = flock_center.position.distance_to(seagull.position)

# 		var speed_to_center = distance_to_center * 0.5 * speed
		
# 		seagull.velocity = direction_to_center * speed_to_center * delta

# 		# Apply movement using the physics engine
# 		seagull.move_and_slide()

# 		# Optional: Update the raycast's target position if used for other functionalities
# 		seagull.raycast.target_position = seagull.velocity

func position_reached():
	pass
