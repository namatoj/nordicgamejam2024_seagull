extends Control

var currentGoals = [[false, 'Sample 1'], 
[false, 'Sample 2'],
[true, 'Sample 3']]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Goal1.checked = currentGoals[0][0]
	$Goal1.text = currentGoals[0][1]
	$Goal2.checked = currentGoals[1][0]
	$Goal2.text = currentGoals[1][1]
	$Goal3.checked = currentGoals[2][0]
	$Goal3.text = currentGoals[2][1]


