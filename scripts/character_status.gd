class_name CharacterStatus
extends Resource

enum CHARACTER_CLASS {
	PLAYER,
	ENEMY,
	NPC
}

@export var Name: String
@export var Class: CHARACTER_CLASS
@export var Health: float

