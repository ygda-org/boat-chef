shader_type canvas_item;

void fragment() {
	if (COLOR.b <= .4)
	{
		COLOR.a = 0.0;
	}
}