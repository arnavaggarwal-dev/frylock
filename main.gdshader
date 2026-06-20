shader_type spatial;

uniform float soggy_factor : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D noise_tex : hint_default_white;
uniform sampler2D albedo_tex : source_color;
uniform sampler2D roughness_tex;
uniform sampler2D normal_tex : hint_normal;
void vertex() {
	// t goes from 0.0 (bottom) to 1.0 (top)
	float t = (VERTEX.y + 1.0) / 2.0;
	
	// 7 degree tilt toward user (along Z axis)
	float tilt_rad = 0.349066; // 7 degrees in radians
	VERTEX.z += VERTEX.y * sin(tilt_rad);
	VERTEX.y *= cos(tilt_rad);
	
	// Sogginess droop — sags toward user (Z forward) as it gets soggy
	float droop_strength = t * t * soggy_factor;
	VERTEX.z += droop_strength * 0.9;
	VERTEX.y -= droop_strength * 0.3;
	
	// Surface bumpiness — flattens as soggy
	vec2 uv = UV * 4.0;
	float noise = texture(noise_tex, uv).r;
	VERTEX += NORMAL * noise * 0.04 * (1.0 - soggy_factor);
}

void fragment() {
    vec2 uv = UV * 4.0;
    float noise = texture(noise_tex, uv).r;
    
    // Crispy golden color
    vec3 crispy_color = vec3(0.85, 0.58, 0.1) + noise * vec3(0.1, 0.05, 0.0);
    // Soggy pale color
    vec3 soggy_color = vec3(0.72, 0.65, 0.45);
    
    ALBEDO = mix(crispy_color, soggy_color, soggy_factor);
    ROUGHNESS = mix(0.35, 0.85, soggy_factor) + noise * 0.1;
    METALLIC = 0.0;
    
    // Slight subsurface-ish warm glow on crispy
    EMISSION = mix(vec3(0.08, 0.04, 0.0), vec3(0.0), soggy_factor) * (1.0 - noise * 0.5);
}