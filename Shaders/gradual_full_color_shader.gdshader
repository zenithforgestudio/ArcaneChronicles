shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0);
uniform vec4 target_color = vec4(0.835, 0.235, 0.416, 1.0);

//color variations
//    vec4(0.121, 0.019, 0.063, 1.0);
//    vec4(0.835, 0.235, 0.416, 1.0);    // #d53c6a
//    vec4(1.0, 0.509, 0.453, 1.0);      // #ff8274

void fragment() {
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(UV, center);  // Distance from the center

    // Exponentially increase the distance effect, scaling distance with a higher power for outer pixels
    float dist_factor = pow(dist, 2.0);  // You can adjust the exponent (3.0) to tweak the effect strength

    // Control how the recoloring happens based on distance (effect strength increases with distance)
    float effect_strength = smoothstep(progress * 0.3, progress, dist_factor);

    vec4 original_color = texture(TEXTURE, UV);

    // Mix the original color with the target color based on the effect strength
    vec3 final_color = mix(original_color.rgb, target_color.rgb, effect_strength);

    // Set the final color, keeping the alpha from the original texture
    COLOR = vec4(final_color, original_color.a);
}
