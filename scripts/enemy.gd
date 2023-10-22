class_name Enemy
extends CharacterBody2D

signal die

@export var speed: float
@export var knock_speed: float

@onready var anim: AnimationPlayer = %AnimationPlayer
@onready var health: HealthComponent = %HealthComponent

var target: Vector2 = Vector2.ZERO
var knockdir: Vector2 = Vector2.ZERO
var terrain_speed: float = 1.0

func _ready() -> void:
	set_physics_process(false)
	health.die.connect(_on_health_component_die)
	
func _physics_process(delta: float) -> void:
	if target != Vector2.ZERO:
		velocity = global_position.direction_to(target) * speed * terrain_speed
		look_at(target)
		anim.play('running')
	if position.distance_to(target) < 10:
		velocity = Vector2.ZERO
		anim.play('idle')
	if knockdir != Vector2.ZERO:
		velocity = knockdir * knock_speed * terrain_speed
		knockdir = Vector2.ZERO
	move_and_slide()
	
func rush(tgt: Vector2) -> void:
	target = tgt
	set_physics_process(true)
	

func damage(attack: Attack, bullet_dir: Vector2) -> void:
	knockdir = global_transform.x.direction_to(bullet_dir)
	health.damage(attack)
	


func _on_health_component_die(isend: bool=false) -> void:
	if not isend:
		emit_signal("die")
	set_physics_process(false)
	$CollisionShape2D.call_deferred("set_disabled", true)
	anim.play('die')


func _on_terrain_detector_in_normal() -> void:
	terrain_speed = 1.0

func _on_terrain_detector_in_swarm() -> void:
	terrain_speed = 0.5

func _on_terrain_detector_in_wire() -> void:
	terrain_speed = 0.1
