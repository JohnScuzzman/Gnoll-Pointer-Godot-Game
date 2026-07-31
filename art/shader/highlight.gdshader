shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Default: Red
uniform float outline_width : hint_range(0.0, 10.0) = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	 vec4 current_color = texture(TEXTURE, UV);
    vec2 texture_pixel_size = TEXTURE_PIXEL_SIZE;
    
    // If the pixel is already fully opaque, keep its original color
    if (current_color.a > 0.0) {
        COLOR = current_color;
    } else {
        // Check neighboring pixels (Up, Down, Left, Right)
        float alpha = current_color.a;
        alpha += texture(TEXTURE, UV + vec2(0.0, -texture_pixel_size.y) * outline_width).a; // Up
        alpha += texture(TEXTURE, UV + vec2(0.0, texture_pixel_size.y) * outline_width).a;  // Down
        alpha += texture(TEXTURE, UV + vec2(-texture_pixel_size.x, 0.0) * outline_width).a; // Left
        alpha += texture(TEXTURE, UV + vec2(texture_pixel_size.x, 0.0) * outline_width).a;  // Right
        
        // If any neighbor has color, apply the outline color
        if (alpha > 0.0) {
            COLOR = outline_color;
        } else {
            COLOR = current_color; // Keep transparent
        }
    }
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
