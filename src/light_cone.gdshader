shader_type canvas_item;
render_mode world_vertex_coords;

uniform vec2 pos;
uniform vec2 fwd_vec; // normalized
uniform float rads;

varying vec2 world_position;

void vertex() {
	world_position = VERTEX;
}

void fragment() {
	vec2 pixel_vec = normalize(world_position - pos);
	float PdotF = dot(fwd_vec, pixel_vec);
	float angle = acos(PdotF / 1.0);
	
	if (angle > rads) {
		COLOR = vec4(0, 0, 0, 0);
	} else {
		COLOR *= vec4(1, 1, 0, 1);
	}
}
