Shader "SDF/Ssed8Shader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_SamplingScale("Sampling Scale", Range(1,81)) = 1.0
	}
	SubShader
	{
		Cull Off
		ZWrite Off
		ZTest Always

		Pass
		{
			Name "SSED8 Filtering"

			CGPROGRAM

			#include "UnityCustomRenderTexture.cginc"

			#pragma vertex CustomRenderTextureVertexShader
			#pragma fragment frag

			sampler2D _MainTex;
			float _SamplingScale;

			float3 frag(v2f_customrendertexture i) : SV_Target
			{
				float2 uv = i.globalTexcoord;
				float dx = _SamplingScale / _CustomRenderTextureWidth;
				float dy = _SamplingScale / _CustomRenderTextureHeight;

				float3 t = tex2D(_MainTex, uv);
				float3 ret = t;
				float length2 = dot(t.xy, t.xy);

				float2 duv;
				float l2;

				duv = float2(-dx, -dy);
				t = tex2D(_MainTex, uv + duv) + float3(duv * _CustomRenderTextureWidth, 0);	
				l2 = dot(t.xy, t.xy); if (l2 < length2) { length2 = l2; ret = t;}

				duv = float2(-dx, 0);
				t = tex2D(_MainTex, uv + duv) + float3(duv * _CustomRenderTextureWidth, 0);	
				l2 = dot(t.xy, t.xy); if (l2 < length2) { length2 = l2; ret = t; }

				duv = float2(-dx, +dy);
				t = tex2D(_MainTex, uv + duv) + float3(duv * _CustomRenderTextureWidth, 0);	
				l2 = dot(t.xy, t.xy); if (l2 < length2) { length2 = l2; ret = t; }

				duv = float2(0, -dy);
				t = tex2D(_MainTex, uv + duv) + float3(duv * _CustomRenderTextureWidth, 0); 
				l2 = dot(t.xy, t.xy); if (l2 < length2) { length2 = l2; ret = t; }

				duv = float2(0, +dy);
				t = tex2D(_MainTex, uv + duv) + float3(duv * _CustomRenderTextureWidth, 0);	
				l2 = dot(t.xy, t.xy); if (l2 < length2) { length2 = l2; ret = t; }

				duv = float2(+dx, -dy);
				t = tex2D(_MainTex, uv + duv) + float3(duv * _CustomRenderTextureWidth, 0);	
				l2 = dot(t.xy, t.xy); if (l2 < length2) { length2 = l2; ret = t; }

				duv = float2(+dx, 0);
				t = tex2D(_MainTex, uv + duv) + float3(duv * _CustomRenderTextureWidth, 0);	
				l2 = dot(t.xy, t.xy); if (l2 < length2) { length2 = l2; ret = t; }

				duv = float2(+dx, +dy);
				t = tex2D(_MainTex, uv + duv) + float3(duv * _CustomRenderTextureWidth, 0);	
				l2 = dot(t.xy, t.xy); if (l2 < length2) { length2 = l2; ret = t; }

				return ret;
			}

			ENDCG
		}
	}
}

