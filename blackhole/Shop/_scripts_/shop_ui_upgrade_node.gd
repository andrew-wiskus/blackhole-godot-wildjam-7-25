class_name ShopUI_UpgradeNode extends Button

signal on_purchase_pressed(node: ShopUI_UpgradeNode)

@export var upgrade_id: ShopCC.UpgradeID 
@export var is_first_upgrade: bool = false

@onready var level_description_txt: RichTextLabel = $UpgradeTooltipContainer/MarginContainer/UpgradeText_VBox/level_description_txt
@onready var upgrade_title_txt: RichTextLabel = $UpgradeTooltipContainer/MarginContainer/UpgradeText_VBox/upgrade_title_txt
@onready var upgrade_text_v_box: VBoxContainer = $UpgradeTooltipContainer/MarginContainer/UpgradeText_VBox
@onready var upgrade_tooltip_container: PanelContainer = $UpgradeTooltipContainer

var _level_labels = []
var current_level = 1 
var config = null
var _shop_controller: ShopController = null
	#{ --- CONFIG OBJ EXAMPLE
		#id = ShopCC.UpgradeID.GRAVITY_1,
		#title = "Increase Gravity Force Multiplier",
		#levels = [
			#{ value = 0.2, cost = 100, unlocks = [ShopCC.UpgradeID.SIZE_1] },
			#{ value = 0.3, cost = 300, unlocks = [] },
			#{ value = 0.5, cost = 500, unlocks = [ShopCC.UpgradeID.SPEED_1] },
		#]
	#}

func _ready() -> void:
	_shop_controller = ShopCC.get_shop_controller(self)
	config = ShopCC.get_upgrade_config(upgrade_id)
	
	_initilize_level_labels()
	_update_labels_for_current_lvl()
	
	upgrade_title_txt.text = config.title
	upgrade_tooltip_container.visible = false
	
	#if is_first_upgrade == false:
		#hide()

func _initilize_level_labels(): 
	var level_labels = []
	for level_config in config.levels:
		if len(level_labels) == 0:
			level_description_txt.text = level_description(level_config.value)
			level_labels.append({ level = 0, label = level_description_txt})
		else:
			var new_label = level_description_txt.duplicate() as RichTextLabel
			new_label.text = level_description(level_config.value)
			upgrade_text_v_box.add_child(new_label)
			level_labels.append({ level = level_labels.size(), label = new_label})
	_level_labels = level_labels

func _update_labels_for_current_lvl():
	for item in _level_labels:
		if item.level > current_level:
			item.label.modulate = Color(255, 255, 255, 0.5)
	
func level_description(value):
	if config.id == ShopCC.UpgradeID.GRAVITY_1:
		return "Gravity multiplier +" + str(int(value * 100)) + "%"
	if config.id == ShopCC.UpgradeID.SIZE_1:
		return "Area of effect +" + str(int(value * 100)) + "%"
	if config.id == ShopCC.UpgradeID.SPEED_1:
		return "Increase speed by " + str(int(value)) + "m/s"
	
	return "NOT_SET"

func hide_tooltip():
	upgrade_tooltip_container.visible = false

func update_after_purchase_success(_new_level):
	current_level = _new_level
	_update_labels_for_current_lvl()
	# TODO: Add visual when reaching max level.. like turning it yellow or something

func _on_purchase_button_pressed() -> void:
	_shop_controller.try_purchase_upgrade(self)

func _on_upgrade_node_clicked() -> void:
	upgrade_tooltip_container.visible = !upgrade_tooltip_container.visible
