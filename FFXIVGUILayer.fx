//is a Subtle UIMask for FF14,OR MORE GAME,Subtle
//for UTwelve
//
// This is free and unencumbered software released into the public domain.
// 
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.
// 
// 
// order ：
// TOP: FFKeepUI
//      FFblackUI    <-BLACK MASK
//      **you shaders**
//LAST: FFRestoreUI
// good lucky
//


#include "ReShade.fxh"


texture FFKeepUI_Tex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
sampler FFKeepUI_black { Texture = FFKeepUI_Tex; };
sampler FFKeepUI_Sampler { Texture = FFKeepUI_Tex; };


void PS_FFKeepUI(float4 pos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target)

{
	 color = tex2D(ReShade::BackBuffer, texcoord) ;
}

void PS_FFblackUI(float4 pos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target)
{
	float4 A =tex2D(ReShade::BackBuffer, texcoord) ;
	float4 B =tex2D(FFKeepUI_Sampler, texcoord) ;
	color = B-A;
}

void PS_FFRestoreUI(float4 pos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target)
{
	color = tex2D(FFKeepUI_Sampler, texcoord);
}



technique FFKeepUI <
	ui_tooltip = "Keep the colors of screen into the texture for restoring colors of UI when executing FFRestoreUI.";
	enabled = true;
>
{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_FFKeepUI;
		RenderTarget = FFKeepUI_Tex;
		BlendEnable = true;
		ClearRenderTargets = false;
	}
}

technique FFblackUI <
	ui_tooltip = " FFKeepUI.";
	enabled = true;
>
{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_FFblackUI;

		ClearRenderTargets = false;
		BlendEnable = true;

		SrcBlend = SRCALPHA;
		DestBlend = INVSRCALPHA;
	}
}

technique FFRestoreUI <
	ui_tooltip = "Restore the colors of UI (include HUD) using the texture of screen kept when executing FFKeepUI.";
	enabled = true;
>
{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_FFRestoreUI;

		ClearRenderTargets = false;
		BlendEnable = true;

		SrcBlend = SRCALPHA;
		DestBlend = INVSRCALPHA;
	}
}
