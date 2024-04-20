extends Area2D
signal picked_up_seagull

var polygon_points = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if len(polygon_points) > 0:
		#polygon_points.append(polygon_points[0]) # First and last point needs to be the same
		$Polygon2D.polygon = PackedVector2Array(polygon_points)
		$CollisionPolygon2D.polygon = PackedVector2Array(polygon_points)
		
		polygon_points = []

func _on_body_entered(body):
	if body.is_in_group("sittingSeagulls"):
		emit_signal("picked_up_seagull")
		body.queue_free()

func _on_removal_timer_timeout():
	queue_free()