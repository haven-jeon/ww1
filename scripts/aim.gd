class_name Aim
extends Node2D

signal use_ammo(num_ammos)

@export var bomb: PackedScene

var tween: Tween = null
var is_stop_aim: bool = false:
    set(b):
        if b:
            $AimTimer.stop()
            
var target: Vector2 = Vector2.ZERO
var attached_weapon: WeaponResource
var is_attached: bool = false

func _input(event: InputEvent) -> void:
    if is_attached and event is InputEventKey:
        if event.is_action_pressed("aim"):
            global_transform = owner.get_node("soldier/Muzzle").global_transform
            make_range(100, 80, 100)
        if event.is_action_released("aim"):
            throw_bomb(set_target())

# 트윈으로 거리를 가늠하고 그 거리의 좌표를 저장한다. 
func make_range(distance: float, speed: float, wait_time: float) -> void:
    tween = create_tween() # Creates a new tween
    visible = true
    target = Vector2.ZERO
    $AimTimer.start(wait_time)
    is_stop_aim = false
    tween.set_loops(0)
    tween.tween_property($Marker, "position:x", distance, distance/speed)
    tween.tween_property($Marker, "position:x", 0, distance/speed)
    

## 수류탄 투척
func throw_bomb(target: Vector2) -> void:
    if not is_attached:
        return
    if attached_weapon and attached_weapon.CurrentAmmo <= 0:
        return
    var bom: Bomb = bomb.instantiate()
    owner.add_child(bom)
    bom.global_transform = owner.get_node("soldier/Muzzle").global_transform
    bom.launch(target)
    use_ammo.emit(bom.attack_component.Weapon.Consume)

## 마커에서 target을 가져온다.
func set_target() -> Vector2:
    is_stop_aim = true
    if tween != null and tween.is_valid():
        tween.kill()
    if not $AimTimer.is_stopped():
        $Timer.stop()
    target = $Marker/Marker2D.global_position
    $Marker.position.x = 0
    visible = false
    return target
    

func attach_grenada(weapon: WeaponResource) -> void:
    attached_weapon = weapon
    is_attached = true
    
func detach_grenada() -> void:
    attached_weapon = null
    is_attached = false


func _on_inventory_ui_select_weapon(weapon: WeaponResource) -> void:
    if weapon and weapon.Class == WeaponResource.WEAPON_CLASS.GRENADA:
        attach_grenada(weapon)
    else:
        detach_grenada()
