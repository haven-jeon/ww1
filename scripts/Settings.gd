extends Node

var settings := {
	"Fullscreen": { "Node": CheckBox.new(), "Value": { "button_pressed": false } },
	"Light 2D": { "Node": CheckBox.new(), "Value": { "button_pressed": true } }
}

var ui: CanvasLayer

func initSettings():
	var settings_panel := ui.get_node("SettingsPanel")
	var container := settings_panel.get_node("VBoxContainer")
	
	for name in settings.keys():
		var node: Control = settings[name]["Node"]
		container.add_child.call_deferred(node)
		node.set_deferred("text", name)
		for vkey in settings[name]["Value"].keys():
			node.set_deferred(vkey, settings[name]["Value"][vkey])
		
func _process(delta: float) -> void:
	if settings["Fullscreen"]["Node"].button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
