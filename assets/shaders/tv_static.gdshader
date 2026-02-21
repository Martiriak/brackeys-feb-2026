shader_type spatial;
render_mode unshaded, blend_mix, depth_test_disabled;

uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
// Tween this from 0.0 (Full Static) to 1.0 (Invisible)
uniform float intensity : hint_range(0.0, 1.0) = 0.0; 
uniform vec2 hole_size = vec2(0.33, 0.27);
uniform float edge_softness = 0.05;
uniform float static_speed = 20.0;

// A standard pseudo-random function for shaders
float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
	vec2 uv = UV * 2.0 - 1.0;
    
    // 1. Hole Mask
    vec2 d = abs(uv) - hole_size;
    float box = length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
    float alpha_mask = smoothstep(-edge_softness, 0.0, box);
    
    // 2. Static Noise
    float time_step = floor(TIME * static_speed);
    float noise = random(UV + time_step);
    
    // 3. Output
    ALBEDO = flash_color.rgb * noise;
    
	float plateau = clamp(intensity * 1.5, 0.0, 1.0);
    // Straight linear alpha: 1.0 is visible, 0.0 is invisible
    ALPHA = alpha_mask * plateau;
}