extends Node2D

@onready var seagulls : Node2D = $Seagulls
@onready var raycast: RayCast2D = $RayCast2D
@onready var flock_center: Marker2D = $FlockCenter

@export var speed = 400
@export var rotation_speed = 2
@export var min_separation = 50 # Minimum distance between seagulls

var rotation_radians = 0
var target = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	update_flock_center()

func _input(event):
	if event is InputEventMouseMotion:
		target = get_global_mouse_position()
		raycast.target_position = target - position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Action"):
		add_seagull()

	var angle_to_mouse = position.direction_to(target).angle()
	rotation_radians = map_radians_to_circle(rotate_toward(rotation_radians, angle_to_mouse, delta * rotation_speed))

	var velocity = Vector2.from_angle(rotation_radians) * speed
	position += velocity * delta

	update_seagulls()
	update_flock_center()

func update_seagulls():
	for seagull in seagulls.get_children():
		seagull.look_towards(rotation_radians)

func map_radians_to_circle(angle):
	return fposmod(angle, 2 * PI)

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
