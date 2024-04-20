extends Node2D

@onready var seagulls : Node2D = $Seagulls
@onready var raycast: RayCast2D = $RayCast2D

@export var speed = 400
@export var rotation_speed = 2

var rotation_radians = 0
var target = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		target = get_global_mouse_position()
		raycast.target_position = target - position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var angle_to_mouse = position.direction_to(target).angle()
	rotation_radians = map_radians_to_circle(rotate_toward(rotation_radians, angle_to_mouse, delta * rotation_speed))

	var velocity = Vector2.from_angle(rotation_radians) * speed
	position += velocity * delta

	update_seagulls()

func update_seagulls():
	for seagull in seagulls.get_children():
		seagull.look_towards(rotation_radians)


func map_radians_to_circle(angle):
	return fposmod(angle, 2 * PI)