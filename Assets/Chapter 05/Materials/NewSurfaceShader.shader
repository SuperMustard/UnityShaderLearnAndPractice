Shader "Custom/vertexAnim" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Speed ("Speed", Range(0, 100)) = 5
		_Frequency ("Frequency", Range(0, 5)) = 1
		_Amplitude ("Wave Amplitude", Range(-1, 1)) = 1
		_TintAmount("Tint Amount", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		float _TintAmount;
		float _Speed;
		float _Frequency;
		float _Amplitude;
		float _OffsetVal;

		struct Input {
			float2 uv_MainTex;
			float3 vertPos;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void vert(inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input, o);
			float time = _Time * _Speed;
			float waveValueA = sin(time + v.vertex.x * _Frequency) * _Amplitude;

			v.vertex.xyz = float3(v.vertex.x, v.vertex.y + waveValueA, v.vertex.z);
			v.normal = normalize(float3(v.normal.x + waveValueA, v.normal.y, v.normal.z));
			o.vertPos = float3(waveValueA, waveValueA, waveValueA);
		}

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
