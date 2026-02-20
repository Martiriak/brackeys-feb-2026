shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform vec2 tv_screen_size = vec2(1152.0, 648.0); // The pixel size of your UI/Screen
uniform float target_res = 64.0;                   // The "crunchy" resolution

uniform float pixel_progress : hint_range(0.0, 1.0) = 0.0; // 0 = Normal, 1 = Pixelated
uniform float color_progress : hint_range(0.0, 1.0) = 0.0; // 0 = Normal, 1 = Pixelated

void fragment() {
    // 1. Calculate Aspect Ratio
    // This ensures that 64 pixels high matches 64 pixels wide in world-space
    float aspect = tv_screen_size.x / tv_screen_size.y;
    vec2 target_resolution = vec2(target_res * aspect, target_res);
    
	float wave_res = pixel_progress;
    // 2. Mix between full resolution and target resolution
    // When progress is 0, we use the actual screen size (no pixelation)
    // When progress is 1, we use the target_resolution (64px high)
    vec2 current_res = mix(tv_screen_size, target_resolution, wave_res);
    
    // 3. Apply the grid math
    vec2 grid_uv = round(SCREEN_UV * current_res) / current_res;
    
	vec4 text = texture(screen_texture, grid_uv);
    float brightness = (text.r + text.g + text.b) / 3.0;

    // Create the red "Flash" color based on brightness
    vec3 red_effect = vec3(clamp((1.0 - brightness), 0.0, 1.0), 0.0, 0.0);

    // Smoothly mix between the original texture and the red effect based on progress
    // This removes the "flicker" and makes the 1-second transition look seamless
    text.rgb = mix(text.rgb, red_effect, color_progress);

    COLOR = text;
}
//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
