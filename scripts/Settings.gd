extends Node

var settings := {
	"Fullscreen": { "Node": CheckBox.new(), "Value": { "button_pressed": false } },
	"Light 2D": { "Node": CheckBox.new(), "Value": { "button_pressed": true } }
}

var ui: CanvasLayer

func initSettings():
	var settings_panel := ui.get_node("SettingsPanel")
	var container := settings_panel.get_node("VBoxContainer")
	
	for n in settings.keys():
		var node: Control = settings[n]["Node"].duplicate()
		container.add_child.call_deferred(node)
		node.set_deferred("text", n)
		for vkey in settings[n]["Value"].keys():
			node.set_deferred(vkey, settings[n]["Value"][vkey])
		
func _process(_delta: float) -> void:
	if settings["Fullscreen"]["Node"].button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

## level status
var num_levels: int = 2
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
