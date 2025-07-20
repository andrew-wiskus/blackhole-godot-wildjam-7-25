shader_type spatial;
render_mode unshaded;

// Base sky color
uniform vec3 sky_color: source_color = vec3(0.05, 0.05, 0.10);
// Star color
uniform vec3 star_color: source_color = vec3(1.0, 1.0, 1.0);

// How many stars per unit (higher = more stars)
uniform float star_density: hint_range(10.0, 200.0, 1.0) = 50.0;
// Chance (0–1) that a grid cell contains a star
uniform float star_chance: hint_range(0.0, 1.0, 0.01) = 0.98;

// Twinkle controls
uniform float twinkle_speed_min: hint_range(0.1, 10.0, 0.1) = 0.5;
uniform float twinkle_speed_max: hint_range(0.1, 10.0, 0.1) = 2.0;
uniform float twinkle_intensity: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float twinkle_scale: hint_range(0.1, 10.0, 0.1) = 1.0;

// Star size controls (fraction of cell)
uniform float star_size_min: hint_range(0.0, 1.0, 0.01) = 0.02;
uniform float star_size_max: hint_range(0.0, 1.0, 0.01) = 0.06;

// Simple 2D hash for per-cell randomness
float rand2(vec2 v) {
    return fract(sin(dot(v, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
    vec3 col = sky_color;
    vec2 uv2 = UV * star_density;
    vec2 cell = floor(uv2);

    // Primary random for placement & seed
    float seed = rand2(cell);
    if (seed > star_chance) {
        // Jitter each star's center within its cell
        vec2 jitter = vec2(
            rand2(cell + vec2(5.3, 1.7)),
            rand2(cell + vec2(2.8, 7.1))
        );
        vec2 star_center = cell + jitter;
        vec2 diff = uv2 - star_center;
        float dist = length(diff);

        // Randomize size per-star
        float size = mix(star_size_min, star_size_max, rand2(cell + vec2(9.2, 3.4)));

        // Twinkle rate & brightness
        float speed = mix(twinkle_speed_min, twinkle_speed_max, rand2(cell + vec2(6.9, 4.2)));
        float phase = sin(TIME * speed + seed * twinkle_scale * TAU);
        float brightness = mix(0.0, twinkle_intensity, phase * 0.5 + 0.5);

        // Soft circular mask
        float mask = 1.0 - smoothstep(size * 0.8, size, dist);
        col += star_color * brightness * mask;
    }

    ALBEDO = col;
}