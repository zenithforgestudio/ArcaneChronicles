shader_type canvas_item;

uniform float outline_width : hint_range(1, 10) = 1.0;

void fragment() {
    vec4 current_color = texture(TEXTURE, UV);

    // Initialize outline color to white
    vec4 outline_color = vec4(1.0, 1.0, 1.0, 1.0);

    // Start with transparent (black) color for all pixels
    vec4 result_color = current_color;

    // If the current pixel is transparent, check surrounding pixels
    if (current_color.a == 0.0) {
        for (float x = -outline_width; x <= outline_width; x++) {
            for (float y = -outline_width; y <= outline_width; y++) {
                if (x == 0.0 && y == 0.0) continue; // Skip the center pixel

                vec2 offset = vec2(x, y) * TEXTURE_PIXEL_SIZE;
                vec4 neighbor_color = texture(TEXTURE, UV + offset);

                if (neighbor_color.a > 0.0) {
                    // If any neighboring pixel is non-transparent, set outline color
                    result_color = outline_color;
                    break;
                }
            }
            // If we already set the result color to the outline color, stop checking further pixels
            if (result_color == outline_color) {
                break;
            }
        }
    }

    // Set the final pixel color
    COLOR = result_color;
}
