extends Node3D
var year = 0

func _on_timer_timeout() -> void:
	year+=1
	$Label.text = "Year: " + str(year)
	pass # Replace with function body.
func set_seconds_per_year(spy):
	$Timer.wait_time = spy
