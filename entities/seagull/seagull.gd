class_name Seagull
extends CharacterBody2D

@onready var raycast: RayCast2D = $RayCast2D

@onready var animation_manager : AnimationManager = $AnimationManager

func look_towards(radians):
	animation_manager.look_towards(radians)

func get_speed():
	return get_parent().get_parent().get_speed()
