class_name Raptor
extends Node2D
signal escaped_raptor

@onready var animation_manager : AnimationManager = $AnimationManager
@onready var flight_manager : FlightManager = $FlightManager
@onready var raycast : RayCast2D = $RayCast2D

@export var escapeRadius = 1000
@export var attackRadius = 400

var rotation_radians : float = 0

var target : Node2D

enum State {Roaming, Chasing, Attacking, Dying}

var state : State = State.Roaming

var can_attack = true

var start_position : Vector2

func _ready():
	start_position = global_position
	set_new_roam_target()

func _process(_delta):
	if target:
		if !is_instance_valid(target):
			target = null
			set_state(State.Roaming)
	if state == State.Chasing:
		if target.global_position.distance_to(global_position) > escapeRadius:
			set_state(State.Roaming)
			escaped_raptor.emit()
		if target.global_position.distance_to(global_position) < attackRadius and can_attack:
			set_state(State.Attacking)
		else:
			flight_manager.target_pos = target.global_position
	if state == State.Attacking:
		var attack_target = estimate_target_position()
		raycast.target_position = attack_target - global_position
		flight_manager.target_pos = attack_target



	if state != State.Dying:
		animation_manager.look_towards(rotation_radians)

func _on_body_enters_detection_radius(body: Node2D) -> void:
	if body.is_in_group("raptor_target"):
		target = body
		set_state(State.Chasing)


func _on_hurt_box_body_entered(body:Node2D):
	if body.is_in_group("raptor_victim"):
		body.die()

func position_reached():
	if state == State.Roaming:
		set_new_roam_target()

func set_new_roam_target():
	var roam_range = 750
	var new_roam_target = Vector2(roam_range, 0).rotated(randf_range(-PI/4, PI/4))
	flight_manager.target_pos = start_position + new_roam_target

func set_state(new_state : State):
	if state == State.Dying:
		return
	state = new_state
	if state == State.Roaming:
		set_new_roam_target()
	if state == State.Chasing:
		flight_manager.target_pos = target.global_position
	if state == State.Attacking:
		start_attack()

func start_attack():
	can_attack = false
	var attack_target = estimate_target_position()
	raycast.target_position = attack_target - global_position
	flight_manager.target_pos = attack_target
	var tween = get_tree().create_tween()
	# Slow down, then speed up quickly, fly for a bit, then slow down again
	tween.tween_property(flight_manager, "rotation_speed", 4, 0.01)
	tween.tween_property(flight_manager, "speed", 50, 0.5)
	tween.tween_interval(0.75)
	tween.tween_property(flight_manager, "rotation_speed", 0.25, 0.01)
	tween.tween_interval(0.25)
	tween.tween_property(flight_manager, "speed", 1400, 0.1)
	tween.tween_interval(0.5)
	tween.tween_property(flight_manager, "speed", 100, 1)
	tween.tween_property(flight_manager, "rotation_speed", 2, 0.01)
	tween.tween_interval(0.5)
	tween.tween_property(flight_manager, "speed", 400, 0.1)
	tween.tween_interval(0.5)
	tween.tween_callback(_on_attack_complete)

func estimate_target_position() -> Vector2:
	var target_velocity = target.get_speed()
	var target_position = target.global_position
	var distance = target_position.distance_to(global_position)
	var time_to_reach = distance / 400
	return target_position + target_velocity * time_to_reach

func _on_attack_complete():
	can_attack = true
	if target:
		set_state(State.Chasing)
	else:
		set_state(State.Roaming)

func die():
	set_state(State.Dying)
	flight_manager.disabled = true
	var tween := get_tree().create_tween().set_loops(32)
	tween.set_parallel(true)
	tween.tween_callback(animation_manager.rotate_animation)
	tween.tween_interval(0.075)

	var tween2 := get_tree().create_tween()
	tween2.tween_property(self, "scale", Vector2(0, 0), 2.5)
	await tween2.finished
	queue_free()
