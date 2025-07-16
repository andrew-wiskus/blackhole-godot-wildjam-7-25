class_name ShopController extends Control

@onready var currency_label = $CurrencyLabel
var shop_ui_active: bool = false

func _ready() -> void:
	currency_label.text = str(GameState.currency) + "kg"
	close_shop_ui()

func try_purchase_upgrade(upgrade_node: ShopUI_UpgradeNode):
	var config = upgrade_node.config
	print(config)

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

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Toggle Shop UI"): toggle_shop_visible()
	if Input.is_action_just_pressed("Esc"): close_shop_ui()
