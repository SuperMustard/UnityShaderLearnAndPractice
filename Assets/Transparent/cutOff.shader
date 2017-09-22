// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/NewSurfaceShader" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_CutOff ("Smoothness", Range(0,1)) = 0.5
	}
		SubShader{
			Tags { "Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType" = "TransparentCutout" }
			LOD 200

			pass {
				Tags{"LightMode" = "ForwardBase"}
				CGPROGRAM

				#pragma vertex vert
				#pragma fragment frag
				#include "Lighting.cginc"

				sampler2D _MainTex;
				fixed _CutOff;
				float4 _MainTex_ST;

				struct a2v {
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					float4 texcoord : TEXCOORD;
				};

				struct v2f {
					float4 pos : SV_POSITION;
					float2 uv : TEXCOORD;
				};

				v2f vert(a2v IN) {
					v2f o;
					o.pos = UnityObjectToClipPos(IN.vertex);
					o.uv = TRANSFORM_TEX(IN.texcoord, _MainTex);

					return o;
				}

				float4 frag(v2f IN) : COLOR{
					fixed4 texColor = tex2D(_MainTex, IN.uv);
					clip(texColor.a - _CutOff);
					float4 color = float4(texColor.rgb, 1.0);
					return color;
				}

			ENDCG
			}
		}
	FallBack "Diffuse"
}
