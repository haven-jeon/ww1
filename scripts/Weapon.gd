class_name WeaponResource
extends Resource


enum WEAPON_CLASS {
    HAND_GUN,
    RIPLE,
    GRENADA
}

@export var Name: String
@export var Class: WEAPON_CLASS
@export var Cooltime: float
@export var speed: float
@export var Power: float
@export var Img: Texture2D
@export var CurrentAmmo: int
@export var MaxAmmo: int
@export var Consume: int = 1
