shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D sprite_texture : source_color, filter_nearest;

uniform vec2 r_displacement = vec2(8.0, 0.0);
uniform vec2 g_displacement = vec2(0.0, 2.0);
uniform vec2 b_displacement = vec2(-8.0, 0.0);


void fragment() {
	vec4 original_color = texture(sprite_texture, UV);
	
	float r = texture(sprite_texture, UV + vec2(VIEWPORT_SIZE * r_displacement), 0.0).r;
	float g = texture(sprite_texture, UV + vec2(VIEWPORT_SIZE * g_displacement), 0.0).g;
	float b = texture(sprite_texture, UV + vec2(VIEWPORT_SIZE * b_displacement), 0.0).b;
	
	ALBEDO = vec3(r, g, b);
	ALPHA = original_color.a;
}
