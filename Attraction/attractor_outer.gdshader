shader_type spatial;
render_mode blend_mix, depth_draw_never, cull_back;

uniform vec4 edge_color : source_color = vec4(0.08, 0.65, 1.0, 1.0);
uniform vec4 glow_color : source_color = vec4(0.7, 1.0, 1.0, 1.0);
uniform float fresnel_power = 3.5;
uniform float alpha_strength = 0.65;
uniform float emission_strength = 1.8;
uniform float wave_scale = 10.0;
uniform float wave_speed = 2.0;
uniform float distortion_amount = 0.035;
uniform float pulse_speed = 2.5;
uniform float pulse_amount = 0.15;
varying vec3 local_position;

void vertex() {
    local_position = VERTEX;
    float wave = sin(VERTEX.x * wave_scale + TIME * wave_speed) *
        sin(VERTEX.y * wave_scale * 0.7 + TIME * wave_speed * 1.2) *
        sin(VERTEX.z * wave_scale * 1.3 + TIME * wave_speed * 0.8);
    VERTEX += NORMAL * wave * distortion_amount;
}
void fragment() {
    float fresnel = pow(1.0 - clamp(dot(normalize(NORMAL), normalize(VIEW)), 0.0, 1.0), fresnel_power);
    vec3 p = local_position * wave_scale;
    float turbulence = sin(p.x * 1.6 + sin(p.z * 2.3 + TIME * 0.7)) * sin(p.y * 1.8 - TIME * 0.5);
    float filaments = pow(1.0 - abs(turbulence), 18.0);
    float grain = sin(p.x * 55.0) * sin(p.y * 61.0) * sin(p.z * 57.0);
    float pulse = 1.0 + sin(TIME * pulse_speed) * pulse_amount;
    ALBEDO = mix(vec3(0.12, 0.19, 0.27), edge_color.rgb, filaments * 0.2);
    METALLIC = 0.25;
    ROUGHNESS = 0.42 + grain * 0.045;
    EMISSION = mix(edge_color.rgb, glow_color.rgb, fresnel) *
        (fresnel * 0.8 + filaments * 0.2) * emission_strength * pulse;
    // A visible body across the whole surface, with a denser luminous rim.
    ALPHA = clamp(alpha_strength * (0.55 + fresnel * 0.45 + filaments * 0.12), 0.0, 0.95);
}
