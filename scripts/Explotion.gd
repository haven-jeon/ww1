extends CPUParticles2D

@export var time: float = 1.0
@export var particle_amount: int = 100


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lifetime = time
	amount = particle_amount
	one_shot = true

func play() -> void:
	set_emitting(true)
