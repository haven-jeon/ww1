class_name Enemy
extends CharacterBody2D

signal die

@export var speed: float

@onready var anim: AnimationPlayer = %AnimationPlayer
@onready var health: HealthComponent = %HealthComponent

var target: Vector2 = Vector2.ZERO

func _ready() -> void:
	set_physics_process(false)
	health.die.connect(_on_health_component_die)
	
func _physics_process(delta: float) -> void:
	if target != Vector2.ZERO:
		velocity = global_position.direction_to(target) * speed
		look_at(target)
		anim.play('running')
	if position.distance_to(target) < 10:
		velocity = Vector2.ZERO
		anim.play('idle')
	move_and_slide()
	
func rush(tgt: Vector2) -> void:
	target = tgt
	set_physics_process(true)
	

func damage(attack: Attack) -> void:
	health.damage(attack)
	


func _on_health_component_die(isend: bool=false) -> void:
	if not isend:
		emit_signal("die")
	set_physics_process(false)
	$CollisionShape2D.disabled = true
	anim.play('die')
	
