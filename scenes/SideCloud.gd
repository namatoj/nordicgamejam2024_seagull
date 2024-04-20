class_name SideCloud
extends Area2D

@onready var collision_shape : CollisionShape2D = $CollisionShape2D
var bodies_contained : Array[Node2D] = []


func _process(delta):
	var direction_out = Vector2(0, -1).rotated(rotation)
	for body in bodies_contained:
		# Make it stronger the further below from local Y 0
		var body_position = body.global_position
		var rect_position = self.global_position
		var relative_position = body_position - rect_position
		var inverse_rotation = -self.rotation
		var local_position = relative_position.rotated(inverse_rotation)
		body.position += direction_out * max(local_position.y, 0) * 4 * delta

func _on_body_entered(body):
	bodies_contained.append(body)

func _on_body_exited(body):
	bodies_contained.erase(body)