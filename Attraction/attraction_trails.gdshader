shader_type spatial;
render_mode unshaded, blend_add, cull_disabled, depth_draw_never;
uniform vec4 energy_color : source_color = vec4(0.06, 0.55, 1.0, 1.0);
void fragment() {
    float across = pow(max(1.0 - abs(UV.y * 2.0 - 1.0), 0.0), 1.5);
    float ends = smoothstep(0.0, 0.1, UV.x) * (1.0 - smoothstep(0.85, 1.0, UV.x));
    // UV.x runs from the distant end into the core.
    float head = fract(TIME * (0.85 + COLOR.r * 0.5) - COLOR.r * 7.0);
    float delta = head - UV.x;
    float streak = (1.0 - smoothstep(0.0, 0.22, delta)) * step(0.0, delta);
    ALBEDO = energy_color.rgb * (0.45 + streak * 3.0);
    // Fully transparent between moving streaks; no persistent path line.
    ALPHA = across * ends * streak * 0.75;
}
