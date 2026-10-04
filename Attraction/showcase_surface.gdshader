shader_type spatial;
uniform vec4 surface_color : source_color = vec4(0.018, 0.026, 0.04, 1.0);
uniform float metalness : hint_range(0.0, 1.0) = 0.65;
uniform float roughness : hint_range(0.0, 1.0) = 0.36;
uniform float panel_strength : hint_range(0.0, 1.0) = 0.15;
uniform float panel_spacing = 1.5;
varying vec3 world_position;
void vertex() {
    world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), f.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0)), f.x), f.y);
}
void fragment() {
    vec2 p = world_position.xz;
    vec2 grid = abs(fract(p / panel_spacing + 0.5) - 0.5) * panel_spacing;
    float distance_to_line = min(grid.x, grid.y);
    float aa = max(fwidth(distance_to_line), 0.001);
    float line = 1.0 - smoothstep(0.008, 0.008 + aa, distance_to_line);
    float grain = noise(p * 12.0) * 2.0 - 1.0;
    ALBEDO = surface_color.rgb * (1.0 - line * panel_strength + grain * 0.008);
    METALLIC = metalness;
    ROUGHNESS = clamp(roughness + grain * 0.012 + line * 0.1, 0.0, 1.0);
}
