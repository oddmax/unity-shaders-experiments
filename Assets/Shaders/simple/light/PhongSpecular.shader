Shader "Custom/PhongSpecular" {
	Properties {
		_MainTint ("Maint tint", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SpecularColor("Specular color", Color) = (1,1,1,1)
		_SpecularPower("Specular power", Range(0,30)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Phong

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
		
		fixed4 LightingPhong (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
		    //Reflection
		    float NdotL = dot(s.Normal, lightDir);
		    float3 reflectionVector = normalize(2.0 * s.Normal * NdotL - lightDir);
		    
		    //Specular
		    float spec = pow(max(0, dot(reflectionVector, viewDir)), _SpecularPower);
		    float3 finalSpec = _SpecularColor * spec;
		    
		    //Final effect
		    fixed4 c;
		    c.rgb = ((s.Albedo * _LightColor0.rgb * max(0, NdotL)) + (_LightColor0.rgb * finalSpec)) * (atten);
		    c.a = s.Alpha;
		    
		    return c;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
