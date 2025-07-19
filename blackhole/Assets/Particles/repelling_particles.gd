extends GPUParticles3D
@onready var initial_particle_size = draw_pass_1.radius

func multiplier_particle_size(multiplier):
	draw_pass_1.radius = initial_particle_size*multiplier/20
	draw_pass_1.height = 2*draw_pass_1.radius
	if process_material:
		process_material.set("emission_sphere_radius", multiplier)
	pass
