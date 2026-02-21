shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform vec2 tv_screen_size = vec2(1152.0, 648.0); // The pixel size of your UI/Screen
uniform float target_res = 64.0;                   // The "crunchy" resolution
uniform float extreme_res = 16.0;

uniform float pixel_progress : hint_range(0.0, 2.0) = 0.0; // 0 = Normal, 1 = Pixelated
uniform float color_progress : hint_range(0.0, 1.0) = 0.0; // 0 = Normal, 1 = Pixelated
uniform vec3 flash_color : source_color = vec3(1.0, 1.0, 1.0);

void fragment() {
    float aspect = tv_screen_size.x / tv_screen_size.y;
    bool is_green = flash_color.g > flash_color.r;
    
    vec2 current_res;
    
    if (is_green) {
        float plateau = clamp(1.0 - abs(pixel_progress * 1.35 - 1.0), 0.0, 20.0);
        
        float smooth_plateau = smoothstep(0.0, 1.0, plateau);
		
        float crunch_level = mix(tv_screen_size.y, extreme_res, smooth_plateau);
        current_res = vec2(crunch_level * aspect, crunch_level);
    } else {
        // RED LOGIC: Normal -> Target
        vec2 target_resolution = vec2(target_res * aspect, target_res);
        current_res = mix(tv_screen_size, target_resolution, pixel_progress);
    }
    
    // Pixelation Grid
    vec2 grid_uv = round(SCREEN_UV * current_res) / current_res;
    vec4 text = texture(screen_texture, grid_uv);
    
    // Dynamic Flash Color
    float brightness = (text.r + text.g + text.b) / 3.0;
    float mask = clamp((1.0 - brightness), 0.0, 1.0);
    vec3 dynamic_flash = mask * flash_color.rgb;

    text.rgb = mix(text.rgb, dynamic_flash, color_progress);
    COLOR = text;
}
//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
