#version 140

// VBO-ból érkező változók
in vec3 vs_in_pos;
in vec3 vs_in_norm;
in vec2 vs_in_tex;

// a pipeline-ban tovább adandó értékek
out vec3 vs_out_pos;
out vec3 vs_out_norm;
out vec2 vs_out_tex;

// shader külső paraméterei
uniform mat4 MVP;
uniform mat4 world;
uniform mat4 worldIT;
uniform sampler2D heiImage;

void main()
{

	vec4 textureColor = texture(heiImage, vs_in_tex);
	vec3 dir = normalize(vs_in_pos);
	float h = (textureColor.y - 0.5F) / 3;

	gl_Position = MVP * vec4( vs_in_pos + dir * h , 1 );

	vs_out_pos = (world * vec4(vs_in_pos, 1)).xyz;
	vs_out_norm = (worldIT * vec4(vs_in_norm, 0)).xyz;
	vs_out_tex = vs_in_tex;
}
