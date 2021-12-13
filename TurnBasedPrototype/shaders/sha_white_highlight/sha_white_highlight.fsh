//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_highlight_mix;
uniform vec4 u_highlight_colour;

void main()
{
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	if (gl_FragColor.a>0.0){
		vec4 final_colour = mix(gl_FragColor.rgba,u_highlight_colour, u_highlight_mix);
		gl_FragColor = final_colour;
	}
	
}
