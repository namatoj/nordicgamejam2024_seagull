class_name FlightManager
extends Node

@onready var parent = get_parent()

@export var speed : float = 500
@export var rotation_speed = 2

var target_pos : Vector2 = Vector2.ZERO
var target_enabled = false

func _process(delta):		
	if target_enabled:
		var angle_to_mouse = parent.position.direction_to(target_pos).angle()
		parent.rotation_radians = map_radians_to_circle(rotate_toward(parent.rotation_radians, angle_to_mouse, delta * rotation_speed))

		var velocity = Vector2.from_angle(parent.rotation_radians) * speed
		parent.position += velocity * delta

		

func map_radians_to_circle(angle):
	return fposmod(angle, 2 * PI)