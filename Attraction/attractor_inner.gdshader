shader_type spatial;
render_mode cull_back;

uniform vec4 base_color : source_color = vec4(0.015, 0.065, 0.16, 1.0);
uniform vec4 hot_color : source_color = vec4(0.15, 0.8, 1.0, 1.0);
uniform float emission_strength = 2.4;
uniform float pulse_speed = 2.2;
uniform float pulse_amount = 0.1;
uniform float swirl_scale = 8.0;
uniform float swirl_speed = 1.8;
uniform float band_scale = 10.0;
uniform float band_speed = 3.0;
varying vec3 local_position;

float hash(vec3 p) {
    return fract(sin(dot(p, vec3(127.1, 311.7, 74.7))) * 43758.5453);
}
float noise(vec3 p) {
    vec3 i = floor(p);
    vec3 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    return mix(mix(mix(hash(i), hash(i + vec3(1,0,0)), f.x),
                   mix(hash(i + vec3(0,1,0)), hash(i + vec3(1,1,0)), f.x), f.y),
               mix(mix(hash(i + vec3(0,0,1)), hash(i + vec3(1,0,1)), f.x),
                   mix(hash(i + vec3(0,1,1)), hash(i + vec3(1,1,1)), f.x), f.y), f.z);
}
void vertex() { local_position = VERTEX; }
void fragment() {
    // Object-space turbulence avoids UV seams and camera-dependent patterns.
    vec3 p = local_position * swirl_scale;
    vec3 drift = vec3(TIME * swirl_speed * 0.12, -TIME * band_speed * 0.06, 0.0);
    float cloud = noise(p + drift) * 0.65 + noise(p * 2.1 - drift) * 0.25 + noise(p * 4.3) * 0.1;
    float veins = 1.0 - smoothstep(0.008, 0.045, abs(cloud - 0.5));
    float detail = noise(p * band_scale);
    float pulse = 1.0 + sin(TIME * pulse_speed) * pulse_amount;
    ALBEDO = base_color.rgb * (0.5 + cloud) + hot_color.rgb * veins * 0.12;
    METALLIC = 0.25;
    ROUGHNESS = 0.48 + detail * 0.15;
    EMISSION = hot_color.rgb * (veins * 0.85 + cloud * 0.08) * emission_strength * pulse;
}
