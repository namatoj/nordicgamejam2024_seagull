extends Area2D
signal picked_up_seagull

var polygon_points = []

@onready var label_position: Node2D = $LabelPosition
@onready var label: Label = $LabelPosition/Label

const LABEL_MESSAGES = [
	"Cool!",
	"Nice!",
	"Great!",
	"Neat!",
]

var show_message = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if len(polygon_points) > 0:
		label_position.position = loop_center()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if len(polygon_points) > 0:
		#polygon_points.append(polygon_points[0]) # First and last point needs to be the same
		$Polygon2D.polygon = PackedVector2Array(polygon_points)
		$CollisionPolygon2D.polygon = PackedVector2Array(polygon_points)
		
		polygon_points = []
	if show_message:
		label_position.visible = true
		label.text = LABEL_MESSAGES.pick_random()
		show_message = false

func _on_body_entered(body):
	if body.is_in_group("sittingSeagulls"):
		emit_signal("picked_up_seagull")
		body.queue_free()
		show_message = true
	if body.is_in_group("killable_by_loop"):
		body.die()
		show_message = true

func _on_removal_timer_timeout():
	queue_free()


func loop_center():
	var center = Vector2(0, 0)
	if len(polygon_points) > 0:
		for point in polygon_points:
			center += point
		center /= len(polygon_points)
	return center

func _on_timer_timeout():
	monitoring = false
