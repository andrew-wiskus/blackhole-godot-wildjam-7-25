class_name ShopController extends Control

@export var shop_layout: ShopUI_Layout
var _gc: GameController

var shop_ui_active: bool = false

func _ready() -> void:
	close_shop_ui()
	_gc = get_tree().get_first_node_in_group("game_controller")
	print(_gc)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Toggle Shop UI"): toggle_shop_visible()
	if Input.is_action_just_pressed("Esc"): close_shop_ui()

func _set_ui_active(is_active):
	shop_ui_active = is_active
	if shop_ui_active:
		show()
		GameState.pause_game()
	else:
		hide()
		GameState.resume_game()

func toggle_shop_visible(): _set_ui_active(!shop_ui_active)
func close_shop_ui(): _set_ui_active(false)
func open_shop_ui(): _set_ui_active(true)

func try_purchase_upgrade(upgrade_node: ShopUI_UpgradeNode):
	if upgrade_node.is_max_level: return false
	
	var id = upgrade_node.upgrade_id
	var next_level = upgrade_node.next_level
	var unlocked_ids: Array = next_level.unlocks.duplicate()

	if GameState.try_purchase(next_level.cost):
		if id == ShopCC.UpgradeID.GRAVITY_1:
			_gc.handle_gravity_upgrade(next_level)
		if id == ShopCC.UpgradeID.SPEED_1:
			_gc.handle_speed_upgrade(next_level)
		if id == ShopCC.UpgradeID.SPEED_2:
			_gc.handle_speed_upgrade(next_level)
		if id == ShopCC.UpgradeID.SPEED_3:
			_gc.handle_speed_upgrade(next_level)
		if id == ShopCC.UpgradeID.SPEED_4:
			_gc.handle_speed_upgrade(next_level)
		if id == ShopCC.UpgradeID.AOE_1:
			_gc.handle_aoe_upgrade(next_level)
		if id == ShopCC.UpgradeID.MASS_EFFICENCY_1:
			_gc.handle_mass_efficiency_upgrade(next_level)
		if id == ShopCC.UpgradeID.PASSIVE_MASS_1:
			_gc.handle_passive_mass_upgrade(next_level)
		if id== ShopCC.UpgradeID.MAX_ZOOM:
			_gc.handle_max_zoom_upgrade(next_level)
		upgrade_node.update_after_purchase_success(upgrade_node.current_level + 1)
		shop_layout.on_node_upgraded(upgrade_node, unlocked_ids)
