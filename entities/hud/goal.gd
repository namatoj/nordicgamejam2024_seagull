extends Control

@export var checked = false
@export var text = "Sample 1"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_checked_status(status):
	checked = status
	if checked:
		$Checkbox.texture = load("res://art/checkedCheckbox.png")
	else:
		$Checkbox.texture = load("res://art/uncheckedCheckbox.png")
	
func set_text(text):
	$Label.text = text
