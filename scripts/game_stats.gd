extends Node

var distance_to_exit = 5000
var goal_status = {
	"Destroy zeppelin": true
}

func reset():
	distance_to_exit = 0
	goal_status = {}