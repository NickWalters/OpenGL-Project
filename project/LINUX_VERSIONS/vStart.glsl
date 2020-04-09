
attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;
varying vec3 globNormal;
varying vec3 globPosition;

uniform mat4 ModelView;
uniform mat4 Projection;

void main()
{

    vec4 vpos = vec4(vPosition, 1.0);

    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vpos).xyz;
    globPosition = pos;
    
    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
    globNormal = vNormal;
}
