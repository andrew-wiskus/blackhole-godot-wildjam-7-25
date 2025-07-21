extends Control

@export var main_scene_path: String = "res://main.tscn"
#@onready var progress_bar: ProgressBar = $ProgressBar  # Optional progress bar
@onready var loading_label: Label =  $PanelContainer/Panel/Label    # Optional loading text

var loading_status: ResourceLoader.ThreadLoadStatus
var progress: Array = []
var label_locked = false
func _ready():
	# Start loading the main scene in background
	ResourceLoader.load_threaded_request(main_scene_path)
	
	# Optional: Start with fade-in
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)

func _process(_delta):
	# Check loading progress
	loading_status = ResourceLoader.load_threaded_get_status(main_scene_path, progress)
	
	# Update progress bar if you have one
	#if progress_bar:
		#progress_bar.value = progress[0] * 100
	
	# Update loading text if you have one
	if loading_label and !label_locked:
		loading_label.text = "Loading... " + str(int(progress[0] * 100.0)) + "%"
		if progress[0] * 100.0 >= 100.0:
			lock_label()
	
	# Check if loading is complete
	if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
		_on_loading_complete()
func lock_label():
	label_locked = true
	
func _on_loading_complete():
	# Get the loaded scene
	var loaded_scene = ResourceLoader.load_threaded_get(main_scene_path)
	
	# Optional: Add a small delay to show 100% completion
	await get_tree().create_timer(3).timeout
	
	# Optional: Fade out before switching
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	
	# Change to the main scene
	get_tree().change_scene_to_packed(loaded_scene)
