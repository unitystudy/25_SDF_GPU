Shader "Unlit/MSUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Samples("Sampling count", Range(0, 100)) = 10.0
        _Radius("radius", Range(0, 100)) = 10.0
        _Color("Color", Color) = (0.2, 1.0, 0.3, 1)
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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MainTex_TexelSize;
            int _Samples;
            float _Radius;
            float4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float alpha = tex2D(_MainTex, i.uv).a;
            if (0.5 < alpha)discard;

                for (int l = 0; l < _Samples; l++) {
                    float c = cos(2.0 * 3.1415926535 * l / _Samples);
                    float s = sin(2.0 * 3.1415926535 * l / _Samples);
                    alpha += tex2D(_MainTex, i.uv + _MainTex_TexelSize.xy * _Radius * float2(c, s)).a;
                }

                if (alpha < 0.5)discard;

                return _Color;
            }
            ENDCG
        }
    }
}
