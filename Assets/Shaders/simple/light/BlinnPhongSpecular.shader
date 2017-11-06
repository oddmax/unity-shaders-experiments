Shader "Custom/BlinnPhongSpecular" {
	Properties {
		_MainTint ("Main tint", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SpecularColor("Specular color", Color) = (1,1,1,1)
		_SpecularPower("Specular power", Range(0,30)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf CustomBlinnPhong

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

        float4 _SpecularColor;
        float _SpecularPower;
        float4 _MainTint;
        
		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		
		fixed4 LightingCustomBlinnPhong (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
		    //Reflection
		    float NdotL = max(0, dot(s.Normal, lightDir));
		    
		    //Specular
		    float3 halfVector = normalize(lightDir + viewDir);
		    float NdotH = max(0, dot(s.Normal, halfVector));
		    float spec = pow(NdotH, _SpecularPower) * _SpecularColor;
		    
		    //Final effect
		    fixed4 c;
		    c.rgb = (s.Albedo * _LightColor0.rgb * atten) + (_LightColor0.rgb * _SpecularColor.rgb * spec);
		    c.a = s.Alpha;
		    
		    return c;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
