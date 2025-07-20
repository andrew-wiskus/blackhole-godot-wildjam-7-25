class_name ShopUI_ScrollController extends ScrollContainer

@onready var shop_ui_container: ColorRect = $ShopUI_Layout
var is_scrolling = false

func _ready() -> void:
	await get_parent().ready
	scroll_to_center()

func scroll_to_center():
	var centered_bg = Vector2(shop_ui_container.size.x / 2 - size.x / 2, shop_ui_container.size.y / 2 - size.y / 2)
	self.scroll_horizontal = centered_bg.x
	self.scroll_vertical = centered_bg.y


func update_scroll(movement: Vector2):
	scroll_horizontal -= movement.x
	scroll_vertical -= movement.y


func _on_shop_ui_layout_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		is_scrolling = event.pressed

	if event is InputEventMouseMotion and is_scrolling:
		update_scroll(event.relative)
