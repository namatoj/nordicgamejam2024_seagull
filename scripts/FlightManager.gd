class_name FlightManager
extends Node

@onready var parent = get_parent()

@export var speed : float = 500
@export var rotation_speed : float = 2

signal position_reached

var target_sensitivity = 20

var target_pos : Vector2 = Vector2.ZERO # Global

func _process(delta):		
	var angle_to_target = parent.global_position.direction_to(target_pos).angle()
	parent.rotation_radians = map_radians_to_circle(rotate_toward(parent.rotation_radians, angle_to_target, delta * rotation_speed))

	var velocity = Vector2.from_angle(parent.rotation_radians) * speed
	parent.position += velocity * delta
	if parent.global_position.distance_to(target_pos) < target_sensitivity:
		parent.position_reached()

		

func map_radians_to_circle(angle):
	return fposmod(angle, 2 * PI)
