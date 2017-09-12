Shader "Custom/myToon" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RampTex("Ramp Map", 2D) = "white" {}
		_CelShadingLevels("Cel Level", Range(0, 10)) = 2.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Toon

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
		void surf(Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}

		sampler2D _RampTex;
		half _CelShadingLevels;
		fixed4 LightingToon(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			half NdotL = dot(s.Normal, lightDir);
			NdotL = tex2D(_RampTex, fixed2(NdotL, 0.5));
			half cel = floor(NdotL * _CelShadingLevels) / (_CelShadingLevels - 0.5);//Snap


			fixed4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * cel * atten * 2;
			c.a = s.Alpha;

			return c;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
