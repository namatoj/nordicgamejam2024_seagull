class_name Zeppelin
extends Node2D

@onready var animation_manager : AnimationManager = $AnimationManager
@onready var flight_manager : FlightManager = $FlightManager
@onready var raycast : RayCast2D = $RayCast2D

@export var escapeRadius : float = 1000
@export var attackRadius = 400

signal spawn_plane(pos: Vector2, dir: Vector2)

var rotation_radians : float = 0

var target : Node2D

enum State {Roaming, Chasing, Attacking, Dying}

var state : State = State.Roaming

var can_attack = true

func _ready():
	set_new_roam_target()

func _process(_delta):
	if target:
		if !is_instance_valid(target):
			target = null
			set_state(State.Roaming)
	if state == State.Chasing:
		if target.global_position.distance_to(global_position) > escapeRadius:
			set_state(State.Roaming)
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
	if body.is_in_group("zeppelin_target"):
		target = body
		set_state(State.Chasing)


func _on_hurt_box_body_entered(body:Node2D):
	if body.is_in_group("zeppelin_victim"):
		body.die()
	if body.is_in_group("plane"):
		body.queue_free()

func position_reached():
	if state == State.Roaming:
		set_new_roam_target()

func set_new_roam_target():
	var roam_range = 500
	var new_roam_target = Vector2(roam_range, 0).rotated(randf_range(-PI/4, PI/4))
	flight_manager.target_pos = global_position + new_roam_target

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
	var attack_target = target.global_position #estimate_target_position()
	raycast.target_position = attack_target - global_position
	
	spawn_plane.emit(global_position, global_position.direction_to(attack_target))

	var timer = Timer.new()
	timer.wait_time = 5
	timer.one_shot = true
	timer.timeout.connect(_on_attack_complete)
	add_child(timer)
	timer.start()



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
