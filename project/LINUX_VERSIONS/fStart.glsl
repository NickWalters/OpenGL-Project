varying vec3 globPosition;
varying vec3 globNormal;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform sampler2D texture;
uniform float Shininess;
uniform float texScale;

uniform vec4 LightPosition;
uniform vec4 LightPosition2;



uniform mat4 ModelView;
uniform mat4 View;



void main()
{
    //===============PART G===================//
    vec4 color;

    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition.xyz - globPosition;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -globPosition);   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(globNormal, 0.0)).xyz );

    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct;

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd*DiffuseProduct;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );

    //===============PART H===================//
    vec3 whiter = vec3(0.5, 0.5, 0.5);
    vec3  specular = Ks * (SpecularProduct + whiter);
    //===============PART H===================//

    if (dot(L, N) < 0.0 ) {
		specular = vec3(0.0, 0.0, 0.0);
    } 

    float distanceSq = length(Lvec) * length(Lvec); // Part F
    float a = 1.0;
    float b = 2.0;
    float dist = length(Lvec);
   float light = 1.0/(a + b*dist + distanceSq); //Part F
   
   //===============END OF PART G===================//

   //===============PART I===================//

    // The vector to the light from the ORIGIN    
    vec3 Lvec2 = (LightPosition2).xyz;
    float distanceSq2 = length(Lvec2) * length(Lvec2);
    float light2 = 1.0/(a + b*dist + distanceSq2);


    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L2 = normalize( Lvec2 );   // Direction to the light source
    vec3 H2 = normalize( L2 + E );  // Halfway vector

    float Kd2 = max( dot(L2, N), 0.0 );
    vec3  diffuse2 = Kd2*DiffuseProduct;

    float Ks2 = pow( max(dot(N, H2), 0.0), Shininess );

    vec3  specular2 = Ks2 * (SpecularProduct + whiter);

    if (dot(L2, N) < 0.0 ) {
    specular2 = vec3(0.0, 0.0, 0.0);
    } 

   //===============END OF PART I===================//

    //===============PART F===================//
    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    color.rgb = globalAmbient  + ambient + diffuse + specular + light + light2;
    //===============PART F===================//
    color.a = 1.0;

    gl_FragColor = color * texture2D( texture, texCoord * texScale );

}
