Shader "Unlit/EdgeUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Width("width", Range(0, 20)) = 10.0
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
            float _Width;
            float4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 sdf = tex2D(_MainTex, i.uv);
                float dist = sdf.z * length(sdf.xy);

                if (dist < -_Width || _Width <= dist) discard;

                return _Color;
            }
            ENDCG
        }
    }
}
