extends Node2D

@onready var animation_player = $AnimatedSprite2D/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_lightning_trigger_zone_body_entered(body):
	animation_player.play("lightning")
	pass # Replace with function body.


func _on_killzone_body_entered(body):
	# Hurt the player
	if body.is_in_group("raptor_victim"):
		body.die()

