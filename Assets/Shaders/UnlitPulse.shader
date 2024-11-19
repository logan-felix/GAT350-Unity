Shader "GAT350/UnlitPulse"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _PulseSpeed ("Pulse Speed", Float) = 1.0
        _PulseStrength ("Pulse Strength", Float) = 0.1
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
            float _PulseSpeed;
            float _PulseStrength;

            v2f vert (appdata v)
            {
                v2f o;

                // Compute the pulse effect using sine wave
                float pulse = 1.0 + _PulseStrength * sin(_Time.y * _PulseSpeed);

                // Apply the pulse effect to the vertex position
                v.vertex.xyz *= pulse;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // Apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
