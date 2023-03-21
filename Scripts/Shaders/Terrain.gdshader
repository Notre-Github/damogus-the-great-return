shader_type spatial;

uniform sampler2D _a;
uniform sampler2D heightmap;
uniform float height_ratio = 1.0;

void fragment() {
	ALBEDO = texture(_a, UV).rgb;
}

void vertex() {
	VERTEX.y += texture(heightmap, UV).r * height_ratio;
}