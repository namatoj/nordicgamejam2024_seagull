extends Node2D

signal place_marker(position, rotation)

@onready var seagulls : Node2D = $Seagulls
@onready var raycast: RayCast2D = $RayCast2D
@onready var flock_center: Marker2D = $FlockCenter

@export var speed = 400
@export var rotation_speed = 2
@export var trail_length = 20

var rotation_radians = 0
var target = Vector2.ZERO
var acc_rotation = 0.0

var last_trail_marker_pos = Vector2.ZERO

var trail_marker_positions = []



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

	#if abs(acc_rotation) > 2 * PI:
		#print("loop happened")
		#acc_rotation = 0

	var velocity = Vector2.from_angle(rotation_radians) * speed
	position += velocity * delta
	update_seagulls()
	
	if should_add_trail_marker():
		place_marker.emit(position, rotation_radians)
	
	if trail_is_intersecting():
		print("Loop happened")
		
func should_add_trail_marker():
	if last_trail_marker_pos.distance_to(position) > 10:
		last_trail_marker_pos = position
		trail_marker_positions.push_back(position)
		print(len(trail_marker_positions))
		if len(trail_marker_positions) > trail_length:
			trail_marker_positions.pop_front()

		return true
	return false

func update_seagulls():
	for seagull in seagulls.get_children():
		seagull.look_towards(rotation_radians)

func map_radians_to_circle(angle):
	return fposmod(angle, 2 * PI)

func trail_is_intersecting():
	var segments = []
	for i in len(trail_marker_positions) - 1:
		segments.append(trail_marker_positions[i] - trail_marker_positions[i+1])
	
	#for i in len(segments):
		#for j in range(i, len(segments)):
			## Don't check all combinations
			## Return on the first "hit"
			#pass

	return false

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


