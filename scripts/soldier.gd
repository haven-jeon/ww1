class_name Player
extends CharacterBody2D

@export var speed = 180.0
@export var bullet: PackedScene


var cooltime: float = 1.0

func _ready() -> void:
	set_physics_process(false)
	

func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("left", "right", "up", "down")
	velocity = dir * speed
	if dir == Vector2.ZERO:
		%AnimationPlayer.play("idle")
	else:
		%AnimationPlayer.play("running")
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shot") and $soldier/cooltimeTimer.is_stopped():
		$soldier/cooltimeTimer.start(cooltime)
		shoot()
	move_and_slide()


func shoot() -> void:
	$soldier/AnimationPlayer.play("shoot")
	var b = bullet.instantiate()
	owner.add_child(b)
	cooltime = b.cooltime
	b.global_transform = $soldier/Muzzle.global_transform	


func move() -> void:
	set_physics_process(true)
	
func stop() -> void:
	set_physics_process(false)
	
func disappear() -> void:
	queue_free()
