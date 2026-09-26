shader_type canvas_item;

uniform vec4 overlay_color;

void fragment() {
	if (COLOR.a > 0.0)
		COLOR.rgb = COLOR.rgb + overlay_color.rgb * overlay_color.a;
	if (overlay_color.r < 0.1 && COLOR.a > 0.0)
		COLOR.rgba = overlay_color;
}
