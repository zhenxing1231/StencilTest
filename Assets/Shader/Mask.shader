Shader "Custom/Mask"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _StencilID("Stencil Ref",float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)] _SComp("Stencil Comp",Float) = 8
        [Enum(UnityEngine.Rendering.StencilOp)] _SPass("Stencil Pass",Float) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _SFail("Stencil Fail",Float) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _SZFail("Stencil ZFail",Float) = 0
        _ReadMask("Stencil ReadMask",float) = 255
        _WriteMask("Stencil WriteMask",float) = 255
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        ColorMask 0
        ZWrite off
        Stencil
        {
            Ref [_StencilID]
            Comp [_SComp]
            pass [_SPass]
            Fail [_SFail]
            ZFail [_SZFail]
            ReadMask [_ReadMask]
            WriteMask [_WriteMask]
        }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
