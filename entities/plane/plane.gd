class_name PlaneUnit
extends Node2D

@onready var animation_manager : AnimationManager = $AnimationManager
@onready var flight_manager : FlightManager = $FlightManager
@onready var raycast : RayCast2D = $RayCast2D

@export var escapeRadius = 1000
@export var attackRadius = 400

var rotation_radians : float = 0

var target : Node2D
var zeppelin_target: Node2D

enum State {Roaming, GoingHome, Attacking, Dying}

var state : State = State.Roaming

var can_attack = true
var spawn_direction : float = 0

func _ready():
	set_new_roam_target()

func _process(_delta):
	if target:
		if !is_instance_valid(target):
			target = null
			_on_attack_complete()
	# if state == State.Chasing:
	# 	if target.global_position.distance_to(global_position) > escapeRadius:
	# 		set_state(State.Roaming)
	# 	if target.global_position.distance_to(global_position) < attackRadius and can_attack:
	# 		set_state(State.Attacking)
	# 	else:
	# 		flight_manager.target_pos = target.global_position
	if state == State.Attacking:
		var attack_target = estimate_target_position()
		raycast.target_position = attack_target - global_position
		flight_manager.target_pos = attack_target

	if state == State.GoingHome:
		raycast.target_position = zeppelin_target.global_position - global_position
		flight_manager.target_pos = zeppelin_target.global_position



	if state != State.Dying:
		animation_manager.look_towards(rotation_radians)

func _on_body_enters_detection_radius(body: Node2D) -> void:
	if body.is_in_group("plane_target"):
		target = body
		if can_attack:
			set_state(State.Attacking)
	if body.is_in_group("zeppelins"):
		zeppelin_target = body
		if state == State.Roaming:
			set_state(State.GoingHome)


func _on_hurt_box_body_entered(body:Node2D):
	if body.is_in_group("plane_victim"):
		body.die()


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
	if state == State.GoingHome:
		add_to_group("plane")
		flight_manager.target_pos = zeppelin_target.global_position
	if state == State.Attacking:
		start_attack()

func start_attack():
	can_attack = false
	var attack_target = estimate_target_position()
	raycast.target_position = attack_target - global_position
	flight_manager.target_pos = attack_target
	var tween = get_tree().create_tween()
	# First attack
	tween.tween_property(flight_manager, "rotation_speed", 1, 0.01)
	tween.tween_property(flight_manager, "speed", 1000, 0.75)
	tween.tween_property(flight_manager, "speed", 200, 0.25)
	tween.tween_property(flight_manager, "rotation_speed", 2.5, 0.01)
	tween.tween_interval(1)
	# Second attack
	tween.tween_property(flight_manager, "rotation_speed", 1, 0.01)
	tween.tween_property(flight_manager, "speed", 700, 0.25)
	tween.tween_property(flight_manager, "speed", 1000, 0.50)
	# Attack done
	tween.tween_callback(_on_attack_complete)
	tween.tween_property(flight_manager, "speed", 400, 0.25)
	tween.tween_property(flight_manager, "rotation_speed", 2.5, 0.01)
	tween.tween_interval(5)
	tween.tween_callback(die)
	

func estimate_target_position() -> Vector2:
	#var target_velocity = target.get_speed()
	var target_position = target.global_position
	#var distance = target_position.distance_to(global_position)
	#var time_to_reach = distance / 400
	return target_position

func _on_attack_complete():
	if zeppelin_target:
		set_state(State.GoingHome)
	else:
		set_state(State.Roaming)

func set_speed(dir: Vector2):
	rotation_radians = dir.angle()

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
