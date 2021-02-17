shader_type spatial;
render_mode cull_disabled;

uniform sampler2D texture;
uniform sampler2D blendTexture;
uniform sampler2D noiseTexture;

uniform float offset = 0.;
uniform bool up = true;
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
uniform vec2 textureUVScale = vec2(1.);

const float tao = 2. * 3.14;

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
	float waveFrequency1 = waveFrequency;
	float waveFrequency2 = waveFrequency + 2. - wavePhase;
	float waveFrequency3 = waveFrequency + 3. - wavePhase;
	
	position.y += waveAmplitude * (sin(x / waveFrequency1) + sin(x / waveFrequency2) + sin(x / waveFrequency3));
	position.y += (noise.r * noiseInfluence);

	float direction = up ? 1. : -1.;
	float upperBorder = smoothstep(offset, offset, (position.y * direction) + 1.);
	float bottomBorder = smoothstep(offset, offset, (position.y * direction) - borderHeight + 1.);
	float borderPart = upperBorder - bottomBorder;

	vec4 color = mix(blend, borderColor, upperBorder);
	color = mix(color, text, bottomBorder);
	
	ALBEDO = color.rgb;

	if (!FRONT_FACING) {
		ALBEDO = borderColor.rgb;
		NORMAL = VIEW;
	}

	ALPHA = color.a;
	ALPHA_SCISSOR = 1.0;
	EMISSION = vec3(borderPart) * borderColor.rgb * emissionIntensity;
}
