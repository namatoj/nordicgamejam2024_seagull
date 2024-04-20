extends Node2D

@export var speed = 400
@export var rotation_speed = 2
var target = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		target = event.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var angle_to_mouse = position.direction_to(target).angle()
	rotation = rotate_toward(rotation, angle_to_mouse, delta * rotation_speed)

	var velocity = Vector2.from_angle(rotation) * speed
	position += velocity * delta
