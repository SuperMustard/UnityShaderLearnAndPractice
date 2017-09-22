// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/showDepth" {
	SubShader{
		Tags{ "RenderType" = "Opaque" }
		LOD 200

		pass {
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma vertex vert
		#pragma fragment frag

		sampler2D _CameraDepthTexture;

		struct a2v {
			float4 vertex : POSITION;
			float4 texcoord : TEXCOORD0;
		};

		struct v2f {
			float4 pos : SV_POSITION;
			float4 uv : TEXCOORD0;
		};

		v2f vert(a2v IN) {
			v2f o;
			o.pos = UnityObjectToClipPos(IN.vertex);
			o.uv = IN.texcoord;
			return o;
		}

		float4 frag(v2f IN) : COLOR{
			float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, IN.uv);
		float linearDepth = Linear01Depth(depth);
		return float4 (linearDepth, linearDepth, linearDepth, 1.0);
		}

			ENDCG
	}
	}
		FallBack "Diffuse"
}
