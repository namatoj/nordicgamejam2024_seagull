extends Control

var current_goals = [[false, 'Sample 1'], 
[false, 'Sample 2'],
[false, 'Sample 3']]

var goals = []

# Called when the node enters the scene tree for the first time.
func _ready():
	goals = [$Goal1, $Goal2, $Goal3]


func set_current_goals(new_current_goals):
	current_goals = new_current_goals

	var i = 0
	for key in current_goals:
		if goals != null:
			goals[i].set_checked_status(current_goals[key])
			goals[i].set_text(key)
		i += 1


