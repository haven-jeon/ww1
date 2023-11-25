extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("intro")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		Settings.next_level()


func _on_start_btn_pressed() -> void:
	Settings.next_level()
