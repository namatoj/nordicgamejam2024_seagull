extends Node2D

signal place_marker(position, rotation)

@onready var seagulls : Node2D = $Seagulls
@onready var raycast: RayCast2D = $RayCast2D

@export var speed = 400
@export var rotation_speed = 2
@export var trail_length = 20

var rotation_radians = 0
var target = Vector2.ZERO
var acc_rotation = 0.0

var last_trail_marker_pos = Vector2.ZERO



# Called when the node enters the scene tree for the first time.
func _ready():
	last_trail_marker_pos = position

func _input(event):
	if event is InputEventMouseMotion:
		target = get_global_mouse_position()
		raycast.target_position = target - position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var angle_to_mouse = position.direction_to(target).angle()
	var old_rotation = rotation_radians

	rotation_radians = map_radians_to_circle(rotate_toward(rotation_radians, angle_to_mouse, delta * rotation_speed))
	acc_rotation += rotation_radians - old_rotation
	if abs(acc_rotation) > 2 * PI:
		print("loop happened")
		acc_rotation = 0

	var velocity = Vector2.from_angle(rotation_radians) * speed
	position += velocity * delta
	update_seagulls()
	
	if should_add_trail_marker():
		pass
		# Emit signal for level to act on!
		
func should_add_trail_marker():
	if last_trail_marker_pos.distance_to(position) > 75:
		last_trail_marker_pos = position
		print("add marker")
		place_marker.emit(position, rotation)
		return true
	return false




func update_seagulls():
	for seagull in seagulls.get_children():
		seagull.look_towards(rotation_radians)


func map_radians_to_circle(angle):
	return fposmod(angle, 2 * PI)
