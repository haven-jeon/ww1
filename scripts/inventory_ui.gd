extends Control

signal select_weapon(weapon)

@onready var inv_items: InvItems = preload("res://scenes/init_inv_items.tres")
@onready var slots: Array[Node] = %GridContainer.get_children()


var is_open: bool = false
var slot_item_size: int = 0
var curr_item: int = -1

func _ready() -> void:
    assert(inv_items.Items.size() == slots.size())
    open()
    
func open() -> void:
    is_open = true
    visible = true

func close() -> void:
    is_open = false
    visible = false

func update_item(item: WeaponResource) -> void:
    for i in range(slots.size()): # 기존 아이템이 있는 경우 먼저 업데이트 함
        if slots[i].is_occupied and slots[i].item_name == item.Name:
            slots[i].update(item)
            return
    for i in range(slots.size()):
        if not slots[i].is_occupied:
            slots[i].update(item) # 기존 아이템이 없을 경우 신규 슬롯에 추가
            slot_item_size += 1
            return

func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.is_action_pressed("inventory"): # 인벤토리 열기/닫기
        if is_open:
            close()
        else:
            open()
    if is_open and event is InputEventKey:
        if event.is_action_pressed("inv_right"):
            print("right")
            print(curr_item)
            print(slot_item_size)
            if curr_item >= 0:
                slots[curr_item].de_select()
            curr_item = clamp(curr_item + 1, 0, slot_item_size - 1)
            slots[curr_item].select()
            if slots[curr_item].item_core: # 선택된 무기로 교체
                select_weapon.emit(slots[curr_item].item_core.init_item)
        if event.is_action_pressed("inv_left"):
            print("left")
            print(curr_item)
            print(slot_item_size)
            if curr_item >= 0:
                slots[curr_item].de_select()
            curr_item = clamp(curr_item - 1, 0, slot_item_size - 1)
            slots[curr_item].select()
            if slots[curr_item].item_core: # 선택된 무기로 교체
                select_weapon.emit(slots[curr_item].item_core.init_item)

func _on_aim_use_ammo(num_ammos: int) -> void:
    slots[curr_item].use_ammo(num_ammos)
