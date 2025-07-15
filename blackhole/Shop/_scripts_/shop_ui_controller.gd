class_name ShopController extends Control

@onready var currency_label = $CurrencyLabel

#var is_scrolling = false
#@onready var scroll_container = $ShopUI_ScrollController
#
func _ready() -> void:
	currency_label.text = str(GameState.currency) + "kg"

func try_purchase_upgrade(upgrade_node: ShopUI_UpgradeNode):
	var config = upgrade_node.config
	print(config)
