extends Sprite2D

func _ready():
	update_shader()

func _process(delta):
	if !Vector2(get_viewport_rect().size).is_equal_approx(material.get_shader_parameter("viewport_size")):
		update_shader()

func update_shader():
	material.set_shader_parameter("viewport_size", get_viewport_rect().size)
