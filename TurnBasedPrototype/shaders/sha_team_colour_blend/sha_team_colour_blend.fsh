//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 u_team_colour;
uniform float u_mix;
uniform float u_highlight_mix;
uniform vec4 u_highlight_colour;

// All components are in the range [0…1], including hue.
vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

 
// All components are in the range [0…1], including hue.
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}


void main()
{
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	// Check if the value is a grayscale one
	if (gl_FragColor.r==gl_FragColor.g && gl_FragColor.g==gl_FragColor.b && gl_FragColor.a>0.0){ 
		//execute team_colour blend
		vec3 pixel_hsv = rgb2hsv(gl_FragColor.rgb);
		vec3 team_hsv = rgb2hsv(u_team_colour.rgb);
		float value_difference = float(sign(pixel_hsv.z - team_hsv.z));
		float hue_shift = value_difference*0.02;
		float saturation_shift = -1.0*value_difference*0.01;
		
		vec3 modified_team_hsv=vec3(team_hsv.x+hue_shift, team_hsv.y+saturation_shift, pixel_hsv.z);
		vec3 modified_team_rgb= hsv2rgb(modified_team_hsv);
		vec4 team_colour = vec4(modified_team_rgb.r, modified_team_rgb.g, modified_team_rgb.b, gl_FragColor.a);
		//vec4 team_colour = mix(u_team_colour, gl_FragColor.rgba , u_mix);
		gl_FragColor = team_colour;
		
	}
	if (gl_FragColor.a>0.0){
		vec4 final_colour = mix(gl_FragColor.rgba,u_highlight_colour, u_highlight_mix);
		gl_FragColor = final_colour;
	}
}



