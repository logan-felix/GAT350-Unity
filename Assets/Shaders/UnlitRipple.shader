Shader "GAT350/UnlitRipple"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}      // Base texture
        _RippleColor ("Ripple Color", Color) = (1, 1, 1, 1) // Ripple tint
        _Speed ("Ripple Speed", Float) = 1.0      // Animation speed
        _Frequency ("Ripple Frequency", Float) = 2.0 // Ripple density
        _Amplitude ("Ripple Amplitude", Float) = 0.1 // Ripple intensity
        _WaveHeight ("Wave Height", Float) = 0.1  // Height of vertex displacement
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // Properties
            sampler2D _MainTex;
            float4 _RippleColor;
            float _Speed;
            float _Frequency;
            float _Amplitude;
            float _WaveHeight;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            // Vertex Shader
            v2f vert (appdata v)
            {
                v2f o;
                float time = _Time.y;

                // Calculate the distance of the vertex from the ripple center
                float2 rippleCenter = float2(0.5, 0.5);
                float2 uv = v.vertex.xz; // Assume the xz-plane for UV mapping
                float dist = distance(uv, rippleCenter);

                // Calculate the ripple offset
                float ripple = sin(dist * _Frequency - time * _Speed) * _WaveHeight;

                // Displace the vertex along the y-axis
                v.vertex.y += ripple;

                // Pass the UV and transformed vertex to the fragment shader
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            // Fragment Shader
            float4 frag (v2f i) : SV_Target
            {
                float time = _Time.y;

                // Apply UV distortion (optional, enhances the effect)
                float2 rippleCenter = float2(0.5, 0.5);
                float dist = distance(i.uv, rippleCenter);
                float ripple = sin(dist * _Frequency - time * _Speed) * _Amplitude;
                float2 rippledUV = i.uv + ripple * normalize(i.uv - rippleCenter);

                // Sample the texture
                float4 texColor = tex2D(_MainTex, rippledUV);

                // Combine the texture color with the ripple color
                return texColor * _RippleColor;
            }
            ENDCG
        }
    }
}
