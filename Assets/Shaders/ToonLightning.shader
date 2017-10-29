Shader "Custom/ToonLightning" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RampTex ("Ramp", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Toon

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _RampTex;

		struct Input {
			float2 uv_MainTex;
		};


		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Alpha = c.a;
		}
		
		half4 LightingToon (SurfaceOutput s, half3 lightDir, half atten)
		{
		    half NdotL = dot(s.Normal, lightDir);
		    NdotL = tex2D(_RampTex, fixed2(NdotL, 0.5));
		    fixed4 c;
		    c.rgb = s.Albedo * _LightColor0.rgb * NdotL * atten;
		    c.a = s.Alpha;
		    return c;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
