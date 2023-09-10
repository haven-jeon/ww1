class_name Attack
extends Node2D

@export var Weapon: WeaponResource

var attack_damage: float
var cooltime: float
var speed: float

func _ready() -> void:
	attack_damage = Weapon.Power
	cooltime = Weapon.Cooltime
	speed = Weapon.speed

