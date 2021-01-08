shader_type spatial;
render_mode cull_disabled, specular_schlick_ggx;

uniform vec4 baseColor: hint_color = vec4(0.3058, 0.835, 0.960, 1.);
uniform float speed = 0.5;
uniform vec4 linesColor: hint_color = vec4(0.633232, 0.910156, 0.555693, 1.);
uniform float linesColorIntensity = 5.;
uniform float emissionValue = 1.;
uniform sampler2D hologramTexture;
uniform vec2 hologramTextureTiling = vec2(1., 5.);

vec2 TilingAndOffset(vec2 uv, vec2 tiling, vec2 offset) {
	return uv * tiling + offset;
}

float Fresnel(vec3 normal, vec3 view, float pow) {
	return pow(1.0 - clamp(dot(normal, view), 0.0, 1.0), pow);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 offset = vec2(TIME * speed);
	vec2 tiling = TilingAndOffset(uv, hologramTextureTiling, offset);

	vec4 noise = texture(hologramTexture, tiling);
	float fresnel = Fresnel(NORMAL, VIEW, emissionValue);

	vec4 colorLines = linesColor * vec4(vec3(linesColorIntensity), 1.);
	vec4 emission = colorLines * fresnel * noise;

	ALBEDO = baseColor.rgb;
	ALPHA = dot(noise.rgb, vec3(0.333));
	EMISSION = emission.rgb;
}
