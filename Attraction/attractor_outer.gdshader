shader_type spatial;
render_mode blend_add, depth_draw_never, cull_back, unshaded;

uniform vec4 edge_color : source_color = vec4(0.1, 0.8, 1.0, 1.0);
uniform vec4 glow_color : source_color = vec4(0.7, 1.0, 1.0, 1.0);

uniform float fresnel_power = 3.5;
uniform float alpha_strength = 0.35;
uniform float emission_strength = 3.0;

uniform float wave_scale = 10.0;
uniform float wave_speed = 2.0;
uniform float distortion_amount = 0.08;
uniform float pulse_speed = 2.5;
uniform float pulse_amount = 0.15;

void vertex() {
    float wave =
        sin(VERTEX.x * wave_scale + TIME * wave_speed) *
        sin(VERTEX.y * wave_scale * 0.7 + TIME * wave_speed * 1.2) *
        sin(VERTEX.z * wave_scale * 1.3 + TIME * wave_speed * 0.8);

    VERTEX += NORMAL * wave * distortion_amount;
}

void fragment() {
    float fresnel = pow(1.0 - dot(normalize(NORMAL), normalize(VIEW)), fresnel_power);

    float pulse = 1.0 + sin(TIME * pulse_speed) * pulse_amount;

    float flow = sin(UV.y * 20.0 - TIME * 4.0) * 0.5 + 0.5;
    vec3 color = mix(edge_color.rgb, glow_color.rgb, flow);

    // Preserve the unlit Fresnel field while supplying HDR glow.
    ALBEDO = color * fresnel * emission_strength * pulse;
    EMISSION = color * fresnel * emission_strength * pulse;
    ALPHA = fresnel * alpha_strength * pulse;
}