class_name Seagull
extends CharacterBody2D

@onready var raycast: RayCast2D = $RayCast2D

@onready var animation_manager : AnimationManager = $AnimationManager

var dying = false

func look_towards(radians):
	if not dying:
		animation_manager.look_towards(radians)

func get_speed():
	return get_parent().get_parent().get_speed()

func die():
	dying = true
	var tween := get_tree().create_tween().set_loops(32)
	tween.set_parallel(true)
	tween.tween_callback(animation_manager.rotate_animation)
	tween.tween_interval(0.075)

	var tween2 := get_tree().create_tween()
	tween2.tween_property(self, "scale", Vector2(0, 0), 2.5)
	await tween2.finished
	queue_free()