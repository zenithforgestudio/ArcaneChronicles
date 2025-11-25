shader_type canvas_item;

uniform float time;

const vec3 color_palette[7] = vec3[](
    vec3(1.0, 0.51, 0.45),     // #ff8274
    vec3(0.835, 0.235, 0.416), // #d53c6a
    vec3(0.486, 0.094, 0.235), // #7c183c
    vec3(0.274, 0.055, 0.169), // #460e2b
    vec3(0.192, 0.02, 0.12),   // #31051e
    vec3(0.121, 0.02, 0.063),  // #1f0510
    vec3(0.078, 0.008, 0.031)  // #130208
);

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // Calculate the distance from the center of the texture
    vec2 center = vec2(0.5, 0.5);
    float distance = length(UV - center); // Distance from the center

    // Normalize distance to the range [0, 1]
    float normalized_distance = clamp(distance * 2.0, 0.0, 1.0); // Scale by 2 for larger variation

    // Calculate the color index and blend factor
    float scaled = normalized_distance * float(color_palette.length() - 1);
    int idx1 = int(floor(scaled));         // Lower bound color index
    int idx2 = min(idx1 + 1, 6);           // Upper bound color index (capped at the last color)

    // Blend between the two colors
    float blend = scaled - float(idx1);    // Calculate blend factor between idx1 and idx2
    vec3 col = mix(color_palette[idx1], color_palette[idx2], blend);

    // Apply the color to the output
    COLOR = vec4(col, texture(TEXTURE, UV).a);
}
