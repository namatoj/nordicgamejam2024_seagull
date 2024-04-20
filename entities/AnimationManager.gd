class_name AnimationManager
extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var sprite_name: String = "zeppelin"


func _ready():
	var sprite_frames = SpriteFrames.new()
	for n in range(16):
		var dir = str(n)
		var sprite = load("res://art/" + sprite_name + "/" + sprite_name + "_" + dir + ".png")
		sprite_frames.add_animation(dir)
		sprite_frames.add_frame(dir, sprite, 1)
	animated_sprite.frames = sprite_frames
	animated_sprite.animation = "0"



func look_towards(radians):

	radians = map_radians_to_circle(radians + PI / 16)

	var direction : float = remap(radians, 0, 2 * PI, 0, 16)
	animated_sprite.animation = str(floor(direction))


func map_radians_to_circle(angle):
	return fposmod(angle, 2 * PI)