// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/PartGrab" {
			SubShader{
				Tags { "RenderType" = "Transparent" }
				GrabPass{"_GrabTexture"}
				LOD 200
			Pass{
				CGPROGRAM

				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				sampler2D _GrabTexture;

			struct vIn {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float4 uv : TEXCOORD0;
			};

			v2f vert(vIn IN) {
				v2f o;
				o.vertex = UnityObjectToClipPos(IN.vertex);
				o.uv = ComputeScreenPos(o.vertex);
				return o;
			}

			float4 frag(v2f IN) : COLOR {
				float4 color = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(IN.uv));
				return color;
			}

		ENDCG
		}
	}
	FallBack "Diffuse"
}
