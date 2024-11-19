Shader "GAT350/UnlitWave&Ripple"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        [Header(Shader Info)] 
        [Space(20)]

        // Transparency Properties
        [Toggle] _TranspActive ("Transparency Active", Float) = 1
        _Transparency ("Transparency", Range(0.0, 1.0)) = 1.0

        // Wave Properties
        _WaveAmplitude ("Amplitude", Range(0, 2)) = 0
        _WaveRate ("Rate", Range(0, 2)) = 0
        _WaveLength ("Length", Range(0, 2)) = 0

        // Ripple Properties
        _RippleColor ("Ripple Color", Color) = (1, 1, 1, 1)
        _RippleSpeed ("Ripple Speed", Float) = 1.0
        _RippleFrequency ("Ripple Frequency", Float) = 2.0
        _RippleAmplitude ("Ripple Amplitude", Float) = 0.1
        _RippleHeight ("Ripple Height", Float) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }

        // Help from ChatGPT to fix transparency issues
        Tags { "Queue"="Overlay" } // Set render queue for transparency
        Blend SrcAlpha OneMinusSrcAlpha // Standard transparency blend mode
        ZWrite Off // Disable writing to depth buffer for transparent objects

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

            // Properties
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _RippleColor;

            // Transparency Properties
            float _Transparency;
            float _TranspActive;

            // Ripple Properties
            float _RippleSpeed;
            float _RippleFrequency;
            float _RippleAmplitude;
            float _RippleHeight;

            // Wave Properties
            float _WaveAmplitude;
            float _WaveRate;
            float _WaveLength;

            v2f vert (appdata v)
            {
                v2f o;

                // Ripple
                float2 rippleCenter = float2(0.5, 0.5);
                float dist = distance(v.vertex.xz, rippleCenter);
                float ripple = sin(dist * _RippleFrequency - _Time.y * _RippleSpeed) * _RippleHeight;

                // Wave
                float wave = sin((_Time.y * _WaveRate) + (v.vertex.x * _WaveLength)) * _WaveAmplitude;

                v.vertex.y += ripple + wave;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 color = tex2D(_MainTex, i.uv);
                color.a = (_TranspActive) ? _Transparency : 1.0;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, color);
                return color;
            }
            ENDCG
        }
    }
}
