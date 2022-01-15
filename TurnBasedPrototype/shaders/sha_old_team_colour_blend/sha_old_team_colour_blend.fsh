//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 u_team_colour;
uniform float u_mix;
uniform float u_highlight_mix;
uniform vec4 u_highlight_colour;

void main()
{
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	// Check if the value is a grayscale one
	if (gl_FragColor.r==gl_FragColor.g && gl_FragColor.g==gl_FragColor.b && gl_FragColor.a>0.0){ 
		//execute team_colour blend
		vec4 team_colour = mix(u_team_colour, gl_FragColor.rgba , u_mix);
		gl_FragColor = team_colour;
		
	}
	if (gl_FragColor.a>0.0){
		vec4 final_colour = mix(gl_FragColor.rgba,u_highlight_colour, u_highlight_mix);
		gl_FragColor = final_colour;
	}
	
	
}
