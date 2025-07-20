extends GPUParticles3D
#@onready var initial_particle_size = draw_pass_1.height

func multiplier_particle_size(multiplier):
	#draw_pass_1.height = initial_particle_size*multiplier
	#draw_pass_1.radius = draw_pass_1.height/2
	
	scale = multiplier*Vector3.ONE
	pass
func _process(delta: float) -> void:

	pass
