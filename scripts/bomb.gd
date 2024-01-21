class_name Bomb
extends Node2D


@onready var ray: RayCast2D = $RayCast2D
@onready var attack_component: Attack = $Attack

@export var bomb_num_particles: int = 50
@export var bomb_power: int = 50

@export var is_debug: bool = false

var tween: Tween = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = attack_component.img


## 수류탄 투척
func launch(target: Vector2) -> void:
	tween = create_tween() # Creates a new tween
	var middle_position = (target + global_position) / 2
	tween.set_parallel(true)
	# 아래 세가지 트위은 동시 수행됨
	# 중간 포지션까지는 스케일 확대, 회전
	tween.tween_property(self, "global_position", middle_position, 0.5)
	tween.tween_property(self, "scale", Vector2(2, 2), 0.5)
	tween.tween_property(self, "rotation", deg_to_rad(360), 0.5)
	tween.play()
	await tween.step_finished
	tween = create_tween() 
	tween.set_parallel(true)
	# 중간 포지션까지는 스케일 축소, 회전
	tween.tween_property(self, "global_position", target, 0.5)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.5)
	tween.tween_property(self, "rotation", deg_to_rad(360 * 2), 0.5)
	tween.play()
	await tween.step_finished
	explotion()
	
func explotion() -> void:
	$AnimationPlayer.play("explotion")
	await $AnimationPlayer.animation_finished
	$Explotion.play()
	particle_explod()
	await get_tree().create_timer($Explotion.time).timeout
	queue_free()
		
func particle_explod() -> void:
	var line: Line2D
	if is_debug:
		line = Line2D.new()
		line.width = 1
		add_child(line)
	var rng = RandomNumberGenerator.new()
	var rnd_nums = []
	for _i in range(0, bomb_num_particles):
		var rnd_angle = rng.randf_range(0, 360)
		rnd_nums.append(rnd_angle)
	ray.enabled = true
	var tile_poses: Array[Vector2i] = []
	var tilemap: TileMap
	var objects_collide = [] #중복되는 피해를 막기 위해 리스트 정의
	for r in rnd_nums:
		var particle_position = Vector2(cos(r), sin(r)) * bomb_power
		# 오직 적만 피해줌
		if is_debug:
			line.add_point(ray.position)
			line.add_point(particle_position)
		ray.target_position = particle_position
		ray.collision_mask = 2 ## 오직 적만 영향
		ray.force_raycast_update()
		if ray.is_colliding(): # ray와 충돌한 적에 대한 인식 
			var body_hit = ray.get_collider()
			objects_collide.append(body_hit)
			if body_hit.is_in_group('enemy'):
				print('hit enemy')
				body_hit.damage(attack_component, position.direction_to(particle_position))
				ray.add_exception(body_hit)
		ray.collision_mask = 4 # 오직 타일(yard)만 영향
		ray.force_raycast_update()
		if ray.is_colliding(): # 타일에 대한 인식
			var body_hit = ray.get_collider()
			if body_hit is TileMap:
				tilemap = body_hit
				var pose = tilemap.get_coords_for_body_rid(ray.get_collider_rid())
				if not pose in tile_poses:
					tile_poses.append(tilemap.get_coords_for_body_rid(ray.get_collider_rid()))
					ray.add_exception_rid(ray.get_collider_rid())
	print(tile_poses)
	for t in tile_poses:
		tilemap.erase_cell(1, t)
	if len(tile_poses) != 0:
		tilemap.set_cells_terrain_connect(1, tile_poses, 0, 0, false)
	ray.clear_exceptions()
