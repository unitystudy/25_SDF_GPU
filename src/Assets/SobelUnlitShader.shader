Shader "Unlit/SobelUnlitShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }
    SubShader
    {
		Cull Off
		ZWrite Off
		ZTest Always

		Pass
		{
			Name "Sobel Filtering"

			CGPROGRAM

			#include "UnityCustomRenderTexture.cginc"

			#pragma vertex CustomRenderTextureVertexShader
			#pragma fragment frag

			sampler2D _MainTex;

			inline float2 CalcGradientSobel(float diag1, float diag2, float dh, float dv)
			{
				float gx = diag1 + diag2 + dh * 1.4142;
				float gy = diag1 - diag2 + dv * 1.4142;
				return float2(gx, -gy);
			}

			inline float2 GetGradient(float2 uv)
			{
				float diag1 =
					-tex2D(_MainTex, uv + float2(-dx, +dy)).a
					+ tex2D(_MainTex, uv + float2(+dx, -dy)).a;
				float diag2 =
					-tex2D(_MainTex, uv + float2(-dx, -dy)).a
					+ tex2D(_MainTex, uv + float2(+dx, +dy)).a;

				float right = tex2D(_MainTex, uv + float2(+dx, 0)).a;
				float left = tex2D(_MainTex, uv + float2(-dx, 0)).a;
				float down = tex2D(_MainTex, uv + float2(0, -dy)).a;
				float up = tex2D(_MainTex, uv + float2(0, +dy)).a;
				return CalcGradientSobel(diag1, diag2, right - left, down - up);
			}


			float2 frag(v2f_customrendertexture i) : SV_Target
			{
				return GetGradient(uv);
			}

			ENDCG
		}
	}
}
