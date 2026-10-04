shader_type spatial;
render_mode unshaded, cull_back;

uniform vec4 base_color : source_color = vec4(0.08, 0.55, 1.0, 1.0);
uniform vec4 hot_color  : source_color = vec4(0.75, 1.0, 1.0, 1.0);

uniform float emission_strength : hint_range(0.0, 20.0) = 5.5;
uniform float pulse_speed : hint_range(0.0, 10.0) = 2.2;
uniform float pulse_amount : hint_range(0.0, 1.0) = 0.18;

uniform float swirl_scale : hint_range(0.0, 20.0) = 8.0;
uniform float swirl_speed : hint_range(0.0, 10.0) = 1.8;
uniform float band_scale  : hint_range(0.0, 30.0) = 10.0;
uniform float band_speed  : hint_range(0.0, 10.0) = 3.0;

void fragment() {
    vec3 n = normalize(NORMAL);
    vec2 uv = UV * 2.0 - 1.0;

    float angle = atan(uv.y, uv.x);
    float radial = clamp(length(uv), 0.0, 1.0);

    float swirl = sin(angle * swirl_scale - TIME * swirl_speed) * 0.5 + 0.5;
    float bands = sin((n.y + n.x) * band_scale - TIME * band_speed) * 0.5 + 0.5;

    float energy = mix(swirl, bands, 0.45);

    float pulse = 1.0 + sin(TIME * pulse_speed) * pulse_amount;

    float core_mask = smoothstep(1.0, 0.15, radial);

    vec3 color = mix(base_color.rgb, hot_color.rgb, energy);
    vec3 final_emission = color * emission_strength * pulse * (0.75 + core_mask * 0.5);

    ALBEDO = color * 0.08;
    EMISSION = final_emission;
    ALPHA = 1.0;
}