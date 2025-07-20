shader_type spatial;
render_mode unshaded, cull_disabled; // you can re-add depth_draw_alpha_prepass if you really need it

uniform sampler2D tex : source_color;
uniform vec2   center       = vec2(0.5);
uniform float feather      : hint_range(0.0, 1.0) = 0.05;
uniform float aspect_ratio = 2.0;      // width / height of the texture
uniform float scroll_speed : hint_range(-5.0, 5.0) = 1.0; // UV units/sec

float circle_mask(vec2 uv, vec2 c, float f) {
    vec2 o = uv - c;
    o.x *= aspect_ratio;
    return smoothstep(0.5, 0.5 - f, length(o));
}

void fragment() {
    vec2 uv_static = UV;
    // infinite scroll via fract – no clamp hack
    float x = fract(uv_static.x + TIME * scroll_speed);
    vec2 uv_scroll = vec2(x, uv_static.y);

    vec4 col = texture(tex, uv_scroll);
    float m   = circle_mask(uv_static, center, feather);

    ALBEDO = col.rgb;
    ALPHA  = col.a * m;
}