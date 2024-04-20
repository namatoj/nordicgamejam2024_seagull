class_name Seagull
extends Area2D

@onready var animation_manager : AnimationManager = $AnimationManager

func look_towards(radians):
	animation_manager.look_towards(radians)