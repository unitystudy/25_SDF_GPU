Shader "SDF/ApproxDistShader"
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
			Name "Approx distance distance"

			CGPROGRAM

			#include "UnityCustomRenderTexture.cginc"

			#pragma vertex CustomRenderTextureVertexShader
			#pragma fragment frag

			sampler2D _MainTex;

			inline float2 GetGradient(float2 uv)
			{
				float dx = 1.0 / _CustomRenderTextureWidth;
				float dy = 1.0 / _CustomRenderTextureHeight;

				float diag1 =
					- tex2D(_MainTex, uv + float2(-dx, +dy)).a
					+ tex2D(_MainTex, uv + float2(+dx, -dy)).a;
				float diag2 =
					- tex2D(_MainTex, uv + float2(-dx, -dy)).a
					+ tex2D(_MainTex, uv + float2(+dx, +dy)).a;

				float r = tex2D(_MainTex, uv + float2(+dx, 0)).a;
				float l = tex2D(_MainTex, uv + float2(-dx, 0)).a;
				float u = tex2D(_MainTex, uv + float2(0, +dy)).a;
				float b = tex2D(_MainTex, uv + float2(0, -dy)).a;
				return float2(
					+diag1 + diag2 + (r - l) * 1.41421356237,
					-diag1 + diag2 + (u - b) * 1.41421356237);
			}

			inline float ApproximateDistance(float2 grad, float a)
			{
				grad = abs(normalize(grad));

				float gx = grad.x;
				float gy = grad.y;

				grad.xy = float2(max(gx, gy), min(gx, gy));

				gx = grad.x;
				gy = grad.y;

				float a1 = 0.5 * gy / gx;
				if (a < a1)
				{
					return 0.5 * (gx + gy) - sqrt(2 * gx * gy * a);
				}
				if (a < (1 - a1))
				{
					return (0.5 - a) * gx;
				}
				return -0.5 * (gx + gy) + sqrt(2 * gx * gy * (1 - a));
			}

			float3 frag(v2f_customrendertexture i) : SV_Target
			{
				float2 uv = i.globalTexcoord;
				float alpha = tex2D(_MainTex, uv).a;

				float2 grad = GetGradient(uv);

				bool isEdge =
					(0.001 < alpha && alpha < 0.999) ||   // 0 < alpha < 1 か
					(2.5 <= length(grad));				// はっきりしたエッジ (adhoc)

				float2 distance = isEdge //エッジじゃなかったら無限の距離にアサインする
					? normalize(grad) * ApproximateDistance(grad, alpha)
					: 10000000.0;

				return float3(
					distance,
					(alpha < 0.5) ? -1.0 : 1.0 // シェイプの中か外の情報
					);
			}

			ENDCG
		}
	}
}

