Shader "Vq3/Blur Filter"
{
    Properties
    {
        _PTex("Position Map", 2D) = "" {}
        _CTex("Color Map", 2D) = "" {}
    }
    SubShader
    {
        Pass
        {
            Name "Update"

            CGPROGRAM

            #include "UnityCustomRenderTexture.cginc"
            #pragma vertex CustomRenderTextureVertexShader
            #pragma fragment Fragment

            sampler2D _PTex;
            sampler2D _CTex;

            float4 _PTex_TexelSize;
            float4 _CTex_TexelSize;

            float4 Fragment(v2f_customrendertexture input) : COLOR
            {
                float2 uv = input.localTexcoord.xy;
                float dx = _PTex_TexelSize.x;

                float2 uv1 = float2(uv.x - dx * 3, uv.y);
                float2 uv2 = float2(uv.x - dx * 2, uv.y);
                float2 uv3 = float2(uv.x - dx    , uv.y);
                float2 uv4 = float2(uv.x         , uv.y);
                float2 uv5 = float2(uv.x + dx    , uv.y);
                float2 uv6 = float2(uv.x + dx * 2, uv.y);
                float2 uv7 = float2(uv.x + dx * 3, uv.y);

                float4 p1 = tex2D(_PTex, uv1);
                float4 p2 = tex2D(_PTex, uv2);
                float4 p3 = tex2D(_PTex, uv3);
                float4 p4 = tex2D(_PTex, uv4);
                float4 p5 = tex2D(_PTex, uv5);
                float4 p6 = tex2D(_PTex, uv6);
                float4 p7 = tex2D(_PTex, uv7);

                float m1 = tex2D(_CTex, uv1).w;
                float m2 = tex2D(_CTex, uv2).w;
                float m3 = tex2D(_CTex, uv3).w;
                float m4 = tex2D(_CTex, uv4).w;
                float m5 = tex2D(_CTex, uv5).w;
                float m6 = tex2D(_CTex, uv6).w;
                float m7 = tex2D(_CTex, uv7).w;

                float4 acc =
                    p1 * m1 * 0.005980 +
                    p2 * m2 * 0.060626 +
                    p3 * m3 * 0.241843 +
                    p4 * m4 * 0.383103 +
                    p5 * m5 * 0.241843 +
                    p6 * m6 * 0.060626 +
                    p7 * m7 * 0.005980;

                 return acc.w < 0.001 ? p4 : float4(acc.xyz / acc.w, 1);
             }

            ENDCG
        }
    }
}
