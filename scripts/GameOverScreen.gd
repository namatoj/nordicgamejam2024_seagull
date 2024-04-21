extends Control

func _ready():
	var text = "Goals:\n\n"
	for goal in GameStats.goal_status.keys():
		var goal_status = GameStats.goal_status[goal]
		text += goal + ": "
		if goal_status:
			text += "Completed\n"
		else:
			text += "Not completed\n"
	text += "\n\nDistance to goal: "
	if GameStats.distance_to_exit <= 0:
		text += "Goal reached!"
	else:
		text += str(GameStats.distance_to_exit)
		text += " meters"
	$GoalsLabel.text = text


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
