extends Panel

@onready var item_core: Node2D = %GroundItem
@onready var is_selected: ReferenceRect = %Selected

var item_name: String = ""
var is_occupied: bool = false

func update(item: WeaponResource) -> void:
    item_core.update(item)
    item_name = item_core.item_name
    is_occupied = true
    
func select() -> void:
    is_selected.visible = true
    
func de_select() -> void:
    is_selected.visible = false

func use_ammo(bullets: int) -> void:
    if item_core.init_item:
        item_core.init_item.CurrentAmmo = clamp(item_core.init_item.CurrentAmmo - bullets, 0 , item_core.init_item.MaxAmmo)
