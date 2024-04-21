extends Control

var currentGoals = [[false, 'Sample 1'], 
[false, 'Sample 2'],
[true, 'Sample 3']]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var i = 0
	var goals = [
		$Goal1, $Goal2, $Goal3
	]
	
	for key in currentGoals:
		goals[i].checked = currentGoals[key]
		goals[i].text = key
		i += 1
		


