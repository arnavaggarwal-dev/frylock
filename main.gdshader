shader_type spatial;

uniform float soggy_factor : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D noise_tex : hint_default_white;

void vertex() {
    // Curve the fry along its length
    float t = VERTEX.x; // -1 to 1 along the fry length
    VERTEX.y += sin(t * 3.14159) * 0.18; // gentle arc upward in middle
    VERTEX.y += sin(t * 6.0) * 0.03;     // slight wiggle
    
    // Surface bumpiness from noise
    vec2 uv = UV * 4.0;
    float noise = texture(noise_tex, uv).r;
    VERTEX += NORMAL * noise * 0.03 * (1.0 - soggy_factor);
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