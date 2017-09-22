Shader "Custom/myGaussian" {
	Properties{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
	_BlurSize("Blur Size", Float) = 1.0
	}
		SubShader{
		CGINCLUDE

#include "UnityCG.cginc"

		sampler2D _MainTex;
	half4 _MainTex_TexelSize;
	float _BlurSize;

	struct v2f {
		float4 pos : SV_POSITION;
		half2 xUV[5] : TEXCOORD0;
		half2 yUV[5] : TEXCOORD6;
	};

	v2f vertBlur(appdata_img v) {
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);

		half2 uv = v.texcoord;

		o.yUV[0] = uv;
		o.yUV[1] = uv + float2(0.0, _MainTex_TexelSize.y * 1.0) * _BlurSize;
		o.yUV[2] = uv - float2(0.0, _MainTex_TexelSize.y * 1.0) * _BlurSize;
		o.yUV[3] = uv + float2(0.0, _MainTex_TexelSize.y * 2.0) * _BlurSize;
		o.yUV[4] = uv - float2(0.0, _MainTex_TexelSize.y * 2.0) * _BlurSize;

		o.xUV[0] = uv;
		o.xUV[1] = uv + float2(_MainTex_TexelSize.x * 1.0, 0.0) * _BlurSize;
		o.xUV[2] = uv - float2(_MainTex_TexelSize.x * 1.0, 0.0) * _BlurSize;
		o.xUV[3] = uv + float2(_MainTex_TexelSize.x * 2.0, 0.0) * _BlurSize;
		o.xUV[4] = uv - float2(_MainTex_TexelSize.x * 2.0, 0.0) * _BlurSize;

		return o;
	}

	fixed4 fragBlur(v2f i) : SV_Target{
		float weight[3] = { 0.4026, 0.2442, 0.0545 };

	fixed3 sum = tex2D(_MainTex, i.yUV[0]).rgb * weight[0];

	for (int t = 1; t < 3; t++) {
		sum += tex2D(_MainTex, i.yUV[t * 2 - 1]).rgb * weight[t];
		sum += tex2D(_MainTex, i.yUV[t * 2]).rgb * weight[t];
	}

	for (int it = 1; it < 3; it++) {
		sum += tex2D(_MainTex, i.xUV[it * 2 - 1]).rgb * weight[it];
		sum += tex2D(_MainTex, i.xUV[it * 2]).rgb * weight[it];
	}

	return fixed4(sum, 1.0f);
	}

		ENDCG
		Pass {
		NAME "GAUSSIAN_BLUR"
			CGPROGRAM

			#pragma vertex vertBlur
			#pragma fragment fragBlur

			ENDCG
	}
	}
		FallBack "Diffuse"
}

