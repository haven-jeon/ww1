extends Area2D

var speed: float
var cooltime: float


@onready var attack_component: Attack = $AttackComponent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = attack_component.speed
	cooltime = attack_component.cooltime

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and not body.health.isdie:
		body.damage(attack_component)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
