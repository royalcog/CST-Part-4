varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3  u_tint;      // the shadow colour (multiplied in)
uniform float u_strength;  // 0 = no shadow, 1 = full

void main()
{
    vec4 c = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    c.rgb = mix(c.rgb, c.rgb * u_tint, u_strength);
    gl_FragColor = c;
}