extends Node2D

signal place_marker(position, rotation)

@export var speed = 400
@export var rotation_speed = 2
@export var trail_length = 20
var target = Vector2.ZERO
var acc_rotation = 0.0

var last_trail_marker_pos = Vector2.ZERO



# Called when the node enters the scene tree for the first time.
func _ready():
	last_trail_marker_pos = position

func _input(event):
	if event is InputEventMouseMotion:
		target = event.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var angle_to_mouse = position.direction_to(target).angle()
	var old_rotation = rotation
	rotation = rotate_toward(rotation, angle_to_mouse, delta * rotation_speed)
	acc_rotation += rotation - old_rotation

	if abs(acc_rotation) > 2 * PI:
		print("loop happened")
		acc_rotation = 0

	var velocity = Vector2.from_angle(rotation) * speed
	position += velocity * delta
	
	if should_add_trail_marker():
		pass
		# Emit signal for level to act on!
		# var marker = trail_marker.instantiate()
		
		# add_child(marker.)
		
func should_add_trail_marker():
	if last_trail_marker_pos.distance_to(position) > 75:
		last_trail_marker_pos = position
		print("add marker")
		place_marker.emit(position, rotation)
		return true
	return false


