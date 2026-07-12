shader_type canvas_item;

uniform vec4 fruit_color: source_color;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (COLOR.r < 0.1 && COLOR.b < 0.1 && COLOR.g < 0.1)
	{
		COLOR.rgb = fruit_color.rgb;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
