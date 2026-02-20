shader_type spatial;

render_mode blend_mix, depth_draw_always;
// The viewport texture from your simulation
//uniform sampler2D wave_texture : source_color, filter_linear;
uniform float height_scale = 1.0;
uniform vec3 albedo_color : source_color = vec3(0.3, 0.3, 1.0); // Default Red
uniform float roughness : hint_range(0.0, 1.0) = 0.2;
uniform float specular_strength : hint_range(0.0, 1.0) = 0.5;

uniform float opacity : hint_range(0.0, 1.0) = 0.5;

void vertex() {
	// 1. Fetch the displacement value from the simulation texture.
	// Since the simulation usually stores data in the Red channel:
	float h = VERTEX.y; //texture(wave_texture, UV).r;
	
	// 2. Apply the height to the local Y coordinate.
	VERTEX.y += h * height_scale;
	
	// 3. Optional: Recalculate normals if you want smooth lighting.
	// For a simple red color, we can skip complex normal math, 
	// but the mesh will look "flat" without it.
}

void fragment() {
	// Set the color to Red
	ALBEDO = albedo_color;
	ROUGHNESS = roughness;
	
	ALPHA = opacity;
	
	//float h = texture(wave_texture, UV).r;
	ALBEDO *= (1.0 + 0. * 0.5); 
}

void light() {
	// 1. Diffuse lighting (Lambertian)
	// dot(NORMAL, LIGHT) tells us how much light hits the surface head-on
	float dot_nl = clamp(dot(NORMAL, LIGHT), 0.0, 1.0);
	DIFFUSE_LIGHT += LIGHT_COLOR * ALBEDO.rgb * dot_nl * ATTENUATION;
	
	// 2. Specular lighting (Blinn-Phong)
	// This creates the shiny highlight on the red surface
	vec3 half_vector = normalize(VIEW + LIGHT);
	float dot_nh = clamp(dot(NORMAL, half_vector), 0.0, 1.0);
	
	// Higher roughness makes the specular spot wider and dimmer
	float shininess = (1.0 - roughness) * 128.0;
	float spec = pow(dot_nh, shininess) * specular_strength;
	
	SPECULAR_LIGHT += LIGHT_COLOR * spec * ATTENUATION;
}