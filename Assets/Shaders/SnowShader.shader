Shader "Custom/SnowShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Bump("Bump", 2D) = "bump" {}
		_Snow("Level of snow", Range(1, -1)) = 1
		_SnowColor("Color of snow", Color) = (1,1,1,1)
		_SnowDirection("Direction of snow", Vector) = (0,1,0)
		_SnowDepth("Depth of snow", Range(0,1)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Bump;
		float _Snow;
		float4 _SnowColor;
		float4 _SnowDirection;
		float _SnowDepth;

		struct Input {
			float2 uv_MainTex;
			float2 uv_Bump;
			float3 worldNormal;
			INTERNAL_DATA
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));
			
			if(dot(WorldNormalVector(IN, o.Normal), _SnowDirection.xyz) >= _Snow)
			    o.Albedo = _SnowColor;
            else 
                o.Albedo = c.rgb * _Color;
			
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		
		void vert(inout appdata_full v) {
		    float4 sn = mul(UNITY_MATRIX_IT_MV, _SnowDirection);
		    if(dot(v.normal, sn.xyz) >= _Snow) 
		        v.vertex.xyz += (sn.xyz + v.normal) * _SnowDepth * _Snow;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
