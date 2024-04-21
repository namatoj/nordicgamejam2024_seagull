extends Area2D

@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var sprite : ColorRect = $ColorRect
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector2(1, 0.5)
	position += 100 * direction * delta
	if !Vector2(get_viewport_rect().size).is_equal_approx(sprite.material.get_shader_parameter("viewport_size")):
		update_shader()


func _on_body_entered(body:Node2D):
	if body.has_method("die"):
		body.die()
	else:
		queue_free()


func _ready():
	update_shader()

func update_shader():
	sprite.material.set_shader_parameter("viewport_size", get_viewport_rect().size)
