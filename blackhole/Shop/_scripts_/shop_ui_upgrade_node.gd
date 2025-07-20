class_name ShopUI_UpgradeNode extends Button

@export var upgrade_id: ShopCC.UpgradeID 
@export var is_first_upgrade: bool = false

@onready var level_description_txt: RichTextLabel = $UpgradeTooltipContainer/MarginContainer/UpgradeText_VBox/level_description_txt
@onready var upgrade_title_txt: RichTextLabel = $UpgradeTooltipContainer/MarginContainer/UpgradeText_VBox/upgrade_title_txt
@onready var upgrade_text_v_box: VBoxContainer = $UpgradeTooltipContainer/MarginContainer/UpgradeText_VBox
@onready var upgrade_tooltip_container: PanelContainer = $UpgradeTooltipContainer
@onready var purchase_button: Button = $UpgradeTooltipContainer/MarginContainer/UpgradeText_VBox/PurchaseButton
@onready var _margin_1 = $UpgradeTooltipContainer/MarginContainer/UpgradeText_VBox/__margin_1
@onready var _margin_2 = $UpgradeTooltipContainer/MarginContainer/UpgradeText_VBox/__margin_2

var _level_labels = []
var current_level = 0 
var _config = null
var _shop_controller: ShopController = null
var _unlock_lines = []

var level_config = []

var is_max_level: bool:
	get: 
		return current_level == len(level_config)

var next_level:
	get:
		if is_max_level:
			return null
		return level_config[current_level]

var center:
	get:
		return Vector2(position.x + size.x / 2.0, position.y + size.y / 2.0)

func _ready() -> void:
	current_level = GameState.current_upgrade_levels[upgrade_id]
	_shop_controller = ShopCC.get_shop_controller(self)
	_config = ShopCC.get_upgrade_config(upgrade_id)
	
	_initilize_level_labels()
	
	upgrade_title_txt.text = _config.title
	upgrade_tooltip_container.visible = false
	
	var level_idx = 0
	
	for level in _config.levels:
		for unlock_id in level.unlocks:
			_unlock_lines.append({
				level=level_idx, 
				unlock_id=unlock_id 
			})
	
	level_config = _config.levels
	
	self.text = _config.button_node_label
	
	_update_labels_for_current_lvl()
	
	if is_first_upgrade == false:
		hide()

func _initilize_level_labels(): 
	var level_labels = []
	for level in _config.levels:
		if len(level_labels) == 0:
			level_description_txt.text = _level_description(level.value)
			level_labels.append({ level = 0, label = level_description_txt})
		else:
			var new_label = level_description_txt.duplicate() as RichTextLabel
			new_label.text = _level_description(level.value)
			upgrade_text_v_box.add_child(new_label)
			level_labels.append({ level = level_labels.size(), label = new_label})
	_level_labels = level_labels

func _update_labels_for_current_lvl():
	for item in _level_labels:
		if item.level >= current_level:
			item.label.modulate = Color(255, 255, 255, 0.5)
		else:
			item.label.modulate = Color(255, 255, 255, 1)
		
		if is_max_level:
			item.label.modulate = Color(255, 255, 0, 1)
	
	if is_max_level:
		purchase_button.hide()
		_margin_1.hide()
		_margin_2.hide()
		
		# TODO: Create a new theme for max-upgrades.. then just reference that file
		var max_style_box = StyleBoxFlat.new()
		max_style_box.set_corner_radius_all(3)
		max_style_box.bg_color = Color.GREEN_YELLOW
		
		self.add_theme_color_override("font_color", Color.BLACK)
		self.add_theme_color_override("font_focus_color", Color.BLACK)
		self.add_theme_color_override("font_pressed_color", Color.BLACK)
		self.add_theme_color_override("font_hover_color", Color.BLACK)
		self.add_theme_stylebox_override("normal", max_style_box)
		var hover_box = max_style_box.duplicate()
		hover_box.bg_color = Color.YELLOW
		self.add_theme_stylebox_override("hover", hover_box)
	else:
		purchase_button.text = str(next_level.cost) + " kg"

func _level_description(value):
	if upgrade_id == ShopCC.UpgradeID.GRAVITY_1:
		return "- gravity multi +" + str(int((value - 1) * 100)) + "%"
	if upgrade_id == ShopCC.UpgradeID.AOE_1:
		return "- area of effect +" + str(int((value - 1) * 100)) + "%"
	if upgrade_id == ShopCC.UpgradeID.SPEED_1 \
		or upgrade_id == ShopCC.UpgradeID.SPEED_2 \
		or upgrade_id == ShopCC.UpgradeID.SPEED_3 \
		or upgrade_id == ShopCC.UpgradeID.SPEED_4:
			return "- speed +" + str(int((value - 1) * 100)) + "%"
	if upgrade_id == ShopCC.UpgradeID.MASS_EFFICENCY_1:
		return "- mass efficiency +" + str(int((value - 1) * 100)) + "%"
	if upgrade_id == ShopCC.UpgradeID.PASSIVE_MASS_1:
		return "- passive mass +" + str(int((value - 1) * 100)) + "%"
	if upgrade_id == ShopCC.UpgradeID.MAX_ZOOM:
		return "- max zoom: " + str(value) + "x"
	return "NOT_SET"

# TODO: Need an input listener if they click outside of the tooltip to close the tooltip

func hide_tooltip():
	upgrade_tooltip_container.visible = false

func update_after_purchase_success(_new_level):
	current_level = _new_level
	_update_labels_for_current_lvl()

func _on_purchase_button_pressed() -> void:
	if is_max_level: return
	_shop_controller.try_purchase_upgrade(self)

func _on_upgrade_node_clicked() -> void:
	if upgrade_tooltip_container.visible:
		hide_tooltip()
	else:
		get_parent().hide_all_tooltips()
		upgrade_tooltip_container.visible = !upgrade_tooltip_container.visible
