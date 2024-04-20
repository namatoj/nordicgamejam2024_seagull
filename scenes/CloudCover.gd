extends Area2D

@onready var collision_shape : CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector2(1, 0.5)
	position += 100 * direction * delta


func _on_body_entered(body:Node2D):
	body.queue_free()
