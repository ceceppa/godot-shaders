shader_type spatial;
render_mode cull_disabled;

uniform sampler2D texture;
uniform sampler2D blendTexture;
uniform sampler2D noiseTexture;
uniform sampler2D normalTexture;

//uniform float offset = 0.;
uniform vec3 offset = vec3(0.);
uniform vec4 borderColor: hint_color = vec4(1., 1., 0., 1.);
uniform float borderHeight = 0.1;
uniform float radius = 5.;
uniform float emissionIntensity = 1.;
uniform float noiseSpeed = .01;
uniform float noiseInfluence = 1.;

uniform vec2 UVScale = vec2(1.);
uniform vec2 blendUVScale = vec2(1.);
uniform vec2 noiseUVScale = vec2(1.);

const float tao = 2. * 3.14;
const float NOISE_BORDER_SIZE = 0.2;

// https://github.com/godotengine/godot/issues/19800
uniform mat4 global_transform;

varying vec3 world_pos;

void vertex(){
    world_pos = (global_transform * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	vec3 position = world_pos;
	vec4 text = texture(texture, UV * UVScale);
	vec4 blend = texture(blendTexture, UV * blendUVScale);
	vec4 normal = texture(normalTexture, UV * UVScale);

	vec2 st = UV;
	st.y -= TIME * noiseSpeed;
	vec4 noise = texture(noiseTexture, st * noiseUVScale);

	float global_distance = distance(position, offset);
	global_distance += (noise.r * noiseInfluence);
	float border1 = global_distance > radius ? 1. : 0.;
	float border2 = global_distance > (radius + borderHeight) ? 1. : 0.;

	vec4 color = mix(blend, borderColor, border1);
	color = mix(color, text, border2);

	ALBEDO = color.rgb;

	if (!FRONT_FACING) {
		ALBEDO = borderColor.rgb;
		NORMAL = VIEW;
	}

	ALPHA = color.a;
	ALPHA_SCISSOR = 1.0;
	EMISSION = vec3(border1 - border2) * borderColor.rgb * emissionIntensity;
}
