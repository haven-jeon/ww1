extends Node2D

@export var enemy_inst: PackedScene
@export var game_status: GameStatus

@onready var tilemap: TileMap = $TileMap
@onready var player: Player = $player
@onready var ui: UI = $ui
  
func get_random_target_position() -> Vector2:
	var targets: Array[Vector2i] = tilemap.get_used_cells_by_id(0, 0, Vector2i(15, 15))
	var target: Vector2 = to_global(tilemap.map_to_local(targets.pick_random()))
	return target
	
func enemy_start() -> void:
	var enemy: Enemy = enemy_inst.instantiate()
	add_child(enemy)
	enemy.speed = [50, 100, 150].pick_random()
	var viewport_rect: Rect2 = get_viewport().get_camera_2d().get_viewport_rect()
	enemy.position.x = viewport_rect.end.x
	enemy.position.y = randf_range(0, viewport_rect.end.y)
	enemy.die.connect(_on_die_score)
	enemy.rush(get_random_target_position())


func _on_die_score() -> void:
	game_status.score += 1
	ui.update_score(game_status.score)
	

func _on_spawn_timer_timeout() -> void:
	enemy_start()
	$spawn_timer.start()

func _on_ui_start_game() -> void:
	player.move()
	$spawn_timer.start()


func _on_ui_stop_game() -> void:
	player.stop()
	var enemys = get_tree().get_nodes_in_group("enemy")
	for e in enemys:
		e._on_health_component_die(true)
	$spawn_timer.stop()
