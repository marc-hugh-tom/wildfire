shader_type canvas_item;

uniform float r_rand : hint_range(0.0, 1.0);
uniform float g_rand : hint_range(0.0, 1.0);
uniform float b_rand : hint_range(0.0, 1.0);

void fragment(){
	vec4 col = texture(TEXTURE, UV);
	COLOR = vec4(col.r+r_rand, col.g+g_rand, col.b+b_rand, col.a);
}
