shader_type spatial;

uniform sampler2D texture;
uniform sampler2D blendTexture;
uniform sampler2D noiseTexture;

uniform float offset = 0.;
uniform vec4 borderColor: hint_color = vec4(1., 1., 0., 1.);
uniform float borderHeight = 0.1;
uniform float waveAmplitude = 1.;
uniform float waveFrequency = 1.;
uniform float wavePhase = 0.1;
uniform float emissionIntensity = 1.;
uniform float noiseSpeed = .01;
uniform float noiseInfluence = 1.;

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
	vec4 text = texture(texture, UV);
	vec4 blend = texture(blendTexture, UV * blendUVScale);

	vec2 st = UV;
	st.y -= TIME * noiseSpeed;
	vec4 noise = texture(noiseTexture, st * noiseUVScale);

	float x = tao * position.x;
	position.y += waveAmplitude * (sin(x / waveFrequency) + sin(x / (waveFrequency + 2.) - wavePhase) + sin(x / (waveFrequency + 3.) - wavePhase));
	position.y += (noise.r * noiseInfluence);

	float upperBorder = smoothstep(offset, offset, 1. - position.y);
	float upperSmoothBorder = smoothstep(offset - 0.2, offset - 0.2, 1. - position.y);
	float bottomBorder = smoothstep(offset, offset, 1. - position.y - borderHeight);
	float borderPart = upperBorder - bottomBorder;

	vec4 color = mix(blend, borderColor, upperBorder);
	color = mix(color, text, bottomBorder);
	
	ALBEDO = color.rgb;
	ALPHA = color.a;
	ALPHA_SCISSOR = 1.0;
	EMISSION = vec3(borderPart) * borderColor.rgb * emissionIntensity;
}
