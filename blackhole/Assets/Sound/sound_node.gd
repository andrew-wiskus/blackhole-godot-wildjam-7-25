class_name AudioController extends Node3D

@export var sfx_pitch_variation_range: float = 0.2

func play_mass_consumed_sound():
	# Random pitch between 0.8 and 1.2 (if range is 0.2)
	var random_pitch = 1.0 + randf_range(-sfx_pitch_variation_range, sfx_pitch_variation_range)
	$On_Mass_Consumed_Sound.pitch_scale = random_pitch
	$On_Mass_Consumed_Sound.play()
	
