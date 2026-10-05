shader_type sky;

uniform vec4 horizon_color : source_color = vec4(0.11, 0.15, 0.21, 1.0);
uniform vec4 upper_color : source_color = vec4(0.055, 0.085, 0.14, 1.0);

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
void sky() {
    float elevation = max(EYEDIR.y, 0.0);
    float gradient = smoothstep(0.0, 0.35, elevation);
    vec3 atmosphere = mix(horizon_color.rgb, upper_color.rgb, gradient);
    // Broad, soft haze variation; fade it out where the sky meets the floor fog.
    float haze = noise(EYEDIR * 7.0) * 0.7 + noise(EYEDIR * 17.0) * 0.3;
    atmosphere *= 1.0 + (haze - 0.5) * 0.45 * smoothstep(0.0, 0.18, elevation);
    COLOR = atmosphere;
}
