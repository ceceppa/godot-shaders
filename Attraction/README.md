# Attractor showcase

Open `attractor.tscn` and run the current scene (F6). Use **Forward+** for the intended glow, screen-space reflections and ambient occlusion. The project-wide startup scene and environment are unchanged. A 16:9 viewport, such as 1280 × 720 or 1920 × 1080, matches the composition.

The existing Inner and Outer CSG spheres now live under `Attractor`, floating above a low metallic pedestal. The scene adds a cyan edge inlay, a procedural panel floor, dark background with distance fog, cyan local lighting, amber rim lighting, soft cool fill, and a 42° camera with negative space to the right. There are 44 slow orbital motes and seven short-lived outward accents, with fade ramps and zero gravity. Both systems are prewarmed so the scene starts alive. No external textures, attracted object, supporting runtime script or large asset pack is required.

## Tweak controls

| Look | Inspector location / parameter |
| --- | --- |
| Core intensity and contrast | Attractor/Inner → material override → `emission_strength` (1.8), `base_color`, `hot_color` |
| Core animation | Inner material → `pulse_speed`, `pulse_amount`, `swirl_speed`, `band_speed` |
| Shell brightness and visibility | Attractor/Outer → material override → `emission_strength` (2.8), `alpha_strength` (0.35), `fresnel_power` (3.5) |
| Shell motion | Outer material → `distortion_amount` (0.035), `wave_speed`, `pulse_amount` |
| Bloom spread / threshold | Environment/WorldEnvironment → Glow → intensity (0.65), strength (0.85), HDR threshold (1.2) |
| Cyan illumination and reflection | Attractor/AttractorLight → energy (1.6), range (4.5), attenuation (1.6) |
| Warm contrast | Lighting/WarmRimLight → energy (1.2), color |
| Floor reflectivity | Environment/Floor → material override → `roughness` (0.32), `metalness` (0.55) |
| Floor panels | Floor material → `panel_strength` (0.08), `panel_spacing` (1.8 world units) |
| Atmospheric depth | WorldEnvironment → Fog → density (0.018), light energy (0.35) |
| Pedestal edge brightness | Display/CyanInlay → material override → emission energy (2.0) |
| Particle density / speed | Each GPUParticles3D → amount, lifetime; process material → orbit velocity, radial acceleration |
| Particle brightness / size | Draw pass mesh → material → `intensity`; mesh size and process material scale |
| Framing | Camera3D → position, rotation, FOV (42°) |

Overall brightness is controlled independently by the core/shell shader strengths, Glow settings, and the cyan light energy. Start with shader intensity to retain core detail, then bloom, then environmental illumination. Raising the light alone brightens the pedestal and floor without brightening the orb. Screen-space reflections have the usual limitations for transparent objects and surfaces outside the camera view; the cyan light provides a consistent local connection to the floor.

## Materials and shader integration

- `showcase_surface.gdshader`: shared lit procedural surface for floor and pedestal; subtle smooth noise in albedo/roughness and optional antialiased panel lines. The panel pattern has no emission and appears through surface lighting.
- `energy_mote.gdshader`: camera-facing soft additive particle discs, HDR intensity and particle lifetime alpha. Uses no texture.
- Pedestal inlay: built-in emissive StandardMaterial3D. Particle motion: built-in ParticleProcessMaterial with color ramps.
- Existing attractor shader designs remain intact. A small integration fix sends their calculated HDR energy to `ALBEDO`, because [Godot's unshaded mode uses albedo](https://docs.godotengine.org/en/4.7/tutorials/shaders/shader_reference/spatial_shader.html). The core also no longer writes `ALPHA = 1.0`, keeping it in the opaque pipeline. Swirl, bands, pulse, field displacement and Fresnel calculations are preserved. Scene material values tune the core contrast and replace the shell's green edge with cyan.

## Validation

Loaded and rendered in Godot 4.7.1 on macOS using Metal Forward+, with no runtime or shader errors. A 1280 × 720 render was visually inspected for framing, sphere clearance, core/shell separation, particle visibility and floor lighting. `git diff --check` passes.
