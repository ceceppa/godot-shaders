shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never, cull_disabled;
uniform vec4 energy_color : source_color = vec4(0.12, 0.75, 1.0, 1.0);
uniform float intensity : hint_range(0.0, 10.0) = 2.0;
void vertex() {
    // Camera-facing quads, preserving the size supplied by the particle system.
    MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
    MODELVIEW_MATRIX[0].xyz *= length(MODEL_MATRIX[0].xyz);
    MODELVIEW_MATRIX[1].xyz *= length(MODEL_MATRIX[1].xyz);
    MODELVIEW_MATRIX[2].xyz *= length(MODEL_MATRIX[2].xyz);
}
void fragment() {
    float radius = length(UV * 2.0 - 1.0);
    float halo = pow(max(1.0 - radius, 0.0), 2.5);
    EMISSION = energy_color.rgb * intensity;
    ALBEDO = energy_color.rgb * intensity;
    ALPHA = halo * COLOR.a;
}
