// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/myTransparentGlass" {
Properties{
	_Color("Color", Color) = (1,1,1,1)
	_MainTex("Base ", 2D) = "white"
	_BumpMap("Bump map", 2D) = "bump" {}
	_Magnitude("Magnitude", Range(0, 1)) = 0.05
}
SubShader{
	Tags{
		"Queue" = "Transparent"
		"IgnoreProjector" = "True"
		"RenderType" = "Opaque"
	}
	GrabPass{}
	Pass {
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"

	sampler2D _MainTex;
	sampler2D _BumpMap;
	sampler2D _GrabTexture;
	half4 _Color;
	float _Magnitude;

	struct vertInput {
		float4 vertex : POSITION;
		float2 texcoord : TEXCOORD0;
	};

	struct vertOutput {
		float2 texcoord : TEXCOORD0;
		float4 vertex : POSITION;
		float4 uvgrab : TEXCOORD1;
	};

	vertOutput vert(vertInput v) {
		vertOutput o;
		o.texcoord = v.texcoord;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uvgrab = ComputeGrabScreenPos(o.vertex);
		return o;
	}

	half4 frag(vertOutput i) : COLOR{
		half4 bump = tex2D(_BumpMap, i.texcoord);
		half4 baseColor = tex2D(_MainTex, i.texcoord);
		half2 distortion = UnpackNormal(bump).rg;

		i.uvgrab.xy += distortion * _Magnitude;

		fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
		return col * baseColor * _Color;
	}

	ENDCG
	}		
}
}
