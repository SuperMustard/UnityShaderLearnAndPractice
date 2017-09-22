Shader "Hidden/transparentWithDepth"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_AlphaScale("Alpha Scale", Range(0, 1)) = 0.5
	}
	SubShader
	{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" "LightMode" = "ForwardBase" }
		// No culling or depth

		Pass {
			ZWrite On
			ColorMask 0 //Color RGB | A | 0， 0表示不输出任何颜色
		}

		Pass
		{
			ZWrite Off ZTest Always //Cull Off 关闭剔除实现双面渲染
			Blend SrcAlpha OneMinusSrcAlpha //设置Blend模式 

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;
			float _AlphaScale;

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				return fixed4(col.rgb, col.a * _AlphaScale);
			}
			ENDCG
		}
	}
}
