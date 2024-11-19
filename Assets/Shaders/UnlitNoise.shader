Shader "GAT350/UnlitNoise"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float random(float2 st) 
			{
				return frac(sin(dot(st.xy,
					float2(12.9898,78.233))) * 43758.5453123);
			}
 
			float2 random2(float2 st)
			{
				st = float2(dot(st,float2(127.1,311.7)),
						   dot(st,float2(269.5,183.3)));
				return -1.0 + 2.0 * frac(sin(st) * 43758.5453123);
			}
 
			float valueNoise(float2 st) 
			{
				float2 i = floor(st);
				float2 f = frac(st);
				// Four corners
				float a = random(i);
				float b = random(i + float2(1.0, 0.0));
				float c = random(i + float2(0.0, 1.0));
				float d = random(i + float2(1.0, 1.0));
 
				// Smooth interpolation
				float2 u = f * f * (3.0 - 2.0 * f);
 
				// Mix
				return lerp(a, b, u.x) +
						(c - a)* u.y * (1.0 - u.x) +
						(d - b) * u.x * u.y;
			}

            v2f vert (appdata v)
            {
                v2f o;

                // float2 r = random2(v.uv + _Time.x) * 0.1;
                // v.vertex.xyz = v.vertex.xyz + float3(r.x, r.y, 0);

                float r = valueNoise(v.vertex.xy + _Time.y * 5);
                v.vertex.xyz = v.vertex.xyz + v.normal.xyz * r;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 color1 = tex2D(_MainTex, i.uv);

                float r = random(i.uv + _Time.y);
                fixed4 color2 = fixed4(r, r, r, 1);

                fixed4 color = lerp(color1, color2, 0.5);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, color);
                return color;
            }
            ENDCG
        }
    }
}
