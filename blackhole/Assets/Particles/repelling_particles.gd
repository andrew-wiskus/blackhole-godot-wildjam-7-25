extends GPUParticles3D
@onready var initial_particle_size = draw_pass_1.size

func multiplier_particle_size(multiplier):
	draw_pass_1.size = initial_particle_size*multiplier
	
	scale = multiplier*Vector3.ONE
	pass
