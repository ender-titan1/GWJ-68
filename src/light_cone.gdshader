shader_type canvas_item;
render_mode world_vertex_coords;

uniform vec2 pos;
uniform vec2 fwd_vec; // normalized
uniform float rads;
uniform float range;
uniform vec4 color : source_color;

varying vec2 world_position;

void vertex() {
	world_position = VERTEX;
}

void fragment() {
	vec2 px_vec = world_position - pos;
	vec2 n_px_vec = normalize(px_vec);
	float len_sq = pow(px_vec.x, 2) + pow(px_vec.y, 2);
	float max_len_sq = pow(range, 2);
	
	vec4 out_color = texture(TEXTURE, UV);
	
	if (len_sq > max_len_sq) {
		out_color *= vec4(0, 0, 0, 0);
	}
	
	float PdotF = dot(fwd_vec, n_px_vec);
	float angle = acos(PdotF / 1.0);
	
	if (angle > rads) {
		out_color = vec4(0, 0, 0, 0);
	} else {
		out_color *= color;
	}
	
	COLOR = out_color;
}
