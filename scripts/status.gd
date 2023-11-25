extends Node

var num_levels: int = 1
var current_level: int = 0

var game_scene = "res://scenes/stage_%d.tscn"
var title_scene = "res://scenes/title.tscn"

func restart() -> void:
	current_level = 0
	get_tree().change_scene_to_file(title_scene)

func next_level() -> void:
	current_level += 1
	if current_level <= num_levels:
		get_tree().change_scene_to_file(game_scene % current_level)
	else:
		restart()
