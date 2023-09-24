class_name UI
extends CanvasLayer

signal start_game
signal stop_game

@onready var score: Label = $score
@onready var startbtn: Button = $startbtn
@onready var counter: Label = $counter
@onready var timer: Timer = $counter/Timer

func _ready() -> void:
	score.text = "%d" % 0
	startbtn.visible = true
	

func update_score(point: int) -> void:
	score.text = "%d" % point

func on_game_over() -> void:
	startbtn.visible = true
	
func _physics_process(delta: float) -> void:
	counter.text = time_to_min_sec(timer.time_left)

func time_to_min_sec(time: float) -> String:
	var mins = int(time) / 60
	time -= mins * 60
	var secs = int(time)
	return "%02d" % mins + ":" + "%02d" % secs


func _on_startbtn_pressed() -> void:
	emit_signal("start_game")
	timer.start()
	startbtn.visible = false


func _on_timer_timeout() -> void:
	emit_signal("stop_game")
	timer.stop()
	startbtn.visible = true
