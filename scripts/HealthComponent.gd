class_name HealthComponent
extends Node2D

signal die

@export var STATUS: CharacterStatus

var health: float
var isdie: bool = false

func damage(attack: Attack):
	STATUS.Health -= attack.attack_damage
	print(STATUS.Health)
	if STATUS.Health <= 0 and not isdie:
		isdie = true
		emit_signal("die")
