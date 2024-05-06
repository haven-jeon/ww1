extends Node2D

@onready var item_visual: Sprite2D = %ItemDisp
@onready var ammo_text: Label = %AmmoLabel
@export var init_item: WeaponResource

var item_name: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if !init_item: # if in inventory 
        self.visible = false
        get_node("Area2D/CollisionShape2D").disabled = true
    else: # in in ground
        item_visual.texture = init_item.Img
        ammo_text.text = str(init_item.CurrentAmmo)

## 슬롯 아이템 업데이트 하기 위함
func update(item: WeaponResource) -> void:
    if !item: # 슬롯 초기화 
        self.visible = false
    elif item_name != "": # 이미 슬롯에 아이템이 있을 경우
        self.visible = true
        var ammo: int = init_item.CurrentAmmo + item.CurrentAmmo
        init_item.CurrentAmmo = clamp(ammo, 0, item.MaxAmmo)
        ammo_text.text = str(init_item.CurrentAmmo)
        item_name = item.Name
    else: # 신규 슬롯 아이템일 경우 
        self.visible = true
        init_item = item
        item_visual.texture = init_item.Img
        ammo_text.text = str(init_item.CurrentAmmo)
        item_name = init_item.Name

func _process(delta: float) -> void:
    if init_item:
        ammo_text.text = str(init_item.CurrentAmmo)


func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"): # 플레이어만 아이템을 주울 수 있다. 
        body.pick_weapon(init_item) # TODO: pick_weapon 함수 구현
        queue_free()
