class_name Raptor
extends Node2D

@onready var animation_manager : AnimationManager = $AnimationManager
@onready var flight_manager : FlightManager = $FlightManager


@export var rotation_speed = 2
@export var speed = 400
@export var escapeRadius = 500

var rotation_radians : float = 0

var target : Node2D

func _process(_delta):
	if target:
		if !is_instance_valid(target) or target.global_position.distance_to(global_position) > escapeRadius:
			target = null
			flight_manager.target_enabled = false
			
	if target:
		flight_manager.target_pos = target.global_position
	animation_manager.look_towards(rotation_radians)

func _on_body_enters_detection_radius(body: Node2D) -> void:
	target = body
	flight_manager.target_enabled = true
	

func _on_hurt_box_body_entered(body:Node2D):
	body.queue_free()
