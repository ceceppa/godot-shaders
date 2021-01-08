shader_type canvas_item;

const float BORDER_SIZE = 0.02;
const float NOISE_BORDER_SIZE = 0.05;

uniform sampler2D texture2;
uniform sampler2D noiseTexture;
uniform float noise_speed = 1.;
uniform vec4 borderColor: hint_color = vec4(1.);
 
const vec3 GRAY_COLOR = vec3(0.299, 0.587, 0.114);

float circle(vec2 uv, vec2 position, float radius) {
	float d = distance(position, uv);

	return 1. - clamp(d / radius, 0., 1.);
}

float easeInQuad(float x) {
	return x * x;
}

void fragment() {
	float radius = abs(2. * fract(TIME / 6.));
	radius = easeInQuad(radius);
	float shape = circle(UV, vec2(1.0), radius);
	float shape2 = shape + BORDER_SIZE;

	vec4 color1 = texture(TEXTURE, UV);
	vec4 color2 = texture(texture2, UV);
	
	float r = 0.1;
	vec2 st = UV;
	st.x = st.x - r * sin(TIME / noise_speed);
	st.y = st.y - r * cos(TIME / noise_speed);
	vec4 noise = texture(noiseTexture, st);

	float noiseVal = noise.r * shape;
	float noiseVal2 = noise.r * shape2;
	float s1 = step(noiseVal, NOISE_BORDER_SIZE);
	float s2 = step(noiseVal2, NOISE_BORDER_SIZE);

	vec4 border1 = (1. - s1) * vec4(1., 0., 0., 1.);
	vec4 border2 = (1. - s2) * vec4(1.) - border1;

	vec4 c3 = mix(color2, color1, s1);
	vec4 c4 = mix(c3, border2 * borderColor, border2.r);
	
	COLOR = c4;
}
