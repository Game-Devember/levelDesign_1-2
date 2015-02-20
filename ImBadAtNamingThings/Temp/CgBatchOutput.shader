Shader "FX/SimpleWater4" { 
Properties {
	_ReflectionTex ("Internal reflection", 2D) = "white" {}
	
	_MainTex ("Fallback texture", 2D) = "black" {}	
	_BumpMap ("Normals ", 2D) = "bump" {}
				
	_DistortParams ("Distortions (Bump waves, Reflection, Fresnel power, Fresnel bias)", Vector) = (1.0 ,1.0, 2.0, 1.15)
	_InvFadeParemeter ("Auto blend parameter (Edge, Shore, Distance scale)", Vector) = (0.15 ,0.15, 0.5, 1.0)
	
	_AnimationTiling ("Animation Tiling (Displacement)", Vector) = (2.2 ,2.2, -1.1, -1.1)
	_AnimationDirection ("Animation Direction (displacement)", Vector) = (1.0 ,1.0, 1.0, 1.0)

	_BumpTiling ("Bump Tiling", Vector) = (1.0 ,1.0, -2.0, 3.0)
	_BumpDirection ("Bump Direction & Speed", Vector) = (1.0 ,1.0, -1.0, 1.0)
	
	_FresnelScale ("FresnelScale", Range (0.15, 4.0)) = 0.75	

	_BaseColor ("Base color", COLOR)  = ( .54, .95, .99, 0.5)	
	_ReflectionColor ("Reflection color", COLOR)  = ( .54, .95, .99, 0.5)	
	_SpecularColor ("Specular color", COLOR)  = ( .72, .72, .72, 1)
	
	_WorldLightDir ("Specular light direction", Vector) = (0.0, 0.1, -0.5, 0.0)
	_Shininess ("Shininess", Range (2.0, 500.0)) = 200.0	
		
	_GerstnerIntensity("Per vertex displacement", Float) = 1.0
	_GAmplitude ("Wave Amplitude", Vector) = (0.3 ,0.35, 0.25, 0.25)
	_GFrequency ("Wave Frequency", Vector) = (1.3, 1.35, 1.25, 1.25)
	_GSteepness ("Wave Steepness", Vector) = (1.0, 1.0, 1.0, 1.0)
	_GSpeed ("Wave Speed", Vector) = (1.2, 1.375, 1.1, 1.5)
	_GDirectionAB ("Wave Direction", Vector) = (0.3 ,0.85, 0.85, 0.25)
	_GDirectionCD ("Wave Direction", Vector) = (0.1 ,0.9, 0.5, 0.5)	
} 


#LINE 338


Subshader 
{ 
	Tags {"RenderType"="Transparent" "Queue"="Transparent"}
	
	Lod 500
	ColorMask RGB
	
	GrabPass { "_RefractionTex" }
	
	Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Cull Off
			
			Program "vp" {
// Vertex combos: 8
//   d3d9 - ALU: 24 to 194
//   d3d11 - ALU: 17 to 49, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GSpeed;
uniform vec4 _GSteepness;
uniform vec4 _GFrequency;
uniform vec4 _GAmplitude;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform float _GerstnerIntensity;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = gl_Vertex.w;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec3 offsets_5;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, tmpvar_4.xz);
  tmpvar_8.y = dot (_GDirectionAB.zw, tmpvar_4.xz);
  tmpvar_8.z = dot (_GDirectionCD.xy, tmpvar_4.xz);
  tmpvar_8.w = dot (_GDirectionCD.zw, tmpvar_4.xz);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_5.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_5.z = dot (tmpvar_11, tmpvar_13);
  offsets_5.y = dot (sin((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_14;
  xzVtx_14 = (tmpvar_4.xz + offsets_5.xz);
  vec3 nrml_15;
  nrml_15.y = 2.0;
  vec4 tmpvar_16;
  tmpvar_16 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_17;
  tmpvar_17 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_18;
  tmpvar_18.x = dot (_GDirectionAB.xy, xzVtx_14);
  tmpvar_18.y = dot (_GDirectionAB.zw, xzVtx_14);
  tmpvar_18.z = dot (_GDirectionCD.xy, xzVtx_14);
  tmpvar_18.w = dot (_GDirectionCD.zw, xzVtx_14);
  vec4 tmpvar_19;
  tmpvar_19 = cos(((_GFrequency * tmpvar_18) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_16.xz;
  tmpvar_20.zw = tmpvar_17.xz;
  nrml_15.x = -(dot (tmpvar_19, tmpvar_20));
  vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_16.yw;
  tmpvar_21.zw = tmpvar_17.yw;
  nrml_15.z = -(dot (tmpvar_19, tmpvar_21));
  nrml_15.xz = (nrml_15.xz * _GerstnerIntensity);
  vec3 tmpvar_22;
  tmpvar_22 = normalize(nrml_15);
  nrml_15 = tmpvar_22;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_5);
  vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 grabPassPos_24;
  vec4 o_25;
  vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_23 * 0.5);
  vec2 tmpvar_27;
  tmpvar_27.x = tmpvar_26.x;
  tmpvar_27.y = (tmpvar_26.y * _ProjectionParams.x);
  o_25.xy = (tmpvar_27 + tmpvar_26.w);
  o_25.zw = tmpvar_23.zw;
  grabPassPos_24.xy = ((tmpvar_23.xy + tmpvar_23.w) * 0.5);
  grabPassPos_24.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_22;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_25;
  xlv_TEXCOORD4 = grabPassPos_24;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _InvFadeParemeter;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
uniform vec4 _ZBufferParams;
void main ()
{
  vec4 baseColor_1;
  vec4 rtRefractions_2;
  vec3 worldNormal_3;
  vec4 bump_4;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_4.zw = tmpvar_5.zw;
  bump_4.xy = (tmpvar_5.wy - vec2(1.0, 1.0));
  vec3 tmpvar_6;
  tmpvar_6 = normalize((xlv_TEXCOORD0.xyz + ((bump_4.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_3 = tmpvar_6;
  vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_8;
  tmpvar_8.zw = vec2(0.0, 0.0);
  tmpvar_8.xy = ((tmpvar_6.xz * _DistortParams.y) * 10.0);
  vec4 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD4 + tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractions_2 = texture2DProj (_RefractionTex, tmpvar_9);
  vec4 tmpvar_11;
  tmpvar_11 = texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_8));
  float tmpvar_12;
  tmpvar_12 = (1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, tmpvar_9).x) + _ZBufferParams.w)));
  if ((tmpvar_12 < xlv_TEXCOORD3.z)) {
    rtRefractions_2 = tmpvar_10;
  };
  worldNormal_3.xz = (tmpvar_6.xz * _FresnelScale);
  baseColor_1.xyz = (mix (mix (rtRefractions_2, _BaseColor, _BaseColor.wwww), mix (tmpvar_11, _ReflectionColor, _ReflectionColor.wwww), vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_7), worldNormal_3), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_6, -(normalize((_WorldLightDir.xyz + tmpvar_7))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = clamp ((_InvFadeParemeter * ((1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w))) - xlv_TEXCOORD3.w)), 0.0, 1.0).x;
  gl_FragData[0] = baseColor_1;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 12 [unity_Scale]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 194 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c12.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r3.zw, r3.xyyw
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r2.x, r0, r0
rsq r2.z, r2.x
mul o1.xyz, r2.z, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
add r1.xyz, v0, r4
mov r1.w, v0
dp4 r3.w, r1, c1
dp4 r0.w, r1, c3
dp4 r4.x, r1, c0
mov r2.w, r0
dp4 r2.z, r1, c2
mov r4.y, -r3.w
add r0.zw, r0.w, r4.xyxy
mov r2.x, r4
mov r2.y, r3.w
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c10.x
mad o4.xy, r3.z, c11.zwzw, r0
mov r0.x, c8
mul o5.xy, r0.zwzw, c22.y
mad r0, c15, r0.x, r7.xzxz
mov o0, r2
mov o4.zw, r2
mov o5.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c9
mov o1.w, c23.y
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Vector 15 [_BumpDirection]
Vector 14 [_BumpTiling]
Vector 16 [_GAmplitude]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
Vector 17 [_GFrequency]
Vector 19 [_GSpeed]
Vector 18 [_GSteepness]
Float 13 [_GerstnerIntensity]
Matrix 8 [_Object2World] 4
Vector 2 [_ProjectionParams]
Vector 3 [_ScreenParams]
Vector 0 [_Time]
Vector 1 [_WorldSpaceCameraPos]
Matrix 4 [glstate_matrix_mvp] 4
Vector 12 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 77.33 (58 instructions), vertex: 32, texture: 0,
//   sequencer: 26,  9 GPRs, 21 threads,
// Performance (if enough threads): ~77 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaadeeaaaaadgeaaaaaaaaaaaaaaceaaaaaclmaaaaacoeaaaaaaaa
aaaaaaaaaaaaacjeaaaaaabmaaaaacigpppoadaaaaaaaabaaaaaaabmaaaaaaaa
aaaaachpaaaaabfmaaacaaapaaabaaaaaaaaabgmaaaaaaaaaaaaabhmaaacaaao
aaabaaaaaaaaabgmaaaaaaaaaaaaabiiaaacaabaaaabaaaaaaaaabgmaaaaaaaa
aaaaabjeaaacaabeaaabaaaaaaaaabgmaaaaaaaaaaaaabkcaaacaabfaaabaaaa
aaaaabgmaaaaaaaaaaaaablaaaacaabbaaabaaaaaaaaabgmaaaaaaaaaaaaablm
aaacaabdaaabaaaaaaaaabgmaaaaaaaaaaaaabmeaaacaabcaaabaaaaaaaaabgm
aaaaaaaaaaaaabnaaaacaaanaaabaaaaaaaaaboeaaaaaaaaaaaaabpeaaacaaai
aaaeaaaaaaaaacaeaaaaaaaaaaaaacbeaaacaaacaaabaaaaaaaaabgmaaaaaaaa
aaaaaccgaaacaaadaaabaaaaaaaaabgmaaaaaaaaaaaaacdeaaacaaaaaaabaaaa
aaaaabgmaaaaaaaaaaaaacdkaaacaaabaaabaaaaaaaaacfaaaaaaaaaaaaaacga
aaacaaaeaaaeaaaaaaaaacaeaaaaaaaaaaaaachdaaacaaamaaabaaaaaaaaabgm
aaaaaaaafpechfgnhaeegjhcgfgdhegjgpgoaaklaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpechfgnhafegjgmgjgoghaafpehebgnhagmgjhehfgegfaafpeheegj
hcgfgdhegjgpgoebecaafpeheegjhcgfgdhegjgpgoedeeaafpeheghcgfhbhfgf
gogdhjaafpehfdhagfgfgeaafpehfdhegfgfhagogfhdhdaafpehgfhchdhegogf
hcejgohegfgohdgjhehjaaklaaaaaaadaaabaaabaaabaaaaaaaaaaaafpepgcgk
gfgdhedcfhgphcgmgeaaklklaaadaaadaaaeaaaeaaabaaaaaaaaaaaafpfahcgp
gkgfgdhegjgpgofagbhcgbgnhdaafpfdgdhcgfgfgofagbhcgbgnhdaafpfegjgn
gfaafpfhgphcgmgefdhagbgdgfedgbgngfhcgbfagphdaaklaaabaaadaaabaaad
aaabaaaaaaaaaaaaghgmhdhegbhegffpgngbhehcgjhifpgnhghaaahfgogjhehj
fpfdgdgbgmgfaahghdfpddfpdaaadccodacodcdadddfddcodaaaklklaaaaaaaa
aaaaaaabaaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaeaaaaaadceaaebaaaiaaaaaaaaaaaaaaaaaaaaemkfaaaaaaab
aaaaaaabaaaaaaaiaaaaacjaaaaaaaahaaaapafaaaabhbfbaaacpcfcaaadpdfd
aaagpefeaaaabaebaaaabacoaaaabacpaaaaaacmaaaaaaddaaaabadfaaaaaacn
aaaabadeaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaeamjapnleaiaaaaadoccpjidaaaaaaaalpiaaaaadpiaaaaadpaaaaaa
maejapnlbaabbaahaaaabcaamcaaaaaaaaaagaaigaaobcaabcaaaaaaaaaagabe
gabkbcaabcaaaaaaaaaaeacaaaaabcaameaaaaaaaaaagacegackbcaabcaaaaaa
aaaagadagadgbcaabcaaaaaaaaaagadmaaaaccaaaaaaaaaaafpieaaaaaaaagii
aaaaaaaamiapaaaaaalbaaaacbaabdaamiahaaabaablleaakbaealaamiahaaab
aamgmaleklaeakabmiahaaabaalbleleklaeajabmiahaaafaagmmaleklaeaiab
miadaaacaameblaakbafamaamiapaaadaalmdeaakbacbeaaaabpabagaalmdegg
kbacbfadaacmababaakmaglloaagagadmiapaaabaaaaaaaaklabbbaamiapaaab
aaaamgmgilabpoppmiapaaabaaaaaaaaoiabaaaamiapaaadaanngmblilabpopp
meeaacaaaaaaaalbocaaaaadmabpaiahaaaaaalbcbbcbaadmacpaiabaabliigm
kbaeahadmaepaiagaaakdeblkbahbfadmaipaiahaakademgkbahbeadmeicacad
aakhkhgmkpaibaadmebpadahaaanahblobahacadmeimadacaapbcmmgoaahahad
miaeaaadaabkbiblpbagadacmiabaaadaalabimgpbagadacmiahaaaeaamamaaa
oaadaeaamiapaaabaamgnapiklaeagabmiapaaabaalbdepiklaeafabmiapaaae
aagmnajeklaeaeabmiapiadoaananaaaocaeaeaamiapaaabaagmkhooclaaapaf
miadaaacaamelaaaoaadacaamiapaaahaalmdeaakbacbeaamiapaaacaalmdeaa
kbacbfaamiamaaagaakmagaaoaacacaaaabpagadaaaaaaggcbbbbaahaacpagac
aaofmallkbaeppahmiapaaaaaaaaaaaaklagbbaamiamiaadaanlnlaaocaeaeaa
miamiaaeaanlnlaaocaeaeaamiahiaabacmamaaakaafabaamiapiaacaahkaaaa
kbabaoaamiapaaabaaaamgmgilaapoppbebgaaaaaablbglbkbacadaekibdaaac
aamegnmamaaeacppmiabiaadaamglbaaoaacaaaamiadiaaeaalamgaakbacppaa
miaciaadaagmgmmgklaaacaamiapaaaaaaaaaaaaoiabaaaamiapaaabaaaagmbl
ilaapoppmebdabacaalabjgmkbadbeabmecmabacaaagdblbkbadbfabmeedabaa
aalamemgkbadbeabmeimabaaaaagomblkbadbfabmiabaaaaaakhkhaaopaaabaa
miacaaaaaakhkhaaopacabaamiagaaaaaelmgmaakbaaanaamiabaaaaaalclclb
nbaaaapofibaaaaaaaaaaagmocaaaaiaaaknmaaaaamfgmgmobaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Matrix 256 [glstate_matrix_mvp]
Bind "vertex" Vertex
Vector 467 [_Time]
Vector 466 [_WorldSpaceCameraPos]
Vector 465 [_ProjectionParams]
Matrix 260 [_Object2World]
Vector 464 [unity_Scale]
Float 463 [_GerstnerIntensity]
Vector 462 [_BumpTiling]
Vector 461 [_BumpDirection]
Vector 460 [_GAmplitude]
Vector 459 [_GFrequency]
Vector 458 [_GSteepness]
Vector 457 [_GSpeed]
Vector 456 [_GDirectionAB]
Vector 455 [_GDirectionCD]
"sce_vp_rsx // 64 instructions using 12 registers
[Configuration]
8
0000004000010c00
[Defaults]
1
454 3
3f800000400000003f000000
[Microcode]
1024
00009c6c005cc00d8186c0836041fffc00019c6c005d30080186c08360419ffc
401f9c6c005c60000186c08360403f9c00059c6c005c602a8186c08360409ffc
00051c6c0040007f8106c08360403ffc00041c6c01d0600d8106c0c360405ffc
00041c6c01d0500d8106c0c360409ffc00041c6c01d0400d8106c0c360411ffc
401f9c6c00dd208c0186c0830421dfa000001c6c009cb0138289c0c36041fffc
00009c6c009ca0138289c0c36041fffc00011c6c009c902a8686c0c36041fffc
00039c6c011cd0000686c0c44421fffc00021c6c009c702f8286c0c36041fffc
00019c6c009c80050286c0c36041fffc00031c6c009c702f8086c0c36041fffc
00029c6c009c80050086c0c36041fffc00049c6c009d001010bfc0c360419ffc
00009c6c009c70089286c0c36041fffc00001c6c009c80089286c0c36041fffc
00001c6c00c000100086c08ea0219ffc00001c6c00c000010286c08ae0a07ffc
401f9c6c009ce00d8e86c0c36041ffa400001c6c009cb00d8086c0c36041fffc
00001c6c00c0000d8086c0836121fffc00009c6c004000100a86c08360419ffc
00009c6c784000010c86c0800030647c00029c6c8040003a8a86c0800031837c
00029c6c7840002b8c86c08aa028647c00039c6c804000100686c08aa029837c
00039c6c804000010886c0954024637c00019c6c8040003a8686c09fe023837c
00019c6c7840002b8886c0954024647c00019c6c79c0000d8c86c35fe022447c
00019c6c01c0000d8c86c74360411ffc00019c6c01dcc00d9086c0c360409ffc
00051c6c00c0000c0106c08301a1dffc00001c6c00c000081286c08401a19ffc
00021c6c01d0200d9486c0c360405ffc00031c6c01d0000d9486c0c360411ffc
00021c6c01d0300d9486c0c360411ffc00021c6c01d0100d9486c0c360403ffc
00019c6c009c70088086c0c36041fffc00001c6c009c80088086c0c36041fffc
00001c6c00c000100086c08ea0219ffc00001c6c00c000010686c08ae1a07ffc
00001c6c011cb00d8086c0c36121fffc00021c6c0040007f8886c08360409ffc
00031c6c004000ff8886c08360409ffc00021c6c004000000886c08360403ffc
00019c6c00c000080c86c08002219ffc00021c6c804000000c86c0800031007c
401f9c6c8040000d8886c08aa029e000401f9c6c804000558886c09540246028
00011c6c809c600e08aa80dfe023c07c00019c6c01c0000d8086c54360403ffc
00019c6c01c0000d8086c14360405ffc00011c6c009d102a848000c360409ffc
00059c6c009cf0d7068000c360415ffc00001c6c0140000c16860b4360411ffc
401f9c6c00c000080486c09541219fa8401f9c6c204000558886c0800030602c
401f9c6c009c600806aa80c360419fac401f9c6c0080000000860b436041df9d
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304 // 304 used size, 19 vars
Float 16 [_GerstnerIntensity]
Vector 176 [_BumpTiling] 4
Vector 192 [_BumpDirection] 4
Vector 208 [_GAmplitude] 4
Vector 224 [_GFrequency] 4
Vector 240 [_GSteepness] 4
Vector 256 [_GSpeed] 4
Vector 272 [_GDirectionAB] 4
Vector 288 [_GDirectionCD] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 0 [_Time] 4
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 62 instructions, 7 temp regs, 0 temp arrays:
// ALU 49 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedhflopkeeblkkhmnpjdcbmcnpmmkpmomdabaaaaaakeajaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcpaahaaaaeaaaabaapmabaaaafjaaaaae
egiocaaaaaaaaaaabdaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagiaaaaacahaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaa
beaaaaaaapaaaaaibcaabaaaacaaaaaaegiacaaaaaaaaaaabbaaaaaaegaabaaa
abaaaaaaapaaaaaiccaabaaaacaaaaaaogikcaaaaaaaaaaabbaaaaaaegaabaaa
abaaaaaaapaaaaaiecaabaaaacaaaaaaegiacaaaaaaaaaaabcaaaaaaegaabaaa
abaaaaaaapaaaaaiicaabaaaacaaaaaaogikcaaaaaaaaaaabcaaaaaaegaabaaa
abaaaaaadiaaaaajpcaabaaaabaaaaaaegiocaaaaaaaaaaabaaaaaaafgifcaaa
abaaaaaaaaaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaaaaaaaaaaoaaaaaa
egaobaaaacaaaaaaegaobaaaabaaaaaaenaaaaahpcaabaaaacaaaaaapcaabaaa
adaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaacaaaaaaegaobaaaacaaaaaa
egiocaaaaaaaaaaaanaaaaaadiaaaaajpcaabaaaaeaaaaaaegiocaaaaaaaaaaa
anaaaaaaegiocaaaaaaaaaaaapaaaaaadiaaaaaipcaabaaaafaaaaaaegaebaaa
aeaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaeaaaaaakgapbaaa
aeaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaagaaaaaaogakbaaa
afaaaaaadgaaaaafmcaabaaaagaaaaaaagaibaaaaeaaaaaadgaaaaafmcaabaaa
afaaaaaafganbaaaaeaaaaaabbaaaaahecaabaaaacaaaaaaegaobaaaadaaaaaa
egaobaaaafaaaaaabbaaaaahbcaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaa
agaaaaaaaaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaaegbcbaaaaaaaaaaa
dcaaaaakdcaabaaaacaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaa
igaabaaaacaaaaaadiaaaaaipcaabaaaaeaaaaaafgafbaaaadaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaeaaaaaaegiocaaaacaaaaaaaaaaaaaa
agaabaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaaegiocaaa
acaaaaaaacaaaaaakgakbaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaa
adaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaadaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaadaaaaaaapaaaaaibcaabaaaaeaaaaaa
egiacaaaaaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiccaabaaaaeaaaaaa
ogikcaaaaaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiecaabaaaaeaaaaaa
egiacaaaaaaaaaaabcaaaaaaegaabaaaacaaaaaaapaaaaaiicaabaaaaeaaaaaa
ogikcaaaaaaaaaaabcaaaaaaegaabaaaacaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaaaaaaaaaaoaaaaaaegaobaaaaeaaaaaaegaobaaaabaaaaaaenaaaaag
aanaaaaapcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaajpcaabaaaacaaaaaa
egiocaaaaaaaaaaaanaaaaaaegiocaaaaaaaaaaaaoaaaaaadiaaaaaipcaabaaa
aeaaaaaaegaebaaaacaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaa
acaaaaaakgapbaaaacaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaa
afaaaaaaogakbaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaaagaibaaaacaaaaaa
dgaaaaafmcaabaaaaeaaaaaafganbaaaacaaaaaabbaaaaahicaabaaaaaaaaaaa
egaobaaaabaaaaaaegaobaaaaeaaaaaabbaaaaahbcaabaaaabaaaaaaegaobaaa
abaaaaaaegaobaaaafaaaaaadgaaaaagbcaabaaaabaaaaaaakaabaiaebaaaaaa
abaaaaaadgaaaaagecaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadiaaaaai
fcaabaaaabaaaaaaagacbaaaabaaaaaaagiacaaaaaaaaaaaabaaaaaadgaaaaaf
ccaabaaaabaaaaaaabeaaaaaaaaaaaeabaaaaaahicaabaaaaaaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhccabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaf
iccabaaaabaaaaaaabeaaaaaaaaaiadpaaaaaaajhccabaaaacaaaaaaegacbaaa
aaaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaaaaaaaaa
agiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaaaaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaa
diaaaaaibcaabaaaaaaaaaaabkaabaaaadaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaahicaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdiaaaaak
fcaabaaaaaaaaaaaagadbaaaadaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaaaaaaaaamgaabaaaaaaaaaaa
dcaaaaamdcaabaaaaaaaaaaaegaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaialp
aaaaaaaaaaaaaaaapgapbaaaadaaaaaadiaaaaakdccabaaaafaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaadgaaaaafmccabaaa
aeaaaaaakgaobaaaadaaaaaadgaaaaafmccabaaaafaaaaaakgaobaaaadaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = _glesVertex.w;
  mediump vec3 vtxForAni_2;
  mediump vec3 worldSpaceVertex_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_3 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (worldSpaceVertex_3.xzz * unity_Scale.w);
  vtxForAni_2 = tmpvar_6;
  mediump vec4 amplitude_7;
  amplitude_7 = _GAmplitude;
  mediump vec4 frequency_8;
  frequency_8 = _GFrequency;
  mediump vec4 steepness_9;
  steepness_9 = _GSteepness;
  mediump vec4 speed_10;
  speed_10 = _GSpeed;
  mediump vec4 directionAB_11;
  directionAB_11 = _GDirectionAB;
  mediump vec4 directionCD_12;
  directionCD_12 = _GDirectionCD;
  mediump vec4 TIME_13;
  mediump vec3 offsets_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((steepness_9.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_16;
  tmpvar_16 = ((steepness_9.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_17;
  tmpvar_17.x = dot (directionAB_11.xy, vtxForAni_2.xz);
  tmpvar_17.y = dot (directionAB_11.zw, vtxForAni_2.xz);
  tmpvar_17.z = dot (directionCD_12.xy, vtxForAni_2.xz);
  tmpvar_17.w = dot (directionCD_12.zw, vtxForAni_2.xz);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (frequency_8 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (_Time.yyyy * speed_10);
  TIME_13 = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = cos((tmpvar_18 + TIME_13));
  mediump vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_15.xz;
  tmpvar_21.zw = tmpvar_16.xz;
  offsets_14.x = dot (tmpvar_20, tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22.xy = tmpvar_15.yw;
  tmpvar_22.zw = tmpvar_16.yw;
  offsets_14.z = dot (tmpvar_20, tmpvar_22);
  offsets_14.y = dot (sin((tmpvar_18 + TIME_13)), amplitude_7);
  mediump vec2 xzVtx_23;
  xzVtx_23 = (vtxForAni_2.xz + offsets_14.xz);
  mediump vec4 TIME_24;
  mediump vec3 nrml_25;
  nrml_25.y = 2.0;
  mediump vec4 tmpvar_26;
  tmpvar_26 = ((frequency_8.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_27;
  tmpvar_27 = ((frequency_8.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_28;
  tmpvar_28.x = dot (directionAB_11.xy, xzVtx_23);
  tmpvar_28.y = dot (directionAB_11.zw, xzVtx_23);
  tmpvar_28.z = dot (directionCD_12.xy, xzVtx_23);
  tmpvar_28.w = dot (directionCD_12.zw, xzVtx_23);
  highp vec4 tmpvar_29;
  tmpvar_29 = (_Time.yyyy * speed_10);
  TIME_24 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = cos(((frequency_8 * tmpvar_28) + TIME_24));
  mediump vec4 tmpvar_31;
  tmpvar_31.xy = tmpvar_26.xz;
  tmpvar_31.zw = tmpvar_27.xz;
  nrml_25.x = -(dot (tmpvar_30, tmpvar_31));
  mediump vec4 tmpvar_32;
  tmpvar_32.xy = tmpvar_26.yw;
  tmpvar_32.zw = tmpvar_27.yw;
  nrml_25.z = -(dot (tmpvar_30, tmpvar_32));
  nrml_25.xz = (nrml_25.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_33;
  tmpvar_33 = normalize(nrml_25);
  nrml_25 = tmpvar_33;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_14);
  highp vec4 tmpvar_34;
  tmpvar_34 = (glstate_matrix_mvp * tmpvar_1);
  highp vec4 grabPassPos_35;
  highp vec4 o_36;
  highp vec4 tmpvar_37;
  tmpvar_37 = (tmpvar_34 * 0.5);
  highp vec2 tmpvar_38;
  tmpvar_38.x = tmpvar_37.x;
  tmpvar_38.y = (tmpvar_37.y * _ProjectionParams.x);
  o_36.xy = (tmpvar_38 + tmpvar_37.w);
  o_36.zw = tmpvar_34.zw;
  grabPassPos_35.xy = ((tmpvar_34.xy + tmpvar_34.w) * 0.5);
  grabPassPos_35.zw = tmpvar_34.zw;
  tmpvar_4.xyz = tmpvar_33;
  tmpvar_4.w = 1.0;
  gl_Position = tmpvar_34;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (worldSpaceVertex_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_36;
  xlv_TEXCOORD4 = grabPassPos_35;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _InvFadeParemeter;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _ZBufferParams;
void main ()
{
  mediump vec4 reflectionColor_1;
  mediump vec4 baseColor_2;
  mediump float depth_3;
  mediump vec4 edgeBlendFactors_4;
  highp float nh_5;
  mediump vec3 h_6;
  mediump vec4 rtReflections_7;
  mediump vec4 rtRefractions_8;
  mediump float refrFix_9;
  mediump vec4 rtRefractionsNoDistort_10;
  mediump vec4 grabWithOffset_11;
  mediump vec4 screenWithOffset_12;
  mediump vec4 distortOffset_13;
  mediump vec3 viewVector_14;
  mediump vec3 worldNormal_15;
  mediump vec4 coords_16;
  coords_16 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_17;
  vertexNormal_17 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_18;
  bumpStrength_18 = _DistortParams.x;
  mediump vec4 bump_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = (texture2D (_BumpMap, coords_16.xy) + texture2D (_BumpMap, coords_16.zw));
  bump_19 = tmpvar_20;
  bump_19.xy = (bump_19.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize((vertexNormal_17 + ((bump_19.xxy * bumpStrength_18) * vec3(1.0, 0.0, 1.0))));
  worldNormal_15 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize(xlv_TEXCOORD1);
  viewVector_14 = tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23.zw = vec2(0.0, 0.0);
  tmpvar_23.xy = ((tmpvar_21.xz * _DistortParams.y) * 10.0);
  distortOffset_13 = tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = (xlv_TEXCOORD3 + distortOffset_13);
  screenWithOffset_12 = tmpvar_24;
  highp vec4 tmpvar_25;
  tmpvar_25 = (xlv_TEXCOORD4 + distortOffset_13);
  grabWithOffset_11 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractionsNoDistort_10 = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = texture2DProj (_CameraDepthTexture, grabWithOffset_11).x;
  refrFix_9 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2DProj (_RefractionTex, grabWithOffset_11);
  rtRefractions_8 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2DProj (_ReflectionTex, screenWithOffset_12);
  rtReflections_7 = tmpvar_29;
  highp float tmpvar_30;
  highp float z_31;
  z_31 = refrFix_9;
  tmpvar_30 = (1.0/(((_ZBufferParams.z * z_31) + _ZBufferParams.w)));
  if ((tmpvar_30 < xlv_TEXCOORD3.z)) {
    rtRefractions_8 = rtRefractionsNoDistort_10;
  };
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize((_WorldLightDir.xyz + viewVector_14));
  h_6 = tmpvar_32;
  mediump float tmpvar_33;
  tmpvar_33 = max (0.0, dot (tmpvar_21, -(h_6)));
  nh_5 = tmpvar_33;
  lowp float tmpvar_34;
  tmpvar_34 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth_3 = tmpvar_34;
  highp float tmpvar_35;
  highp float z_36;
  z_36 = depth_3;
  tmpvar_35 = (1.0/(((_ZBufferParams.z * z_36) + _ZBufferParams.w)));
  depth_3 = tmpvar_35;
  highp vec4 tmpvar_37;
  tmpvar_37 = clamp ((_InvFadeParemeter * (depth_3 - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors_4 = tmpvar_37;
  highp vec2 tmpvar_38;
  tmpvar_38 = (tmpvar_21.xz * _FresnelScale);
  worldNormal_15.xz = tmpvar_38;
  mediump float bias_39;
  bias_39 = _DistortParams.w;
  mediump float power_40;
  power_40 = _DistortParams.z;
  baseColor_2 = _BaseColor;
  highp vec4 tmpvar_41;
  tmpvar_41 = mix (rtReflections_7, _ReflectionColor, _ReflectionColor.wwww);
  reflectionColor_1 = tmpvar_41;
  mediump vec4 tmpvar_42;
  tmpvar_42 = mix (mix (rtRefractions_8, baseColor_2, baseColor_2.wwww), reflectionColor_1, vec4(clamp ((bias_39 + ((1.0 - bias_39) * pow (clamp ((1.0 - max (dot (-(viewVector_14), worldNormal_15), 0.0)), 0.0, 1.0), power_40))), 0.0, 1.0)));
  highp vec4 tmpvar_43;
  tmpvar_43 = (tmpvar_42 + (max (0.0, pow (nh_5, _Shininess)) * _SpecularColor));
  baseColor_2.xyz = tmpvar_43.xyz;
  baseColor_2.w = edgeBlendFactors_4.x;
  gl_FragData[0] = baseColor_2;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = _glesVertex.w;
  mediump vec3 vtxForAni_2;
  mediump vec3 worldSpaceVertex_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_3 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (worldSpaceVertex_3.xzz * unity_Scale.w);
  vtxForAni_2 = tmpvar_6;
  mediump vec4 amplitude_7;
  amplitude_7 = _GAmplitude;
  mediump vec4 frequency_8;
  frequency_8 = _GFrequency;
  mediump vec4 steepness_9;
  steepness_9 = _GSteepness;
  mediump vec4 speed_10;
  speed_10 = _GSpeed;
  mediump vec4 directionAB_11;
  directionAB_11 = _GDirectionAB;
  mediump vec4 directionCD_12;
  directionCD_12 = _GDirectionCD;
  mediump vec4 TIME_13;
  mediump vec3 offsets_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((steepness_9.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_16;
  tmpvar_16 = ((steepness_9.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_17;
  tmpvar_17.x = dot (directionAB_11.xy, vtxForAni_2.xz);
  tmpvar_17.y = dot (directionAB_11.zw, vtxForAni_2.xz);
  tmpvar_17.z = dot (directionCD_12.xy, vtxForAni_2.xz);
  tmpvar_17.w = dot (directionCD_12.zw, vtxForAni_2.xz);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (frequency_8 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (_Time.yyyy * speed_10);
  TIME_13 = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = cos((tmpvar_18 + TIME_13));
  mediump vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_15.xz;
  tmpvar_21.zw = tmpvar_16.xz;
  offsets_14.x = dot (tmpvar_20, tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22.xy = tmpvar_15.yw;
  tmpvar_22.zw = tmpvar_16.yw;
  offsets_14.z = dot (tmpvar_20, tmpvar_22);
  offsets_14.y = dot (sin((tmpvar_18 + TIME_13)), amplitude_7);
  mediump vec2 xzVtx_23;
  xzVtx_23 = (vtxForAni_2.xz + offsets_14.xz);
  mediump vec4 TIME_24;
  mediump vec3 nrml_25;
  nrml_25.y = 2.0;
  mediump vec4 tmpvar_26;
  tmpvar_26 = ((frequency_8.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_27;
  tmpvar_27 = ((frequency_8.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_28;
  tmpvar_28.x = dot (directionAB_11.xy, xzVtx_23);
  tmpvar_28.y = dot (directionAB_11.zw, xzVtx_23);
  tmpvar_28.z = dot (directionCD_12.xy, xzVtx_23);
  tmpvar_28.w = dot (directionCD_12.zw, xzVtx_23);
  highp vec4 tmpvar_29;
  tmpvar_29 = (_Time.yyyy * speed_10);
  TIME_24 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = cos(((frequency_8 * tmpvar_28) + TIME_24));
  mediump vec4 tmpvar_31;
  tmpvar_31.xy = tmpvar_26.xz;
  tmpvar_31.zw = tmpvar_27.xz;
  nrml_25.x = -(dot (tmpvar_30, tmpvar_31));
  mediump vec4 tmpvar_32;
  tmpvar_32.xy = tmpvar_26.yw;
  tmpvar_32.zw = tmpvar_27.yw;
  nrml_25.z = -(dot (tmpvar_30, tmpvar_32));
  nrml_25.xz = (nrml_25.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_33;
  tmpvar_33 = normalize(nrml_25);
  nrml_25 = tmpvar_33;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_14);
  highp vec4 tmpvar_34;
  tmpvar_34 = (glstate_matrix_mvp * tmpvar_1);
  highp vec4 grabPassPos_35;
  highp vec4 o_36;
  highp vec4 tmpvar_37;
  tmpvar_37 = (tmpvar_34 * 0.5);
  highp vec2 tmpvar_38;
  tmpvar_38.x = tmpvar_37.x;
  tmpvar_38.y = (tmpvar_37.y * _ProjectionParams.x);
  o_36.xy = (tmpvar_38 + tmpvar_37.w);
  o_36.zw = tmpvar_34.zw;
  grabPassPos_35.xy = ((tmpvar_34.xy + tmpvar_34.w) * 0.5);
  grabPassPos_35.zw = tmpvar_34.zw;
  tmpvar_4.xyz = tmpvar_33;
  tmpvar_4.w = 1.0;
  gl_Position = tmpvar_34;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (worldSpaceVertex_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_36;
  xlv_TEXCOORD4 = grabPassPos_35;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _InvFadeParemeter;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _ZBufferParams;
void main ()
{
  mediump vec4 reflectionColor_1;
  mediump vec4 baseColor_2;
  mediump float depth_3;
  mediump vec4 edgeBlendFactors_4;
  highp float nh_5;
  mediump vec3 h_6;
  mediump vec4 rtReflections_7;
  mediump vec4 rtRefractions_8;
  mediump float refrFix_9;
  mediump vec4 rtRefractionsNoDistort_10;
  mediump vec4 grabWithOffset_11;
  mediump vec4 screenWithOffset_12;
  mediump vec4 distortOffset_13;
  mediump vec3 viewVector_14;
  mediump vec3 worldNormal_15;
  mediump vec4 coords_16;
  coords_16 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_17;
  vertexNormal_17 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_18;
  bumpStrength_18 = _DistortParams.x;
  mediump vec4 bump_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = (texture2D (_BumpMap, coords_16.xy) + texture2D (_BumpMap, coords_16.zw));
  bump_19 = tmpvar_20;
  bump_19.xy = (bump_19.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize((vertexNormal_17 + ((bump_19.xxy * bumpStrength_18) * vec3(1.0, 0.0, 1.0))));
  worldNormal_15 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize(xlv_TEXCOORD1);
  viewVector_14 = tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23.zw = vec2(0.0, 0.0);
  tmpvar_23.xy = ((tmpvar_21.xz * _DistortParams.y) * 10.0);
  distortOffset_13 = tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = (xlv_TEXCOORD3 + distortOffset_13);
  screenWithOffset_12 = tmpvar_24;
  highp vec4 tmpvar_25;
  tmpvar_25 = (xlv_TEXCOORD4 + distortOffset_13);
  grabWithOffset_11 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractionsNoDistort_10 = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = texture2DProj (_CameraDepthTexture, grabWithOffset_11).x;
  refrFix_9 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2DProj (_RefractionTex, grabWithOffset_11);
  rtRefractions_8 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2DProj (_ReflectionTex, screenWithOffset_12);
  rtReflections_7 = tmpvar_29;
  highp float tmpvar_30;
  highp float z_31;
  z_31 = refrFix_9;
  tmpvar_30 = (1.0/(((_ZBufferParams.z * z_31) + _ZBufferParams.w)));
  if ((tmpvar_30 < xlv_TEXCOORD3.z)) {
    rtRefractions_8 = rtRefractionsNoDistort_10;
  };
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize((_WorldLightDir.xyz + viewVector_14));
  h_6 = tmpvar_32;
  mediump float tmpvar_33;
  tmpvar_33 = max (0.0, dot (tmpvar_21, -(h_6)));
  nh_5 = tmpvar_33;
  lowp float tmpvar_34;
  tmpvar_34 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth_3 = tmpvar_34;
  highp float tmpvar_35;
  highp float z_36;
  z_36 = depth_3;
  tmpvar_35 = (1.0/(((_ZBufferParams.z * z_36) + _ZBufferParams.w)));
  depth_3 = tmpvar_35;
  highp vec4 tmpvar_37;
  tmpvar_37 = clamp ((_InvFadeParemeter * (depth_3 - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors_4 = tmpvar_37;
  highp vec2 tmpvar_38;
  tmpvar_38 = (tmpvar_21.xz * _FresnelScale);
  worldNormal_15.xz = tmpvar_38;
  mediump float bias_39;
  bias_39 = _DistortParams.w;
  mediump float power_40;
  power_40 = _DistortParams.z;
  baseColor_2 = _BaseColor;
  highp vec4 tmpvar_41;
  tmpvar_41 = mix (rtReflections_7, _ReflectionColor, _ReflectionColor.wwww);
  reflectionColor_1 = tmpvar_41;
  mediump vec4 tmpvar_42;
  tmpvar_42 = mix (mix (rtRefractions_8, baseColor_2, baseColor_2.wwww), reflectionColor_1, vec4(clamp ((bias_39 + ((1.0 - bias_39) * pow (clamp ((1.0 - max (dot (-(viewVector_14), worldNormal_15), 0.0)), 0.0, 1.0), power_40))), 0.0, 1.0)));
  highp vec4 tmpvar_43;
  tmpvar_43 = (tmpvar_42 + (max (0.0, pow (nh_5, _Shininess)) * _SpecularColor));
  baseColor_2.xyz = tmpvar_43.xyz;
  baseColor_2.w = edgeBlendFactors_4.x;
  gl_FragData[0] = baseColor_2;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 485
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 495
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 504
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 348
#line 356
#line 379
#line 396
#line 408
#line 453
#line 474
#line 511
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 515
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 519
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 523
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 527
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 531
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 551
#line 580
#line 621
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 356
void ComputeScreenAndGrabPassPos( in highp vec4 pos, out highp vec4 screenPos, out highp vec4 grabPassPos ) {
    highp float scale = 1.0;
    screenPos = ComputeScreenPos( pos);
    #line 360
    grabPassPos.xy = ((vec2( pos.x, (pos.y * scale)) + pos.w) * 0.5);
    grabPassPos.zw = pos.zw;
}
#line 460
mediump vec3 GerstnerNormal4( in mediump vec2 xzVtx, in mediump vec4 amp, in mediump vec4 freq, in mediump vec4 speed, in mediump vec4 dirAB, in mediump vec4 dirCD ) {
    #line 462
    mediump vec3 nrml = vec3( 0.0, 2.0, 0.0);
    mediump vec4 AB = ((freq.xxyy * amp.xxyy) * dirAB.xyzw);
    mediump vec4 CD = ((freq.zzww * amp.zzww) * dirCD.xyzw);
    mediump vec4 dotABCD = (freq.xyzw * vec4( dot( dirAB.xy, xzVtx), dot( dirAB.zw, xzVtx), dot( dirCD.xy, xzVtx), dot( dirCD.zw, xzVtx)));
    #line 466
    mediump vec4 TIME = (_Time.yyyy * speed);
    mediump vec4 COS = cos((dotABCD + TIME));
    nrml.x -= dot( COS, vec4( AB.xz, CD.xz));
    nrml.z -= dot( COS, vec4( AB.yw, CD.yw));
    #line 470
    nrml.xz *= _GerstnerIntensity;
    nrml = normalize(nrml);
    return nrml;
}
#line 439
mediump vec3 GerstnerOffset4( in mediump vec2 xzVtx, in mediump vec4 steepness, in mediump vec4 amp, in mediump vec4 freq, in mediump vec4 speed, in mediump vec4 dirAB, in mediump vec4 dirCD ) {
    #line 441
    mediump vec3 offsets;
    mediump vec4 AB = ((steepness.xxyy * amp.xxyy) * dirAB.xyzw);
    mediump vec4 CD = ((steepness.zzww * amp.zzww) * dirCD.xyzw);
    mediump vec4 dotABCD = (freq.xyzw * vec4( dot( dirAB.xy, xzVtx), dot( dirAB.zw, xzVtx), dot( dirCD.xy, xzVtx), dot( dirCD.zw, xzVtx)));
    #line 445
    mediump vec4 TIME = (_Time.yyyy * speed);
    mediump vec4 COS = cos((dotABCD + TIME));
    mediump vec4 SIN = sin((dotABCD + TIME));
    offsets.x = dot( COS, vec4( AB.xz, CD.xz));
    #line 449
    offsets.z = dot( COS, vec4( AB.yw, CD.yw));
    offsets.y = dot( SIN, amp);
    return offsets;
}
#line 474
void Gerstner( out mediump vec3 offs, out mediump vec3 nrml, in mediump vec3 vtx, in mediump vec3 tileableVtx, in mediump vec4 amplitude, in mediump vec4 frequency, in mediump vec4 steepness, in mediump vec4 speed, in mediump vec4 directionAB, in mediump vec4 directionCD ) {
    offs = GerstnerOffset4( tileableVtx.xz, steepness, amplitude, frequency, speed, directionAB, directionCD);
    nrml = GerstnerNormal4( (tileableVtx.xz + offs.xz), amplitude, frequency, speed, directionAB, directionCD);
}
#line 533
v2f vert( in appdata_full v ) {
    #line 535
    v2f o;
    mediump vec3 worldSpaceVertex = (_Object2World * v.vertex).xyz;
    mediump vec3 vtxForAni = (worldSpaceVertex.xzz * unity_Scale.w);
    mediump vec3 nrml;
    #line 539
    mediump vec3 offsets;
    Gerstner( offsets, nrml, v.vertex.xyz, vtxForAni, _GAmplitude, _GFrequency, _GSteepness, _GSpeed, _GDirectionAB, _GDirectionCD);
    v.vertex.xyz += offsets;
    mediump vec2 tileableUv = worldSpaceVertex.xz;
    #line 543
    o.bumpCoords.xyzw = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection.xyzw)) * _BumpTiling.xyzw);
    o.viewInterpolator.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
    o.pos = (glstate_matrix_mvp * v.vertex);
    ComputeScreenAndGrabPassPos( o.pos, o.screenPos, o.grabPassPos);
    #line 547
    o.normalInterpolator.xyz = nrml;
    o.normalInterpolator.w = 1.0;
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.normalInterpolator);
    xlv_TEXCOORD1 = vec3(xl_retval.viewInterpolator);
    xlv_TEXCOORD2 = vec4(xl_retval.bumpCoords);
    xlv_TEXCOORD3 = vec4(xl_retval.screenPos);
    xlv_TEXCOORD4 = vec4(xl_retval.grabPassPos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 485
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 495
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 504
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 348
#line 356
#line 379
#line 396
#line 408
#line 453
#line 474
#line 511
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 515
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 519
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 523
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 527
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 531
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 551
#line 580
#line 621
#line 390
mediump float Fresnel( in mediump vec3 viewVector, in mediump vec3 worldNormal, in mediump float bias, in mediump float power ) {
    #line 392
    mediump float facing = clamp( (1.0 - max( dot( (-viewVector), worldNormal), 0.0)), 0.0, 1.0);
    mediump float refl2Refr = xll_saturate_f((bias + ((1.0 - bias) * pow( facing, power))));
    return refl2Refr;
}
#line 280
highp float LinearEyeDepth( in highp float z ) {
    #line 282
    return (1.0 / ((_ZBufferParams.z * z) + _ZBufferParams.w));
}
#line 316
mediump vec3 PerPixelNormal( in sampler2D bumpMap, in mediump vec4 coords, in mediump vec3 vertexNormal, in mediump float bumpStrength ) {
    mediump vec4 bump = (texture( bumpMap, coords.xy) + texture( bumpMap, coords.zw));
    #line 319
    bump.xy = (bump.wy - vec2( 1.0, 1.0));
    mediump vec3 worldNormal = (vertexNormal + ((bump.xxy * bumpStrength) * vec3( 1.0, 0.0, 1.0)));
    return normalize(worldNormal);
}
#line 551
mediump vec4 frag( in v2f i ) {
    mediump vec3 worldNormal = PerPixelNormal( _BumpMap, i.bumpCoords, i.normalInterpolator.xyz, _DistortParams.x);
    mediump vec3 viewVector = normalize(i.viewInterpolator.xyz);
    #line 555
    mediump vec4 distortOffset = vec4( ((worldNormal.xz * _DistortParams.y) * 10.0), 0.0, 0.0);
    mediump vec4 screenWithOffset = (i.screenPos + distortOffset);
    mediump vec4 grabWithOffset = (i.grabPassPos + distortOffset);
    mediump vec4 rtRefractionsNoDistort = textureProj( _RefractionTex, i.grabPassPos);
    #line 559
    mediump float refrFix = textureProj( _CameraDepthTexture, grabWithOffset).x;
    mediump vec4 rtRefractions = textureProj( _RefractionTex, grabWithOffset);
    mediump vec4 rtReflections = textureProj( _ReflectionTex, screenWithOffset);
    if ((LinearEyeDepth( refrFix) < i.screenPos.z)){
        rtRefractions = rtRefractionsNoDistort;
    }
    #line 563
    mediump vec3 reflectVector = normalize(reflect( viewVector, worldNormal));
    mediump vec3 h = normalize((_WorldLightDir.xyz + viewVector.xyz));
    highp float nh = max( 0.0, dot( worldNormal, (-h)));
    highp float spec = max( 0.0, pow( nh, _Shininess));
    #line 567
    mediump vec4 edgeBlendFactors = vec4( 1.0, 0.0, 0.0, 0.0);
    mediump float depth = textureProj( _CameraDepthTexture, i.screenPos).x;
    depth = LinearEyeDepth( depth);
    edgeBlendFactors = xll_saturate_vf4((_InvFadeParemeter * (depth - i.screenPos.w)));
    #line 571
    worldNormal.xz *= _FresnelScale;
    mediump float refl2Refr = Fresnel( viewVector, worldNormal, _DistortParams.w, _DistortParams.z);
    mediump vec4 baseColor = _BaseColor;
    mediump vec4 reflectionColor = mix( rtReflections, _ReflectionColor, vec4( _ReflectionColor.w));
    #line 575
    baseColor = mix( mix( rtRefractions, baseColor, vec4( baseColor.w)), reflectionColor, vec4( refl2Refr));
    baseColor = (baseColor + (spec * _SpecularColor));
    baseColor.w = edgeBlendFactors.x;
    return baseColor;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    mediump vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.normalInterpolator = vec4(xlv_TEXCOORD0);
    xlt_i.viewInterpolator = vec3(xlv_TEXCOORD1);
    xlt_i.bumpCoords = vec4(xlv_TEXCOORD2);
    xlt_i.screenPos = vec4(xlv_TEXCOORD3);
    xlt_i.grabPassPos = vec4(xlv_TEXCOORD4);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GSpeed;
uniform vec4 _GSteepness;
uniform vec4 _GFrequency;
uniform vec4 _GAmplitude;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform float _GerstnerIntensity;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = gl_Vertex.w;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec3 offsets_5;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, tmpvar_4.xz);
  tmpvar_8.y = dot (_GDirectionAB.zw, tmpvar_4.xz);
  tmpvar_8.z = dot (_GDirectionCD.xy, tmpvar_4.xz);
  tmpvar_8.w = dot (_GDirectionCD.zw, tmpvar_4.xz);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_5.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_5.z = dot (tmpvar_11, tmpvar_13);
  offsets_5.y = dot (sin((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_14;
  xzVtx_14 = (tmpvar_4.xz + offsets_5.xz);
  vec3 nrml_15;
  nrml_15.y = 2.0;
  vec4 tmpvar_16;
  tmpvar_16 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_17;
  tmpvar_17 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_18;
  tmpvar_18.x = dot (_GDirectionAB.xy, xzVtx_14);
  tmpvar_18.y = dot (_GDirectionAB.zw, xzVtx_14);
  tmpvar_18.z = dot (_GDirectionCD.xy, xzVtx_14);
  tmpvar_18.w = dot (_GDirectionCD.zw, xzVtx_14);
  vec4 tmpvar_19;
  tmpvar_19 = cos(((_GFrequency * tmpvar_18) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_16.xz;
  tmpvar_20.zw = tmpvar_17.xz;
  nrml_15.x = -(dot (tmpvar_19, tmpvar_20));
  vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_16.yw;
  tmpvar_21.zw = tmpvar_17.yw;
  nrml_15.z = -(dot (tmpvar_19, tmpvar_21));
  nrml_15.xz = (nrml_15.xz * _GerstnerIntensity);
  vec3 tmpvar_22;
  tmpvar_22 = normalize(nrml_15);
  nrml_15 = tmpvar_22;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_5);
  vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 grabPassPos_24;
  vec4 o_25;
  vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_23 * 0.5);
  vec2 tmpvar_27;
  tmpvar_27.x = tmpvar_26.x;
  tmpvar_27.y = (tmpvar_26.y * _ProjectionParams.x);
  o_25.xy = (tmpvar_27 + tmpvar_26.w);
  o_25.zw = tmpvar_23.zw;
  grabPassPos_24.xy = ((tmpvar_23.xy + tmpvar_23.w) * 0.5);
  grabPassPos_24.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_22;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_25;
  xlv_TEXCOORD4 = grabPassPos_24;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _InvFadeParemeter;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _RefractionTex;
uniform sampler2D _BumpMap;
uniform vec4 _ZBufferParams;
void main ()
{
  vec4 baseColor_1;
  vec4 rtRefractions_2;
  vec3 worldNormal_3;
  vec4 bump_4;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_4.zw = tmpvar_5.zw;
  bump_4.xy = (tmpvar_5.wy - vec2(1.0, 1.0));
  vec3 tmpvar_6;
  tmpvar_6 = normalize((xlv_TEXCOORD0.xyz + ((bump_4.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_3 = tmpvar_6;
  vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_8;
  tmpvar_8.zw = vec2(0.0, 0.0);
  tmpvar_8.xy = ((tmpvar_6.xz * _DistortParams.y) * 10.0);
  vec4 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD4 + tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractions_2 = texture2DProj (_RefractionTex, tmpvar_9);
  float tmpvar_11;
  tmpvar_11 = (1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, tmpvar_9).x) + _ZBufferParams.w)));
  if ((tmpvar_11 < xlv_TEXCOORD3.z)) {
    rtRefractions_2 = tmpvar_10;
  };
  worldNormal_3.xz = (tmpvar_6.xz * _FresnelScale);
  baseColor_1.xyz = (mix (mix (rtRefractions_2, _BaseColor, _BaseColor.wwww), _ReflectionColor, vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_7), worldNormal_3), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_6, -(normalize((_WorldLightDir.xyz + tmpvar_7))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = clamp ((_InvFadeParemeter * ((1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w))) - xlv_TEXCOORD3.w)), 0.0, 1.0).x;
  gl_FragData[0] = baseColor_1;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 12 [unity_Scale]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 194 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c12.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r3.zw, r3.xyyw
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r2.x, r0, r0
rsq r2.z, r2.x
mul o1.xyz, r2.z, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
add r1.xyz, v0, r4
mov r1.w, v0
dp4 r3.w, r1, c1
dp4 r0.w, r1, c3
dp4 r4.x, r1, c0
mov r2.w, r0
dp4 r2.z, r1, c2
mov r4.y, -r3.w
add r0.zw, r0.w, r4.xyxy
mov r2.x, r4
mov r2.y, r3.w
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c10.x
mad o4.xy, r3.z, c11.zwzw, r0
mov r0.x, c8
mul o5.xy, r0.zwzw, c22.y
mad r0, c15, r0.x, r7.xzxz
mov o0, r2
mov o4.zw, r2
mov o5.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c9
mov o1.w, c23.y
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Bind "vertex" Vertex
Vector 15 [_BumpDirection]
Vector 14 [_BumpTiling]
Vector 16 [_GAmplitude]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
Vector 17 [_GFrequency]
Vector 19 [_GSpeed]
Vector 18 [_GSteepness]
Float 13 [_GerstnerIntensity]
Matrix 8 [_Object2World] 4
Vector 2 [_ProjectionParams]
Vector 3 [_ScreenParams]
Vector 0 [_Time]
Vector 1 [_WorldSpaceCameraPos]
Matrix 4 [glstate_matrix_mvp] 4
Vector 12 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 77.33 (58 instructions), vertex: 32, texture: 0,
//   sequencer: 26,  9 GPRs, 21 threads,
// Performance (if enough threads): ~77 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaadeeaaaaadgeaaaaaaaaaaaaaaceaaaaaclmaaaaacoeaaaaaaaa
aaaaaaaaaaaaacjeaaaaaabmaaaaacigpppoadaaaaaaaabaaaaaaabmaaaaaaaa
aaaaachpaaaaabfmaaacaaapaaabaaaaaaaaabgmaaaaaaaaaaaaabhmaaacaaao
aaabaaaaaaaaabgmaaaaaaaaaaaaabiiaaacaabaaaabaaaaaaaaabgmaaaaaaaa
aaaaabjeaaacaabeaaabaaaaaaaaabgmaaaaaaaaaaaaabkcaaacaabfaaabaaaa
aaaaabgmaaaaaaaaaaaaablaaaacaabbaaabaaaaaaaaabgmaaaaaaaaaaaaablm
aaacaabdaaabaaaaaaaaabgmaaaaaaaaaaaaabmeaaacaabcaaabaaaaaaaaabgm
aaaaaaaaaaaaabnaaaacaaanaaabaaaaaaaaaboeaaaaaaaaaaaaabpeaaacaaai
aaaeaaaaaaaaacaeaaaaaaaaaaaaacbeaaacaaacaaabaaaaaaaaabgmaaaaaaaa
aaaaaccgaaacaaadaaabaaaaaaaaabgmaaaaaaaaaaaaacdeaaacaaaaaaabaaaa
aaaaabgmaaaaaaaaaaaaacdkaaacaaabaaabaaaaaaaaacfaaaaaaaaaaaaaacga
aaacaaaeaaaeaaaaaaaaacaeaaaaaaaaaaaaachdaaacaaamaaabaaaaaaaaabgm
aaaaaaaafpechfgnhaeegjhcgfgdhegjgpgoaaklaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpechfgnhafegjgmgjgoghaafpehebgnhagmgjhehfgegfaafpeheegj
hcgfgdhegjgpgoebecaafpeheegjhcgfgdhegjgpgoedeeaafpeheghcgfhbhfgf
gogdhjaafpehfdhagfgfgeaafpehfdhegfgfhagogfhdhdaafpehgfhchdhegogf
hcejgohegfgohdgjhehjaaklaaaaaaadaaabaaabaaabaaaaaaaaaaaafpepgcgk
gfgdhedcfhgphcgmgeaaklklaaadaaadaaaeaaaeaaabaaaaaaaaaaaafpfahcgp
gkgfgdhegjgpgofagbhcgbgnhdaafpfdgdhcgfgfgofagbhcgbgnhdaafpfegjgn
gfaafpfhgphcgmgefdhagbgdgfedgbgngfhcgbfagphdaaklaaabaaadaaabaaad
aaabaaaaaaaaaaaaghgmhdhegbhegffpgngbhehcgjhifpgnhghaaahfgogjhehj
fpfdgdgbgmgfaahghdfpddfpdaaadccodacodcdadddfddcodaaaklklaaaaaaaa
aaaaaaabaaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaeaaaaaadceaaebaaaiaaaaaaaaaaaaaaaaaaaaemkfaaaaaaab
aaaaaaabaaaaaaaiaaaaacjaaaaaaaahaaaapafaaaabhbfbaaacpcfcaaadpdfd
aaagpefeaaaabaebaaaabacoaaaabacpaaaaaacmaaaaaaddaaaabadfaaaaaacn
aaaabadeaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaeamjapnleaiaaaaadoccpjidaaaaaaaalpiaaaaadpiaaaaadpaaaaaa
maejapnlbaabbaahaaaabcaamcaaaaaaaaaagaaigaaobcaabcaaaaaaaaaagabe
gabkbcaabcaaaaaaaaaaeacaaaaabcaameaaaaaaaaaagacegackbcaabcaaaaaa
aaaagadagadgbcaabcaaaaaaaaaagadmaaaaccaaaaaaaaaaafpieaaaaaaaagii
aaaaaaaamiapaaaaaalbaaaacbaabdaamiahaaabaablleaakbaealaamiahaaab
aamgmaleklaeakabmiahaaabaalbleleklaeajabmiahaaafaagmmaleklaeaiab
miadaaacaameblaakbafamaamiapaaadaalmdeaakbacbeaaaabpabagaalmdegg
kbacbfadaacmababaakmaglloaagagadmiapaaabaaaaaaaaklabbbaamiapaaab
aaaamgmgilabpoppmiapaaabaaaaaaaaoiabaaaamiapaaadaanngmblilabpopp
meeaacaaaaaaaalbocaaaaadmabpaiahaaaaaalbcbbcbaadmacpaiabaabliigm
kbaeahadmaepaiagaaakdeblkbahbfadmaipaiahaakademgkbahbeadmeicacad
aakhkhgmkpaibaadmebpadahaaanahblobahacadmeimadacaapbcmmgoaahahad
miaeaaadaabkbiblpbagadacmiabaaadaalabimgpbagadacmiahaaaeaamamaaa
oaadaeaamiapaaabaamgnapiklaeagabmiapaaabaalbdepiklaeafabmiapaaae
aagmnajeklaeaeabmiapiadoaananaaaocaeaeaamiapaaabaagmkhooclaaapaf
miadaaacaamelaaaoaadacaamiapaaahaalmdeaakbacbeaamiapaaacaalmdeaa
kbacbfaamiamaaagaakmagaaoaacacaaaabpagadaaaaaaggcbbbbaahaacpagac
aaofmallkbaeppahmiapaaaaaaaaaaaaklagbbaamiamiaadaanlnlaaocaeaeaa
miamiaaeaanlnlaaocaeaeaamiahiaabacmamaaakaafabaamiapiaacaahkaaaa
kbabaoaamiapaaabaaaamgmgilaapoppbebgaaaaaablbglbkbacadaekibdaaac
aamegnmamaaeacppmiabiaadaamglbaaoaacaaaamiadiaaeaalamgaakbacppaa
miaciaadaagmgmmgklaaacaamiapaaaaaaaaaaaaoiabaaaamiapaaabaaaagmbl
ilaapoppmebdabacaalabjgmkbadbeabmecmabacaaagdblbkbadbfabmeedabaa
aalamemgkbadbeabmeimabaaaaagomblkbadbfabmiabaaaaaakhkhaaopaaabaa
miacaaaaaakhkhaaopacabaamiagaaaaaelmgmaakbaaanaamiabaaaaaalclclb
nbaaaapofibaaaaaaaaaaagmocaaaaiaaaknmaaaaamfgmgmobaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Matrix 256 [glstate_matrix_mvp]
Bind "vertex" Vertex
Vector 467 [_Time]
Vector 466 [_WorldSpaceCameraPos]
Vector 465 [_ProjectionParams]
Matrix 260 [_Object2World]
Vector 464 [unity_Scale]
Float 463 [_GerstnerIntensity]
Vector 462 [_BumpTiling]
Vector 461 [_BumpDirection]
Vector 460 [_GAmplitude]
Vector 459 [_GFrequency]
Vector 458 [_GSteepness]
Vector 457 [_GSpeed]
Vector 456 [_GDirectionAB]
Vector 455 [_GDirectionCD]
"sce_vp_rsx // 64 instructions using 12 registers
[Configuration]
8
0000004000010c00
[Defaults]
1
454 3
3f800000400000003f000000
[Microcode]
1024
00009c6c005cc00d8186c0836041fffc00019c6c005d30080186c08360419ffc
401f9c6c005c60000186c08360403f9c00059c6c005c602a8186c08360409ffc
00051c6c0040007f8106c08360403ffc00041c6c01d0600d8106c0c360405ffc
00041c6c01d0500d8106c0c360409ffc00041c6c01d0400d8106c0c360411ffc
401f9c6c00dd208c0186c0830421dfa000001c6c009cb0138289c0c36041fffc
00009c6c009ca0138289c0c36041fffc00011c6c009c902a8686c0c36041fffc
00039c6c011cd0000686c0c44421fffc00021c6c009c702f8286c0c36041fffc
00019c6c009c80050286c0c36041fffc00031c6c009c702f8086c0c36041fffc
00029c6c009c80050086c0c36041fffc00049c6c009d001010bfc0c360419ffc
00009c6c009c70089286c0c36041fffc00001c6c009c80089286c0c36041fffc
00001c6c00c000100086c08ea0219ffc00001c6c00c000010286c08ae0a07ffc
401f9c6c009ce00d8e86c0c36041ffa400001c6c009cb00d8086c0c36041fffc
00001c6c00c0000d8086c0836121fffc00009c6c004000100a86c08360419ffc
00009c6c784000010c86c0800030647c00029c6c8040003a8a86c0800031837c
00029c6c7840002b8c86c08aa028647c00039c6c804000100686c08aa029837c
00039c6c804000010886c0954024637c00019c6c8040003a8686c09fe023837c
00019c6c7840002b8886c0954024647c00019c6c79c0000d8c86c35fe022447c
00019c6c01c0000d8c86c74360411ffc00019c6c01dcc00d9086c0c360409ffc
00051c6c00c0000c0106c08301a1dffc00001c6c00c000081286c08401a19ffc
00021c6c01d0200d9486c0c360405ffc00031c6c01d0000d9486c0c360411ffc
00021c6c01d0300d9486c0c360411ffc00021c6c01d0100d9486c0c360403ffc
00019c6c009c70088086c0c36041fffc00001c6c009c80088086c0c36041fffc
00001c6c00c000100086c08ea0219ffc00001c6c00c000010686c08ae1a07ffc
00001c6c011cb00d8086c0c36121fffc00021c6c0040007f8886c08360409ffc
00031c6c004000ff8886c08360409ffc00021c6c004000000886c08360403ffc
00019c6c00c000080c86c08002219ffc00021c6c804000000c86c0800031007c
401f9c6c8040000d8886c08aa029e000401f9c6c804000558886c09540246028
00011c6c809c600e08aa80dfe023c07c00019c6c01c0000d8086c54360403ffc
00019c6c01c0000d8086c14360405ffc00011c6c009d102a848000c360409ffc
00059c6c009cf0d7068000c360415ffc00001c6c0140000c16860b4360411ffc
401f9c6c00c000080486c09541219fa8401f9c6c204000558886c0800030602c
401f9c6c009c600806aa80c360419fac401f9c6c0080000000860b436041df9d
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304 // 304 used size, 19 vars
Float 16 [_GerstnerIntensity]
Vector 176 [_BumpTiling] 4
Vector 192 [_BumpDirection] 4
Vector 208 [_GAmplitude] 4
Vector 224 [_GFrequency] 4
Vector 240 [_GSteepness] 4
Vector 256 [_GSpeed] 4
Vector 272 [_GDirectionAB] 4
Vector 288 [_GDirectionCD] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 0 [_Time] 4
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 62 instructions, 7 temp regs, 0 temp arrays:
// ALU 49 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedhflopkeeblkkhmnpjdcbmcnpmmkpmomdabaaaaaakeajaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcpaahaaaaeaaaabaapmabaaaafjaaaaae
egiocaaaaaaaaaaabdaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagiaaaaacahaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaa
beaaaaaaapaaaaaibcaabaaaacaaaaaaegiacaaaaaaaaaaabbaaaaaaegaabaaa
abaaaaaaapaaaaaiccaabaaaacaaaaaaogikcaaaaaaaaaaabbaaaaaaegaabaaa
abaaaaaaapaaaaaiecaabaaaacaaaaaaegiacaaaaaaaaaaabcaaaaaaegaabaaa
abaaaaaaapaaaaaiicaabaaaacaaaaaaogikcaaaaaaaaaaabcaaaaaaegaabaaa
abaaaaaadiaaaaajpcaabaaaabaaaaaaegiocaaaaaaaaaaabaaaaaaafgifcaaa
abaaaaaaaaaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaaaaaaaaaaoaaaaaa
egaobaaaacaaaaaaegaobaaaabaaaaaaenaaaaahpcaabaaaacaaaaaapcaabaaa
adaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaacaaaaaaegaobaaaacaaaaaa
egiocaaaaaaaaaaaanaaaaaadiaaaaajpcaabaaaaeaaaaaaegiocaaaaaaaaaaa
anaaaaaaegiocaaaaaaaaaaaapaaaaaadiaaaaaipcaabaaaafaaaaaaegaebaaa
aeaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaeaaaaaakgapbaaa
aeaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaagaaaaaaogakbaaa
afaaaaaadgaaaaafmcaabaaaagaaaaaaagaibaaaaeaaaaaadgaaaaafmcaabaaa
afaaaaaafganbaaaaeaaaaaabbaaaaahecaabaaaacaaaaaaegaobaaaadaaaaaa
egaobaaaafaaaaaabbaaaaahbcaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaa
agaaaaaaaaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaaegbcbaaaaaaaaaaa
dcaaaaakdcaabaaaacaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaa
igaabaaaacaaaaaadiaaaaaipcaabaaaaeaaaaaafgafbaaaadaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaeaaaaaaegiocaaaacaaaaaaaaaaaaaa
agaabaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaaegiocaaa
acaaaaaaacaaaaaakgakbaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaa
adaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaadaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaadaaaaaaapaaaaaibcaabaaaaeaaaaaa
egiacaaaaaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiccaabaaaaeaaaaaa
ogikcaaaaaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiecaabaaaaeaaaaaa
egiacaaaaaaaaaaabcaaaaaaegaabaaaacaaaaaaapaaaaaiicaabaaaaeaaaaaa
ogikcaaaaaaaaaaabcaaaaaaegaabaaaacaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaaaaaaaaaaoaaaaaaegaobaaaaeaaaaaaegaobaaaabaaaaaaenaaaaag
aanaaaaapcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaajpcaabaaaacaaaaaa
egiocaaaaaaaaaaaanaaaaaaegiocaaaaaaaaaaaaoaaaaaadiaaaaaipcaabaaa
aeaaaaaaegaebaaaacaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaa
acaaaaaakgapbaaaacaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaa
afaaaaaaogakbaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaaagaibaaaacaaaaaa
dgaaaaafmcaabaaaaeaaaaaafganbaaaacaaaaaabbaaaaahicaabaaaaaaaaaaa
egaobaaaabaaaaaaegaobaaaaeaaaaaabbaaaaahbcaabaaaabaaaaaaegaobaaa
abaaaaaaegaobaaaafaaaaaadgaaaaagbcaabaaaabaaaaaaakaabaiaebaaaaaa
abaaaaaadgaaaaagecaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadiaaaaai
fcaabaaaabaaaaaaagacbaaaabaaaaaaagiacaaaaaaaaaaaabaaaaaadgaaaaaf
ccaabaaaabaaaaaaabeaaaaaaaaaaaeabaaaaaahicaabaaaaaaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhccabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaf
iccabaaaabaaaaaaabeaaaaaaaaaiadpaaaaaaajhccabaaaacaaaaaaegacbaaa
aaaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaaaaaaaaa
agiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaaaaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaa
diaaaaaibcaabaaaaaaaaaaabkaabaaaadaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaahicaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdiaaaaak
fcaabaaaaaaaaaaaagadbaaaadaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaaaaaaaaamgaabaaaaaaaaaaa
dcaaaaamdcaabaaaaaaaaaaaegaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaialp
aaaaaaaaaaaaaaaapgapbaaaadaaaaaadiaaaaakdccabaaaafaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaadgaaaaafmccabaaa
aeaaaaaakgaobaaaadaaaaaadgaaaaafmccabaaaafaaaaaakgaobaaaadaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = _glesVertex.w;
  mediump vec3 vtxForAni_2;
  mediump vec3 worldSpaceVertex_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_3 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (worldSpaceVertex_3.xzz * unity_Scale.w);
  vtxForAni_2 = tmpvar_6;
  mediump vec4 amplitude_7;
  amplitude_7 = _GAmplitude;
  mediump vec4 frequency_8;
  frequency_8 = _GFrequency;
  mediump vec4 steepness_9;
  steepness_9 = _GSteepness;
  mediump vec4 speed_10;
  speed_10 = _GSpeed;
  mediump vec4 directionAB_11;
  directionAB_11 = _GDirectionAB;
  mediump vec4 directionCD_12;
  directionCD_12 = _GDirectionCD;
  mediump vec4 TIME_13;
  mediump vec3 offsets_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((steepness_9.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_16;
  tmpvar_16 = ((steepness_9.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_17;
  tmpvar_17.x = dot (directionAB_11.xy, vtxForAni_2.xz);
  tmpvar_17.y = dot (directionAB_11.zw, vtxForAni_2.xz);
  tmpvar_17.z = dot (directionCD_12.xy, vtxForAni_2.xz);
  tmpvar_17.w = dot (directionCD_12.zw, vtxForAni_2.xz);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (frequency_8 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (_Time.yyyy * speed_10);
  TIME_13 = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = cos((tmpvar_18 + TIME_13));
  mediump vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_15.xz;
  tmpvar_21.zw = tmpvar_16.xz;
  offsets_14.x = dot (tmpvar_20, tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22.xy = tmpvar_15.yw;
  tmpvar_22.zw = tmpvar_16.yw;
  offsets_14.z = dot (tmpvar_20, tmpvar_22);
  offsets_14.y = dot (sin((tmpvar_18 + TIME_13)), amplitude_7);
  mediump vec2 xzVtx_23;
  xzVtx_23 = (vtxForAni_2.xz + offsets_14.xz);
  mediump vec4 TIME_24;
  mediump vec3 nrml_25;
  nrml_25.y = 2.0;
  mediump vec4 tmpvar_26;
  tmpvar_26 = ((frequency_8.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_27;
  tmpvar_27 = ((frequency_8.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_28;
  tmpvar_28.x = dot (directionAB_11.xy, xzVtx_23);
  tmpvar_28.y = dot (directionAB_11.zw, xzVtx_23);
  tmpvar_28.z = dot (directionCD_12.xy, xzVtx_23);
  tmpvar_28.w = dot (directionCD_12.zw, xzVtx_23);
  highp vec4 tmpvar_29;
  tmpvar_29 = (_Time.yyyy * speed_10);
  TIME_24 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = cos(((frequency_8 * tmpvar_28) + TIME_24));
  mediump vec4 tmpvar_31;
  tmpvar_31.xy = tmpvar_26.xz;
  tmpvar_31.zw = tmpvar_27.xz;
  nrml_25.x = -(dot (tmpvar_30, tmpvar_31));
  mediump vec4 tmpvar_32;
  tmpvar_32.xy = tmpvar_26.yw;
  tmpvar_32.zw = tmpvar_27.yw;
  nrml_25.z = -(dot (tmpvar_30, tmpvar_32));
  nrml_25.xz = (nrml_25.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_33;
  tmpvar_33 = normalize(nrml_25);
  nrml_25 = tmpvar_33;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_14);
  highp vec4 tmpvar_34;
  tmpvar_34 = (glstate_matrix_mvp * tmpvar_1);
  highp vec4 grabPassPos_35;
  highp vec4 o_36;
  highp vec4 tmpvar_37;
  tmpvar_37 = (tmpvar_34 * 0.5);
  highp vec2 tmpvar_38;
  tmpvar_38.x = tmpvar_37.x;
  tmpvar_38.y = (tmpvar_37.y * _ProjectionParams.x);
  o_36.xy = (tmpvar_38 + tmpvar_37.w);
  o_36.zw = tmpvar_34.zw;
  grabPassPos_35.xy = ((tmpvar_34.xy + tmpvar_34.w) * 0.5);
  grabPassPos_35.zw = tmpvar_34.zw;
  tmpvar_4.xyz = tmpvar_33;
  tmpvar_4.w = 1.0;
  gl_Position = tmpvar_34;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (worldSpaceVertex_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_36;
  xlv_TEXCOORD4 = grabPassPos_35;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _InvFadeParemeter;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _RefractionTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _ZBufferParams;
void main ()
{
  mediump vec4 reflectionColor_1;
  mediump vec4 baseColor_2;
  mediump float depth_3;
  mediump vec4 edgeBlendFactors_4;
  highp float nh_5;
  mediump vec3 h_6;
  mediump vec4 rtRefractions_7;
  mediump float refrFix_8;
  mediump vec4 rtRefractionsNoDistort_9;
  mediump vec4 grabWithOffset_10;
  mediump vec4 distortOffset_11;
  mediump vec3 viewVector_12;
  mediump vec3 worldNormal_13;
  mediump vec4 coords_14;
  coords_14 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_15;
  vertexNormal_15 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_16;
  bumpStrength_16 = _DistortParams.x;
  mediump vec4 bump_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = (texture2D (_BumpMap, coords_14.xy) + texture2D (_BumpMap, coords_14.zw));
  bump_17 = tmpvar_18;
  bump_17.xy = (bump_17.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize((vertexNormal_15 + ((bump_17.xxy * bumpStrength_16) * vec3(1.0, 0.0, 1.0))));
  worldNormal_13 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize(xlv_TEXCOORD1);
  viewVector_12 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.zw = vec2(0.0, 0.0);
  tmpvar_21.xy = ((tmpvar_19.xz * _DistortParams.y) * 10.0);
  distortOffset_11 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22 = (xlv_TEXCOORD4 + distortOffset_11);
  grabWithOffset_10 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractionsNoDistort_9 = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = texture2DProj (_CameraDepthTexture, grabWithOffset_10).x;
  refrFix_8 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2DProj (_RefractionTex, grabWithOffset_10);
  rtRefractions_7 = tmpvar_25;
  highp float tmpvar_26;
  highp float z_27;
  z_27 = refrFix_8;
  tmpvar_26 = (1.0/(((_ZBufferParams.z * z_27) + _ZBufferParams.w)));
  if ((tmpvar_26 < xlv_TEXCOORD3.z)) {
    rtRefractions_7 = rtRefractionsNoDistort_9;
  };
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((_WorldLightDir.xyz + viewVector_12));
  h_6 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = max (0.0, dot (tmpvar_19, -(h_6)));
  nh_5 = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth_3 = tmpvar_30;
  highp float tmpvar_31;
  highp float z_32;
  z_32 = depth_3;
  tmpvar_31 = (1.0/(((_ZBufferParams.z * z_32) + _ZBufferParams.w)));
  depth_3 = tmpvar_31;
  highp vec4 tmpvar_33;
  tmpvar_33 = clamp ((_InvFadeParemeter * (depth_3 - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors_4 = tmpvar_33;
  highp vec2 tmpvar_34;
  tmpvar_34 = (tmpvar_19.xz * _FresnelScale);
  worldNormal_13.xz = tmpvar_34;
  mediump float bias_35;
  bias_35 = _DistortParams.w;
  mediump float power_36;
  power_36 = _DistortParams.z;
  baseColor_2 = _BaseColor;
  reflectionColor_1 = _ReflectionColor;
  mediump vec4 tmpvar_37;
  tmpvar_37 = mix (mix (rtRefractions_7, baseColor_2, baseColor_2.wwww), reflectionColor_1, vec4(clamp ((bias_35 + ((1.0 - bias_35) * pow (clamp ((1.0 - max (dot (-(viewVector_12), worldNormal_13), 0.0)), 0.0, 1.0), power_36))), 0.0, 1.0)));
  highp vec4 tmpvar_38;
  tmpvar_38 = (tmpvar_37 + (max (0.0, pow (nh_5, _Shininess)) * _SpecularColor));
  baseColor_2.xyz = tmpvar_38.xyz;
  baseColor_2.w = edgeBlendFactors_4.x;
  gl_FragData[0] = baseColor_2;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = _glesVertex.w;
  mediump vec3 vtxForAni_2;
  mediump vec3 worldSpaceVertex_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_3 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (worldSpaceVertex_3.xzz * unity_Scale.w);
  vtxForAni_2 = tmpvar_6;
  mediump vec4 amplitude_7;
  amplitude_7 = _GAmplitude;
  mediump vec4 frequency_8;
  frequency_8 = _GFrequency;
  mediump vec4 steepness_9;
  steepness_9 = _GSteepness;
  mediump vec4 speed_10;
  speed_10 = _GSpeed;
  mediump vec4 directionAB_11;
  directionAB_11 = _GDirectionAB;
  mediump vec4 directionCD_12;
  directionCD_12 = _GDirectionCD;
  mediump vec4 TIME_13;
  mediump vec3 offsets_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((steepness_9.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_16;
  tmpvar_16 = ((steepness_9.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_17;
  tmpvar_17.x = dot (directionAB_11.xy, vtxForAni_2.xz);
  tmpvar_17.y = dot (directionAB_11.zw, vtxForAni_2.xz);
  tmpvar_17.z = dot (directionCD_12.xy, vtxForAni_2.xz);
  tmpvar_17.w = dot (directionCD_12.zw, vtxForAni_2.xz);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (frequency_8 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (_Time.yyyy * speed_10);
  TIME_13 = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = cos((tmpvar_18 + TIME_13));
  mediump vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_15.xz;
  tmpvar_21.zw = tmpvar_16.xz;
  offsets_14.x = dot (tmpvar_20, tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22.xy = tmpvar_15.yw;
  tmpvar_22.zw = tmpvar_16.yw;
  offsets_14.z = dot (tmpvar_20, tmpvar_22);
  offsets_14.y = dot (sin((tmpvar_18 + TIME_13)), amplitude_7);
  mediump vec2 xzVtx_23;
  xzVtx_23 = (vtxForAni_2.xz + offsets_14.xz);
  mediump vec4 TIME_24;
  mediump vec3 nrml_25;
  nrml_25.y = 2.0;
  mediump vec4 tmpvar_26;
  tmpvar_26 = ((frequency_8.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_27;
  tmpvar_27 = ((frequency_8.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_28;
  tmpvar_28.x = dot (directionAB_11.xy, xzVtx_23);
  tmpvar_28.y = dot (directionAB_11.zw, xzVtx_23);
  tmpvar_28.z = dot (directionCD_12.xy, xzVtx_23);
  tmpvar_28.w = dot (directionCD_12.zw, xzVtx_23);
  highp vec4 tmpvar_29;
  tmpvar_29 = (_Time.yyyy * speed_10);
  TIME_24 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = cos(((frequency_8 * tmpvar_28) + TIME_24));
  mediump vec4 tmpvar_31;
  tmpvar_31.xy = tmpvar_26.xz;
  tmpvar_31.zw = tmpvar_27.xz;
  nrml_25.x = -(dot (tmpvar_30, tmpvar_31));
  mediump vec4 tmpvar_32;
  tmpvar_32.xy = tmpvar_26.yw;
  tmpvar_32.zw = tmpvar_27.yw;
  nrml_25.z = -(dot (tmpvar_30, tmpvar_32));
  nrml_25.xz = (nrml_25.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_33;
  tmpvar_33 = normalize(nrml_25);
  nrml_25 = tmpvar_33;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_14);
  highp vec4 tmpvar_34;
  tmpvar_34 = (glstate_matrix_mvp * tmpvar_1);
  highp vec4 grabPassPos_35;
  highp vec4 o_36;
  highp vec4 tmpvar_37;
  tmpvar_37 = (tmpvar_34 * 0.5);
  highp vec2 tmpvar_38;
  tmpvar_38.x = tmpvar_37.x;
  tmpvar_38.y = (tmpvar_37.y * _ProjectionParams.x);
  o_36.xy = (tmpvar_38 + tmpvar_37.w);
  o_36.zw = tmpvar_34.zw;
  grabPassPos_35.xy = ((tmpvar_34.xy + tmpvar_34.w) * 0.5);
  grabPassPos_35.zw = tmpvar_34.zw;
  tmpvar_4.xyz = tmpvar_33;
  tmpvar_4.w = 1.0;
  gl_Position = tmpvar_34;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (worldSpaceVertex_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_36;
  xlv_TEXCOORD4 = grabPassPos_35;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _InvFadeParemeter;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _RefractionTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _ZBufferParams;
void main ()
{
  mediump vec4 reflectionColor_1;
  mediump vec4 baseColor_2;
  mediump float depth_3;
  mediump vec4 edgeBlendFactors_4;
  highp float nh_5;
  mediump vec3 h_6;
  mediump vec4 rtRefractions_7;
  mediump float refrFix_8;
  mediump vec4 rtRefractionsNoDistort_9;
  mediump vec4 grabWithOffset_10;
  mediump vec4 distortOffset_11;
  mediump vec3 viewVector_12;
  mediump vec3 worldNormal_13;
  mediump vec4 coords_14;
  coords_14 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_15;
  vertexNormal_15 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_16;
  bumpStrength_16 = _DistortParams.x;
  mediump vec4 bump_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = (texture2D (_BumpMap, coords_14.xy) + texture2D (_BumpMap, coords_14.zw));
  bump_17 = tmpvar_18;
  bump_17.xy = (bump_17.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize((vertexNormal_15 + ((bump_17.xxy * bumpStrength_16) * vec3(1.0, 0.0, 1.0))));
  worldNormal_13 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize(xlv_TEXCOORD1);
  viewVector_12 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.zw = vec2(0.0, 0.0);
  tmpvar_21.xy = ((tmpvar_19.xz * _DistortParams.y) * 10.0);
  distortOffset_11 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22 = (xlv_TEXCOORD4 + distortOffset_11);
  grabWithOffset_10 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractionsNoDistort_9 = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = texture2DProj (_CameraDepthTexture, grabWithOffset_10).x;
  refrFix_8 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2DProj (_RefractionTex, grabWithOffset_10);
  rtRefractions_7 = tmpvar_25;
  highp float tmpvar_26;
  highp float z_27;
  z_27 = refrFix_8;
  tmpvar_26 = (1.0/(((_ZBufferParams.z * z_27) + _ZBufferParams.w)));
  if ((tmpvar_26 < xlv_TEXCOORD3.z)) {
    rtRefractions_7 = rtRefractionsNoDistort_9;
  };
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((_WorldLightDir.xyz + viewVector_12));
  h_6 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = max (0.0, dot (tmpvar_19, -(h_6)));
  nh_5 = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth_3 = tmpvar_30;
  highp float tmpvar_31;
  highp float z_32;
  z_32 = depth_3;
  tmpvar_31 = (1.0/(((_ZBufferParams.z * z_32) + _ZBufferParams.w)));
  depth_3 = tmpvar_31;
  highp vec4 tmpvar_33;
  tmpvar_33 = clamp ((_InvFadeParemeter * (depth_3 - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors_4 = tmpvar_33;
  highp vec2 tmpvar_34;
  tmpvar_34 = (tmpvar_19.xz * _FresnelScale);
  worldNormal_13.xz = tmpvar_34;
  mediump float bias_35;
  bias_35 = _DistortParams.w;
  mediump float power_36;
  power_36 = _DistortParams.z;
  baseColor_2 = _BaseColor;
  reflectionColor_1 = _ReflectionColor;
  mediump vec4 tmpvar_37;
  tmpvar_37 = mix (mix (rtRefractions_7, baseColor_2, baseColor_2.wwww), reflectionColor_1, vec4(clamp ((bias_35 + ((1.0 - bias_35) * pow (clamp ((1.0 - max (dot (-(viewVector_12), worldNormal_13), 0.0)), 0.0, 1.0), power_36))), 0.0, 1.0)));
  highp vec4 tmpvar_38;
  tmpvar_38 = (tmpvar_37 + (max (0.0, pow (nh_5, _Shininess)) * _SpecularColor));
  baseColor_2.xyz = tmpvar_38.xyz;
  baseColor_2.w = edgeBlendFactors_4.x;
  gl_FragData[0] = baseColor_2;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 485
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 495
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 504
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 348
#line 356
#line 379
#line 396
#line 408
#line 453
#line 474
#line 511
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 515
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 519
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 523
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 527
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 531
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 551
#line 579
#line 619
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 356
void ComputeScreenAndGrabPassPos( in highp vec4 pos, out highp vec4 screenPos, out highp vec4 grabPassPos ) {
    highp float scale = 1.0;
    screenPos = ComputeScreenPos( pos);
    #line 360
    grabPassPos.xy = ((vec2( pos.x, (pos.y * scale)) + pos.w) * 0.5);
    grabPassPos.zw = pos.zw;
}
#line 460
mediump vec3 GerstnerNormal4( in mediump vec2 xzVtx, in mediump vec4 amp, in mediump vec4 freq, in mediump vec4 speed, in mediump vec4 dirAB, in mediump vec4 dirCD ) {
    #line 462
    mediump vec3 nrml = vec3( 0.0, 2.0, 0.0);
    mediump vec4 AB = ((freq.xxyy * amp.xxyy) * dirAB.xyzw);
    mediump vec4 CD = ((freq.zzww * amp.zzww) * dirCD.xyzw);
    mediump vec4 dotABCD = (freq.xyzw * vec4( dot( dirAB.xy, xzVtx), dot( dirAB.zw, xzVtx), dot( dirCD.xy, xzVtx), dot( dirCD.zw, xzVtx)));
    #line 466
    mediump vec4 TIME = (_Time.yyyy * speed);
    mediump vec4 COS = cos((dotABCD + TIME));
    nrml.x -= dot( COS, vec4( AB.xz, CD.xz));
    nrml.z -= dot( COS, vec4( AB.yw, CD.yw));
    #line 470
    nrml.xz *= _GerstnerIntensity;
    nrml = normalize(nrml);
    return nrml;
}
#line 439
mediump vec3 GerstnerOffset4( in mediump vec2 xzVtx, in mediump vec4 steepness, in mediump vec4 amp, in mediump vec4 freq, in mediump vec4 speed, in mediump vec4 dirAB, in mediump vec4 dirCD ) {
    #line 441
    mediump vec3 offsets;
    mediump vec4 AB = ((steepness.xxyy * amp.xxyy) * dirAB.xyzw);
    mediump vec4 CD = ((steepness.zzww * amp.zzww) * dirCD.xyzw);
    mediump vec4 dotABCD = (freq.xyzw * vec4( dot( dirAB.xy, xzVtx), dot( dirAB.zw, xzVtx), dot( dirCD.xy, xzVtx), dot( dirCD.zw, xzVtx)));
    #line 445
    mediump vec4 TIME = (_Time.yyyy * speed);
    mediump vec4 COS = cos((dotABCD + TIME));
    mediump vec4 SIN = sin((dotABCD + TIME));
    offsets.x = dot( COS, vec4( AB.xz, CD.xz));
    #line 449
    offsets.z = dot( COS, vec4( AB.yw, CD.yw));
    offsets.y = dot( SIN, amp);
    return offsets;
}
#line 474
void Gerstner( out mediump vec3 offs, out mediump vec3 nrml, in mediump vec3 vtx, in mediump vec3 tileableVtx, in mediump vec4 amplitude, in mediump vec4 frequency, in mediump vec4 steepness, in mediump vec4 speed, in mediump vec4 directionAB, in mediump vec4 directionCD ) {
    offs = GerstnerOffset4( tileableVtx.xz, steepness, amplitude, frequency, speed, directionAB, directionCD);
    nrml = GerstnerNormal4( (tileableVtx.xz + offs.xz), amplitude, frequency, speed, directionAB, directionCD);
}
#line 533
v2f vert( in appdata_full v ) {
    #line 535
    v2f o;
    mediump vec3 worldSpaceVertex = (_Object2World * v.vertex).xyz;
    mediump vec3 vtxForAni = (worldSpaceVertex.xzz * unity_Scale.w);
    mediump vec3 nrml;
    #line 539
    mediump vec3 offsets;
    Gerstner( offsets, nrml, v.vertex.xyz, vtxForAni, _GAmplitude, _GFrequency, _GSteepness, _GSpeed, _GDirectionAB, _GDirectionCD);
    v.vertex.xyz += offsets;
    mediump vec2 tileableUv = worldSpaceVertex.xz;
    #line 543
    o.bumpCoords.xyzw = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection.xyzw)) * _BumpTiling.xyzw);
    o.viewInterpolator.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
    o.pos = (glstate_matrix_mvp * v.vertex);
    ComputeScreenAndGrabPassPos( o.pos, o.screenPos, o.grabPassPos);
    #line 547
    o.normalInterpolator.xyz = nrml;
    o.normalInterpolator.w = 1.0;
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.normalInterpolator);
    xlv_TEXCOORD1 = vec3(xl_retval.viewInterpolator);
    xlv_TEXCOORD2 = vec4(xl_retval.bumpCoords);
    xlv_TEXCOORD3 = vec4(xl_retval.screenPos);
    xlv_TEXCOORD4 = vec4(xl_retval.grabPassPos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 485
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 495
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 504
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 348
#line 356
#line 379
#line 396
#line 408
#line 453
#line 474
#line 511
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 515
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 519
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 523
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 527
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 531
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 551
#line 579
#line 619
#line 390
mediump float Fresnel( in mediump vec3 viewVector, in mediump vec3 worldNormal, in mediump float bias, in mediump float power ) {
    #line 392
    mediump float facing = clamp( (1.0 - max( dot( (-viewVector), worldNormal), 0.0)), 0.0, 1.0);
    mediump float refl2Refr = xll_saturate_f((bias + ((1.0 - bias) * pow( facing, power))));
    return refl2Refr;
}
#line 280
highp float LinearEyeDepth( in highp float z ) {
    #line 282
    return (1.0 / ((_ZBufferParams.z * z) + _ZBufferParams.w));
}
#line 316
mediump vec3 PerPixelNormal( in sampler2D bumpMap, in mediump vec4 coords, in mediump vec3 vertexNormal, in mediump float bumpStrength ) {
    mediump vec4 bump = (texture( bumpMap, coords.xy) + texture( bumpMap, coords.zw));
    #line 319
    bump.xy = (bump.wy - vec2( 1.0, 1.0));
    mediump vec3 worldNormal = (vertexNormal + ((bump.xxy * bumpStrength) * vec3( 1.0, 0.0, 1.0)));
    return normalize(worldNormal);
}
#line 551
mediump vec4 frag( in v2f i ) {
    mediump vec3 worldNormal = PerPixelNormal( _BumpMap, i.bumpCoords, i.normalInterpolator.xyz, _DistortParams.x);
    mediump vec3 viewVector = normalize(i.viewInterpolator.xyz);
    #line 555
    mediump vec4 distortOffset = vec4( ((worldNormal.xz * _DistortParams.y) * 10.0), 0.0, 0.0);
    mediump vec4 screenWithOffset = (i.screenPos + distortOffset);
    mediump vec4 grabWithOffset = (i.grabPassPos + distortOffset);
    mediump vec4 rtRefractionsNoDistort = textureProj( _RefractionTex, i.grabPassPos);
    #line 559
    mediump float refrFix = textureProj( _CameraDepthTexture, grabWithOffset).x;
    mediump vec4 rtRefractions = textureProj( _RefractionTex, grabWithOffset);
    if ((LinearEyeDepth( refrFix) < i.screenPos.z)){
        rtRefractions = rtRefractionsNoDistort;
    }
    mediump vec3 reflectVector = normalize(reflect( viewVector, worldNormal));
    #line 563
    mediump vec3 h = normalize((_WorldLightDir.xyz + viewVector.xyz));
    highp float nh = max( 0.0, dot( worldNormal, (-h)));
    highp float spec = max( 0.0, pow( nh, _Shininess));
    mediump vec4 edgeBlendFactors = vec4( 1.0, 0.0, 0.0, 0.0);
    #line 567
    mediump float depth = textureProj( _CameraDepthTexture, i.screenPos).x;
    depth = LinearEyeDepth( depth);
    edgeBlendFactors = xll_saturate_vf4((_InvFadeParemeter * (depth - i.screenPos.w)));
    worldNormal.xz *= _FresnelScale;
    #line 571
    mediump float refl2Refr = Fresnel( viewVector, worldNormal, _DistortParams.w, _DistortParams.z);
    mediump vec4 baseColor = _BaseColor;
    mediump vec4 reflectionColor = _ReflectionColor;
    baseColor = mix( mix( rtRefractions, baseColor, vec4( baseColor.w)), reflectionColor, vec4( refl2Refr));
    #line 575
    baseColor = (baseColor + (spec * _SpecularColor));
    baseColor.w = edgeBlendFactors.x;
    return baseColor;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    mediump vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.normalInterpolator = vec4(xlv_TEXCOORD0);
    xlt_i.viewInterpolator = vec3(xlv_TEXCOORD1);
    xlt_i.bumpCoords = vec4(xlv_TEXCOORD2);
    xlt_i.screenPos = vec4(xlv_TEXCOORD3);
    xlt_i.grabPassPos = vec4(xlv_TEXCOORD4);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GSpeed;
uniform vec4 _GSteepness;
uniform vec4 _GFrequency;
uniform vec4 _GAmplitude;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform float _GerstnerIntensity;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = gl_Vertex.w;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec3 offsets_5;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, tmpvar_4.xz);
  tmpvar_8.y = dot (_GDirectionAB.zw, tmpvar_4.xz);
  tmpvar_8.z = dot (_GDirectionCD.xy, tmpvar_4.xz);
  tmpvar_8.w = dot (_GDirectionCD.zw, tmpvar_4.xz);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_5.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_5.z = dot (tmpvar_11, tmpvar_13);
  offsets_5.y = dot (sin((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_14;
  xzVtx_14 = (tmpvar_4.xz + offsets_5.xz);
  vec3 nrml_15;
  nrml_15.y = 2.0;
  vec4 tmpvar_16;
  tmpvar_16 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_17;
  tmpvar_17 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_18;
  tmpvar_18.x = dot (_GDirectionAB.xy, xzVtx_14);
  tmpvar_18.y = dot (_GDirectionAB.zw, xzVtx_14);
  tmpvar_18.z = dot (_GDirectionCD.xy, xzVtx_14);
  tmpvar_18.w = dot (_GDirectionCD.zw, xzVtx_14);
  vec4 tmpvar_19;
  tmpvar_19 = cos(((_GFrequency * tmpvar_18) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_16.xz;
  tmpvar_20.zw = tmpvar_17.xz;
  nrml_15.x = -(dot (tmpvar_19, tmpvar_20));
  vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_16.yw;
  tmpvar_21.zw = tmpvar_17.yw;
  nrml_15.z = -(dot (tmpvar_19, tmpvar_21));
  nrml_15.xz = (nrml_15.xz * _GerstnerIntensity);
  vec3 tmpvar_22;
  tmpvar_22 = normalize(nrml_15);
  nrml_15 = tmpvar_22;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_5);
  vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 grabPassPos_24;
  vec4 o_25;
  vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_23 * 0.5);
  vec2 tmpvar_27;
  tmpvar_27.x = tmpvar_26.x;
  tmpvar_27.y = (tmpvar_26.y * _ProjectionParams.x);
  o_25.xy = (tmpvar_27 + tmpvar_26.w);
  o_25.zw = tmpvar_23.zw;
  grabPassPos_24.xy = ((tmpvar_23.xy + tmpvar_23.w) * 0.5);
  grabPassPos_24.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_22;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_25;
  xlv_TEXCOORD4 = grabPassPos_24;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.0, 0.0);
  tmpvar_7.xy = ((tmpvar_5.xz * _DistortParams.y) * 10.0);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  baseColor_1.xyz = (mix (mix (texture2DProj (_RefractionTex, (xlv_TEXCOORD4 + tmpvar_7)), _BaseColor, _BaseColor.wwww), mix (texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_7)), _ReflectionColor, _ReflectionColor.wwww), vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = 1.0;
  gl_FragData[0] = baseColor_1;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 12 [unity_Scale]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 194 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c12.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r3.zw, r3.xyyw
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r2.x, r0, r0
rsq r2.z, r2.x
mul o1.xyz, r2.z, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
add r1.xyz, v0, r4
mov r1.w, v0
dp4 r3.w, r1, c1
dp4 r0.w, r1, c3
dp4 r4.x, r1, c0
mov r2.w, r0
dp4 r2.z, r1, c2
mov r4.y, -r3.w
add r0.zw, r0.w, r4.xyxy
mov r2.x, r4
mov r2.y, r3.w
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c10.x
mad o4.xy, r3.z, c11.zwzw, r0
mov r0.x, c8
mul o5.xy, r0.zwzw, c22.y
mad r0, c15, r0.x, r7.xzxz
mov o0, r2
mov o4.zw, r2
mov o5.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c9
mov o1.w, c23.y
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Vector 15 [_BumpDirection]
Vector 14 [_BumpTiling]
Vector 16 [_GAmplitude]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
Vector 17 [_GFrequency]
Vector 19 [_GSpeed]
Vector 18 [_GSteepness]
Float 13 [_GerstnerIntensity]
Matrix 8 [_Object2World] 4
Vector 2 [_ProjectionParams]
Vector 3 [_ScreenParams]
Vector 0 [_Time]
Vector 1 [_WorldSpaceCameraPos]
Matrix 4 [glstate_matrix_mvp] 4
Vector 12 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 77.33 (58 instructions), vertex: 32, texture: 0,
//   sequencer: 26,  9 GPRs, 21 threads,
// Performance (if enough threads): ~77 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaadeeaaaaadgeaaaaaaaaaaaaaaceaaaaaclmaaaaacoeaaaaaaaa
aaaaaaaaaaaaacjeaaaaaabmaaaaacigpppoadaaaaaaaabaaaaaaabmaaaaaaaa
aaaaachpaaaaabfmaaacaaapaaabaaaaaaaaabgmaaaaaaaaaaaaabhmaaacaaao
aaabaaaaaaaaabgmaaaaaaaaaaaaabiiaaacaabaaaabaaaaaaaaabgmaaaaaaaa
aaaaabjeaaacaabeaaabaaaaaaaaabgmaaaaaaaaaaaaabkcaaacaabfaaabaaaa
aaaaabgmaaaaaaaaaaaaablaaaacaabbaaabaaaaaaaaabgmaaaaaaaaaaaaablm
aaacaabdaaabaaaaaaaaabgmaaaaaaaaaaaaabmeaaacaabcaaabaaaaaaaaabgm
aaaaaaaaaaaaabnaaaacaaanaaabaaaaaaaaaboeaaaaaaaaaaaaabpeaaacaaai
aaaeaaaaaaaaacaeaaaaaaaaaaaaacbeaaacaaacaaabaaaaaaaaabgmaaaaaaaa
aaaaaccgaaacaaadaaabaaaaaaaaabgmaaaaaaaaaaaaacdeaaacaaaaaaabaaaa
aaaaabgmaaaaaaaaaaaaacdkaaacaaabaaabaaaaaaaaacfaaaaaaaaaaaaaacga
aaacaaaeaaaeaaaaaaaaacaeaaaaaaaaaaaaachdaaacaaamaaabaaaaaaaaabgm
aaaaaaaafpechfgnhaeegjhcgfgdhegjgpgoaaklaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpechfgnhafegjgmgjgoghaafpehebgnhagmgjhehfgegfaafpeheegj
hcgfgdhegjgpgoebecaafpeheegjhcgfgdhegjgpgoedeeaafpeheghcgfhbhfgf
gogdhjaafpehfdhagfgfgeaafpehfdhegfgfhagogfhdhdaafpehgfhchdhegogf
hcejgohegfgohdgjhehjaaklaaaaaaadaaabaaabaaabaaaaaaaaaaaafpepgcgk
gfgdhedcfhgphcgmgeaaklklaaadaaadaaaeaaaeaaabaaaaaaaaaaaafpfahcgp
gkgfgdhegjgpgofagbhcgbgnhdaafpfdgdhcgfgfgofagbhcgbgnhdaafpfegjgn
gfaafpfhgphcgmgefdhagbgdgfedgbgngfhcgbfagphdaaklaaabaaadaaabaaad
aaabaaaaaaaaaaaaghgmhdhegbhegffpgngbhehcgjhifpgnhghaaahfgogjhehj
fpfdgdgbgmgfaahghdfpddfpdaaadccodacodcdadddfddcodaaaklklaaaaaaaa
aaaaaaabaaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaeaaaaaadceaaebaaaiaaaaaaaaaaaaaaaaaaaaemkfaaaaaaab
aaaaaaabaaaaaaaiaaaaacjaaaaaaaahaaaapafaaaabhbfbaaacpcfcaaadpdfd
aaagpefeaaaabaebaaaabacoaaaabacpaaaaaacmaaaaaaddaaaabadfaaaaaacn
aaaabadeaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaeamjapnleaiaaaaadoccpjidaaaaaaaalpiaaaaadpiaaaaadpaaaaaa
maejapnlbaabbaahaaaabcaamcaaaaaaaaaagaaigaaobcaabcaaaaaaaaaagabe
gabkbcaabcaaaaaaaaaaeacaaaaabcaameaaaaaaaaaagacegackbcaabcaaaaaa
aaaagadagadgbcaabcaaaaaaaaaagadmaaaaccaaaaaaaaaaafpieaaaaaaaagii
aaaaaaaamiapaaaaaalbaaaacbaabdaamiahaaabaablleaakbaealaamiahaaab
aamgmaleklaeakabmiahaaabaalbleleklaeajabmiahaaafaagmmaleklaeaiab
miadaaacaameblaakbafamaamiapaaadaalmdeaakbacbeaaaabpabagaalmdegg
kbacbfadaacmababaakmaglloaagagadmiapaaabaaaaaaaaklabbbaamiapaaab
aaaamgmgilabpoppmiapaaabaaaaaaaaoiabaaaamiapaaadaanngmblilabpopp
meeaacaaaaaaaalbocaaaaadmabpaiahaaaaaalbcbbcbaadmacpaiabaabliigm
kbaeahadmaepaiagaaakdeblkbahbfadmaipaiahaakademgkbahbeadmeicacad
aakhkhgmkpaibaadmebpadahaaanahblobahacadmeimadacaapbcmmgoaahahad
miaeaaadaabkbiblpbagadacmiabaaadaalabimgpbagadacmiahaaaeaamamaaa
oaadaeaamiapaaabaamgnapiklaeagabmiapaaabaalbdepiklaeafabmiapaaae
aagmnajeklaeaeabmiapiadoaananaaaocaeaeaamiapaaabaagmkhooclaaapaf
miadaaacaamelaaaoaadacaamiapaaahaalmdeaakbacbeaamiapaaacaalmdeaa
kbacbfaamiamaaagaakmagaaoaacacaaaabpagadaaaaaaggcbbbbaahaacpagac
aaofmallkbaeppahmiapaaaaaaaaaaaaklagbbaamiamiaadaanlnlaaocaeaeaa
miamiaaeaanlnlaaocaeaeaamiahiaabacmamaaakaafabaamiapiaacaahkaaaa
kbabaoaamiapaaabaaaamgmgilaapoppbebgaaaaaablbglbkbacadaekibdaaac
aamegnmamaaeacppmiabiaadaamglbaaoaacaaaamiadiaaeaalamgaakbacppaa
miaciaadaagmgmmgklaaacaamiapaaaaaaaaaaaaoiabaaaamiapaaabaaaagmbl
ilaapoppmebdabacaalabjgmkbadbeabmecmabacaaagdblbkbadbfabmeedabaa
aalamemgkbadbeabmeimabaaaaagomblkbadbfabmiabaaaaaakhkhaaopaaabaa
miacaaaaaakhkhaaopacabaamiagaaaaaelmgmaakbaaanaamiabaaaaaalclclb
nbaaaapofibaaaaaaaaaaagmocaaaaiaaaknmaaaaamfgmgmobaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Matrix 256 [glstate_matrix_mvp]
Bind "vertex" Vertex
Vector 467 [_Time]
Vector 466 [_WorldSpaceCameraPos]
Vector 465 [_ProjectionParams]
Matrix 260 [_Object2World]
Vector 464 [unity_Scale]
Float 463 [_GerstnerIntensity]
Vector 462 [_BumpTiling]
Vector 461 [_BumpDirection]
Vector 460 [_GAmplitude]
Vector 459 [_GFrequency]
Vector 458 [_GSteepness]
Vector 457 [_GSpeed]
Vector 456 [_GDirectionAB]
Vector 455 [_GDirectionCD]
"sce_vp_rsx // 64 instructions using 12 registers
[Configuration]
8
0000004000010c00
[Defaults]
1
454 3
3f800000400000003f000000
[Microcode]
1024
00009c6c005cc00d8186c0836041fffc00019c6c005d30080186c08360419ffc
401f9c6c005c60000186c08360403f9c00059c6c005c602a8186c08360409ffc
00051c6c0040007f8106c08360403ffc00041c6c01d0600d8106c0c360405ffc
00041c6c01d0500d8106c0c360409ffc00041c6c01d0400d8106c0c360411ffc
401f9c6c00dd208c0186c0830421dfa000001c6c009cb0138289c0c36041fffc
00009c6c009ca0138289c0c36041fffc00011c6c009c902a8686c0c36041fffc
00039c6c011cd0000686c0c44421fffc00021c6c009c702f8286c0c36041fffc
00019c6c009c80050286c0c36041fffc00031c6c009c702f8086c0c36041fffc
00029c6c009c80050086c0c36041fffc00049c6c009d001010bfc0c360419ffc
00009c6c009c70089286c0c36041fffc00001c6c009c80089286c0c36041fffc
00001c6c00c000100086c08ea0219ffc00001c6c00c000010286c08ae0a07ffc
401f9c6c009ce00d8e86c0c36041ffa400001c6c009cb00d8086c0c36041fffc
00001c6c00c0000d8086c0836121fffc00009c6c004000100a86c08360419ffc
00009c6c784000010c86c0800030647c00029c6c8040003a8a86c0800031837c
00029c6c7840002b8c86c08aa028647c00039c6c804000100686c08aa029837c
00039c6c804000010886c0954024637c00019c6c8040003a8686c09fe023837c
00019c6c7840002b8886c0954024647c00019c6c79c0000d8c86c35fe022447c
00019c6c01c0000d8c86c74360411ffc00019c6c01dcc00d9086c0c360409ffc
00051c6c00c0000c0106c08301a1dffc00001c6c00c000081286c08401a19ffc
00021c6c01d0200d9486c0c360405ffc00031c6c01d0000d9486c0c360411ffc
00021c6c01d0300d9486c0c360411ffc00021c6c01d0100d9486c0c360403ffc
00019c6c009c70088086c0c36041fffc00001c6c009c80088086c0c36041fffc
00001c6c00c000100086c08ea0219ffc00001c6c00c000010686c08ae1a07ffc
00001c6c011cb00d8086c0c36121fffc00021c6c0040007f8886c08360409ffc
00031c6c004000ff8886c08360409ffc00021c6c004000000886c08360403ffc
00019c6c00c000080c86c08002219ffc00021c6c804000000c86c0800031007c
401f9c6c8040000d8886c08aa029e000401f9c6c804000558886c09540246028
00011c6c809c600e08aa80dfe023c07c00019c6c01c0000d8086c54360403ffc
00019c6c01c0000d8086c14360405ffc00011c6c009d102a848000c360409ffc
00059c6c009cf0d7068000c360415ffc00001c6c0140000c16860b4360411ffc
401f9c6c00c000080486c09541219fa8401f9c6c204000558886c0800030602c
401f9c6c009c600806aa80c360419fac401f9c6c0080000000860b436041df9d
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304 // 304 used size, 19 vars
Float 16 [_GerstnerIntensity]
Vector 176 [_BumpTiling] 4
Vector 192 [_BumpDirection] 4
Vector 208 [_GAmplitude] 4
Vector 224 [_GFrequency] 4
Vector 240 [_GSteepness] 4
Vector 256 [_GSpeed] 4
Vector 272 [_GDirectionAB] 4
Vector 288 [_GDirectionCD] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 0 [_Time] 4
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 62 instructions, 7 temp regs, 0 temp arrays:
// ALU 49 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedhflopkeeblkkhmnpjdcbmcnpmmkpmomdabaaaaaakeajaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcpaahaaaaeaaaabaapmabaaaafjaaaaae
egiocaaaaaaaaaaabdaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagiaaaaacahaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaa
beaaaaaaapaaaaaibcaabaaaacaaaaaaegiacaaaaaaaaaaabbaaaaaaegaabaaa
abaaaaaaapaaaaaiccaabaaaacaaaaaaogikcaaaaaaaaaaabbaaaaaaegaabaaa
abaaaaaaapaaaaaiecaabaaaacaaaaaaegiacaaaaaaaaaaabcaaaaaaegaabaaa
abaaaaaaapaaaaaiicaabaaaacaaaaaaogikcaaaaaaaaaaabcaaaaaaegaabaaa
abaaaaaadiaaaaajpcaabaaaabaaaaaaegiocaaaaaaaaaaabaaaaaaafgifcaaa
abaaaaaaaaaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaaaaaaaaaaoaaaaaa
egaobaaaacaaaaaaegaobaaaabaaaaaaenaaaaahpcaabaaaacaaaaaapcaabaaa
adaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaacaaaaaaegaobaaaacaaaaaa
egiocaaaaaaaaaaaanaaaaaadiaaaaajpcaabaaaaeaaaaaaegiocaaaaaaaaaaa
anaaaaaaegiocaaaaaaaaaaaapaaaaaadiaaaaaipcaabaaaafaaaaaaegaebaaa
aeaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaeaaaaaakgapbaaa
aeaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaagaaaaaaogakbaaa
afaaaaaadgaaaaafmcaabaaaagaaaaaaagaibaaaaeaaaaaadgaaaaafmcaabaaa
afaaaaaafganbaaaaeaaaaaabbaaaaahecaabaaaacaaaaaaegaobaaaadaaaaaa
egaobaaaafaaaaaabbaaaaahbcaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaa
agaaaaaaaaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaaegbcbaaaaaaaaaaa
dcaaaaakdcaabaaaacaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaa
igaabaaaacaaaaaadiaaaaaipcaabaaaaeaaaaaafgafbaaaadaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaeaaaaaaegiocaaaacaaaaaaaaaaaaaa
agaabaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaaegiocaaa
acaaaaaaacaaaaaakgakbaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaa
adaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaadaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaadaaaaaaapaaaaaibcaabaaaaeaaaaaa
egiacaaaaaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiccaabaaaaeaaaaaa
ogikcaaaaaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiecaabaaaaeaaaaaa
egiacaaaaaaaaaaabcaaaaaaegaabaaaacaaaaaaapaaaaaiicaabaaaaeaaaaaa
ogikcaaaaaaaaaaabcaaaaaaegaabaaaacaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaaaaaaaaaaoaaaaaaegaobaaaaeaaaaaaegaobaaaabaaaaaaenaaaaag
aanaaaaapcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaajpcaabaaaacaaaaaa
egiocaaaaaaaaaaaanaaaaaaegiocaaaaaaaaaaaaoaaaaaadiaaaaaipcaabaaa
aeaaaaaaegaebaaaacaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaa
acaaaaaakgapbaaaacaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaa
afaaaaaaogakbaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaaagaibaaaacaaaaaa
dgaaaaafmcaabaaaaeaaaaaafganbaaaacaaaaaabbaaaaahicaabaaaaaaaaaaa
egaobaaaabaaaaaaegaobaaaaeaaaaaabbaaaaahbcaabaaaabaaaaaaegaobaaa
abaaaaaaegaobaaaafaaaaaadgaaaaagbcaabaaaabaaaaaaakaabaiaebaaaaaa
abaaaaaadgaaaaagecaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadiaaaaai
fcaabaaaabaaaaaaagacbaaaabaaaaaaagiacaaaaaaaaaaaabaaaaaadgaaaaaf
ccaabaaaabaaaaaaabeaaaaaaaaaaaeabaaaaaahicaabaaaaaaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhccabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaf
iccabaaaabaaaaaaabeaaaaaaaaaiadpaaaaaaajhccabaaaacaaaaaaegacbaaa
aaaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaaaaaaaaa
agiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaaaaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaa
diaaaaaibcaabaaaaaaaaaaabkaabaaaadaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaahicaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdiaaaaak
fcaabaaaaaaaaaaaagadbaaaadaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaaaaaaaaamgaabaaaaaaaaaaa
dcaaaaamdcaabaaaaaaaaaaaegaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaialp
aaaaaaaaaaaaaaaapgapbaaaadaaaaaadiaaaaakdccabaaaafaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaadgaaaaafmccabaaa
aeaaaaaakgaobaaaadaaaaaadgaaaaafmccabaaaafaaaaaakgaobaaaadaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = _glesVertex.w;
  mediump vec3 vtxForAni_2;
  mediump vec3 worldSpaceVertex_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_3 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (worldSpaceVertex_3.xzz * unity_Scale.w);
  vtxForAni_2 = tmpvar_6;
  mediump vec4 amplitude_7;
  amplitude_7 = _GAmplitude;
  mediump vec4 frequency_8;
  frequency_8 = _GFrequency;
  mediump vec4 steepness_9;
  steepness_9 = _GSteepness;
  mediump vec4 speed_10;
  speed_10 = _GSpeed;
  mediump vec4 directionAB_11;
  directionAB_11 = _GDirectionAB;
  mediump vec4 directionCD_12;
  directionCD_12 = _GDirectionCD;
  mediump vec4 TIME_13;
  mediump vec3 offsets_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((steepness_9.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_16;
  tmpvar_16 = ((steepness_9.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_17;
  tmpvar_17.x = dot (directionAB_11.xy, vtxForAni_2.xz);
  tmpvar_17.y = dot (directionAB_11.zw, vtxForAni_2.xz);
  tmpvar_17.z = dot (directionCD_12.xy, vtxForAni_2.xz);
  tmpvar_17.w = dot (directionCD_12.zw, vtxForAni_2.xz);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (frequency_8 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (_Time.yyyy * speed_10);
  TIME_13 = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = cos((tmpvar_18 + TIME_13));
  mediump vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_15.xz;
  tmpvar_21.zw = tmpvar_16.xz;
  offsets_14.x = dot (tmpvar_20, tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22.xy = tmpvar_15.yw;
  tmpvar_22.zw = tmpvar_16.yw;
  offsets_14.z = dot (tmpvar_20, tmpvar_22);
  offsets_14.y = dot (sin((tmpvar_18 + TIME_13)), amplitude_7);
  mediump vec2 xzVtx_23;
  xzVtx_23 = (vtxForAni_2.xz + offsets_14.xz);
  mediump vec4 TIME_24;
  mediump vec3 nrml_25;
  nrml_25.y = 2.0;
  mediump vec4 tmpvar_26;
  tmpvar_26 = ((frequency_8.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_27;
  tmpvar_27 = ((frequency_8.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_28;
  tmpvar_28.x = dot (directionAB_11.xy, xzVtx_23);
  tmpvar_28.y = dot (directionAB_11.zw, xzVtx_23);
  tmpvar_28.z = dot (directionCD_12.xy, xzVtx_23);
  tmpvar_28.w = dot (directionCD_12.zw, xzVtx_23);
  highp vec4 tmpvar_29;
  tmpvar_29 = (_Time.yyyy * speed_10);
  TIME_24 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = cos(((frequency_8 * tmpvar_28) + TIME_24));
  mediump vec4 tmpvar_31;
  tmpvar_31.xy = tmpvar_26.xz;
  tmpvar_31.zw = tmpvar_27.xz;
  nrml_25.x = -(dot (tmpvar_30, tmpvar_31));
  mediump vec4 tmpvar_32;
  tmpvar_32.xy = tmpvar_26.yw;
  tmpvar_32.zw = tmpvar_27.yw;
  nrml_25.z = -(dot (tmpvar_30, tmpvar_32));
  nrml_25.xz = (nrml_25.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_33;
  tmpvar_33 = normalize(nrml_25);
  nrml_25 = tmpvar_33;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_14);
  highp vec4 tmpvar_34;
  tmpvar_34 = (glstate_matrix_mvp * tmpvar_1);
  highp vec4 grabPassPos_35;
  highp vec4 o_36;
  highp vec4 tmpvar_37;
  tmpvar_37 = (tmpvar_34 * 0.5);
  highp vec2 tmpvar_38;
  tmpvar_38.x = tmpvar_37.x;
  tmpvar_38.y = (tmpvar_37.y * _ProjectionParams.x);
  o_36.xy = (tmpvar_38 + tmpvar_37.w);
  o_36.zw = tmpvar_34.zw;
  grabPassPos_35.xy = ((tmpvar_34.xy + tmpvar_34.w) * 0.5);
  grabPassPos_35.zw = tmpvar_34.zw;
  tmpvar_4.xyz = tmpvar_33;
  tmpvar_4.w = 1.0;
  gl_Position = tmpvar_34;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (worldSpaceVertex_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_36;
  xlv_TEXCOORD4 = grabPassPos_35;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
void main ()
{
  mediump vec4 reflectionColor_1;
  mediump vec4 baseColor_2;
  highp float nh_3;
  mediump vec3 h_4;
  mediump vec4 rtReflections_5;
  mediump vec4 rtRefractions_6;
  mediump vec4 grabWithOffset_7;
  mediump vec4 screenWithOffset_8;
  mediump vec4 distortOffset_9;
  mediump vec3 viewVector_10;
  mediump vec3 worldNormal_11;
  mediump vec4 coords_12;
  coords_12 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_13;
  vertexNormal_13 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_14;
  bumpStrength_14 = _DistortParams.x;
  mediump vec4 bump_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = (texture2D (_BumpMap, coords_12.xy) + texture2D (_BumpMap, coords_12.zw));
  bump_15 = tmpvar_16;
  bump_15.xy = (bump_15.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize((vertexNormal_13 + ((bump_15.xxy * bumpStrength_14) * vec3(1.0, 0.0, 1.0))));
  worldNormal_11.y = tmpvar_17.y;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize(xlv_TEXCOORD1);
  viewVector_10 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.zw = vec2(0.0, 0.0);
  tmpvar_19.xy = ((tmpvar_17.xz * _DistortParams.y) * 10.0);
  distortOffset_9 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20 = (xlv_TEXCOORD3 + distortOffset_9);
  screenWithOffset_8 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21 = (xlv_TEXCOORD4 + distortOffset_9);
  grabWithOffset_7 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2DProj (_RefractionTex, grabWithOffset_7);
  rtRefractions_6 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2DProj (_ReflectionTex, screenWithOffset_8);
  rtReflections_5 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((_WorldLightDir.xyz + viewVector_10));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = max (0.0, dot (tmpvar_17, -(h_4)));
  nh_3 = tmpvar_25;
  highp vec2 tmpvar_26;
  tmpvar_26 = (tmpvar_17.xz * _FresnelScale);
  worldNormal_11.xz = tmpvar_26;
  mediump float bias_27;
  bias_27 = _DistortParams.w;
  mediump float power_28;
  power_28 = _DistortParams.z;
  baseColor_2 = _BaseColor;
  highp vec4 tmpvar_29;
  tmpvar_29 = mix (rtReflections_5, _ReflectionColor, _ReflectionColor.wwww);
  reflectionColor_1 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = mix (mix (rtRefractions_6, baseColor_2, baseColor_2.wwww), reflectionColor_1, vec4(clamp ((bias_27 + ((1.0 - bias_27) * pow (clamp ((1.0 - max (dot (-(viewVector_10), worldNormal_11), 0.0)), 0.0, 1.0), power_28))), 0.0, 1.0)));
  highp vec4 tmpvar_31;
  tmpvar_31 = (tmpvar_30 + (max (0.0, pow (nh_3, _Shininess)) * _SpecularColor));
  baseColor_2.xyz = tmpvar_31.xyz;
  baseColor_2.w = 1.0;
  gl_FragData[0] = baseColor_2;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = _glesVertex.w;
  mediump vec3 vtxForAni_2;
  mediump vec3 worldSpaceVertex_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_3 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (worldSpaceVertex_3.xzz * unity_Scale.w);
  vtxForAni_2 = tmpvar_6;
  mediump vec4 amplitude_7;
  amplitude_7 = _GAmplitude;
  mediump vec4 frequency_8;
  frequency_8 = _GFrequency;
  mediump vec4 steepness_9;
  steepness_9 = _GSteepness;
  mediump vec4 speed_10;
  speed_10 = _GSpeed;
  mediump vec4 directionAB_11;
  directionAB_11 = _GDirectionAB;
  mediump vec4 directionCD_12;
  directionCD_12 = _GDirectionCD;
  mediump vec4 TIME_13;
  mediump vec3 offsets_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((steepness_9.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_16;
  tmpvar_16 = ((steepness_9.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_17;
  tmpvar_17.x = dot (directionAB_11.xy, vtxForAni_2.xz);
  tmpvar_17.y = dot (directionAB_11.zw, vtxForAni_2.xz);
  tmpvar_17.z = dot (directionCD_12.xy, vtxForAni_2.xz);
  tmpvar_17.w = dot (directionCD_12.zw, vtxForAni_2.xz);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (frequency_8 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (_Time.yyyy * speed_10);
  TIME_13 = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = cos((tmpvar_18 + TIME_13));
  mediump vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_15.xz;
  tmpvar_21.zw = tmpvar_16.xz;
  offsets_14.x = dot (tmpvar_20, tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22.xy = tmpvar_15.yw;
  tmpvar_22.zw = tmpvar_16.yw;
  offsets_14.z = dot (tmpvar_20, tmpvar_22);
  offsets_14.y = dot (sin((tmpvar_18 + TIME_13)), amplitude_7);
  mediump vec2 xzVtx_23;
  xzVtx_23 = (vtxForAni_2.xz + offsets_14.xz);
  mediump vec4 TIME_24;
  mediump vec3 nrml_25;
  nrml_25.y = 2.0;
  mediump vec4 tmpvar_26;
  tmpvar_26 = ((frequency_8.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_27;
  tmpvar_27 = ((frequency_8.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_28;
  tmpvar_28.x = dot (directionAB_11.xy, xzVtx_23);
  tmpvar_28.y = dot (directionAB_11.zw, xzVtx_23);
  tmpvar_28.z = dot (directionCD_12.xy, xzVtx_23);
  tmpvar_28.w = dot (directionCD_12.zw, xzVtx_23);
  highp vec4 tmpvar_29;
  tmpvar_29 = (_Time.yyyy * speed_10);
  TIME_24 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = cos(((frequency_8 * tmpvar_28) + TIME_24));
  mediump vec4 tmpvar_31;
  tmpvar_31.xy = tmpvar_26.xz;
  tmpvar_31.zw = tmpvar_27.xz;
  nrml_25.x = -(dot (tmpvar_30, tmpvar_31));
  mediump vec4 tmpvar_32;
  tmpvar_32.xy = tmpvar_26.yw;
  tmpvar_32.zw = tmpvar_27.yw;
  nrml_25.z = -(dot (tmpvar_30, tmpvar_32));
  nrml_25.xz = (nrml_25.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_33;
  tmpvar_33 = normalize(nrml_25);
  nrml_25 = tmpvar_33;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_14);
  highp vec4 tmpvar_34;
  tmpvar_34 = (glstate_matrix_mvp * tmpvar_1);
  highp vec4 grabPassPos_35;
  highp vec4 o_36;
  highp vec4 tmpvar_37;
  tmpvar_37 = (tmpvar_34 * 0.5);
  highp vec2 tmpvar_38;
  tmpvar_38.x = tmpvar_37.x;
  tmpvar_38.y = (tmpvar_37.y * _ProjectionParams.x);
  o_36.xy = (tmpvar_38 + tmpvar_37.w);
  o_36.zw = tmpvar_34.zw;
  grabPassPos_35.xy = ((tmpvar_34.xy + tmpvar_34.w) * 0.5);
  grabPassPos_35.zw = tmpvar_34.zw;
  tmpvar_4.xyz = tmpvar_33;
  tmpvar_4.w = 1.0;
  gl_Position = tmpvar_34;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (worldSpaceVertex_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_36;
  xlv_TEXCOORD4 = grabPassPos_35;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
void main ()
{
  mediump vec4 reflectionColor_1;
  mediump vec4 baseColor_2;
  highp float nh_3;
  mediump vec3 h_4;
  mediump vec4 rtReflections_5;
  mediump vec4 rtRefractions_6;
  mediump vec4 grabWithOffset_7;
  mediump vec4 screenWithOffset_8;
  mediump vec4 distortOffset_9;
  mediump vec3 viewVector_10;
  mediump vec3 worldNormal_11;
  mediump vec4 coords_12;
  coords_12 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_13;
  vertexNormal_13 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_14;
  bumpStrength_14 = _DistortParams.x;
  mediump vec4 bump_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = (texture2D (_BumpMap, coords_12.xy) + texture2D (_BumpMap, coords_12.zw));
  bump_15 = tmpvar_16;
  bump_15.xy = (bump_15.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize((vertexNormal_13 + ((bump_15.xxy * bumpStrength_14) * vec3(1.0, 0.0, 1.0))));
  worldNormal_11.y = tmpvar_17.y;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize(xlv_TEXCOORD1);
  viewVector_10 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.zw = vec2(0.0, 0.0);
  tmpvar_19.xy = ((tmpvar_17.xz * _DistortParams.y) * 10.0);
  distortOffset_9 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20 = (xlv_TEXCOORD3 + distortOffset_9);
  screenWithOffset_8 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21 = (xlv_TEXCOORD4 + distortOffset_9);
  grabWithOffset_7 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2DProj (_RefractionTex, grabWithOffset_7);
  rtRefractions_6 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2DProj (_ReflectionTex, screenWithOffset_8);
  rtReflections_5 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((_WorldLightDir.xyz + viewVector_10));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = max (0.0, dot (tmpvar_17, -(h_4)));
  nh_3 = tmpvar_25;
  highp vec2 tmpvar_26;
  tmpvar_26 = (tmpvar_17.xz * _FresnelScale);
  worldNormal_11.xz = tmpvar_26;
  mediump float bias_27;
  bias_27 = _DistortParams.w;
  mediump float power_28;
  power_28 = _DistortParams.z;
  baseColor_2 = _BaseColor;
  highp vec4 tmpvar_29;
  tmpvar_29 = mix (rtReflections_5, _ReflectionColor, _ReflectionColor.wwww);
  reflectionColor_1 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = mix (mix (rtRefractions_6, baseColor_2, baseColor_2.wwww), reflectionColor_1, vec4(clamp ((bias_27 + ((1.0 - bias_27) * pow (clamp ((1.0 - max (dot (-(viewVector_10), worldNormal_11), 0.0)), 0.0, 1.0), power_28))), 0.0, 1.0)));
  highp vec4 tmpvar_31;
  tmpvar_31 = (tmpvar_30 + (max (0.0, pow (nh_3, _Shininess)) * _SpecularColor));
  baseColor_2.xyz = tmpvar_31.xyz;
  baseColor_2.w = 1.0;
  gl_FragData[0] = baseColor_2;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 485
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 495
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 504
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 348
#line 356
#line 379
#line 396
#line 408
#line 453
#line 474
#line 511
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 515
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 519
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 523
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 527
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 531
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 551
#line 576
#line 624
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 356
void ComputeScreenAndGrabPassPos( in highp vec4 pos, out highp vec4 screenPos, out highp vec4 grabPassPos ) {
    highp float scale = 1.0;
    screenPos = ComputeScreenPos( pos);
    #line 360
    grabPassPos.xy = ((vec2( pos.x, (pos.y * scale)) + pos.w) * 0.5);
    grabPassPos.zw = pos.zw;
}
#line 460
mediump vec3 GerstnerNormal4( in mediump vec2 xzVtx, in mediump vec4 amp, in mediump vec4 freq, in mediump vec4 speed, in mediump vec4 dirAB, in mediump vec4 dirCD ) {
    #line 462
    mediump vec3 nrml = vec3( 0.0, 2.0, 0.0);
    mediump vec4 AB = ((freq.xxyy * amp.xxyy) * dirAB.xyzw);
    mediump vec4 CD = ((freq.zzww * amp.zzww) * dirCD.xyzw);
    mediump vec4 dotABCD = (freq.xyzw * vec4( dot( dirAB.xy, xzVtx), dot( dirAB.zw, xzVtx), dot( dirCD.xy, xzVtx), dot( dirCD.zw, xzVtx)));
    #line 466
    mediump vec4 TIME = (_Time.yyyy * speed);
    mediump vec4 COS = cos((dotABCD + TIME));
    nrml.x -= dot( COS, vec4( AB.xz, CD.xz));
    nrml.z -= dot( COS, vec4( AB.yw, CD.yw));
    #line 470
    nrml.xz *= _GerstnerIntensity;
    nrml = normalize(nrml);
    return nrml;
}
#line 439
mediump vec3 GerstnerOffset4( in mediump vec2 xzVtx, in mediump vec4 steepness, in mediump vec4 amp, in mediump vec4 freq, in mediump vec4 speed, in mediump vec4 dirAB, in mediump vec4 dirCD ) {
    #line 441
    mediump vec3 offsets;
    mediump vec4 AB = ((steepness.xxyy * amp.xxyy) * dirAB.xyzw);
    mediump vec4 CD = ((steepness.zzww * amp.zzww) * dirCD.xyzw);
    mediump vec4 dotABCD = (freq.xyzw * vec4( dot( dirAB.xy, xzVtx), dot( dirAB.zw, xzVtx), dot( dirCD.xy, xzVtx), dot( dirCD.zw, xzVtx)));
    #line 445
    mediump vec4 TIME = (_Time.yyyy * speed);
    mediump vec4 COS = cos((dotABCD + TIME));
    mediump vec4 SIN = sin((dotABCD + TIME));
    offsets.x = dot( COS, vec4( AB.xz, CD.xz));
    #line 449
    offsets.z = dot( COS, vec4( AB.yw, CD.yw));
    offsets.y = dot( SIN, amp);
    return offsets;
}
#line 474
void Gerstner( out mediump vec3 offs, out mediump vec3 nrml, in mediump vec3 vtx, in mediump vec3 tileableVtx, in mediump vec4 amplitude, in mediump vec4 frequency, in mediump vec4 steepness, in mediump vec4 speed, in mediump vec4 directionAB, in mediump vec4 directionCD ) {
    offs = GerstnerOffset4( tileableVtx.xz, steepness, amplitude, frequency, speed, directionAB, directionCD);
    nrml = GerstnerNormal4( (tileableVtx.xz + offs.xz), amplitude, frequency, speed, directionAB, directionCD);
}
#line 533
v2f vert( in appdata_full v ) {
    #line 535
    v2f o;
    mediump vec3 worldSpaceVertex = (_Object2World * v.vertex).xyz;
    mediump vec3 vtxForAni = (worldSpaceVertex.xzz * unity_Scale.w);
    mediump vec3 nrml;
    #line 539
    mediump vec3 offsets;
    Gerstner( offsets, nrml, v.vertex.xyz, vtxForAni, _GAmplitude, _GFrequency, _GSteepness, _GSpeed, _GDirectionAB, _GDirectionCD);
    v.vertex.xyz += offsets;
    mediump vec2 tileableUv = worldSpaceVertex.xz;
    #line 543
    o.bumpCoords.xyzw = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection.xyzw)) * _BumpTiling.xyzw);
    o.viewInterpolator.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
    o.pos = (glstate_matrix_mvp * v.vertex);
    ComputeScreenAndGrabPassPos( o.pos, o.screenPos, o.grabPassPos);
    #line 547
    o.normalInterpolator.xyz = nrml;
    o.normalInterpolator.w = 1.0;
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.normalInterpolator);
    xlv_TEXCOORD1 = vec3(xl_retval.viewInterpolator);
    xlv_TEXCOORD2 = vec4(xl_retval.bumpCoords);
    xlv_TEXCOORD3 = vec4(xl_retval.screenPos);
    xlv_TEXCOORD4 = vec4(xl_retval.grabPassPos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 485
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 495
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 504
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 348
#line 356
#line 379
#line 396
#line 408
#line 453
#line 474
#line 511
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 515
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 519
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 523
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 527
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 531
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 551
#line 576
#line 624
#line 390
mediump float Fresnel( in mediump vec3 viewVector, in mediump vec3 worldNormal, in mediump float bias, in mediump float power ) {
    #line 392
    mediump float facing = clamp( (1.0 - max( dot( (-viewVector), worldNormal), 0.0)), 0.0, 1.0);
    mediump float refl2Refr = xll_saturate_f((bias + ((1.0 - bias) * pow( facing, power))));
    return refl2Refr;
}
#line 316
mediump vec3 PerPixelNormal( in sampler2D bumpMap, in mediump vec4 coords, in mediump vec3 vertexNormal, in mediump float bumpStrength ) {
    mediump vec4 bump = (texture( bumpMap, coords.xy) + texture( bumpMap, coords.zw));
    #line 319
    bump.xy = (bump.wy - vec2( 1.0, 1.0));
    mediump vec3 worldNormal = (vertexNormal + ((bump.xxy * bumpStrength) * vec3( 1.0, 0.0, 1.0)));
    return normalize(worldNormal);
}
#line 551
mediump vec4 frag( in v2f i ) {
    mediump vec3 worldNormal = PerPixelNormal( _BumpMap, i.bumpCoords, i.normalInterpolator.xyz, _DistortParams.x);
    mediump vec3 viewVector = normalize(i.viewInterpolator.xyz);
    #line 555
    mediump vec4 distortOffset = vec4( ((worldNormal.xz * _DistortParams.y) * 10.0), 0.0, 0.0);
    mediump vec4 screenWithOffset = (i.screenPos + distortOffset);
    mediump vec4 grabWithOffset = (i.grabPassPos + distortOffset);
    mediump vec4 rtRefractionsNoDistort = textureProj( _RefractionTex, i.grabPassPos);
    #line 559
    mediump float refrFix = textureProj( _CameraDepthTexture, grabWithOffset).x;
    mediump vec4 rtRefractions = textureProj( _RefractionTex, grabWithOffset);
    mediump vec4 rtReflections = textureProj( _ReflectionTex, screenWithOffset);
    mediump vec3 reflectVector = normalize(reflect( viewVector, worldNormal));
    #line 563
    mediump vec3 h = normalize((_WorldLightDir.xyz + viewVector.xyz));
    highp float nh = max( 0.0, dot( worldNormal, (-h)));
    highp float spec = max( 0.0, pow( nh, _Shininess));
    mediump vec4 edgeBlendFactors = vec4( 1.0, 0.0, 0.0, 0.0);
    #line 567
    worldNormal.xz *= _FresnelScale;
    mediump float refl2Refr = Fresnel( viewVector, worldNormal, _DistortParams.w, _DistortParams.z);
    mediump vec4 baseColor = _BaseColor;
    mediump vec4 reflectionColor = mix( rtReflections, _ReflectionColor, vec4( _ReflectionColor.w));
    #line 571
    baseColor = mix( mix( rtRefractions, baseColor, vec4( baseColor.w)), reflectionColor, vec4( refl2Refr));
    baseColor = (baseColor + (spec * _SpecularColor));
    baseColor.w = edgeBlendFactors.x;
    return baseColor;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    mediump vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.normalInterpolator = vec4(xlv_TEXCOORD0);
    xlt_i.viewInterpolator = vec3(xlv_TEXCOORD1);
    xlt_i.bumpCoords = vec4(xlv_TEXCOORD2);
    xlt_i.screenPos = vec4(xlv_TEXCOORD3);
    xlt_i.grabPassPos = vec4(xlv_TEXCOORD4);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GSpeed;
uniform vec4 _GSteepness;
uniform vec4 _GFrequency;
uniform vec4 _GAmplitude;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform float _GerstnerIntensity;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = gl_Vertex.w;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec3 offsets_5;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, tmpvar_4.xz);
  tmpvar_8.y = dot (_GDirectionAB.zw, tmpvar_4.xz);
  tmpvar_8.z = dot (_GDirectionCD.xy, tmpvar_4.xz);
  tmpvar_8.w = dot (_GDirectionCD.zw, tmpvar_4.xz);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_5.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_5.z = dot (tmpvar_11, tmpvar_13);
  offsets_5.y = dot (sin((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_14;
  xzVtx_14 = (tmpvar_4.xz + offsets_5.xz);
  vec3 nrml_15;
  nrml_15.y = 2.0;
  vec4 tmpvar_16;
  tmpvar_16 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_17;
  tmpvar_17 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_18;
  tmpvar_18.x = dot (_GDirectionAB.xy, xzVtx_14);
  tmpvar_18.y = dot (_GDirectionAB.zw, xzVtx_14);
  tmpvar_18.z = dot (_GDirectionCD.xy, xzVtx_14);
  tmpvar_18.w = dot (_GDirectionCD.zw, xzVtx_14);
  vec4 tmpvar_19;
  tmpvar_19 = cos(((_GFrequency * tmpvar_18) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_16.xz;
  tmpvar_20.zw = tmpvar_17.xz;
  nrml_15.x = -(dot (tmpvar_19, tmpvar_20));
  vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_16.yw;
  tmpvar_21.zw = tmpvar_17.yw;
  nrml_15.z = -(dot (tmpvar_19, tmpvar_21));
  nrml_15.xz = (nrml_15.xz * _GerstnerIntensity);
  vec3 tmpvar_22;
  tmpvar_22 = normalize(nrml_15);
  nrml_15 = tmpvar_22;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_5);
  vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 grabPassPos_24;
  vec4 o_25;
  vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_23 * 0.5);
  vec2 tmpvar_27;
  tmpvar_27.x = tmpvar_26.x;
  tmpvar_27.y = (tmpvar_26.y * _ProjectionParams.x);
  o_25.xy = (tmpvar_27 + tmpvar_26.w);
  o_25.zw = tmpvar_23.zw;
  grabPassPos_24.xy = ((tmpvar_23.xy + tmpvar_23.w) * 0.5);
  grabPassPos_24.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_22;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_25;
  xlv_TEXCOORD4 = grabPassPos_24;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _RefractionTex;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.0, 0.0);
  tmpvar_7.xy = ((tmpvar_5.xz * _DistortParams.y) * 10.0);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  baseColor_1.xyz = (mix (mix (texture2DProj (_RefractionTex, (xlv_TEXCOORD4 + tmpvar_7)), _BaseColor, _BaseColor.wwww), _ReflectionColor, vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = 1.0;
  gl_FragData[0] = baseColor_1;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 12 [unity_Scale]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 194 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c12.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r3.zw, r3.xyyw
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r2.x, r0, r0
rsq r2.z, r2.x
mul o1.xyz, r2.z, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
add r1.xyz, v0, r4
mov r1.w, v0
dp4 r3.w, r1, c1
dp4 r0.w, r1, c3
dp4 r4.x, r1, c0
mov r2.w, r0
dp4 r2.z, r1, c2
mov r4.y, -r3.w
add r0.zw, r0.w, r4.xyxy
mov r2.x, r4
mov r2.y, r3.w
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c10.x
mad o4.xy, r3.z, c11.zwzw, r0
mov r0.x, c8
mul o5.xy, r0.zwzw, c22.y
mad r0, c15, r0.x, r7.xzxz
mov o0, r2
mov o4.zw, r2
mov o5.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c9
mov o1.w, c23.y
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Bind "vertex" Vertex
Vector 15 [_BumpDirection]
Vector 14 [_BumpTiling]
Vector 16 [_GAmplitude]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
Vector 17 [_GFrequency]
Vector 19 [_GSpeed]
Vector 18 [_GSteepness]
Float 13 [_GerstnerIntensity]
Matrix 8 [_Object2World] 4
Vector 2 [_ProjectionParams]
Vector 3 [_ScreenParams]
Vector 0 [_Time]
Vector 1 [_WorldSpaceCameraPos]
Matrix 4 [glstate_matrix_mvp] 4
Vector 12 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 77.33 (58 instructions), vertex: 32, texture: 0,
//   sequencer: 26,  9 GPRs, 21 threads,
// Performance (if enough threads): ~77 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaadeeaaaaadgeaaaaaaaaaaaaaaceaaaaaclmaaaaacoeaaaaaaaa
aaaaaaaaaaaaacjeaaaaaabmaaaaacigpppoadaaaaaaaabaaaaaaabmaaaaaaaa
aaaaachpaaaaabfmaaacaaapaaabaaaaaaaaabgmaaaaaaaaaaaaabhmaaacaaao
aaabaaaaaaaaabgmaaaaaaaaaaaaabiiaaacaabaaaabaaaaaaaaabgmaaaaaaaa
aaaaabjeaaacaabeaaabaaaaaaaaabgmaaaaaaaaaaaaabkcaaacaabfaaabaaaa
aaaaabgmaaaaaaaaaaaaablaaaacaabbaaabaaaaaaaaabgmaaaaaaaaaaaaablm
aaacaabdaaabaaaaaaaaabgmaaaaaaaaaaaaabmeaaacaabcaaabaaaaaaaaabgm
aaaaaaaaaaaaabnaaaacaaanaaabaaaaaaaaaboeaaaaaaaaaaaaabpeaaacaaai
aaaeaaaaaaaaacaeaaaaaaaaaaaaacbeaaacaaacaaabaaaaaaaaabgmaaaaaaaa
aaaaaccgaaacaaadaaabaaaaaaaaabgmaaaaaaaaaaaaacdeaaacaaaaaaabaaaa
aaaaabgmaaaaaaaaaaaaacdkaaacaaabaaabaaaaaaaaacfaaaaaaaaaaaaaacga
aaacaaaeaaaeaaaaaaaaacaeaaaaaaaaaaaaachdaaacaaamaaabaaaaaaaaabgm
aaaaaaaafpechfgnhaeegjhcgfgdhegjgpgoaaklaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpechfgnhafegjgmgjgoghaafpehebgnhagmgjhehfgegfaafpeheegj
hcgfgdhegjgpgoebecaafpeheegjhcgfgdhegjgpgoedeeaafpeheghcgfhbhfgf
gogdhjaafpehfdhagfgfgeaafpehfdhegfgfhagogfhdhdaafpehgfhchdhegogf
hcejgohegfgohdgjhehjaaklaaaaaaadaaabaaabaaabaaaaaaaaaaaafpepgcgk
gfgdhedcfhgphcgmgeaaklklaaadaaadaaaeaaaeaaabaaaaaaaaaaaafpfahcgp
gkgfgdhegjgpgofagbhcgbgnhdaafpfdgdhcgfgfgofagbhcgbgnhdaafpfegjgn
gfaafpfhgphcgmgefdhagbgdgfedgbgngfhcgbfagphdaaklaaabaaadaaabaaad
aaabaaaaaaaaaaaaghgmhdhegbhegffpgngbhehcgjhifpgnhghaaahfgogjhehj
fpfdgdgbgmgfaahghdfpddfpdaaadccodacodcdadddfddcodaaaklklaaaaaaaa
aaaaaaabaaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaeaaaaaadceaaebaaaiaaaaaaaaaaaaaaaaaaaaemkfaaaaaaab
aaaaaaabaaaaaaaiaaaaacjaaaaaaaahaaaapafaaaabhbfbaaacpcfcaaadpdfd
aaagpefeaaaabaebaaaabacoaaaabacpaaaaaacmaaaaaaddaaaabadfaaaaaacn
aaaabadeaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaeamjapnleaiaaaaadoccpjidaaaaaaaalpiaaaaadpiaaaaadpaaaaaa
maejapnlbaabbaahaaaabcaamcaaaaaaaaaagaaigaaobcaabcaaaaaaaaaagabe
gabkbcaabcaaaaaaaaaaeacaaaaabcaameaaaaaaaaaagacegackbcaabcaaaaaa
aaaagadagadgbcaabcaaaaaaaaaagadmaaaaccaaaaaaaaaaafpieaaaaaaaagii
aaaaaaaamiapaaaaaalbaaaacbaabdaamiahaaabaablleaakbaealaamiahaaab
aamgmaleklaeakabmiahaaabaalbleleklaeajabmiahaaafaagmmaleklaeaiab
miadaaacaameblaakbafamaamiapaaadaalmdeaakbacbeaaaabpabagaalmdegg
kbacbfadaacmababaakmaglloaagagadmiapaaabaaaaaaaaklabbbaamiapaaab
aaaamgmgilabpoppmiapaaabaaaaaaaaoiabaaaamiapaaadaanngmblilabpopp
meeaacaaaaaaaalbocaaaaadmabpaiahaaaaaalbcbbcbaadmacpaiabaabliigm
kbaeahadmaepaiagaaakdeblkbahbfadmaipaiahaakademgkbahbeadmeicacad
aakhkhgmkpaibaadmebpadahaaanahblobahacadmeimadacaapbcmmgoaahahad
miaeaaadaabkbiblpbagadacmiabaaadaalabimgpbagadacmiahaaaeaamamaaa
oaadaeaamiapaaabaamgnapiklaeagabmiapaaabaalbdepiklaeafabmiapaaae
aagmnajeklaeaeabmiapiadoaananaaaocaeaeaamiapaaabaagmkhooclaaapaf
miadaaacaamelaaaoaadacaamiapaaahaalmdeaakbacbeaamiapaaacaalmdeaa
kbacbfaamiamaaagaakmagaaoaacacaaaabpagadaaaaaaggcbbbbaahaacpagac
aaofmallkbaeppahmiapaaaaaaaaaaaaklagbbaamiamiaadaanlnlaaocaeaeaa
miamiaaeaanlnlaaocaeaeaamiahiaabacmamaaakaafabaamiapiaacaahkaaaa
kbabaoaamiapaaabaaaamgmgilaapoppbebgaaaaaablbglbkbacadaekibdaaac
aamegnmamaaeacppmiabiaadaamglbaaoaacaaaamiadiaaeaalamgaakbacppaa
miaciaadaagmgmmgklaaacaamiapaaaaaaaaaaaaoiabaaaamiapaaabaaaagmbl
ilaapoppmebdabacaalabjgmkbadbeabmecmabacaaagdblbkbadbfabmeedabaa
aalamemgkbadbeabmeimabaaaaagomblkbadbfabmiabaaaaaakhkhaaopaaabaa
miacaaaaaakhkhaaopacabaamiagaaaaaelmgmaakbaaanaamiabaaaaaalclclb
nbaaaapofibaaaaaaaaaaagmocaaaaiaaaknmaaaaamfgmgmobaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Matrix 256 [glstate_matrix_mvp]
Bind "vertex" Vertex
Vector 467 [_Time]
Vector 466 [_WorldSpaceCameraPos]
Vector 465 [_ProjectionParams]
Matrix 260 [_Object2World]
Vector 464 [unity_Scale]
Float 463 [_GerstnerIntensity]
Vector 462 [_BumpTiling]
Vector 461 [_BumpDirection]
Vector 460 [_GAmplitude]
Vector 459 [_GFrequency]
Vector 458 [_GSteepness]
Vector 457 [_GSpeed]
Vector 456 [_GDirectionAB]
Vector 455 [_GDirectionCD]
"sce_vp_rsx // 64 instructions using 12 registers
[Configuration]
8
0000004000010c00
[Defaults]
1
454 3
3f800000400000003f000000
[Microcode]
1024
00009c6c005cc00d8186c0836041fffc00019c6c005d30080186c08360419ffc
401f9c6c005c60000186c08360403f9c00059c6c005c602a8186c08360409ffc
00051c6c0040007f8106c08360403ffc00041c6c01d0600d8106c0c360405ffc
00041c6c01d0500d8106c0c360409ffc00041c6c01d0400d8106c0c360411ffc
401f9c6c00dd208c0186c0830421dfa000001c6c009cb0138289c0c36041fffc
00009c6c009ca0138289c0c36041fffc00011c6c009c902a8686c0c36041fffc
00039c6c011cd0000686c0c44421fffc00021c6c009c702f8286c0c36041fffc
00019c6c009c80050286c0c36041fffc00031c6c009c702f8086c0c36041fffc
00029c6c009c80050086c0c36041fffc00049c6c009d001010bfc0c360419ffc
00009c6c009c70089286c0c36041fffc00001c6c009c80089286c0c36041fffc
00001c6c00c000100086c08ea0219ffc00001c6c00c000010286c08ae0a07ffc
401f9c6c009ce00d8e86c0c36041ffa400001c6c009cb00d8086c0c36041fffc
00001c6c00c0000d8086c0836121fffc00009c6c004000100a86c08360419ffc
00009c6c784000010c86c0800030647c00029c6c8040003a8a86c0800031837c
00029c6c7840002b8c86c08aa028647c00039c6c804000100686c08aa029837c
00039c6c804000010886c0954024637c00019c6c8040003a8686c09fe023837c
00019c6c7840002b8886c0954024647c00019c6c79c0000d8c86c35fe022447c
00019c6c01c0000d8c86c74360411ffc00019c6c01dcc00d9086c0c360409ffc
00051c6c00c0000c0106c08301a1dffc00001c6c00c000081286c08401a19ffc
00021c6c01d0200d9486c0c360405ffc00031c6c01d0000d9486c0c360411ffc
00021c6c01d0300d9486c0c360411ffc00021c6c01d0100d9486c0c360403ffc
00019c6c009c70088086c0c36041fffc00001c6c009c80088086c0c36041fffc
00001c6c00c000100086c08ea0219ffc00001c6c00c000010686c08ae1a07ffc
00001c6c011cb00d8086c0c36121fffc00021c6c0040007f8886c08360409ffc
00031c6c004000ff8886c08360409ffc00021c6c004000000886c08360403ffc
00019c6c00c000080c86c08002219ffc00021c6c804000000c86c0800031007c
401f9c6c8040000d8886c08aa029e000401f9c6c804000558886c09540246028
00011c6c809c600e08aa80dfe023c07c00019c6c01c0000d8086c54360403ffc
00019c6c01c0000d8086c14360405ffc00011c6c009d102a848000c360409ffc
00059c6c009cf0d7068000c360415ffc00001c6c0140000c16860b4360411ffc
401f9c6c00c000080486c09541219fa8401f9c6c204000558886c0800030602c
401f9c6c009c600806aa80c360419fac401f9c6c0080000000860b436041df9d
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304 // 304 used size, 19 vars
Float 16 [_GerstnerIntensity]
Vector 176 [_BumpTiling] 4
Vector 192 [_BumpDirection] 4
Vector 208 [_GAmplitude] 4
Vector 224 [_GFrequency] 4
Vector 240 [_GSteepness] 4
Vector 256 [_GSpeed] 4
Vector 272 [_GDirectionAB] 4
Vector 288 [_GDirectionCD] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 0 [_Time] 4
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 62 instructions, 7 temp regs, 0 temp arrays:
// ALU 49 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedhflopkeeblkkhmnpjdcbmcnpmmkpmomdabaaaaaakeajaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcpaahaaaaeaaaabaapmabaaaafjaaaaae
egiocaaaaaaaaaaabdaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagiaaaaacahaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaa
beaaaaaaapaaaaaibcaabaaaacaaaaaaegiacaaaaaaaaaaabbaaaaaaegaabaaa
abaaaaaaapaaaaaiccaabaaaacaaaaaaogikcaaaaaaaaaaabbaaaaaaegaabaaa
abaaaaaaapaaaaaiecaabaaaacaaaaaaegiacaaaaaaaaaaabcaaaaaaegaabaaa
abaaaaaaapaaaaaiicaabaaaacaaaaaaogikcaaaaaaaaaaabcaaaaaaegaabaaa
abaaaaaadiaaaaajpcaabaaaabaaaaaaegiocaaaaaaaaaaabaaaaaaafgifcaaa
abaaaaaaaaaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaaaaaaaaaaoaaaaaa
egaobaaaacaaaaaaegaobaaaabaaaaaaenaaaaahpcaabaaaacaaaaaapcaabaaa
adaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaacaaaaaaegaobaaaacaaaaaa
egiocaaaaaaaaaaaanaaaaaadiaaaaajpcaabaaaaeaaaaaaegiocaaaaaaaaaaa
anaaaaaaegiocaaaaaaaaaaaapaaaaaadiaaaaaipcaabaaaafaaaaaaegaebaaa
aeaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaeaaaaaakgapbaaa
aeaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaagaaaaaaogakbaaa
afaaaaaadgaaaaafmcaabaaaagaaaaaaagaibaaaaeaaaaaadgaaaaafmcaabaaa
afaaaaaafganbaaaaeaaaaaabbaaaaahecaabaaaacaaaaaaegaobaaaadaaaaaa
egaobaaaafaaaaaabbaaaaahbcaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaa
agaaaaaaaaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaaegbcbaaaaaaaaaaa
dcaaaaakdcaabaaaacaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaa
igaabaaaacaaaaaadiaaaaaipcaabaaaaeaaaaaafgafbaaaadaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaeaaaaaaegiocaaaacaaaaaaaaaaaaaa
agaabaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaaegiocaaa
acaaaaaaacaaaaaakgakbaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaa
adaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaadaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaadaaaaaaapaaaaaibcaabaaaaeaaaaaa
egiacaaaaaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiccaabaaaaeaaaaaa
ogikcaaaaaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiecaabaaaaeaaaaaa
egiacaaaaaaaaaaabcaaaaaaegaabaaaacaaaaaaapaaaaaiicaabaaaaeaaaaaa
ogikcaaaaaaaaaaabcaaaaaaegaabaaaacaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaaaaaaaaaaoaaaaaaegaobaaaaeaaaaaaegaobaaaabaaaaaaenaaaaag
aanaaaaapcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaajpcaabaaaacaaaaaa
egiocaaaaaaaaaaaanaaaaaaegiocaaaaaaaaaaaaoaaaaaadiaaaaaipcaabaaa
aeaaaaaaegaebaaaacaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaa
acaaaaaakgapbaaaacaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaa
afaaaaaaogakbaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaaagaibaaaacaaaaaa
dgaaaaafmcaabaaaaeaaaaaafganbaaaacaaaaaabbaaaaahicaabaaaaaaaaaaa
egaobaaaabaaaaaaegaobaaaaeaaaaaabbaaaaahbcaabaaaabaaaaaaegaobaaa
abaaaaaaegaobaaaafaaaaaadgaaaaagbcaabaaaabaaaaaaakaabaiaebaaaaaa
abaaaaaadgaaaaagecaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadiaaaaai
fcaabaaaabaaaaaaagacbaaaabaaaaaaagiacaaaaaaaaaaaabaaaaaadgaaaaaf
ccaabaaaabaaaaaaabeaaaaaaaaaaaeabaaaaaahicaabaaaaaaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhccabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaf
iccabaaaabaaaaaaabeaaaaaaaaaiadpaaaaaaajhccabaaaacaaaaaaegacbaaa
aaaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaaaaaaaaa
agiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaaaaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaa
diaaaaaibcaabaaaaaaaaaaabkaabaaaadaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaahicaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdiaaaaak
fcaabaaaaaaaaaaaagadbaaaadaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaaaaaaaaamgaabaaaaaaaaaaa
dcaaaaamdcaabaaaaaaaaaaaegaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaialp
aaaaaaaaaaaaaaaapgapbaaaadaaaaaadiaaaaakdccabaaaafaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaadgaaaaafmccabaaa
aeaaaaaakgaobaaaadaaaaaadgaaaaafmccabaaaafaaaaaakgaobaaaadaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = _glesVertex.w;
  mediump vec3 vtxForAni_2;
  mediump vec3 worldSpaceVertex_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_3 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (worldSpaceVertex_3.xzz * unity_Scale.w);
  vtxForAni_2 = tmpvar_6;
  mediump vec4 amplitude_7;
  amplitude_7 = _GAmplitude;
  mediump vec4 frequency_8;
  frequency_8 = _GFrequency;
  mediump vec4 steepness_9;
  steepness_9 = _GSteepness;
  mediump vec4 speed_10;
  speed_10 = _GSpeed;
  mediump vec4 directionAB_11;
  directionAB_11 = _GDirectionAB;
  mediump vec4 directionCD_12;
  directionCD_12 = _GDirectionCD;
  mediump vec4 TIME_13;
  mediump vec3 offsets_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((steepness_9.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_16;
  tmpvar_16 = ((steepness_9.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_17;
  tmpvar_17.x = dot (directionAB_11.xy, vtxForAni_2.xz);
  tmpvar_17.y = dot (directionAB_11.zw, vtxForAni_2.xz);
  tmpvar_17.z = dot (directionCD_12.xy, vtxForAni_2.xz);
  tmpvar_17.w = dot (directionCD_12.zw, vtxForAni_2.xz);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (frequency_8 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (_Time.yyyy * speed_10);
  TIME_13 = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = cos((tmpvar_18 + TIME_13));
  mediump vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_15.xz;
  tmpvar_21.zw = tmpvar_16.xz;
  offsets_14.x = dot (tmpvar_20, tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22.xy = tmpvar_15.yw;
  tmpvar_22.zw = tmpvar_16.yw;
  offsets_14.z = dot (tmpvar_20, tmpvar_22);
  offsets_14.y = dot (sin((tmpvar_18 + TIME_13)), amplitude_7);
  mediump vec2 xzVtx_23;
  xzVtx_23 = (vtxForAni_2.xz + offsets_14.xz);
  mediump vec4 TIME_24;
  mediump vec3 nrml_25;
  nrml_25.y = 2.0;
  mediump vec4 tmpvar_26;
  tmpvar_26 = ((frequency_8.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_27;
  tmpvar_27 = ((frequency_8.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_28;
  tmpvar_28.x = dot (directionAB_11.xy, xzVtx_23);
  tmpvar_28.y = dot (directionAB_11.zw, xzVtx_23);
  tmpvar_28.z = dot (directionCD_12.xy, xzVtx_23);
  tmpvar_28.w = dot (directionCD_12.zw, xzVtx_23);
  highp vec4 tmpvar_29;
  tmpvar_29 = (_Time.yyyy * speed_10);
  TIME_24 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = cos(((frequency_8 * tmpvar_28) + TIME_24));
  mediump vec4 tmpvar_31;
  tmpvar_31.xy = tmpvar_26.xz;
  tmpvar_31.zw = tmpvar_27.xz;
  nrml_25.x = -(dot (tmpvar_30, tmpvar_31));
  mediump vec4 tmpvar_32;
  tmpvar_32.xy = tmpvar_26.yw;
  tmpvar_32.zw = tmpvar_27.yw;
  nrml_25.z = -(dot (tmpvar_30, tmpvar_32));
  nrml_25.xz = (nrml_25.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_33;
  tmpvar_33 = normalize(nrml_25);
  nrml_25 = tmpvar_33;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_14);
  highp vec4 tmpvar_34;
  tmpvar_34 = (glstate_matrix_mvp * tmpvar_1);
  highp vec4 grabPassPos_35;
  highp vec4 o_36;
  highp vec4 tmpvar_37;
  tmpvar_37 = (tmpvar_34 * 0.5);
  highp vec2 tmpvar_38;
  tmpvar_38.x = tmpvar_37.x;
  tmpvar_38.y = (tmpvar_37.y * _ProjectionParams.x);
  o_36.xy = (tmpvar_38 + tmpvar_37.w);
  o_36.zw = tmpvar_34.zw;
  grabPassPos_35.xy = ((tmpvar_34.xy + tmpvar_34.w) * 0.5);
  grabPassPos_35.zw = tmpvar_34.zw;
  tmpvar_4.xyz = tmpvar_33;
  tmpvar_4.w = 1.0;
  gl_Position = tmpvar_34;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (worldSpaceVertex_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_36;
  xlv_TEXCOORD4 = grabPassPos_35;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _RefractionTex;
uniform sampler2D _BumpMap;
void main ()
{
  mediump vec4 reflectionColor_1;
  mediump vec4 baseColor_2;
  highp float nh_3;
  mediump vec3 h_4;
  mediump vec4 rtRefractions_5;
  mediump vec4 grabWithOffset_6;
  mediump vec4 distortOffset_7;
  mediump vec3 viewVector_8;
  mediump vec3 worldNormal_9;
  mediump vec4 coords_10;
  coords_10 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_11;
  vertexNormal_11 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_12;
  bumpStrength_12 = _DistortParams.x;
  mediump vec4 bump_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = (texture2D (_BumpMap, coords_10.xy) + texture2D (_BumpMap, coords_10.zw));
  bump_13 = tmpvar_14;
  bump_13.xy = (bump_13.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_15;
  tmpvar_15 = normalize((vertexNormal_11 + ((bump_13.xxy * bumpStrength_12) * vec3(1.0, 0.0, 1.0))));
  worldNormal_9.y = tmpvar_15.y;
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize(xlv_TEXCOORD1);
  viewVector_8 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, 0.0);
  tmpvar_17.xy = ((tmpvar_15.xz * _DistortParams.y) * 10.0);
  distortOffset_7 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18 = (xlv_TEXCOORD4 + distortOffset_7);
  grabWithOffset_6 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2DProj (_RefractionTex, grabWithOffset_6);
  rtRefractions_5 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((_WorldLightDir.xyz + viewVector_8));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, dot (tmpvar_15, -(h_4)));
  nh_3 = tmpvar_21;
  highp vec2 tmpvar_22;
  tmpvar_22 = (tmpvar_15.xz * _FresnelScale);
  worldNormal_9.xz = tmpvar_22;
  mediump float bias_23;
  bias_23 = _DistortParams.w;
  mediump float power_24;
  power_24 = _DistortParams.z;
  baseColor_2 = _BaseColor;
  reflectionColor_1 = _ReflectionColor;
  mediump vec4 tmpvar_25;
  tmpvar_25 = mix (mix (rtRefractions_5, baseColor_2, baseColor_2.wwww), reflectionColor_1, vec4(clamp ((bias_23 + ((1.0 - bias_23) * pow (clamp ((1.0 - max (dot (-(viewVector_8), worldNormal_9), 0.0)), 0.0, 1.0), power_24))), 0.0, 1.0)));
  highp vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_25 + (max (0.0, pow (nh_3, _Shininess)) * _SpecularColor));
  baseColor_2.xyz = tmpvar_26.xyz;
  baseColor_2.w = 1.0;
  gl_FragData[0] = baseColor_2;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = _glesVertex.w;
  mediump vec3 vtxForAni_2;
  mediump vec3 worldSpaceVertex_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_3 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (worldSpaceVertex_3.xzz * unity_Scale.w);
  vtxForAni_2 = tmpvar_6;
  mediump vec4 amplitude_7;
  amplitude_7 = _GAmplitude;
  mediump vec4 frequency_8;
  frequency_8 = _GFrequency;
  mediump vec4 steepness_9;
  steepness_9 = _GSteepness;
  mediump vec4 speed_10;
  speed_10 = _GSpeed;
  mediump vec4 directionAB_11;
  directionAB_11 = _GDirectionAB;
  mediump vec4 directionCD_12;
  directionCD_12 = _GDirectionCD;
  mediump vec4 TIME_13;
  mediump vec3 offsets_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((steepness_9.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_16;
  tmpvar_16 = ((steepness_9.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_17;
  tmpvar_17.x = dot (directionAB_11.xy, vtxForAni_2.xz);
  tmpvar_17.y = dot (directionAB_11.zw, vtxForAni_2.xz);
  tmpvar_17.z = dot (directionCD_12.xy, vtxForAni_2.xz);
  tmpvar_17.w = dot (directionCD_12.zw, vtxForAni_2.xz);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (frequency_8 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (_Time.yyyy * speed_10);
  TIME_13 = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = cos((tmpvar_18 + TIME_13));
  mediump vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_15.xz;
  tmpvar_21.zw = tmpvar_16.xz;
  offsets_14.x = dot (tmpvar_20, tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22.xy = tmpvar_15.yw;
  tmpvar_22.zw = tmpvar_16.yw;
  offsets_14.z = dot (tmpvar_20, tmpvar_22);
  offsets_14.y = dot (sin((tmpvar_18 + TIME_13)), amplitude_7);
  mediump vec2 xzVtx_23;
  xzVtx_23 = (vtxForAni_2.xz + offsets_14.xz);
  mediump vec4 TIME_24;
  mediump vec3 nrml_25;
  nrml_25.y = 2.0;
  mediump vec4 tmpvar_26;
  tmpvar_26 = ((frequency_8.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_27;
  tmpvar_27 = ((frequency_8.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_28;
  tmpvar_28.x = dot (directionAB_11.xy, xzVtx_23);
  tmpvar_28.y = dot (directionAB_11.zw, xzVtx_23);
  tmpvar_28.z = dot (directionCD_12.xy, xzVtx_23);
  tmpvar_28.w = dot (directionCD_12.zw, xzVtx_23);
  highp vec4 tmpvar_29;
  tmpvar_29 = (_Time.yyyy * speed_10);
  TIME_24 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = cos(((frequency_8 * tmpvar_28) + TIME_24));
  mediump vec4 tmpvar_31;
  tmpvar_31.xy = tmpvar_26.xz;
  tmpvar_31.zw = tmpvar_27.xz;
  nrml_25.x = -(dot (tmpvar_30, tmpvar_31));
  mediump vec4 tmpvar_32;
  tmpvar_32.xy = tmpvar_26.yw;
  tmpvar_32.zw = tmpvar_27.yw;
  nrml_25.z = -(dot (tmpvar_30, tmpvar_32));
  nrml_25.xz = (nrml_25.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_33;
  tmpvar_33 = normalize(nrml_25);
  nrml_25 = tmpvar_33;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_14);
  highp vec4 tmpvar_34;
  tmpvar_34 = (glstate_matrix_mvp * tmpvar_1);
  highp vec4 grabPassPos_35;
  highp vec4 o_36;
  highp vec4 tmpvar_37;
  tmpvar_37 = (tmpvar_34 * 0.5);
  highp vec2 tmpvar_38;
  tmpvar_38.x = tmpvar_37.x;
  tmpvar_38.y = (tmpvar_37.y * _ProjectionParams.x);
  o_36.xy = (tmpvar_38 + tmpvar_37.w);
  o_36.zw = tmpvar_34.zw;
  grabPassPos_35.xy = ((tmpvar_34.xy + tmpvar_34.w) * 0.5);
  grabPassPos_35.zw = tmpvar_34.zw;
  tmpvar_4.xyz = tmpvar_33;
  tmpvar_4.w = 1.0;
  gl_Position = tmpvar_34;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (worldSpaceVertex_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_36;
  xlv_TEXCOORD4 = grabPassPos_35;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _RefractionTex;
uniform sampler2D _BumpMap;
void main ()
{
  mediump vec4 reflectionColor_1;
  mediump vec4 baseColor_2;
  highp float nh_3;
  mediump vec3 h_4;
  mediump vec4 rtRefractions_5;
  mediump vec4 grabWithOffset_6;
  mediump vec4 distortOffset_7;
  mediump vec3 viewVector_8;
  mediump vec3 worldNormal_9;
  mediump vec4 coords_10;
  coords_10 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_11;
  vertexNormal_11 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_12;
  bumpStrength_12 = _DistortParams.x;
  mediump vec4 bump_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = (texture2D (_BumpMap, coords_10.xy) + texture2D (_BumpMap, coords_10.zw));
  bump_13 = tmpvar_14;
  bump_13.xy = (bump_13.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_15;
  tmpvar_15 = normalize((vertexNormal_11 + ((bump_13.xxy * bumpStrength_12) * vec3(1.0, 0.0, 1.0))));
  worldNormal_9.y = tmpvar_15.y;
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize(xlv_TEXCOORD1);
  viewVector_8 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, 0.0);
  tmpvar_17.xy = ((tmpvar_15.xz * _DistortParams.y) * 10.0);
  distortOffset_7 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18 = (xlv_TEXCOORD4 + distortOffset_7);
  grabWithOffset_6 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2DProj (_RefractionTex, grabWithOffset_6);
  rtRefractions_5 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((_WorldLightDir.xyz + viewVector_8));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, dot (tmpvar_15, -(h_4)));
  nh_3 = tmpvar_21;
  highp vec2 tmpvar_22;
  tmpvar_22 = (tmpvar_15.xz * _FresnelScale);
  worldNormal_9.xz = tmpvar_22;
  mediump float bias_23;
  bias_23 = _DistortParams.w;
  mediump float power_24;
  power_24 = _DistortParams.z;
  baseColor_2 = _BaseColor;
  reflectionColor_1 = _ReflectionColor;
  mediump vec4 tmpvar_25;
  tmpvar_25 = mix (mix (rtRefractions_5, baseColor_2, baseColor_2.wwww), reflectionColor_1, vec4(clamp ((bias_23 + ((1.0 - bias_23) * pow (clamp ((1.0 - max (dot (-(viewVector_8), worldNormal_9), 0.0)), 0.0, 1.0), power_24))), 0.0, 1.0)));
  highp vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_25 + (max (0.0, pow (nh_3, _Shininess)) * _SpecularColor));
  baseColor_2.xyz = tmpvar_26.xyz;
  baseColor_2.w = 1.0;
  gl_FragData[0] = baseColor_2;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 485
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 495
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 504
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 348
#line 356
#line 379
#line 396
#line 408
#line 453
#line 474
#line 511
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 515
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 519
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 523
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 527
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 531
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 551
#line 575
#line 612
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 356
void ComputeScreenAndGrabPassPos( in highp vec4 pos, out highp vec4 screenPos, out highp vec4 grabPassPos ) {
    highp float scale = 1.0;
    screenPos = ComputeScreenPos( pos);
    #line 360
    grabPassPos.xy = ((vec2( pos.x, (pos.y * scale)) + pos.w) * 0.5);
    grabPassPos.zw = pos.zw;
}
#line 460
mediump vec3 GerstnerNormal4( in mediump vec2 xzVtx, in mediump vec4 amp, in mediump vec4 freq, in mediump vec4 speed, in mediump vec4 dirAB, in mediump vec4 dirCD ) {
    #line 462
    mediump vec3 nrml = vec3( 0.0, 2.0, 0.0);
    mediump vec4 AB = ((freq.xxyy * amp.xxyy) * dirAB.xyzw);
    mediump vec4 CD = ((freq.zzww * amp.zzww) * dirCD.xyzw);
    mediump vec4 dotABCD = (freq.xyzw * vec4( dot( dirAB.xy, xzVtx), dot( dirAB.zw, xzVtx), dot( dirCD.xy, xzVtx), dot( dirCD.zw, xzVtx)));
    #line 466
    mediump vec4 TIME = (_Time.yyyy * speed);
    mediump vec4 COS = cos((dotABCD + TIME));
    nrml.x -= dot( COS, vec4( AB.xz, CD.xz));
    nrml.z -= dot( COS, vec4( AB.yw, CD.yw));
    #line 470
    nrml.xz *= _GerstnerIntensity;
    nrml = normalize(nrml);
    return nrml;
}
#line 439
mediump vec3 GerstnerOffset4( in mediump vec2 xzVtx, in mediump vec4 steepness, in mediump vec4 amp, in mediump vec4 freq, in mediump vec4 speed, in mediump vec4 dirAB, in mediump vec4 dirCD ) {
    #line 441
    mediump vec3 offsets;
    mediump vec4 AB = ((steepness.xxyy * amp.xxyy) * dirAB.xyzw);
    mediump vec4 CD = ((steepness.zzww * amp.zzww) * dirCD.xyzw);
    mediump vec4 dotABCD = (freq.xyzw * vec4( dot( dirAB.xy, xzVtx), dot( dirAB.zw, xzVtx), dot( dirCD.xy, xzVtx), dot( dirCD.zw, xzVtx)));
    #line 445
    mediump vec4 TIME = (_Time.yyyy * speed);
    mediump vec4 COS = cos((dotABCD + TIME));
    mediump vec4 SIN = sin((dotABCD + TIME));
    offsets.x = dot( COS, vec4( AB.xz, CD.xz));
    #line 449
    offsets.z = dot( COS, vec4( AB.yw, CD.yw));
    offsets.y = dot( SIN, amp);
    return offsets;
}
#line 474
void Gerstner( out mediump vec3 offs, out mediump vec3 nrml, in mediump vec3 vtx, in mediump vec3 tileableVtx, in mediump vec4 amplitude, in mediump vec4 frequency, in mediump vec4 steepness, in mediump vec4 speed, in mediump vec4 directionAB, in mediump vec4 directionCD ) {
    offs = GerstnerOffset4( tileableVtx.xz, steepness, amplitude, frequency, speed, directionAB, directionCD);
    nrml = GerstnerNormal4( (tileableVtx.xz + offs.xz), amplitude, frequency, speed, directionAB, directionCD);
}
#line 533
v2f vert( in appdata_full v ) {
    #line 535
    v2f o;
    mediump vec3 worldSpaceVertex = (_Object2World * v.vertex).xyz;
    mediump vec3 vtxForAni = (worldSpaceVertex.xzz * unity_Scale.w);
    mediump vec3 nrml;
    #line 539
    mediump vec3 offsets;
    Gerstner( offsets, nrml, v.vertex.xyz, vtxForAni, _GAmplitude, _GFrequency, _GSteepness, _GSpeed, _GDirectionAB, _GDirectionCD);
    v.vertex.xyz += offsets;
    mediump vec2 tileableUv = worldSpaceVertex.xz;
    #line 543
    o.bumpCoords.xyzw = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection.xyzw)) * _BumpTiling.xyzw);
    o.viewInterpolator.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
    o.pos = (glstate_matrix_mvp * v.vertex);
    ComputeScreenAndGrabPassPos( o.pos, o.screenPos, o.grabPassPos);
    #line 547
    o.normalInterpolator.xyz = nrml;
    o.normalInterpolator.w = 1.0;
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.normalInterpolator);
    xlv_TEXCOORD1 = vec3(xl_retval.viewInterpolator);
    xlv_TEXCOORD2 = vec4(xl_retval.bumpCoords);
    xlv_TEXCOORD3 = vec4(xl_retval.screenPos);
    xlv_TEXCOORD4 = vec4(xl_retval.grabPassPos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 485
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 495
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 504
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 348
#line 356
#line 379
#line 396
#line 408
#line 453
#line 474
#line 511
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 515
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 519
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 523
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 527
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 531
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 551
#line 575
#line 612
#line 390
mediump float Fresnel( in mediump vec3 viewVector, in mediump vec3 worldNormal, in mediump float bias, in mediump float power ) {
    #line 392
    mediump float facing = clamp( (1.0 - max( dot( (-viewVector), worldNormal), 0.0)), 0.0, 1.0);
    mediump float refl2Refr = xll_saturate_f((bias + ((1.0 - bias) * pow( facing, power))));
    return refl2Refr;
}
#line 316
mediump vec3 PerPixelNormal( in sampler2D bumpMap, in mediump vec4 coords, in mediump vec3 vertexNormal, in mediump float bumpStrength ) {
    mediump vec4 bump = (texture( bumpMap, coords.xy) + texture( bumpMap, coords.zw));
    #line 319
    bump.xy = (bump.wy - vec2( 1.0, 1.0));
    mediump vec3 worldNormal = (vertexNormal + ((bump.xxy * bumpStrength) * vec3( 1.0, 0.0, 1.0)));
    return normalize(worldNormal);
}
#line 551
mediump vec4 frag( in v2f i ) {
    mediump vec3 worldNormal = PerPixelNormal( _BumpMap, i.bumpCoords, i.normalInterpolator.xyz, _DistortParams.x);
    mediump vec3 viewVector = normalize(i.viewInterpolator.xyz);
    #line 555
    mediump vec4 distortOffset = vec4( ((worldNormal.xz * _DistortParams.y) * 10.0), 0.0, 0.0);
    mediump vec4 screenWithOffset = (i.screenPos + distortOffset);
    mediump vec4 grabWithOffset = (i.grabPassPos + distortOffset);
    mediump vec4 rtRefractionsNoDistort = textureProj( _RefractionTex, i.grabPassPos);
    #line 559
    mediump float refrFix = textureProj( _CameraDepthTexture, grabWithOffset).x;
    mediump vec4 rtRefractions = textureProj( _RefractionTex, grabWithOffset);
    mediump vec3 reflectVector = normalize(reflect( viewVector, worldNormal));
    mediump vec3 h = normalize((_WorldLightDir.xyz + viewVector.xyz));
    #line 563
    highp float nh = max( 0.0, dot( worldNormal, (-h)));
    highp float spec = max( 0.0, pow( nh, _Shininess));
    mediump vec4 edgeBlendFactors = vec4( 1.0, 0.0, 0.0, 0.0);
    worldNormal.xz *= _FresnelScale;
    #line 567
    mediump float refl2Refr = Fresnel( viewVector, worldNormal, _DistortParams.w, _DistortParams.z);
    mediump vec4 baseColor = _BaseColor;
    mediump vec4 reflectionColor = _ReflectionColor;
    baseColor = mix( mix( rtRefractions, baseColor, vec4( baseColor.w)), reflectionColor, vec4( refl2Refr));
    #line 571
    baseColor = (baseColor + (spec * _SpecularColor));
    baseColor.w = edgeBlendFactors.x;
    return baseColor;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    mediump vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.normalInterpolator = vec4(xlv_TEXCOORD0);
    xlt_i.viewInterpolator = vec3(xlv_TEXCOORD1);
    xlt_i.bumpCoords = vec4(xlv_TEXCOORD2);
    xlt_i.screenPos = vec4(xlv_TEXCOORD3);
    xlt_i.grabPassPos = vec4(xlv_TEXCOORD4);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 grabPassPos_4;
  vec4 o_5;
  vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  grabPassPos_4.xy = ((tmpvar_3.xy + tmpvar_3.w) * 0.5);
  grabPassPos_4.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (tmpvar_2 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_2.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_5;
  xlv_TEXCOORD4 = grabPassPos_4;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _InvFadeParemeter;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
uniform vec4 _ZBufferParams;
void main ()
{
  vec4 baseColor_1;
  vec4 rtRefractions_2;
  vec3 worldNormal_3;
  vec4 bump_4;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_4.zw = tmpvar_5.zw;
  bump_4.xy = (tmpvar_5.wy - vec2(1.0, 1.0));
  vec3 tmpvar_6;
  tmpvar_6 = normalize((xlv_TEXCOORD0.xyz + ((bump_4.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_3 = tmpvar_6;
  vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_8;
  tmpvar_8.zw = vec2(0.0, 0.0);
  tmpvar_8.xy = ((tmpvar_6.xz * _DistortParams.y) * 10.0);
  vec4 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD4 + tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractions_2 = texture2DProj (_RefractionTex, tmpvar_9);
  vec4 tmpvar_11;
  tmpvar_11 = texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_8));
  float tmpvar_12;
  tmpvar_12 = (1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, tmpvar_9).x) + _ZBufferParams.w)));
  if ((tmpvar_12 < xlv_TEXCOORD3.z)) {
    rtRefractions_2 = tmpvar_10;
  };
  worldNormal_3.xz = (tmpvar_6.xz * _FresnelScale);
  baseColor_1.xyz = (mix (mix (rtRefractions_2, _BaseColor, _BaseColor.wwww), mix (tmpvar_11, _ReflectionColor, _ReflectionColor.wwww), vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_7), worldNormal_3), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_6, -(normalize((_WorldLightDir.xyz + tmpvar_7))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = clamp ((_InvFadeParemeter * ((1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w))) - xlv_TEXCOORD3.w)), 0.0, 1.0).x;
  gl_FragData[0] = baseColor_1;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 24 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r2.y, v0, c1
dp4 r2.w, v0, c3
dp4 r3.x, v0, c0
mov r0.w, r2
dp4 r0.z, v0, c2
mov r0.y, r2
mov r0.x, r3
mul r1.xyz, r0.xyww, c14.x
mul r1.y, r1, c10.x
mov o0, r0
mov r3.y, -r2
mov r0.x, c8
dp4 r2.x, v0, c4
dp4 r2.z, v0, c6
mad o4.xy, r1.z, c11.zwzw, r1
mad r1, c13, r0.x, r2.xzxz
dp4 r2.y, v0, c5
add r0.xy, r2.w, r3
mov o1, c14.yzyz
mul o3, r1, c12
mov o4.zw, r0
mov o5.zw, r0
add o2.xyz, r2, -c9
mul o5.xy, r0, c14.x
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Vector 13 [_BumpDirection]
Vector 12 [_BumpTiling]
Matrix 8 [_Object2World] 4
Vector 2 [_ProjectionParams]
Vector 3 [_ScreenParams]
Vector 0 [_Time]
Vector 1 [_WorldSpaceCameraPos]
Matrix 4 [glstate_matrix_mvp] 4
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 28.00 (21 instructions), vertex: 32, texture: 0,
//   sequencer: 14,  4 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaaccmaaaaabieaaaaaaaaaaaaaaceaaaaabkeaaaaabmmaaaaaaaa
aaaaaaaaaaaaabhmaaaaaabmaaaaabgopppoadaaaaaaaaaiaaaaaabmaaaaaaaa
aaaaabghaaaaaalmaaacaaanaaabaaaaaaaaaammaaaaaaaaaaaaaanmaaacaaam
aaabaaaaaaaaaammaaaaaaaaaaaaaaoiaaacaaaiaaaeaaaaaaaaaapiaaaaaaaa
aaaaabaiaaacaaacaaabaaaaaaaaaammaaaaaaaaaaaaabbkaaacaaadaaabaaaa
aaaaaammaaaaaaaaaaaaabciaaacaaaaaaabaaaaaaaaaammaaaaaaaaaaaaabco
aaacaaabaaabaaaaaaaaabeeaaaaaaaaaaaaabfeaaacaaaeaaaeaaaaaaaaaapi
aaaaaaaafpechfgnhaeegjhcgfgdhegjgpgoaaklaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpechfgnhafegjgmgjgoghaafpepgcgkgfgdhedcfhgphcgmgeaaklkl
aaadaaadaaaeaaaeaaabaaaaaaaaaaaafpfahcgpgkgfgdhegjgpgofagbhcgbgn
hdaafpfdgdhcgfgfgofagbhcgbgnhdaafpfegjgngfaafpfhgphcgmgefdhagbgd
gfedgbgngfhcgbfagphdaaklaaabaaadaaabaaadaaabaaaaaaaaaaaaghgmhdhe
gbhegffpgngbhehcgjhifpgnhghaaahghdfpddfpdaaadccodacodcdadddfddco
daaaklklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaabeeaaebaaadaaaaaaaaaaaaaaaa
aaaaemkfaaaaaaabaaaaaaabaaaaaaaiaaaaacjaaaaaaaaeaaaapafaaaabhbfb
aaacpcfcaaadpdfdaaagpefeaaaababaaaaababdaaaababgaaaaaabbaaaaaabh
aaaababjaaaaaabcaaaababiaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaalpiaaaaa
dpiaaaaadpaaaaaaaaaaaaaabaabbaaeaaaabcaamcaaaaaaaaaafaafaaaabcaa
meaaaaaaaaaagaakgababcaabcaaaaaaaaaaeabgaaaaccaaaaaaaaaaafpiaaaa
aaaaaanbaaaaaaaamiapaaabaamgiiaakbaaahaamiapaaabaalbnapiklaaagab
miapaaabaagmdepiklaaafabmiapaaadaablnajeklaaaeabmiapiadoaananaaa
ocadadaamiahaaabaamgleaakbaaalaamiahaaabaalbmaleklaaakabmiahaaaa
aagmleleklaaajabmiahaaaaaablmaleklaaaiaamiapaaacaagmkhooclaaanaa
miapaaabaaofmaaakbadppaacalkmaaaabaaaagmocaaaaiamiamiaadaanlnlaa
ocadadaamiamiaaeaanlnlaaocadadaamiahiaabacmamaaakaaaabaabebgaaaa
aablbglbkbabadadkibdaaabaamegnmamaadabppmiapiaacaahkaaaakbacamaa
miabiaadaamglbaaoaabaaaamiadiaaeaalamgaakbabppaamiaciaadaagmgmmg
klaaacaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Matrix 256 [glstate_matrix_mvp]
Bind "vertex" Vertex
Vector 467 [_Time]
Vector 466 [_WorldSpaceCameraPos]
Vector 465 [_ProjectionParams]
Matrix 260 [_Object2World]
Vector 464 [_BumpTiling]
Vector 463 [_BumpDirection]
"sce_vp_rsx // 24 instructions using 4 registers
[Configuration]
8
0000001800010400
[Defaults]
1
462 3
000000003f8000003f000000
[Microcode]
384
401f9c6c005ce0088186c0836041ff9c00009c6c005cf00d8186c0836041fffc
00001c6c01d0200d8106c0c360405ffc00011c6c01d0000d8106c0c360411ffc
00011c6c01d0300d8106c0c360405ffc00001c6c01d0100d8106c0c360411ffc
00019c6c01d0500d8106c0c360409ffc00019c6c01d0600d8106c0c360405ffc
00019c6c01d0400d8106c0c360411ffc00009c6c011d300d828000c441a1fffc
401f9c6c00dd208c0186c08301a1dfa000011c6c004000800086c08360409ffc
00001c6c004000000086c08360409ffc00001c6c004000550486c08360403ffc
00001c6c004000000486c08360411ffc401f9c6c009d000d8286c0c36041ffa4
401f9c6c0040000d8086c0836041ff80401f9c6c004000558086c08360407fa8
401f9c6c004000558086c08360407fac00009c6c00c000080486c09541219ffc
00001c6c009ce00e00aa80c36041dffc00001c6c009d102a808000c360409ffc
401f9c6c00c000080086c09540219fa8401f9c6c009ce00802aa80c360419fad
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304 // 208 used size, 19 vars
Vector 176 [_BumpTiling] 4
Vector 192 [_BumpDirection] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 0 [_Time] 4
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 22 instructions, 2 temp regs, 0 temp arrays:
// ALU 17 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgfnbjpjeejeaghdcadhgpaenaihapgflabaaaaaaceafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefchaadaaaaeaaaabaanmaaaaaafjaaaaae
egiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaipccabaaa
abaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaiadpdiaaaaaihcaabaaa
abaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaaa
abaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaabaaaaaa
agiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaabaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaalaaaaaa
diaaaaaibcaabaaaabaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaahicaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaadpdiaaaaak
fcaabaaaabaaaaaaagadbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
dcaaaaamdcaabaaaaaaaaaaaegaabaaaaaaaaaaaaceaaaaaaaaaiadpaaaaialp
aaaaaaaaaaaaaaaapgapbaaaaaaaaaaadiaaaaakdccabaaaafaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaadgaaaaafmccabaaa
aeaaaaaakgaobaaaaaaaaaaadgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 worldSpaceVertex_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_1 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 grabPassPos_5;
  highp vec4 o_6;
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7.x;
  tmpvar_8.y = (tmpvar_7.y * _ProjectionParams.x);
  o_6.xy = (tmpvar_8 + tmpvar_7.w);
  o_6.zw = tmpvar_4.zw;
  grabPassPos_5.xy = ((tmpvar_4.xy + tmpvar_4.w) * 0.5);
  grabPassPos_5.zw = tmpvar_4.zw;
  tmpvar_2.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex_1 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_1.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_6;
  xlv_TEXCOORD4 = grabPassPos_5;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _InvFadeParemeter;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _ZBufferParams;
void main ()
{
  mediump vec4 reflectionColor_1;
  mediump vec4 baseColor_2;
  mediump float depth_3;
  mediump vec4 edgeBlendFactors_4;
  highp float nh_5;
  mediump vec3 h_6;
  mediump vec4 rtReflections_7;
  mediump vec4 rtRefractions_8;
  mediump float refrFix_9;
  mediump vec4 rtRefractionsNoDistort_10;
  mediump vec4 grabWithOffset_11;
  mediump vec4 screenWithOffset_12;
  mediump vec4 distortOffset_13;
  mediump vec3 viewVector_14;
  mediump vec3 worldNormal_15;
  mediump vec4 coords_16;
  coords_16 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_17;
  vertexNormal_17 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_18;
  bumpStrength_18 = _DistortParams.x;
  mediump vec4 bump_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = (texture2D (_BumpMap, coords_16.xy) + texture2D (_BumpMap, coords_16.zw));
  bump_19 = tmpvar_20;
  bump_19.xy = (bump_19.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize((vertexNormal_17 + ((bump_19.xxy * bumpStrength_18) * vec3(1.0, 0.0, 1.0))));
  worldNormal_15 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize(xlv_TEXCOORD1);
  viewVector_14 = tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23.zw = vec2(0.0, 0.0);
  tmpvar_23.xy = ((tmpvar_21.xz * _DistortParams.y) * 10.0);
  distortOffset_13 = tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = (xlv_TEXCOORD3 + distortOffset_13);
  screenWithOffset_12 = tmpvar_24;
  highp vec4 tmpvar_25;
  tmpvar_25 = (xlv_TEXCOORD4 + distortOffset_13);
  grabWithOffset_11 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractionsNoDistort_10 = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = texture2DProj (_CameraDepthTexture, grabWithOffset_11).x;
  refrFix_9 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2DProj (_RefractionTex, grabWithOffset_11);
  rtRefractions_8 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2DProj (_ReflectionTex, screenWithOffset_12);
  rtReflections_7 = tmpvar_29;
  highp float tmpvar_30;
  highp float z_31;
  z_31 = refrFix_9;
  tmpvar_30 = (1.0/(((_ZBufferParams.z * z_31) + _ZBufferParams.w)));
  if ((tmpvar_30 < xlv_TEXCOORD3.z)) {
    rtRefractions_8 = rtRefractionsNoDistort_10;
  };
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize((_WorldLightDir.xyz + viewVector_14));
  h_6 = tmpvar_32;
  mediump float tmpvar_33;
  tmpvar_33 = max (0.0, dot (tmpvar_21, -(h_6)));
  nh_5 = tmpvar_33;
  lowp float tmpvar_34;
  tmpvar_34 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth_3 = tmpvar_34;
  highp float tmpvar_35;
  highp float z_36;
  z_36 = depth_3;
  tmpvar_35 = (1.0/(((_ZBufferParams.z * z_36) + _ZBufferParams.w)));
  depth_3 = tmpvar_35;
  highp vec4 tmpvar_37;
  tmpvar_37 = clamp ((_InvFadeParemeter * (depth_3 - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors_4 = tmpvar_37;
  highp vec2 tmpvar_38;
  tmpvar_38 = (tmpvar_21.xz * _FresnelScale);
  worldNormal_15.xz = tmpvar_38;
  mediump float bias_39;
  bias_39 = _DistortParams.w;
  mediump float power_40;
  power_40 = _DistortParams.z;
  baseColor_2 = _BaseColor;
  highp vec4 tmpvar_41;
  tmpvar_41 = mix (rtReflections_7, _ReflectionColor, _ReflectionColor.wwww);
  reflectionColor_1 = tmpvar_41;
  mediump vec4 tmpvar_42;
  tmpvar_42 = mix (mix (rtRefractions_8, baseColor_2, baseColor_2.wwww), reflectionColor_1, vec4(clamp ((bias_39 + ((1.0 - bias_39) * pow (clamp ((1.0 - max (dot (-(viewVector_14), worldNormal_15), 0.0)), 0.0, 1.0), power_40))), 0.0, 1.0)));
  highp vec4 tmpvar_43;
  tmpvar_43 = (tmpvar_42 + (max (0.0, pow (nh_5, _Shininess)) * _SpecularColor));
  baseColor_2.xyz = tmpvar_43.xyz;
  baseColor_2.w = edgeBlendFactors_4.x;
  gl_FragData[0] = baseColor_2;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 worldSpaceVertex_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_1 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 grabPassPos_5;
  highp vec4 o_6;
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7.x;
  tmpvar_8.y = (tmpvar_7.y * _ProjectionParams.x);
  o_6.xy = (tmpvar_8 + tmpvar_7.w);
  o_6.zw = tmpvar_4.zw;
  grabPassPos_5.xy = ((tmpvar_4.xy + tmpvar_4.w) * 0.5);
  grabPassPos_5.zw = tmpvar_4.zw;
  tmpvar_2.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex_1 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_1.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_6;
  xlv_TEXCOORD4 = grabPassPos_5;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _InvFadeParemeter;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _ZBufferParams;
void main ()
{
  mediump vec4 reflectionColor_1;
  mediump vec4 baseColor_2;
  mediump float depth_3;
  mediump vec4 edgeBlendFactors_4;
  highp float nh_5;
  mediump vec3 h_6;
  mediump vec4 rtReflections_7;
  mediump vec4 rtRefractions_8;
  mediump float refrFix_9;
  mediump vec4 rtRefractionsNoDistort_10;
  mediump vec4 grabWithOffset_11;
  mediump vec4 screenWithOffset_12;
  mediump vec4 distortOffset_13;
  mediump vec3 viewVector_14;
  mediump vec3 worldNormal_15;
  mediump vec4 coords_16;
  coords_16 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_17;
  vertexNormal_17 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_18;
  bumpStrength_18 = _DistortParams.x;
  mediump vec4 bump_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = (texture2D (_BumpMap, coords_16.xy) + texture2D (_BumpMap, coords_16.zw));
  bump_19 = tmpvar_20;
  bump_19.xy = (bump_19.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize((vertexNormal_17 + ((bump_19.xxy * bumpStrength_18) * vec3(1.0, 0.0, 1.0))));
  worldNormal_15 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize(xlv_TEXCOORD1);
  viewVector_14 = tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23.zw = vec2(0.0, 0.0);
  tmpvar_23.xy = ((tmpvar_21.xz * _DistortParams.y) * 10.0);
  distortOffset_13 = tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = (xlv_TEXCOORD3 + distortOffset_13);
  screenWithOffset_12 = tmpvar_24;
  highp vec4 tmpvar_25;
  tmpvar_25 = (xlv_TEXCOORD4 + distortOffset_13);
  grabWithOffset_11 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractionsNoDistort_10 = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = texture2DProj (_CameraDepthTexture, grabWithOffset_11).x;
  refrFix_9 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2DProj (_RefractionTex, grabWithOffset_11);
  rtRefractions_8 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2DProj (_ReflectionTex, screenWithOffset_12);
  rtReflections_7 = tmpvar_29;
  highp float tmpvar_30;
  highp float z_31;
  z_31 = refrFix_9;
  tmpvar_30 = (1.0/(((_ZBufferParams.z * z_31) + _ZBufferParams.w)));
  if ((tmpvar_30 < xlv_TEXCOORD3.z)) {
    rtRefractions_8 = rtRefractionsNoDistort_10;
  };
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize((_WorldLightDir.xyz + viewVector_14));
  h_6 = tmpvar_32;
  mediump float tmpvar_33;
  tmpvar_33 = max (0.0, dot (tmpvar_21, -(h_6)));
  nh_5 = tmpvar_33;
  lowp float tmpvar_34;
  tmpvar_34 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth_3 = tmpvar_34;
  highp float tmpvar_35;
  highp float z_36;
  z_36 = depth_3;
  tmpvar_35 = (1.0/(((_ZBufferParams.z * z_36) + _ZBufferParams.w)));
  depth_3 = tmpvar_35;
  highp vec4 tmpvar_37;
  tmpvar_37 = clamp ((_InvFadeParemeter * (depth_3 - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors_4 = tmpvar_37;
  highp vec2 tmpvar_38;
  tmpvar_38 = (tmpvar_21.xz * _FresnelScale);
  worldNormal_15.xz = tmpvar_38;
  mediump float bias_39;
  bias_39 = _DistortParams.w;
  mediump float power_40;
  power_40 = _DistortParams.z;
  baseColor_2 = _BaseColor;
  highp vec4 tmpvar_41;
  tmpvar_41 = mix (rtReflections_7, _ReflectionColor, _ReflectionColor.wwww);
  reflectionColor_1 = tmpvar_41;
  mediump vec4 tmpvar_42;
  tmpvar_42 = mix (mix (rtRefractions_8, baseColor_2, baseColor_2.wwww), reflectionColor_1, vec4(clamp ((bias_39 + ((1.0 - bias_39) * pow (clamp ((1.0 - max (dot (-(viewVector_14), worldNormal_15), 0.0)), 0.0, 1.0), power_40))), 0.0, 1.0)));
  highp vec4 tmpvar_43;
  tmpvar_43 = (tmpvar_42 + (max (0.0, pow (nh_5, _Shininess)) * _SpecularColor));
  baseColor_2.xyz = tmpvar_43.xyz;
  baseColor_2.w = edgeBlendFactors_4.x;
  gl_FragData[0] = baseColor_2;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 480
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 490
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 499
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 351
#line 374
#line 391
#line 403
#line 448
#line 469
#line 506
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 510
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 514
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 518
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 522
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 526
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 546
#line 575
#line 616
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 351
void ComputeScreenAndGrabPassPos( in highp vec4 pos, out highp vec4 screenPos, out highp vec4 grabPassPos ) {
    highp float scale = 1.0;
    screenPos = ComputeScreenPos( pos);
    #line 355
    grabPassPos.xy = ((vec2( pos.x, (pos.y * scale)) + pos.w) * 0.5);
    grabPassPos.zw = pos.zw;
}
#line 469
void Gerstner( out mediump vec3 offs, out mediump vec3 nrml, in mediump vec3 vtx, in mediump vec3 tileableVtx, in mediump vec4 amplitude, in mediump vec4 frequency, in mediump vec4 steepness, in mediump vec4 speed, in mediump vec4 directionAB, in mediump vec4 directionCD ) {
    offs = vec3( 0.0, 0.0, 0.0);
    nrml = vec3( 0.0, 1.0, 0.0);
}
#line 528
v2f vert( in appdata_full v ) {
    #line 530
    v2f o;
    mediump vec3 worldSpaceVertex = (_Object2World * v.vertex).xyz;
    mediump vec3 vtxForAni = (worldSpaceVertex.xzz * unity_Scale.w);
    mediump vec3 nrml;
    #line 534
    mediump vec3 offsets;
    Gerstner( offsets, nrml, v.vertex.xyz, vtxForAni, _GAmplitude, _GFrequency, _GSteepness, _GSpeed, _GDirectionAB, _GDirectionCD);
    v.vertex.xyz += offsets;
    mediump vec2 tileableUv = worldSpaceVertex.xz;
    #line 538
    o.bumpCoords.xyzw = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection.xyzw)) * _BumpTiling.xyzw);
    o.viewInterpolator.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
    o.pos = (glstate_matrix_mvp * v.vertex);
    ComputeScreenAndGrabPassPos( o.pos, o.screenPos, o.grabPassPos);
    #line 542
    o.normalInterpolator.xyz = nrml;
    o.normalInterpolator.w = 1.0;
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.normalInterpolator);
    xlv_TEXCOORD1 = vec3(xl_retval.viewInterpolator);
    xlv_TEXCOORD2 = vec4(xl_retval.bumpCoords);
    xlv_TEXCOORD3 = vec4(xl_retval.screenPos);
    xlv_TEXCOORD4 = vec4(xl_retval.grabPassPos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 480
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 490
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 499
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 351
#line 374
#line 391
#line 403
#line 448
#line 469
#line 506
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 510
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 514
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 518
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 522
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 526
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 546
#line 575
#line 616
#line 385
mediump float Fresnel( in mediump vec3 viewVector, in mediump vec3 worldNormal, in mediump float bias, in mediump float power ) {
    #line 387
    mediump float facing = clamp( (1.0 - max( dot( (-viewVector), worldNormal), 0.0)), 0.0, 1.0);
    mediump float refl2Refr = xll_saturate_f((bias + ((1.0 - bias) * pow( facing, power))));
    return refl2Refr;
}
#line 280
highp float LinearEyeDepth( in highp float z ) {
    #line 282
    return (1.0 / ((_ZBufferParams.z * z) + _ZBufferParams.w));
}
#line 316
mediump vec3 PerPixelNormal( in sampler2D bumpMap, in mediump vec4 coords, in mediump vec3 vertexNormal, in mediump float bumpStrength ) {
    mediump vec4 bump = (texture( bumpMap, coords.xy) + texture( bumpMap, coords.zw));
    #line 319
    bump.xy = (bump.wy - vec2( 1.0, 1.0));
    mediump vec3 worldNormal = (vertexNormal + ((bump.xxy * bumpStrength) * vec3( 1.0, 0.0, 1.0)));
    return normalize(worldNormal);
}
#line 546
mediump vec4 frag( in v2f i ) {
    mediump vec3 worldNormal = PerPixelNormal( _BumpMap, i.bumpCoords, i.normalInterpolator.xyz, _DistortParams.x);
    mediump vec3 viewVector = normalize(i.viewInterpolator.xyz);
    #line 550
    mediump vec4 distortOffset = vec4( ((worldNormal.xz * _DistortParams.y) * 10.0), 0.0, 0.0);
    mediump vec4 screenWithOffset = (i.screenPos + distortOffset);
    mediump vec4 grabWithOffset = (i.grabPassPos + distortOffset);
    mediump vec4 rtRefractionsNoDistort = textureProj( _RefractionTex, i.grabPassPos);
    #line 554
    mediump float refrFix = textureProj( _CameraDepthTexture, grabWithOffset).x;
    mediump vec4 rtRefractions = textureProj( _RefractionTex, grabWithOffset);
    mediump vec4 rtReflections = textureProj( _ReflectionTex, screenWithOffset);
    if ((LinearEyeDepth( refrFix) < i.screenPos.z)){
        rtRefractions = rtRefractionsNoDistort;
    }
    #line 558
    mediump vec3 reflectVector = normalize(reflect( viewVector, worldNormal));
    mediump vec3 h = normalize((_WorldLightDir.xyz + viewVector.xyz));
    highp float nh = max( 0.0, dot( worldNormal, (-h)));
    highp float spec = max( 0.0, pow( nh, _Shininess));
    #line 562
    mediump vec4 edgeBlendFactors = vec4( 1.0, 0.0, 0.0, 0.0);
    mediump float depth = textureProj( _CameraDepthTexture, i.screenPos).x;
    depth = LinearEyeDepth( depth);
    edgeBlendFactors = xll_saturate_vf4((_InvFadeParemeter * (depth - i.screenPos.w)));
    #line 566
    worldNormal.xz *= _FresnelScale;
    mediump float refl2Refr = Fresnel( viewVector, worldNormal, _DistortParams.w, _DistortParams.z);
    mediump vec4 baseColor = _BaseColor;
    mediump vec4 reflectionColor = mix( rtReflections, _ReflectionColor, vec4( _ReflectionColor.w));
    #line 570
    baseColor = mix( mix( rtRefractions, baseColor, vec4( baseColor.w)), reflectionColor, vec4( refl2Refr));
    baseColor = (baseColor + (spec * _SpecularColor));
    baseColor.w = edgeBlendFactors.x;
    return baseColor;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    mediump vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.normalInterpolator = vec4(xlv_TEXCOORD0);
    xlt_i.viewInterpolator = vec3(xlv_TEXCOORD1);
    xlt_i.bumpCoords = vec4(xlv_TEXCOORD2);
    xlt_i.screenPos = vec4(xlv_TEXCOORD3);
    xlt_i.grabPassPos = vec4(xlv_TEXCOORD4);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 grabPassPos_4;
  vec4 o_5;
  vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  grabPassPos_4.xy = ((tmpvar_3.xy + tmpvar_3.w) * 0.5);
  grabPassPos_4.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (tmpvar_2 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_2.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_5;
  xlv_TEXCOORD4 = grabPassPos_4;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _InvFadeParemeter;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _RefractionTex;
uniform sampler2D _BumpMap;
uniform vec4 _ZBufferParams;
void main ()
{
  vec4 baseColor_1;
  vec4 rtRefractions_2;
  vec3 worldNormal_3;
  vec4 bump_4;
  vec4 tmpvar_5;
  tmpvar_5 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_4.zw = tmpvar_5.zw;
  bump_4.xy = (tmpvar_5.wy - vec2(1.0, 1.0));
  vec3 tmpvar_6;
  tmpvar_6 = normalize((xlv_TEXCOORD0.xyz + ((bump_4.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_3 = tmpvar_6;
  vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_8;
  tmpvar_8.zw = vec2(0.0, 0.0);
  tmpvar_8.xy = ((tmpvar_6.xz * _DistortParams.y) * 10.0);
  vec4 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD4 + tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractions_2 = texture2DProj (_RefractionTex, tmpvar_9);
  float tmpvar_11;
  tmpvar_11 = (1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, tmpvar_9).x) + _ZBufferParams.w)));
  if ((tmpvar_11 < xlv_TEXCOORD3.z)) {
    rtRefractions_2 = tmpvar_10;
  };
  worldNormal_3.xz = (tmpvar_6.xz * _FresnelScale);
  baseColor_1.xyz = (mix (mix (rtRefractions_2, _BaseColor, _BaseColor.wwww), _ReflectionColor, vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_7), worldNormal_3), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_6, -(normalize((_WorldLightDir.xyz + tmpvar_7))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = clamp ((_InvFadeParemeter * ((1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w))) - xlv_TEXCOORD3.w)), 0.0, 1.0).x;
  gl_FragData[0] = baseColor_1;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 24 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r2.y, v0, c1
dp4 r2.w, v0, c3
dp4 r3.x, v0, c0
mov r0.w, r2
dp4 r0.z, v0, c2
mov r0.y, r2
mov r0.x, r3
mul r1.xyz, r0.xyww, c14.x
mul r1.y, r1, c10.x
mov o0, r0
mov r3.y, -r2
mov r0.x, c8
dp4 r2.x, v0, c4
dp4 r2.z, v0, c6
mad o4.xy, r1.z, c11.zwzw, r1
mad r1, c13, r0.x, r2.xzxz
dp4 r2.y, v0, c5
add r0.xy, r2.w, r3
mov o1, c14.yzyz
mul o3, r1, c12
mov o4.zw, r0
mov o5.zw, r0
add o2.xyz, r2, -c9
mul o5.xy, r0, c14.x
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Bind "vertex" Vertex
Vector 13 [_BumpDirection]
Vector 12 [_BumpTiling]
Matrix 8 [_Object2World] 4
Vector 2 [_ProjectionParams]
Vector 3 [_ScreenParams]
Vector 0 [_Time]
Vector 1 [_WorldSpaceCameraPos]
Matrix 4 [glstate_matrix_mvp] 4
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 28.00 (21 instructions), vertex: 32, texture: 0,
//   sequencer: 14,  4 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaaccmaaaaabieaaaaaaaaaaaaaaceaaaaabkeaaaaabmmaaaaaaaa
aaaaaaaaaaaaabhmaaaaaabmaaaaabgopppoadaaaaaaaaaiaaaaaabmaaaaaaaa
aaaaabghaaaaaalmaaacaaanaaabaaaaaaaaaammaaaaaaaaaaaaaanmaaacaaam
aaabaaaaaaaaaammaaaaaaaaaaaaaaoiaaacaaaiaaaeaaaaaaaaaapiaaaaaaaa
aaaaabaiaaacaaacaaabaaaaaaaaaammaaaaaaaaaaaaabbkaaacaaadaaabaaaa
aaaaaammaaaaaaaaaaaaabciaaacaaaaaaabaaaaaaaaaammaaaaaaaaaaaaabco
aaacaaabaaabaaaaaaaaabeeaaaaaaaaaaaaabfeaaacaaaeaaaeaaaaaaaaaapi
aaaaaaaafpechfgnhaeegjhcgfgdhegjgpgoaaklaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpechfgnhafegjgmgjgoghaafpepgcgkgfgdhedcfhgphcgmgeaaklkl
aaadaaadaaaeaaaeaaabaaaaaaaaaaaafpfahcgpgkgfgdhegjgpgofagbhcgbgn
hdaafpfdgdhcgfgfgofagbhcgbgnhdaafpfegjgngfaafpfhgphcgmgefdhagbgd
gfedgbgngfhcgbfagphdaaklaaabaaadaaabaaadaaabaaaaaaaaaaaaghgmhdhe
gbhegffpgngbhehcgjhifpgnhghaaahghdfpddfpdaaadccodacodcdadddfddco
daaaklklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaabeeaaebaaadaaaaaaaaaaaaaaaa
aaaaemkfaaaaaaabaaaaaaabaaaaaaaiaaaaacjaaaaaaaaeaaaapafaaaabhbfb
aaacpcfcaaadpdfdaaagpefeaaaababaaaaababdaaaababgaaaaaabbaaaaaabh
aaaababjaaaaaabcaaaababiaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaalpiaaaaa
dpiaaaaadpaaaaaaaaaaaaaabaabbaaeaaaabcaamcaaaaaaaaaafaafaaaabcaa
meaaaaaaaaaagaakgababcaabcaaaaaaaaaaeabgaaaaccaaaaaaaaaaafpiaaaa
aaaaaanbaaaaaaaamiapaaabaamgiiaakbaaahaamiapaaabaalbnapiklaaagab
miapaaabaagmdepiklaaafabmiapaaadaablnajeklaaaeabmiapiadoaananaaa
ocadadaamiahaaabaamgleaakbaaalaamiahaaabaalbmaleklaaakabmiahaaaa
aagmleleklaaajabmiahaaaaaablmaleklaaaiaamiapaaacaagmkhooclaaanaa
miapaaabaaofmaaakbadppaacalkmaaaabaaaagmocaaaaiamiamiaadaanlnlaa
ocadadaamiamiaaeaanlnlaaocadadaamiahiaabacmamaaakaaaabaabebgaaaa
aablbglbkbabadadkibdaaabaamegnmamaadabppmiapiaacaahkaaaakbacamaa
miabiaadaamglbaaoaabaaaamiadiaaeaalamgaakbabppaamiaciaadaagmgmmg
klaaacaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Matrix 256 [glstate_matrix_mvp]
Bind "vertex" Vertex
Vector 467 [_Time]
Vector 466 [_WorldSpaceCameraPos]
Vector 465 [_ProjectionParams]
Matrix 260 [_Object2World]
Vector 464 [_BumpTiling]
Vector 463 [_BumpDirection]
"sce_vp_rsx // 24 instructions using 4 registers
[Configuration]
8
0000001800010400
[Defaults]
1
462 3
000000003f8000003f000000
[Microcode]
384
401f9c6c005ce0088186c0836041ff9c00009c6c005cf00d8186c0836041fffc
00001c6c01d0200d8106c0c360405ffc00011c6c01d0000d8106c0c360411ffc
00011c6c01d0300d8106c0c360405ffc00001c6c01d0100d8106c0c360411ffc
00019c6c01d0500d8106c0c360409ffc00019c6c01d0600d8106c0c360405ffc
00019c6c01d0400d8106c0c360411ffc00009c6c011d300d828000c441a1fffc
401f9c6c00dd208c0186c08301a1dfa000011c6c004000800086c08360409ffc
00001c6c004000000086c08360409ffc00001c6c004000550486c08360403ffc
00001c6c004000000486c08360411ffc401f9c6c009d000d8286c0c36041ffa4
401f9c6c0040000d8086c0836041ff80401f9c6c004000558086c08360407fa8
401f9c6c004000558086c08360407fac00009c6c00c000080486c09541219ffc
00001c6c009ce00e00aa80c36041dffc00001c6c009d102a808000c360409ffc
401f9c6c00c000080086c09540219fa8401f9c6c009ce00802aa80c360419fad
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304 // 208 used size, 19 vars
Vector 176 [_BumpTiling] 4
Vector 192 [_BumpDirection] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 0 [_Time] 4
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 22 instructions, 2 temp regs, 0 temp arrays:
// ALU 17 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgfnbjpjeejeaghdcadhgpaenaihapgflabaaaaaaceafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefchaadaaaaeaaaabaanmaaaaaafjaaaaae
egiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaipccabaaa
abaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaiadpdiaaaaaihcaabaaa
abaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaaa
abaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaabaaaaaa
agiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaabaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaalaaaaaa
diaaaaaibcaabaaaabaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaahicaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaadpdiaaaaak
fcaabaaaabaaaaaaagadbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
dcaaaaamdcaabaaaaaaaaaaaegaabaaaaaaaaaaaaceaaaaaaaaaiadpaaaaialp
aaaaaaaaaaaaaaaapgapbaaaaaaaaaaadiaaaaakdccabaaaafaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaadgaaaaafmccabaaa
aeaaaaaakgaobaaaaaaaaaaadgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 worldSpaceVertex_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_1 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 grabPassPos_5;
  highp vec4 o_6;
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7.x;
  tmpvar_8.y = (tmpvar_7.y * _ProjectionParams.x);
  o_6.xy = (tmpvar_8 + tmpvar_7.w);
  o_6.zw = tmpvar_4.zw;
  grabPassPos_5.xy = ((tmpvar_4.xy + tmpvar_4.w) * 0.5);
  grabPassPos_5.zw = tmpvar_4.zw;
  tmpvar_2.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex_1 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_1.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_6;
  xlv_TEXCOORD4 = grabPassPos_5;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _InvFadeParemeter;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _RefractionTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _ZBufferParams;
void main ()
{
  mediump vec4 reflectionColor_1;
  mediump vec4 baseColor_2;
  mediump float depth_3;
  mediump vec4 edgeBlendFactors_4;
  highp float nh_5;
  mediump vec3 h_6;
  mediump vec4 rtRefractions_7;
  mediump float refrFix_8;
  mediump vec4 rtRefractionsNoDistort_9;
  mediump vec4 grabWithOffset_10;
  mediump vec4 distortOffset_11;
  mediump vec3 viewVector_12;
  mediump vec3 worldNormal_13;
  mediump vec4 coords_14;
  coords_14 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_15;
  vertexNormal_15 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_16;
  bumpStrength_16 = _DistortParams.x;
  mediump vec4 bump_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = (texture2D (_BumpMap, coords_14.xy) + texture2D (_BumpMap, coords_14.zw));
  bump_17 = tmpvar_18;
  bump_17.xy = (bump_17.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize((vertexNormal_15 + ((bump_17.xxy * bumpStrength_16) * vec3(1.0, 0.0, 1.0))));
  worldNormal_13 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize(xlv_TEXCOORD1);
  viewVector_12 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.zw = vec2(0.0, 0.0);
  tmpvar_21.xy = ((tmpvar_19.xz * _DistortParams.y) * 10.0);
  distortOffset_11 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22 = (xlv_TEXCOORD4 + distortOffset_11);
  grabWithOffset_10 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractionsNoDistort_9 = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = texture2DProj (_CameraDepthTexture, grabWithOffset_10).x;
  refrFix_8 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2DProj (_RefractionTex, grabWithOffset_10);
  rtRefractions_7 = tmpvar_25;
  highp float tmpvar_26;
  highp float z_27;
  z_27 = refrFix_8;
  tmpvar_26 = (1.0/(((_ZBufferParams.z * z_27) + _ZBufferParams.w)));
  if ((tmpvar_26 < xlv_TEXCOORD3.z)) {
    rtRefractions_7 = rtRefractionsNoDistort_9;
  };
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((_WorldLightDir.xyz + viewVector_12));
  h_6 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = max (0.0, dot (tmpvar_19, -(h_6)));
  nh_5 = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth_3 = tmpvar_30;
  highp float tmpvar_31;
  highp float z_32;
  z_32 = depth_3;
  tmpvar_31 = (1.0/(((_ZBufferParams.z * z_32) + _ZBufferParams.w)));
  depth_3 = tmpvar_31;
  highp vec4 tmpvar_33;
  tmpvar_33 = clamp ((_InvFadeParemeter * (depth_3 - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors_4 = tmpvar_33;
  highp vec2 tmpvar_34;
  tmpvar_34 = (tmpvar_19.xz * _FresnelScale);
  worldNormal_13.xz = tmpvar_34;
  mediump float bias_35;
  bias_35 = _DistortParams.w;
  mediump float power_36;
  power_36 = _DistortParams.z;
  baseColor_2 = _BaseColor;
  reflectionColor_1 = _ReflectionColor;
  mediump vec4 tmpvar_37;
  tmpvar_37 = mix (mix (rtRefractions_7, baseColor_2, baseColor_2.wwww), reflectionColor_1, vec4(clamp ((bias_35 + ((1.0 - bias_35) * pow (clamp ((1.0 - max (dot (-(viewVector_12), worldNormal_13), 0.0)), 0.0, 1.0), power_36))), 0.0, 1.0)));
  highp vec4 tmpvar_38;
  tmpvar_38 = (tmpvar_37 + (max (0.0, pow (nh_5, _Shininess)) * _SpecularColor));
  baseColor_2.xyz = tmpvar_38.xyz;
  baseColor_2.w = edgeBlendFactors_4.x;
  gl_FragData[0] = baseColor_2;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 worldSpaceVertex_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_1 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 grabPassPos_5;
  highp vec4 o_6;
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7.x;
  tmpvar_8.y = (tmpvar_7.y * _ProjectionParams.x);
  o_6.xy = (tmpvar_8 + tmpvar_7.w);
  o_6.zw = tmpvar_4.zw;
  grabPassPos_5.xy = ((tmpvar_4.xy + tmpvar_4.w) * 0.5);
  grabPassPos_5.zw = tmpvar_4.zw;
  tmpvar_2.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex_1 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_1.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_6;
  xlv_TEXCOORD4 = grabPassPos_5;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _InvFadeParemeter;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _RefractionTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _ZBufferParams;
void main ()
{
  mediump vec4 reflectionColor_1;
  mediump vec4 baseColor_2;
  mediump float depth_3;
  mediump vec4 edgeBlendFactors_4;
  highp float nh_5;
  mediump vec3 h_6;
  mediump vec4 rtRefractions_7;
  mediump float refrFix_8;
  mediump vec4 rtRefractionsNoDistort_9;
  mediump vec4 grabWithOffset_10;
  mediump vec4 distortOffset_11;
  mediump vec3 viewVector_12;
  mediump vec3 worldNormal_13;
  mediump vec4 coords_14;
  coords_14 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_15;
  vertexNormal_15 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_16;
  bumpStrength_16 = _DistortParams.x;
  mediump vec4 bump_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = (texture2D (_BumpMap, coords_14.xy) + texture2D (_BumpMap, coords_14.zw));
  bump_17 = tmpvar_18;
  bump_17.xy = (bump_17.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize((vertexNormal_15 + ((bump_17.xxy * bumpStrength_16) * vec3(1.0, 0.0, 1.0))));
  worldNormal_13 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize(xlv_TEXCOORD1);
  viewVector_12 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.zw = vec2(0.0, 0.0);
  tmpvar_21.xy = ((tmpvar_19.xz * _DistortParams.y) * 10.0);
  distortOffset_11 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22 = (xlv_TEXCOORD4 + distortOffset_11);
  grabWithOffset_10 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractionsNoDistort_9 = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = texture2DProj (_CameraDepthTexture, grabWithOffset_10).x;
  refrFix_8 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2DProj (_RefractionTex, grabWithOffset_10);
  rtRefractions_7 = tmpvar_25;
  highp float tmpvar_26;
  highp float z_27;
  z_27 = refrFix_8;
  tmpvar_26 = (1.0/(((_ZBufferParams.z * z_27) + _ZBufferParams.w)));
  if ((tmpvar_26 < xlv_TEXCOORD3.z)) {
    rtRefractions_7 = rtRefractionsNoDistort_9;
  };
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((_WorldLightDir.xyz + viewVector_12));
  h_6 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = max (0.0, dot (tmpvar_19, -(h_6)));
  nh_5 = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth_3 = tmpvar_30;
  highp float tmpvar_31;
  highp float z_32;
  z_32 = depth_3;
  tmpvar_31 = (1.0/(((_ZBufferParams.z * z_32) + _ZBufferParams.w)));
  depth_3 = tmpvar_31;
  highp vec4 tmpvar_33;
  tmpvar_33 = clamp ((_InvFadeParemeter * (depth_3 - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors_4 = tmpvar_33;
  highp vec2 tmpvar_34;
  tmpvar_34 = (tmpvar_19.xz * _FresnelScale);
  worldNormal_13.xz = tmpvar_34;
  mediump float bias_35;
  bias_35 = _DistortParams.w;
  mediump float power_36;
  power_36 = _DistortParams.z;
  baseColor_2 = _BaseColor;
  reflectionColor_1 = _ReflectionColor;
  mediump vec4 tmpvar_37;
  tmpvar_37 = mix (mix (rtRefractions_7, baseColor_2, baseColor_2.wwww), reflectionColor_1, vec4(clamp ((bias_35 + ((1.0 - bias_35) * pow (clamp ((1.0 - max (dot (-(viewVector_12), worldNormal_13), 0.0)), 0.0, 1.0), power_36))), 0.0, 1.0)));
  highp vec4 tmpvar_38;
  tmpvar_38 = (tmpvar_37 + (max (0.0, pow (nh_5, _Shininess)) * _SpecularColor));
  baseColor_2.xyz = tmpvar_38.xyz;
  baseColor_2.w = edgeBlendFactors_4.x;
  gl_FragData[0] = baseColor_2;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 480
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 490
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 499
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 351
#line 374
#line 391
#line 403
#line 448
#line 469
#line 506
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 510
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 514
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 518
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 522
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 526
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 546
#line 574
#line 614
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 351
void ComputeScreenAndGrabPassPos( in highp vec4 pos, out highp vec4 screenPos, out highp vec4 grabPassPos ) {
    highp float scale = 1.0;
    screenPos = ComputeScreenPos( pos);
    #line 355
    grabPassPos.xy = ((vec2( pos.x, (pos.y * scale)) + pos.w) * 0.5);
    grabPassPos.zw = pos.zw;
}
#line 469
void Gerstner( out mediump vec3 offs, out mediump vec3 nrml, in mediump vec3 vtx, in mediump vec3 tileableVtx, in mediump vec4 amplitude, in mediump vec4 frequency, in mediump vec4 steepness, in mediump vec4 speed, in mediump vec4 directionAB, in mediump vec4 directionCD ) {
    offs = vec3( 0.0, 0.0, 0.0);
    nrml = vec3( 0.0, 1.0, 0.0);
}
#line 528
v2f vert( in appdata_full v ) {
    #line 530
    v2f o;
    mediump vec3 worldSpaceVertex = (_Object2World * v.vertex).xyz;
    mediump vec3 vtxForAni = (worldSpaceVertex.xzz * unity_Scale.w);
    mediump vec3 nrml;
    #line 534
    mediump vec3 offsets;
    Gerstner( offsets, nrml, v.vertex.xyz, vtxForAni, _GAmplitude, _GFrequency, _GSteepness, _GSpeed, _GDirectionAB, _GDirectionCD);
    v.vertex.xyz += offsets;
    mediump vec2 tileableUv = worldSpaceVertex.xz;
    #line 538
    o.bumpCoords.xyzw = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection.xyzw)) * _BumpTiling.xyzw);
    o.viewInterpolator.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
    o.pos = (glstate_matrix_mvp * v.vertex);
    ComputeScreenAndGrabPassPos( o.pos, o.screenPos, o.grabPassPos);
    #line 542
    o.normalInterpolator.xyz = nrml;
    o.normalInterpolator.w = 1.0;
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.normalInterpolator);
    xlv_TEXCOORD1 = vec3(xl_retval.viewInterpolator);
    xlv_TEXCOORD2 = vec4(xl_retval.bumpCoords);
    xlv_TEXCOORD3 = vec4(xl_retval.screenPos);
    xlv_TEXCOORD4 = vec4(xl_retval.grabPassPos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 480
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 490
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 499
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 351
#line 374
#line 391
#line 403
#line 448
#line 469
#line 506
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 510
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 514
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 518
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 522
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 526
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 546
#line 574
#line 614
#line 385
mediump float Fresnel( in mediump vec3 viewVector, in mediump vec3 worldNormal, in mediump float bias, in mediump float power ) {
    #line 387
    mediump float facing = clamp( (1.0 - max( dot( (-viewVector), worldNormal), 0.0)), 0.0, 1.0);
    mediump float refl2Refr = xll_saturate_f((bias + ((1.0 - bias) * pow( facing, power))));
    return refl2Refr;
}
#line 280
highp float LinearEyeDepth( in highp float z ) {
    #line 282
    return (1.0 / ((_ZBufferParams.z * z) + _ZBufferParams.w));
}
#line 316
mediump vec3 PerPixelNormal( in sampler2D bumpMap, in mediump vec4 coords, in mediump vec3 vertexNormal, in mediump float bumpStrength ) {
    mediump vec4 bump = (texture( bumpMap, coords.xy) + texture( bumpMap, coords.zw));
    #line 319
    bump.xy = (bump.wy - vec2( 1.0, 1.0));
    mediump vec3 worldNormal = (vertexNormal + ((bump.xxy * bumpStrength) * vec3( 1.0, 0.0, 1.0)));
    return normalize(worldNormal);
}
#line 546
mediump vec4 frag( in v2f i ) {
    mediump vec3 worldNormal = PerPixelNormal( _BumpMap, i.bumpCoords, i.normalInterpolator.xyz, _DistortParams.x);
    mediump vec3 viewVector = normalize(i.viewInterpolator.xyz);
    #line 550
    mediump vec4 distortOffset = vec4( ((worldNormal.xz * _DistortParams.y) * 10.0), 0.0, 0.0);
    mediump vec4 screenWithOffset = (i.screenPos + distortOffset);
    mediump vec4 grabWithOffset = (i.grabPassPos + distortOffset);
    mediump vec4 rtRefractionsNoDistort = textureProj( _RefractionTex, i.grabPassPos);
    #line 554
    mediump float refrFix = textureProj( _CameraDepthTexture, grabWithOffset).x;
    mediump vec4 rtRefractions = textureProj( _RefractionTex, grabWithOffset);
    if ((LinearEyeDepth( refrFix) < i.screenPos.z)){
        rtRefractions = rtRefractionsNoDistort;
    }
    mediump vec3 reflectVector = normalize(reflect( viewVector, worldNormal));
    #line 558
    mediump vec3 h = normalize((_WorldLightDir.xyz + viewVector.xyz));
    highp float nh = max( 0.0, dot( worldNormal, (-h)));
    highp float spec = max( 0.0, pow( nh, _Shininess));
    mediump vec4 edgeBlendFactors = vec4( 1.0, 0.0, 0.0, 0.0);
    #line 562
    mediump float depth = textureProj( _CameraDepthTexture, i.screenPos).x;
    depth = LinearEyeDepth( depth);
    edgeBlendFactors = xll_saturate_vf4((_InvFadeParemeter * (depth - i.screenPos.w)));
    worldNormal.xz *= _FresnelScale;
    #line 566
    mediump float refl2Refr = Fresnel( viewVector, worldNormal, _DistortParams.w, _DistortParams.z);
    mediump vec4 baseColor = _BaseColor;
    mediump vec4 reflectionColor = _ReflectionColor;
    baseColor = mix( mix( rtRefractions, baseColor, vec4( baseColor.w)), reflectionColor, vec4( refl2Refr));
    #line 570
    baseColor = (baseColor + (spec * _SpecularColor));
    baseColor.w = edgeBlendFactors.x;
    return baseColor;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    mediump vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.normalInterpolator = vec4(xlv_TEXCOORD0);
    xlt_i.viewInterpolator = vec3(xlv_TEXCOORD1);
    xlt_i.bumpCoords = vec4(xlv_TEXCOORD2);
    xlt_i.screenPos = vec4(xlv_TEXCOORD3);
    xlt_i.grabPassPos = vec4(xlv_TEXCOORD4);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 grabPassPos_4;
  vec4 o_5;
  vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  grabPassPos_4.xy = ((tmpvar_3.xy + tmpvar_3.w) * 0.5);
  grabPassPos_4.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (tmpvar_2 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_2.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_5;
  xlv_TEXCOORD4 = grabPassPos_4;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.0, 0.0);
  tmpvar_7.xy = ((tmpvar_5.xz * _DistortParams.y) * 10.0);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  baseColor_1.xyz = (mix (mix (texture2DProj (_RefractionTex, (xlv_TEXCOORD4 + tmpvar_7)), _BaseColor, _BaseColor.wwww), mix (texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_7)), _ReflectionColor, _ReflectionColor.wwww), vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = 1.0;
  gl_FragData[0] = baseColor_1;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 24 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r2.y, v0, c1
dp4 r2.w, v0, c3
dp4 r3.x, v0, c0
mov r0.w, r2
dp4 r0.z, v0, c2
mov r0.y, r2
mov r0.x, r3
mul r1.xyz, r0.xyww, c14.x
mul r1.y, r1, c10.x
mov o0, r0
mov r3.y, -r2
mov r0.x, c8
dp4 r2.x, v0, c4
dp4 r2.z, v0, c6
mad o4.xy, r1.z, c11.zwzw, r1
mad r1, c13, r0.x, r2.xzxz
dp4 r2.y, v0, c5
add r0.xy, r2.w, r3
mov o1, c14.yzyz
mul o3, r1, c12
mov o4.zw, r0
mov o5.zw, r0
add o2.xyz, r2, -c9
mul o5.xy, r0, c14.x
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Vector 13 [_BumpDirection]
Vector 12 [_BumpTiling]
Matrix 8 [_Object2World] 4
Vector 2 [_ProjectionParams]
Vector 3 [_ScreenParams]
Vector 0 [_Time]
Vector 1 [_WorldSpaceCameraPos]
Matrix 4 [glstate_matrix_mvp] 4
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 28.00 (21 instructions), vertex: 32, texture: 0,
//   sequencer: 14,  4 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaaccmaaaaabieaaaaaaaaaaaaaaceaaaaabkeaaaaabmmaaaaaaaa
aaaaaaaaaaaaabhmaaaaaabmaaaaabgopppoadaaaaaaaaaiaaaaaabmaaaaaaaa
aaaaabghaaaaaalmaaacaaanaaabaaaaaaaaaammaaaaaaaaaaaaaanmaaacaaam
aaabaaaaaaaaaammaaaaaaaaaaaaaaoiaaacaaaiaaaeaaaaaaaaaapiaaaaaaaa
aaaaabaiaaacaaacaaabaaaaaaaaaammaaaaaaaaaaaaabbkaaacaaadaaabaaaa
aaaaaammaaaaaaaaaaaaabciaaacaaaaaaabaaaaaaaaaammaaaaaaaaaaaaabco
aaacaaabaaabaaaaaaaaabeeaaaaaaaaaaaaabfeaaacaaaeaaaeaaaaaaaaaapi
aaaaaaaafpechfgnhaeegjhcgfgdhegjgpgoaaklaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpechfgnhafegjgmgjgoghaafpepgcgkgfgdhedcfhgphcgmgeaaklkl
aaadaaadaaaeaaaeaaabaaaaaaaaaaaafpfahcgpgkgfgdhegjgpgofagbhcgbgn
hdaafpfdgdhcgfgfgofagbhcgbgnhdaafpfegjgngfaafpfhgphcgmgefdhagbgd
gfedgbgngfhcgbfagphdaaklaaabaaadaaabaaadaaabaaaaaaaaaaaaghgmhdhe
gbhegffpgngbhehcgjhifpgnhghaaahghdfpddfpdaaadccodacodcdadddfddco
daaaklklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaabeeaaebaaadaaaaaaaaaaaaaaaa
aaaaemkfaaaaaaabaaaaaaabaaaaaaaiaaaaacjaaaaaaaaeaaaapafaaaabhbfb
aaacpcfcaaadpdfdaaagpefeaaaababaaaaababdaaaababgaaaaaabbaaaaaabh
aaaababjaaaaaabcaaaababiaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaalpiaaaaa
dpiaaaaadpaaaaaaaaaaaaaabaabbaaeaaaabcaamcaaaaaaaaaafaafaaaabcaa
meaaaaaaaaaagaakgababcaabcaaaaaaaaaaeabgaaaaccaaaaaaaaaaafpiaaaa
aaaaaanbaaaaaaaamiapaaabaamgiiaakbaaahaamiapaaabaalbnapiklaaagab
miapaaabaagmdepiklaaafabmiapaaadaablnajeklaaaeabmiapiadoaananaaa
ocadadaamiahaaabaamgleaakbaaalaamiahaaabaalbmaleklaaakabmiahaaaa
aagmleleklaaajabmiahaaaaaablmaleklaaaiaamiapaaacaagmkhooclaaanaa
miapaaabaaofmaaakbadppaacalkmaaaabaaaagmocaaaaiamiamiaadaanlnlaa
ocadadaamiamiaaeaanlnlaaocadadaamiahiaabacmamaaakaaaabaabebgaaaa
aablbglbkbabadadkibdaaabaamegnmamaadabppmiapiaacaahkaaaakbacamaa
miabiaadaamglbaaoaabaaaamiadiaaeaalamgaakbabppaamiaciaadaagmgmmg
klaaacaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Matrix 256 [glstate_matrix_mvp]
Bind "vertex" Vertex
Vector 467 [_Time]
Vector 466 [_WorldSpaceCameraPos]
Vector 465 [_ProjectionParams]
Matrix 260 [_Object2World]
Vector 464 [_BumpTiling]
Vector 463 [_BumpDirection]
"sce_vp_rsx // 24 instructions using 4 registers
[Configuration]
8
0000001800010400
[Defaults]
1
462 3
000000003f8000003f000000
[Microcode]
384
401f9c6c005ce0088186c0836041ff9c00009c6c005cf00d8186c0836041fffc
00001c6c01d0200d8106c0c360405ffc00011c6c01d0000d8106c0c360411ffc
00011c6c01d0300d8106c0c360405ffc00001c6c01d0100d8106c0c360411ffc
00019c6c01d0500d8106c0c360409ffc00019c6c01d0600d8106c0c360405ffc
00019c6c01d0400d8106c0c360411ffc00009c6c011d300d828000c441a1fffc
401f9c6c00dd208c0186c08301a1dfa000011c6c004000800086c08360409ffc
00001c6c004000000086c08360409ffc00001c6c004000550486c08360403ffc
00001c6c004000000486c08360411ffc401f9c6c009d000d8286c0c36041ffa4
401f9c6c0040000d8086c0836041ff80401f9c6c004000558086c08360407fa8
401f9c6c004000558086c08360407fac00009c6c00c000080486c09541219ffc
00001c6c009ce00e00aa80c36041dffc00001c6c009d102a808000c360409ffc
401f9c6c00c000080086c09540219fa8401f9c6c009ce00802aa80c360419fad
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304 // 208 used size, 19 vars
Vector 176 [_BumpTiling] 4
Vector 192 [_BumpDirection] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 0 [_Time] 4
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 22 instructions, 2 temp regs, 0 temp arrays:
// ALU 17 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgfnbjpjeejeaghdcadhgpaenaihapgflabaaaaaaceafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefchaadaaaaeaaaabaanmaaaaaafjaaaaae
egiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaipccabaaa
abaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaiadpdiaaaaaihcaabaaa
abaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaaa
abaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaabaaaaaa
agiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaabaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaalaaaaaa
diaaaaaibcaabaaaabaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaahicaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaadpdiaaaaak
fcaabaaaabaaaaaaagadbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
dcaaaaamdcaabaaaaaaaaaaaegaabaaaaaaaaaaaaceaaaaaaaaaiadpaaaaialp
aaaaaaaaaaaaaaaapgapbaaaaaaaaaaadiaaaaakdccabaaaafaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaadgaaaaafmccabaaa
aeaaaaaakgaobaaaaaaaaaaadgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 worldSpaceVertex_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_1 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 grabPassPos_5;
  highp vec4 o_6;
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7.x;
  tmpvar_8.y = (tmpvar_7.y * _ProjectionParams.x);
  o_6.xy = (tmpvar_8 + tmpvar_7.w);
  o_6.zw = tmpvar_4.zw;
  grabPassPos_5.xy = ((tmpvar_4.xy + tmpvar_4.w) * 0.5);
  grabPassPos_5.zw = tmpvar_4.zw;
  tmpvar_2.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex_1 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_1.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_6;
  xlv_TEXCOORD4 = grabPassPos_5;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
void main ()
{
  mediump vec4 reflectionColor_1;
  mediump vec4 baseColor_2;
  highp float nh_3;
  mediump vec3 h_4;
  mediump vec4 rtReflections_5;
  mediump vec4 rtRefractions_6;
  mediump vec4 grabWithOffset_7;
  mediump vec4 screenWithOffset_8;
  mediump vec4 distortOffset_9;
  mediump vec3 viewVector_10;
  mediump vec3 worldNormal_11;
  mediump vec4 coords_12;
  coords_12 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_13;
  vertexNormal_13 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_14;
  bumpStrength_14 = _DistortParams.x;
  mediump vec4 bump_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = (texture2D (_BumpMap, coords_12.xy) + texture2D (_BumpMap, coords_12.zw));
  bump_15 = tmpvar_16;
  bump_15.xy = (bump_15.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize((vertexNormal_13 + ((bump_15.xxy * bumpStrength_14) * vec3(1.0, 0.0, 1.0))));
  worldNormal_11.y = tmpvar_17.y;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize(xlv_TEXCOORD1);
  viewVector_10 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.zw = vec2(0.0, 0.0);
  tmpvar_19.xy = ((tmpvar_17.xz * _DistortParams.y) * 10.0);
  distortOffset_9 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20 = (xlv_TEXCOORD3 + distortOffset_9);
  screenWithOffset_8 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21 = (xlv_TEXCOORD4 + distortOffset_9);
  grabWithOffset_7 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2DProj (_RefractionTex, grabWithOffset_7);
  rtRefractions_6 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2DProj (_ReflectionTex, screenWithOffset_8);
  rtReflections_5 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((_WorldLightDir.xyz + viewVector_10));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = max (0.0, dot (tmpvar_17, -(h_4)));
  nh_3 = tmpvar_25;
  highp vec2 tmpvar_26;
  tmpvar_26 = (tmpvar_17.xz * _FresnelScale);
  worldNormal_11.xz = tmpvar_26;
  mediump float bias_27;
  bias_27 = _DistortParams.w;
  mediump float power_28;
  power_28 = _DistortParams.z;
  baseColor_2 = _BaseColor;
  highp vec4 tmpvar_29;
  tmpvar_29 = mix (rtReflections_5, _ReflectionColor, _ReflectionColor.wwww);
  reflectionColor_1 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = mix (mix (rtRefractions_6, baseColor_2, baseColor_2.wwww), reflectionColor_1, vec4(clamp ((bias_27 + ((1.0 - bias_27) * pow (clamp ((1.0 - max (dot (-(viewVector_10), worldNormal_11), 0.0)), 0.0, 1.0), power_28))), 0.0, 1.0)));
  highp vec4 tmpvar_31;
  tmpvar_31 = (tmpvar_30 + (max (0.0, pow (nh_3, _Shininess)) * _SpecularColor));
  baseColor_2.xyz = tmpvar_31.xyz;
  baseColor_2.w = 1.0;
  gl_FragData[0] = baseColor_2;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 worldSpaceVertex_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_1 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 grabPassPos_5;
  highp vec4 o_6;
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7.x;
  tmpvar_8.y = (tmpvar_7.y * _ProjectionParams.x);
  o_6.xy = (tmpvar_8 + tmpvar_7.w);
  o_6.zw = tmpvar_4.zw;
  grabPassPos_5.xy = ((tmpvar_4.xy + tmpvar_4.w) * 0.5);
  grabPassPos_5.zw = tmpvar_4.zw;
  tmpvar_2.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex_1 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_1.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_6;
  xlv_TEXCOORD4 = grabPassPos_5;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
void main ()
{
  mediump vec4 reflectionColor_1;
  mediump vec4 baseColor_2;
  highp float nh_3;
  mediump vec3 h_4;
  mediump vec4 rtReflections_5;
  mediump vec4 rtRefractions_6;
  mediump vec4 grabWithOffset_7;
  mediump vec4 screenWithOffset_8;
  mediump vec4 distortOffset_9;
  mediump vec3 viewVector_10;
  mediump vec3 worldNormal_11;
  mediump vec4 coords_12;
  coords_12 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_13;
  vertexNormal_13 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_14;
  bumpStrength_14 = _DistortParams.x;
  mediump vec4 bump_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = (texture2D (_BumpMap, coords_12.xy) + texture2D (_BumpMap, coords_12.zw));
  bump_15 = tmpvar_16;
  bump_15.xy = (bump_15.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize((vertexNormal_13 + ((bump_15.xxy * bumpStrength_14) * vec3(1.0, 0.0, 1.0))));
  worldNormal_11.y = tmpvar_17.y;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize(xlv_TEXCOORD1);
  viewVector_10 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.zw = vec2(0.0, 0.0);
  tmpvar_19.xy = ((tmpvar_17.xz * _DistortParams.y) * 10.0);
  distortOffset_9 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20 = (xlv_TEXCOORD3 + distortOffset_9);
  screenWithOffset_8 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21 = (xlv_TEXCOORD4 + distortOffset_9);
  grabWithOffset_7 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2DProj (_RefractionTex, grabWithOffset_7);
  rtRefractions_6 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2DProj (_ReflectionTex, screenWithOffset_8);
  rtReflections_5 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((_WorldLightDir.xyz + viewVector_10));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = max (0.0, dot (tmpvar_17, -(h_4)));
  nh_3 = tmpvar_25;
  highp vec2 tmpvar_26;
  tmpvar_26 = (tmpvar_17.xz * _FresnelScale);
  worldNormal_11.xz = tmpvar_26;
  mediump float bias_27;
  bias_27 = _DistortParams.w;
  mediump float power_28;
  power_28 = _DistortParams.z;
  baseColor_2 = _BaseColor;
  highp vec4 tmpvar_29;
  tmpvar_29 = mix (rtReflections_5, _ReflectionColor, _ReflectionColor.wwww);
  reflectionColor_1 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = mix (mix (rtRefractions_6, baseColor_2, baseColor_2.wwww), reflectionColor_1, vec4(clamp ((bias_27 + ((1.0 - bias_27) * pow (clamp ((1.0 - max (dot (-(viewVector_10), worldNormal_11), 0.0)), 0.0, 1.0), power_28))), 0.0, 1.0)));
  highp vec4 tmpvar_31;
  tmpvar_31 = (tmpvar_30 + (max (0.0, pow (nh_3, _Shininess)) * _SpecularColor));
  baseColor_2.xyz = tmpvar_31.xyz;
  baseColor_2.w = 1.0;
  gl_FragData[0] = baseColor_2;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 480
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 490
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 499
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 351
#line 374
#line 391
#line 403
#line 448
#line 469
#line 506
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 510
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 514
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 518
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 522
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 526
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 546
#line 571
#line 619
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 351
void ComputeScreenAndGrabPassPos( in highp vec4 pos, out highp vec4 screenPos, out highp vec4 grabPassPos ) {
    highp float scale = 1.0;
    screenPos = ComputeScreenPos( pos);
    #line 355
    grabPassPos.xy = ((vec2( pos.x, (pos.y * scale)) + pos.w) * 0.5);
    grabPassPos.zw = pos.zw;
}
#line 469
void Gerstner( out mediump vec3 offs, out mediump vec3 nrml, in mediump vec3 vtx, in mediump vec3 tileableVtx, in mediump vec4 amplitude, in mediump vec4 frequency, in mediump vec4 steepness, in mediump vec4 speed, in mediump vec4 directionAB, in mediump vec4 directionCD ) {
    offs = vec3( 0.0, 0.0, 0.0);
    nrml = vec3( 0.0, 1.0, 0.0);
}
#line 528
v2f vert( in appdata_full v ) {
    #line 530
    v2f o;
    mediump vec3 worldSpaceVertex = (_Object2World * v.vertex).xyz;
    mediump vec3 vtxForAni = (worldSpaceVertex.xzz * unity_Scale.w);
    mediump vec3 nrml;
    #line 534
    mediump vec3 offsets;
    Gerstner( offsets, nrml, v.vertex.xyz, vtxForAni, _GAmplitude, _GFrequency, _GSteepness, _GSpeed, _GDirectionAB, _GDirectionCD);
    v.vertex.xyz += offsets;
    mediump vec2 tileableUv = worldSpaceVertex.xz;
    #line 538
    o.bumpCoords.xyzw = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection.xyzw)) * _BumpTiling.xyzw);
    o.viewInterpolator.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
    o.pos = (glstate_matrix_mvp * v.vertex);
    ComputeScreenAndGrabPassPos( o.pos, o.screenPos, o.grabPassPos);
    #line 542
    o.normalInterpolator.xyz = nrml;
    o.normalInterpolator.w = 1.0;
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.normalInterpolator);
    xlv_TEXCOORD1 = vec3(xl_retval.viewInterpolator);
    xlv_TEXCOORD2 = vec4(xl_retval.bumpCoords);
    xlv_TEXCOORD3 = vec4(xl_retval.screenPos);
    xlv_TEXCOORD4 = vec4(xl_retval.grabPassPos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 480
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 490
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 499
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 351
#line 374
#line 391
#line 403
#line 448
#line 469
#line 506
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 510
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 514
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 518
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 522
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 526
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 546
#line 571
#line 619
#line 385
mediump float Fresnel( in mediump vec3 viewVector, in mediump vec3 worldNormal, in mediump float bias, in mediump float power ) {
    #line 387
    mediump float facing = clamp( (1.0 - max( dot( (-viewVector), worldNormal), 0.0)), 0.0, 1.0);
    mediump float refl2Refr = xll_saturate_f((bias + ((1.0 - bias) * pow( facing, power))));
    return refl2Refr;
}
#line 316
mediump vec3 PerPixelNormal( in sampler2D bumpMap, in mediump vec4 coords, in mediump vec3 vertexNormal, in mediump float bumpStrength ) {
    mediump vec4 bump = (texture( bumpMap, coords.xy) + texture( bumpMap, coords.zw));
    #line 319
    bump.xy = (bump.wy - vec2( 1.0, 1.0));
    mediump vec3 worldNormal = (vertexNormal + ((bump.xxy * bumpStrength) * vec3( 1.0, 0.0, 1.0)));
    return normalize(worldNormal);
}
#line 546
mediump vec4 frag( in v2f i ) {
    mediump vec3 worldNormal = PerPixelNormal( _BumpMap, i.bumpCoords, i.normalInterpolator.xyz, _DistortParams.x);
    mediump vec3 viewVector = normalize(i.viewInterpolator.xyz);
    #line 550
    mediump vec4 distortOffset = vec4( ((worldNormal.xz * _DistortParams.y) * 10.0), 0.0, 0.0);
    mediump vec4 screenWithOffset = (i.screenPos + distortOffset);
    mediump vec4 grabWithOffset = (i.grabPassPos + distortOffset);
    mediump vec4 rtRefractionsNoDistort = textureProj( _RefractionTex, i.grabPassPos);
    #line 554
    mediump float refrFix = textureProj( _CameraDepthTexture, grabWithOffset).x;
    mediump vec4 rtRefractions = textureProj( _RefractionTex, grabWithOffset);
    mediump vec4 rtReflections = textureProj( _ReflectionTex, screenWithOffset);
    mediump vec3 reflectVector = normalize(reflect( viewVector, worldNormal));
    #line 558
    mediump vec3 h = normalize((_WorldLightDir.xyz + viewVector.xyz));
    highp float nh = max( 0.0, dot( worldNormal, (-h)));
    highp float spec = max( 0.0, pow( nh, _Shininess));
    mediump vec4 edgeBlendFactors = vec4( 1.0, 0.0, 0.0, 0.0);
    #line 562
    worldNormal.xz *= _FresnelScale;
    mediump float refl2Refr = Fresnel( viewVector, worldNormal, _DistortParams.w, _DistortParams.z);
    mediump vec4 baseColor = _BaseColor;
    mediump vec4 reflectionColor = mix( rtReflections, _ReflectionColor, vec4( _ReflectionColor.w));
    #line 566
    baseColor = mix( mix( rtRefractions, baseColor, vec4( baseColor.w)), reflectionColor, vec4( refl2Refr));
    baseColor = (baseColor + (spec * _SpecularColor));
    baseColor.w = edgeBlendFactors.x;
    return baseColor;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    mediump vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.normalInterpolator = vec4(xlv_TEXCOORD0);
    xlt_i.viewInterpolator = vec3(xlv_TEXCOORD1);
    xlt_i.bumpCoords = vec4(xlv_TEXCOORD2);
    xlt_i.screenPos = vec4(xlv_TEXCOORD3);
    xlt_i.grabPassPos = vec4(xlv_TEXCOORD4);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 grabPassPos_4;
  vec4 o_5;
  vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  grabPassPos_4.xy = ((tmpvar_3.xy + tmpvar_3.w) * 0.5);
  grabPassPos_4.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (tmpvar_2 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_2.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_5;
  xlv_TEXCOORD4 = grabPassPos_4;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _RefractionTex;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.0, 0.0);
  tmpvar_7.xy = ((tmpvar_5.xz * _DistortParams.y) * 10.0);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  baseColor_1.xyz = (mix (mix (texture2DProj (_RefractionTex, (xlv_TEXCOORD4 + tmpvar_7)), _BaseColor, _BaseColor.wwww), _ReflectionColor, vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = 1.0;
  gl_FragData[0] = baseColor_1;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 24 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r2.y, v0, c1
dp4 r2.w, v0, c3
dp4 r3.x, v0, c0
mov r0.w, r2
dp4 r0.z, v0, c2
mov r0.y, r2
mov r0.x, r3
mul r1.xyz, r0.xyww, c14.x
mul r1.y, r1, c10.x
mov o0, r0
mov r3.y, -r2
mov r0.x, c8
dp4 r2.x, v0, c4
dp4 r2.z, v0, c6
mad o4.xy, r1.z, c11.zwzw, r1
mad r1, c13, r0.x, r2.xzxz
dp4 r2.y, v0, c5
add r0.xy, r2.w, r3
mov o1, c14.yzyz
mul o3, r1, c12
mov o4.zw, r0
mov o5.zw, r0
add o2.xyz, r2, -c9
mul o5.xy, r0, c14.x
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Bind "vertex" Vertex
Vector 13 [_BumpDirection]
Vector 12 [_BumpTiling]
Matrix 8 [_Object2World] 4
Vector 2 [_ProjectionParams]
Vector 3 [_ScreenParams]
Vector 0 [_Time]
Vector 1 [_WorldSpaceCameraPos]
Matrix 4 [glstate_matrix_mvp] 4
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 28.00 (21 instructions), vertex: 32, texture: 0,
//   sequencer: 14,  4 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaaccmaaaaabieaaaaaaaaaaaaaaceaaaaabkeaaaaabmmaaaaaaaa
aaaaaaaaaaaaabhmaaaaaabmaaaaabgopppoadaaaaaaaaaiaaaaaabmaaaaaaaa
aaaaabghaaaaaalmaaacaaanaaabaaaaaaaaaammaaaaaaaaaaaaaanmaaacaaam
aaabaaaaaaaaaammaaaaaaaaaaaaaaoiaaacaaaiaaaeaaaaaaaaaapiaaaaaaaa
aaaaabaiaaacaaacaaabaaaaaaaaaammaaaaaaaaaaaaabbkaaacaaadaaabaaaa
aaaaaammaaaaaaaaaaaaabciaaacaaaaaaabaaaaaaaaaammaaaaaaaaaaaaabco
aaacaaabaaabaaaaaaaaabeeaaaaaaaaaaaaabfeaaacaaaeaaaeaaaaaaaaaapi
aaaaaaaafpechfgnhaeegjhcgfgdhegjgpgoaaklaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpechfgnhafegjgmgjgoghaafpepgcgkgfgdhedcfhgphcgmgeaaklkl
aaadaaadaaaeaaaeaaabaaaaaaaaaaaafpfahcgpgkgfgdhegjgpgofagbhcgbgn
hdaafpfdgdhcgfgfgofagbhcgbgnhdaafpfegjgngfaafpfhgphcgmgefdhagbgd
gfedgbgngfhcgbfagphdaaklaaabaaadaaabaaadaaabaaaaaaaaaaaaghgmhdhe
gbhegffpgngbhehcgjhifpgnhghaaahghdfpddfpdaaadccodacodcdadddfddco
daaaklklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaabeeaaebaaadaaaaaaaaaaaaaaaa
aaaaemkfaaaaaaabaaaaaaabaaaaaaaiaaaaacjaaaaaaaaeaaaapafaaaabhbfb
aaacpcfcaaadpdfdaaagpefeaaaababaaaaababdaaaababgaaaaaabbaaaaaabh
aaaababjaaaaaabcaaaababiaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaalpiaaaaa
dpiaaaaadpaaaaaaaaaaaaaabaabbaaeaaaabcaamcaaaaaaaaaafaafaaaabcaa
meaaaaaaaaaagaakgababcaabcaaaaaaaaaaeabgaaaaccaaaaaaaaaaafpiaaaa
aaaaaanbaaaaaaaamiapaaabaamgiiaakbaaahaamiapaaabaalbnapiklaaagab
miapaaabaagmdepiklaaafabmiapaaadaablnajeklaaaeabmiapiadoaananaaa
ocadadaamiahaaabaamgleaakbaaalaamiahaaabaalbmaleklaaakabmiahaaaa
aagmleleklaaajabmiahaaaaaablmaleklaaaiaamiapaaacaagmkhooclaaanaa
miapaaabaaofmaaakbadppaacalkmaaaabaaaagmocaaaaiamiamiaadaanlnlaa
ocadadaamiamiaaeaanlnlaaocadadaamiahiaabacmamaaakaaaabaabebgaaaa
aablbglbkbabadadkibdaaabaamegnmamaadabppmiapiaacaahkaaaakbacamaa
miabiaadaamglbaaoaabaaaamiadiaaeaalamgaakbabppaamiaciaadaagmgmmg
klaaacaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Matrix 256 [glstate_matrix_mvp]
Bind "vertex" Vertex
Vector 467 [_Time]
Vector 466 [_WorldSpaceCameraPos]
Vector 465 [_ProjectionParams]
Matrix 260 [_Object2World]
Vector 464 [_BumpTiling]
Vector 463 [_BumpDirection]
"sce_vp_rsx // 24 instructions using 4 registers
[Configuration]
8
0000001800010400
[Defaults]
1
462 3
000000003f8000003f000000
[Microcode]
384
401f9c6c005ce0088186c0836041ff9c00009c6c005cf00d8186c0836041fffc
00001c6c01d0200d8106c0c360405ffc00011c6c01d0000d8106c0c360411ffc
00011c6c01d0300d8106c0c360405ffc00001c6c01d0100d8106c0c360411ffc
00019c6c01d0500d8106c0c360409ffc00019c6c01d0600d8106c0c360405ffc
00019c6c01d0400d8106c0c360411ffc00009c6c011d300d828000c441a1fffc
401f9c6c00dd208c0186c08301a1dfa000011c6c004000800086c08360409ffc
00001c6c004000000086c08360409ffc00001c6c004000550486c08360403ffc
00001c6c004000000486c08360411ffc401f9c6c009d000d8286c0c36041ffa4
401f9c6c0040000d8086c0836041ff80401f9c6c004000558086c08360407fa8
401f9c6c004000558086c08360407fac00009c6c00c000080486c09541219ffc
00001c6c009ce00e00aa80c36041dffc00001c6c009d102a808000c360409ffc
401f9c6c00c000080086c09540219fa8401f9c6c009ce00802aa80c360419fad
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304 // 208 used size, 19 vars
Vector 176 [_BumpTiling] 4
Vector 192 [_BumpDirection] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 0 [_Time] 4
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 22 instructions, 2 temp regs, 0 temp arrays:
// ALU 17 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgfnbjpjeejeaghdcadhgpaenaihapgflabaaaaaaceafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefchaadaaaaeaaaabaanmaaaaaafjaaaaae
egiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaipccabaaa
abaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaiadpdiaaaaaihcaabaaa
abaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaaa
abaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaabaaaaaa
agiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaabaaaaaa
diaaaaaipccabaaaadaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaalaaaaaa
diaaaaaibcaabaaaabaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaahicaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaadpdiaaaaak
fcaabaaaabaaaaaaagadbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
dcaaaaamdcaabaaaaaaaaaaaegaabaaaaaaaaaaaaceaaaaaaaaaiadpaaaaialp
aaaaaaaaaaaaaaaapgapbaaaaaaaaaaadiaaaaakdccabaaaafaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaadgaaaaafmccabaaa
aeaaaaaakgaobaaaaaaaaaaadgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 worldSpaceVertex_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_1 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 grabPassPos_5;
  highp vec4 o_6;
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7.x;
  tmpvar_8.y = (tmpvar_7.y * _ProjectionParams.x);
  o_6.xy = (tmpvar_8 + tmpvar_7.w);
  o_6.zw = tmpvar_4.zw;
  grabPassPos_5.xy = ((tmpvar_4.xy + tmpvar_4.w) * 0.5);
  grabPassPos_5.zw = tmpvar_4.zw;
  tmpvar_2.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex_1 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_1.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_6;
  xlv_TEXCOORD4 = grabPassPos_5;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _RefractionTex;
uniform sampler2D _BumpMap;
void main ()
{
  mediump vec4 reflectionColor_1;
  mediump vec4 baseColor_2;
  highp float nh_3;
  mediump vec3 h_4;
  mediump vec4 rtRefractions_5;
  mediump vec4 grabWithOffset_6;
  mediump vec4 distortOffset_7;
  mediump vec3 viewVector_8;
  mediump vec3 worldNormal_9;
  mediump vec4 coords_10;
  coords_10 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_11;
  vertexNormal_11 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_12;
  bumpStrength_12 = _DistortParams.x;
  mediump vec4 bump_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = (texture2D (_BumpMap, coords_10.xy) + texture2D (_BumpMap, coords_10.zw));
  bump_13 = tmpvar_14;
  bump_13.xy = (bump_13.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_15;
  tmpvar_15 = normalize((vertexNormal_11 + ((bump_13.xxy * bumpStrength_12) * vec3(1.0, 0.0, 1.0))));
  worldNormal_9.y = tmpvar_15.y;
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize(xlv_TEXCOORD1);
  viewVector_8 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, 0.0);
  tmpvar_17.xy = ((tmpvar_15.xz * _DistortParams.y) * 10.0);
  distortOffset_7 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18 = (xlv_TEXCOORD4 + distortOffset_7);
  grabWithOffset_6 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2DProj (_RefractionTex, grabWithOffset_6);
  rtRefractions_5 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((_WorldLightDir.xyz + viewVector_8));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, dot (tmpvar_15, -(h_4)));
  nh_3 = tmpvar_21;
  highp vec2 tmpvar_22;
  tmpvar_22 = (tmpvar_15.xz * _FresnelScale);
  worldNormal_9.xz = tmpvar_22;
  mediump float bias_23;
  bias_23 = _DistortParams.w;
  mediump float power_24;
  power_24 = _DistortParams.z;
  baseColor_2 = _BaseColor;
  reflectionColor_1 = _ReflectionColor;
  mediump vec4 tmpvar_25;
  tmpvar_25 = mix (mix (rtRefractions_5, baseColor_2, baseColor_2.wwww), reflectionColor_1, vec4(clamp ((bias_23 + ((1.0 - bias_23) * pow (clamp ((1.0 - max (dot (-(viewVector_8), worldNormal_9), 0.0)), 0.0, 1.0), power_24))), 0.0, 1.0)));
  highp vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_25 + (max (0.0, pow (nh_3, _Shininess)) * _SpecularColor));
  baseColor_2.xyz = tmpvar_26.xyz;
  baseColor_2.w = 1.0;
  gl_FragData[0] = baseColor_2;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 worldSpaceVertex_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_1 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 grabPassPos_5;
  highp vec4 o_6;
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7.x;
  tmpvar_8.y = (tmpvar_7.y * _ProjectionParams.x);
  o_6.xy = (tmpvar_8 + tmpvar_7.w);
  o_6.zw = tmpvar_4.zw;
  grabPassPos_5.xy = ((tmpvar_4.xy + tmpvar_4.w) * 0.5);
  grabPassPos_5.zw = tmpvar_4.zw;
  tmpvar_2.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex_1 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_1.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_6;
  xlv_TEXCOORD4 = grabPassPos_5;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _RefractionTex;
uniform sampler2D _BumpMap;
void main ()
{
  mediump vec4 reflectionColor_1;
  mediump vec4 baseColor_2;
  highp float nh_3;
  mediump vec3 h_4;
  mediump vec4 rtRefractions_5;
  mediump vec4 grabWithOffset_6;
  mediump vec4 distortOffset_7;
  mediump vec3 viewVector_8;
  mediump vec3 worldNormal_9;
  mediump vec4 coords_10;
  coords_10 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_11;
  vertexNormal_11 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_12;
  bumpStrength_12 = _DistortParams.x;
  mediump vec4 bump_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = (texture2D (_BumpMap, coords_10.xy) + texture2D (_BumpMap, coords_10.zw));
  bump_13 = tmpvar_14;
  bump_13.xy = (bump_13.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_15;
  tmpvar_15 = normalize((vertexNormal_11 + ((bump_13.xxy * bumpStrength_12) * vec3(1.0, 0.0, 1.0))));
  worldNormal_9.y = tmpvar_15.y;
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize(xlv_TEXCOORD1);
  viewVector_8 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, 0.0);
  tmpvar_17.xy = ((tmpvar_15.xz * _DistortParams.y) * 10.0);
  distortOffset_7 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18 = (xlv_TEXCOORD4 + distortOffset_7);
  grabWithOffset_6 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2DProj (_RefractionTex, grabWithOffset_6);
  rtRefractions_5 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((_WorldLightDir.xyz + viewVector_8));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, dot (tmpvar_15, -(h_4)));
  nh_3 = tmpvar_21;
  highp vec2 tmpvar_22;
  tmpvar_22 = (tmpvar_15.xz * _FresnelScale);
  worldNormal_9.xz = tmpvar_22;
  mediump float bias_23;
  bias_23 = _DistortParams.w;
  mediump float power_24;
  power_24 = _DistortParams.z;
  baseColor_2 = _BaseColor;
  reflectionColor_1 = _ReflectionColor;
  mediump vec4 tmpvar_25;
  tmpvar_25 = mix (mix (rtRefractions_5, baseColor_2, baseColor_2.wwww), reflectionColor_1, vec4(clamp ((bias_23 + ((1.0 - bias_23) * pow (clamp ((1.0 - max (dot (-(viewVector_8), worldNormal_9), 0.0)), 0.0, 1.0), power_24))), 0.0, 1.0)));
  highp vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_25 + (max (0.0, pow (nh_3, _Shininess)) * _SpecularColor));
  baseColor_2.xyz = tmpvar_26.xyz;
  baseColor_2.w = 1.0;
  gl_FragData[0] = baseColor_2;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 480
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 490
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 499
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 351
#line 374
#line 391
#line 403
#line 448
#line 469
#line 506
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 510
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 514
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 518
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 522
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 526
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 546
#line 570
#line 607
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 351
void ComputeScreenAndGrabPassPos( in highp vec4 pos, out highp vec4 screenPos, out highp vec4 grabPassPos ) {
    highp float scale = 1.0;
    screenPos = ComputeScreenPos( pos);
    #line 355
    grabPassPos.xy = ((vec2( pos.x, (pos.y * scale)) + pos.w) * 0.5);
    grabPassPos.zw = pos.zw;
}
#line 469
void Gerstner( out mediump vec3 offs, out mediump vec3 nrml, in mediump vec3 vtx, in mediump vec3 tileableVtx, in mediump vec4 amplitude, in mediump vec4 frequency, in mediump vec4 steepness, in mediump vec4 speed, in mediump vec4 directionAB, in mediump vec4 directionCD ) {
    offs = vec3( 0.0, 0.0, 0.0);
    nrml = vec3( 0.0, 1.0, 0.0);
}
#line 528
v2f vert( in appdata_full v ) {
    #line 530
    v2f o;
    mediump vec3 worldSpaceVertex = (_Object2World * v.vertex).xyz;
    mediump vec3 vtxForAni = (worldSpaceVertex.xzz * unity_Scale.w);
    mediump vec3 nrml;
    #line 534
    mediump vec3 offsets;
    Gerstner( offsets, nrml, v.vertex.xyz, vtxForAni, _GAmplitude, _GFrequency, _GSteepness, _GSpeed, _GDirectionAB, _GDirectionCD);
    v.vertex.xyz += offsets;
    mediump vec2 tileableUv = worldSpaceVertex.xz;
    #line 538
    o.bumpCoords.xyzw = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection.xyzw)) * _BumpTiling.xyzw);
    o.viewInterpolator.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
    o.pos = (glstate_matrix_mvp * v.vertex);
    ComputeScreenAndGrabPassPos( o.pos, o.screenPos, o.grabPassPos);
    #line 542
    o.normalInterpolator.xyz = nrml;
    o.normalInterpolator.w = 1.0;
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.normalInterpolator);
    xlv_TEXCOORD1 = vec3(xl_retval.viewInterpolator);
    xlv_TEXCOORD2 = vec4(xl_retval.bumpCoords);
    xlv_TEXCOORD3 = vec4(xl_retval.screenPos);
    xlv_TEXCOORD4 = vec4(xl_retval.grabPassPos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 480
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 490
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 499
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 351
#line 374
#line 391
#line 403
#line 448
#line 469
#line 506
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 510
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 514
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 518
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 522
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 526
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 546
#line 570
#line 607
#line 385
mediump float Fresnel( in mediump vec3 viewVector, in mediump vec3 worldNormal, in mediump float bias, in mediump float power ) {
    #line 387
    mediump float facing = clamp( (1.0 - max( dot( (-viewVector), worldNormal), 0.0)), 0.0, 1.0);
    mediump float refl2Refr = xll_saturate_f((bias + ((1.0 - bias) * pow( facing, power))));
    return refl2Refr;
}
#line 316
mediump vec3 PerPixelNormal( in sampler2D bumpMap, in mediump vec4 coords, in mediump vec3 vertexNormal, in mediump float bumpStrength ) {
    mediump vec4 bump = (texture( bumpMap, coords.xy) + texture( bumpMap, coords.zw));
    #line 319
    bump.xy = (bump.wy - vec2( 1.0, 1.0));
    mediump vec3 worldNormal = (vertexNormal + ((bump.xxy * bumpStrength) * vec3( 1.0, 0.0, 1.0)));
    return normalize(worldNormal);
}
#line 546
mediump vec4 frag( in v2f i ) {
    mediump vec3 worldNormal = PerPixelNormal( _BumpMap, i.bumpCoords, i.normalInterpolator.xyz, _DistortParams.x);
    mediump vec3 viewVector = normalize(i.viewInterpolator.xyz);
    #line 550
    mediump vec4 distortOffset = vec4( ((worldNormal.xz * _DistortParams.y) * 10.0), 0.0, 0.0);
    mediump vec4 screenWithOffset = (i.screenPos + distortOffset);
    mediump vec4 grabWithOffset = (i.grabPassPos + distortOffset);
    mediump vec4 rtRefractionsNoDistort = textureProj( _RefractionTex, i.grabPassPos);
    #line 554
    mediump float refrFix = textureProj( _CameraDepthTexture, grabWithOffset).x;
    mediump vec4 rtRefractions = textureProj( _RefractionTex, grabWithOffset);
    mediump vec3 reflectVector = normalize(reflect( viewVector, worldNormal));
    mediump vec3 h = normalize((_WorldLightDir.xyz + viewVector.xyz));
    #line 558
    highp float nh = max( 0.0, dot( worldNormal, (-h)));
    highp float spec = max( 0.0, pow( nh, _Shininess));
    mediump vec4 edgeBlendFactors = vec4( 1.0, 0.0, 0.0, 0.0);
    worldNormal.xz *= _FresnelScale;
    #line 562
    mediump float refl2Refr = Fresnel( viewVector, worldNormal, _DistortParams.w, _DistortParams.z);
    mediump vec4 baseColor = _BaseColor;
    mediump vec4 reflectionColor = _ReflectionColor;
    baseColor = mix( mix( rtRefractions, baseColor, vec4( baseColor.w)), reflectionColor, vec4( refl2Refr));
    #line 566
    baseColor = (baseColor + (spec * _SpecularColor));
    baseColor.w = edgeBlendFactors.x;
    return baseColor;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    mediump vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.normalInterpolator = vec4(xlv_TEXCOORD0);
    xlt_i.viewInterpolator = vec3(xlv_TEXCOORD1);
    xlt_i.bumpCoords = vec4(xlv_TEXCOORD2);
    xlt_i.screenPos = vec4(xlv_TEXCOORD3);
    xlt_i.grabPassPos = vec4(xlv_TEXCOORD4);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 8
//   d3d9 - ALU: 41 to 53, TEX: 3 to 7
//   d3d11 - ALU: 38 to 51, TEX: 3 to 7, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
SetTexture 3 [_ReflectionTex] 2D
"ps_3_0
; 53 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c9, -1.00000000, 0.00000000, 1.00000000, 10.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c9.x
mul_pp r0.xy, r0, c7.x
mad_pp r0.xyz, r0.xxyw, c9.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
mul r0.xy, r1.xzzw, c7.y
mul r3.xy, r0, c9.w
mov_pp r3.zw, c9.y
add r2, r3, v4
texldp r0.x, r2, s2
mad r0.x, r0, c0.z, c0.w
rcp r0.x, r0.x
add r0.w, -v3.z, r0.x
texldp r0.xyz, v4, s1
texldp r2.xyz, r2, s1
cmp_pp r2.xyz, r0.w, r2, r0
add r0, v3, r3
texldp r0.xyz, r0, s3
add_pp r3.xyz, -r2, c2
mad_pp r4.xyz, r3, c2.w, r2
add_pp r2.xyz, -r0, c3
mad_pp r0.xyz, r2, c3.w, r0
add_pp r5.xyz, r0, -r4
dp3 r0.w, v1, v1
rsq r0.w, r0.w
mul r2.xyz, r0.w, v1
add r3.xyz, r2, c6
mul_pp r0.xz, r1, c8.x
mov_pp r0.y, r1
dp3_pp r0.y, -r2, r0
dp3 r0.w, r3, r3
rsq r0.x, r0.w
max_pp r0.w, r0.y, c9.y
mul r0.xyz, r0.x, r3
dp3_pp r1.x, r1, -r0
add_pp_sat r1.w, -r0, c9.z
pow_pp r0, r1.w, c7.z
max_pp r0.z, r1.x, c9.y
pow r1, r0.z, c5.x
mov_pp r0.y, c7.w
mov_pp r0.w, r0.x
add_pp r0.x, c9.z, -r0.y
mad_pp_sat r0.x, r0, r0.w, c7.w
mad_pp r2.xyz, r0.x, r5, r4
texldp r0.x, v3, s2
mad r0.x, r0, c0.z, c0.w
mov r0.y, r1.x
rcp r0.x, r0.x
max r0.y, r0, c9
add r0.x, r0, -v3.w
mad oC0.xyz, r0.y, c1, r2
mul_sat oC0.w, r0.x, c4.x
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Vector 2 [_BaseColor]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
Vector 4 [_InvFadeParemeter]
Vector 3 [_ReflectionColor]
Float 5 [_Shininess]
Vector 1 [_SpecularColor]
Vector 6 [_WorldLightDir]
Vector 0 [_ZBufferParams]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
SetTexture 2 [_RefractionTex] 2D
SetTexture 3 [_CameraDepthTexture] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 52.00 (39 instructions), vertex: 0, texture: 28,
//   sequencer: 20, interpolator: 20;    8 GPRs, 24 threads,
// Performance (if enough threads): ~52 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaackmaaaaaclaaaaaaaaaaaaaaaceaaaaacfaaaaaachiaaaaaaaa
aaaaaaaaaaaaacciaaaaaabmaaaaacbmppppadaaaaaaaaanaaaaaabmaaaaaaaa
aaaaacbfaaaaabcaaaacaaacaaabaaaaaaaaabcmaaaaaaaaaaaaabdmaaadaaaa
aaabaaaaaaaaabeiaaaaaaaaaaaaabfiaaadaaadaaabaaaaaaaaabeiaaaaaaaa
aaaaabgmaaacaaahaaabaaaaaaaaabcmaaaaaaaaaaaaabhlaaacaaaiaaabaaaa
aaaaabimaaaaaaaaaaaaabjmaaacaaaeaaabaaaaaaaaabcmaaaaaaaaaaaaabko
aaacaaadaaabaaaaaaaaabcmaaaaaaaaaaaaablpaaadaaabaaabaaaaaaaaabei
aaaaaaaaaaaaabmoaaadaaacaaabaaaaaaaaabeiaaaaaaaaaaaaabnnaaacaaaf
aaabaaaaaaaaabimaaaaaaaaaaaaaboiaaacaaabaaabaaaaaaaaabcmaaaaaaaa
aaaaabphaaacaaagaaabaaaaaaaaabcmaaaaaaaaaaaaacagaaacaaaaaaabaaaa
aaaaabcmaaaaaaaafpecgbhdgfedgpgmgphcaaklaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpechfgnhaengbhaaaklklklaaaeaaamaaabaaabaaabaaaaaaaaaaaa
fpedgbgngfhcgbeegfhahegifegfhihehfhcgfaafpeegjhdhegphchefagbhcgb
gnhdaafpeghcgfhdgogfgmfdgdgbgmgfaaklklklaaaaaaadaaabaaabaaabaaaa
aaaaaaaafpejgohgeggbgegffagbhcgfgngfhegfhcaafpfcgfgggmgfgdhegjgp
goedgpgmgphcaafpfcgfgggmgfgdhegjgpgofegfhiaafpfcgfgghcgbgdhegjgp
gofegfhiaafpfdgigjgogjgogfhdhdaafpfdhagfgdhfgmgbhcedgpgmgphcaafp
fhgphcgmgeemgjghgiheeegjhcaafpfkechfgggggfhcfagbhcgbgnhdaahahdfp
ddfpdaaadccodacodcdadddfddcodaaaaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaa
aaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaacha
baaaahaaaaaaaaaeaaaaaaaaaaaaemkfaabpaabpaaaaaaabaaaapafaaaaahbfb
aaaapcfcaaaapdfdaaaapefeaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
dpiaaaaaebcaaaaalpiaaaaaaacfgaafgaalbcaabcaaaaaaaaaagabbgabhbcaa
bcaaaaaaafjagabncacdbcaabcaaaaafaaaaaaaagacfmeaabcaaaaaaaaaagacl
cadbbcaaccaaaaaabaaafaebbpbpphpjaaaaeaaadiaacaebbpbppofpaaaaeaaa
emiiabacaaloloblpaababademcdagahaabllablobabadaefiibacacaagmmgbl
oaafaciclabhagabaablleaaobacabpplaihagafaalemaabkaabagppmiaeaaag
aablblaaoaagafaamiamaaacaaeggmomklagahaamiabaaacaamhmhgmnbacacpp
miacaaacaalblbgmolaaaaacficbacacaalololbpaafaficmiabaaaaaalblbaa
obacaaaafiigaaaaaabglbgmobacacickiboacacaapmblebmbafaaaikiecacac
acgcmdecnaaaacaimianaaacaakmgogmgmppacaamiabaaacaemnbeaapaabacaa
miajaaaaaalagmaakcacppaalkeaabaaaaaaaaiamcaaaappeaedababaamfmgmg
kbaappabmiahaaacaamnmbaakbabahaabeagaaababgblmblmaacaeahaebgabaa
aagblmlbmaacadppdibmagagaapbblmgobaaabacmiahaaafaamalaaaobabagaa
gecicakbbpbppoiiaaaaeaaaeacdaaabaalblablobagaeiabacibacbbpbppoii
aaaaeaaagedigakbbpbppppiaaaaeaaabadigaobbpbpppmhaaaaeaaalibiaamb
bpbppehiaaaaeaaakiihacaeaebemaebiaaaadafmiahaaaeaamablbeklaeadaa
miadaaaaaalamgblilagaaaaeneiaaabaagmbllbkaafahaaembcaaaaacmgblgm
oaaaadaamiabaaaaaamggmaaofadaaaakkiaiaaaaaaaaaebmcaaaaaemiahaaaa
aagmmamaomaaacabmiahaaabaemamaaakaaaacaamiahaaaaaamablmaklabacaa
diihaaabaclelebloaaeaaacmiaiaaaaaablgmaakcaappaamiahaaaaaamablle
olababaamiahiaaaaablmaleklaaabaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
SetTexture 3 [_ReflectionTex] 2D
"sce_fp_rsx // 82 instructions using 4 registers
[Configuration]
24
ffffffff0007c020001fffe0000000000000840004000000
[Offsets]
9
_ZBufferParams 2 0
000003a000000290
_SpecularColor 1 0
00000510
_BaseColor 2 0
0000049000000450
_ReflectionColor 2 0
0000018000000160
_InvFadeParemeter 1 0
00000420
_Shininess 1 0
00000310
_WorldLightDir 1 0
000001d0
_DistortParams 5 0
000004e000000470000003800000008000000050
_FresnelScale 1 0
00000140
[Microcode]
1312
d4001700c8011c9dc8000001c8003fe1d40217005c011c9dc8000001c8003fe1
18800300ba001c9dba040001c8000001fe040100c8011c9dc8000001c8003fe1
0a8404405f001c9d000200000002000200000000000000000000000000000000
1e7e7d00c8001c9dc8000001c800000110000100aa021c9cc8000001c8000001
000000000000000000000000000000008e800340c8011c9dc9080001c8003fe1
10800200c8001c9d00020000c800000100004120000000000000000000000000
0e803940c9001c9dc8000029c800000104860140c9001c9dc8000001c8000001
1884014000021c9cc8000001c800000100000000000000000000000000000000
06840200d1001c9dff000001c80000011e040300c8081c9dc9080001c8000001
0e041806c8081c9dc8000001c80000010a860200c9001c9d00020000c8000001
000000000000000000000000000000000e060300c8081c9fc8020001c8000001
000000000000000000000000000000000e820400c80c1c9dfe020001c8080001
00000000000000000000000000000000b0040500c8011c9dc8010001c800bfe1
ae063b00c8011c9dfe080001c800bfe110800540c80c1c9fc90c0001c8000001
0e060300c80c1c9dc8020001c800000100000000000000000000000000000000
02800540c9001c9fc80c0001c800000110060900c9001c9d00020000c8000001
0000000000000000000000000000000008060500c80c1c9dc80c0001c8000001
04808300fe0c1c9f00020000c800000100003f80000000000000000000000000
f6061804c8011c9dc8000001c8003fe104000500a60c1c9dc8020001c8000001
00013f7f00013b7f0001377f00000000088c1d00ab001c9cc8000001c8000001
10060400aa001c9c54020001c802000100000000000000000000000000000000
02803b00c9001c9d540c0001c800000102060900c9001c9d00020000c8000001
000000000000000000000000000000001e020301c8011c9dc9080001c8003fe1
02001d00c80c1c9dc8000001c80000010e041802c8041c9dc8000001c8000001
02000200c8001c9d00020000c800000100000000000000000000000000000000
16021804c8041c9dc8000001c800000102020500a6041c9dc8020001c8000001
00013f7f00013b7f0001377f0000000002001c00c8001c9dc8000001c8000001
04001a00fe0c1c9dc8000001c80000010286020055181c9d54020001c8000001
0000000000000000000000000000000002020400c8041c9d54020001fe020001
0000000000000000000000000000000010821c40c90c1c9dc8000001c8000001
0e880140c8081c9dc8000001c800000102021a00c8041c9dc8000001c8000001
f8040100c8011c9dc8000001c8003fe104000300fe081c9fc8000001c8000001
117e4a0000041c9c54080001c800000110808200aa001c9c00020000c8000001
000000000000000000000000000000000e881803c8011ff5c8000001c8003fe1
0e8a0340c9101c9fc8020001c800000100000000000000000000000000000000
10820440c9041c9dc8020003c904000100000000000000000000000000000000
0e840440c9141c9dfe020001c910000100000000000000000000000000000000
1004090000001c9c00020000c800000100000000000000000000000000000000
0e860340c9041c9dc9080003c800000110848340c9041c9dc8020001c8000001
000000000000000000000000000000000e820440ff081c9dc90c0001c9080001
0e810400fe081c9dc8020001c904000100000000000000000000000000000000
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
ConstBuffer "$Globals" 304 // 164 used size, 19 vars
Vector 48 [_SpecularColor] 4
Vector 64 [_BaseColor] 4
Vector 80 [_ReflectionColor] 4
Vector 96 [_InvFadeParemeter] 4
Float 112 [_Shininess]
Vector 128 [_WorldLightDir] 4
Vector 144 [_DistortParams] 4
Float 160 [_FresnelScale]
ConstBuffer "UnityPerCamera" 128 // 128 used size, 8 vars
Vector 112 [_ZBufferParams] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 2
SetTexture 2 [_CameraDepthTexture] 2D 3
SetTexture 3 [_ReflectionTex] 2D 1
// 62 instructions, 6 temp regs, 0 temp arrays:
// ALU 51 float, 0 int, 0 uint
// TEX 7 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefieceddcnmijckmocpocjlfdgompehodohkfjkabaaaaaajmajaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefchmaiaaaa
eaaaaaaabpacaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaa
abaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaadhcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaad
pcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacagaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaafaaaaaapgbpbaaa
afaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaadaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahhcaabaaaabaaaaaapganbaaa
abaaaaaapganbaaaacaaaaaaaaaaaaakhcaabaaaabaaaaaaegacbaaaabaaaaaa
aceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaagiacaaaaaaaaaaaajaaaaaadcaaaaamhcaabaaaabaaaaaa
egacbaaaabaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaiadpaaaaaaaaegbcbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaidcaabaaaacaaaaaaigaabaaa
abaaaaaafgifcaaaaaaaaaaaajaaaaaadiaaaaakdcaabaaaacaaaaaaegaabaaa
acaaaaaaaceaaaaaaaaacaebaaaacaebaaaaaaaaaaaaaaaadgaaaaafecaabaaa
acaaaaaaabeaaaaaaaaaaaaaaaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaa
egbdbaaaafaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegbdbaaa
aeaaaaaaaoaaaaahdcaabaaaacaaaaaaegaabaaaacaaaaaakgakbaaaacaaaaaa
efaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaadaaaaaaaagabaaa
abaaaaaaaoaaaaahdcaabaaaadaaaaaaegaabaaaadaaaaaakgakbaaaadaaaaaa
efaaaaajpcaabaaaaeaaaaaaegaabaaaadaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaaefaaaaajpcaabaaaadaaaaaaegaabaaaadaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaadcaaaaalicaabaaaaaaaaaaackiacaaaabaaaaaaahaaaaaa
akaabaaaaeaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakicaabaaaaaaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaaaaaaaaadbaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaackbabaaaaeaaaaaadhaaaaajhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaaaaaaaaaj
hcaabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaaaaaaaaapgipcaaaaaaaaaaaaeaaaaaaegacbaaaadaaaaaa
egacbaaaaaaaaaaaaaaaaaajhcaabaaaadaaaaaaegacbaiaebaaaaaaacaaaaaa
egiccaaaaaaaaaaaafaaaaaadcaaaaakhcaabaaaacaaaaaapgipcaaaaaaaaaaa
afaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaaaaaaaaaihcaabaaaacaaaaaa
egacbaiaebaaaaaaaaaaaaaaegacbaaaacaaaaaadiaaaaaifcaabaaaadaaaaaa
agacbaaaabaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaadaaaaaa
bkaabaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aeaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaakhcaabaaaafaaaaaa
egbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaai
icaabaaaaaaaaaaaegacbaiaebaaaaaaaeaaaaaaegacbaaaadaaaaaadeaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaa
aaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaaj
icaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadp
dccaaaakicaabaaaaaaaaaaadkaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaa
aaaaaaaaajaaaaaadcaaaaajhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
acaaaaaaegacbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaafaaaaaa
egacbaaaafaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaafaaaaaabaaaaaaiicaabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaa
aaaaaaaaahaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaak
hccabaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaa
aaaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaadcaaaaalbcaabaaaaaaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaa
aaaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaaaaaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaadkbabaiaebaaaaaaaeaaaaaadicaaaaiiccabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaagaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
"ps_3_0
; 50 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c9, -1.00000000, 0.00000000, 1.00000000, 10.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c9.x
mul_pp r0.xy, r0, c7.x
mad_pp r0.xyz, r0.xxyw, c9.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
mul r0.xy, r1.xzzw, c7.y
mul r0.xy, r0, c9.w
mov_pp r0.zw, c9.y
add r2, v4, r0
texldp r0.x, r2, s2
mad r0.x, r0, c0.z, c0.w
rcp r0.x, r0.x
add r0.w, -v3.z, r0.x
texldp r2.xyz, r2, s1
texldp r0.xyz, v4, s1
cmp_pp r0.xyz, r0.w, r2, r0
add_pp r2.xyz, -r0, c2
mad_pp r4.xyz, r2, c2.w, r0
dp3 r0.w, v1, v1
rsq r0.x, r0.w
mul r2.xyz, r0.x, v1
add r3.xyz, r2, c6
mul_pp r0.xz, r1, c8.x
mov_pp r0.y, r1
dp3_pp r0.y, -r2, r0
dp3 r0.w, r3, r3
rsq r0.x, r0.w
max_pp r0.w, r0.y, c9.y
mul r0.xyz, r0.x, r3
dp3_pp r1.x, r1, -r0
add_pp_sat r1.w, -r0, c9.z
pow_pp r0, r1.w, c7.z
max_pp r0.z, r1.x, c9.y
pow r1, r0.z, c5.x
mov_pp r0.y, c7.w
mov_pp r0.w, r0.x
add_pp r0.x, c9.z, -r0.y
mov r0.y, r1.x
mad_pp_sat r0.x, r0, r0.w, c7.w
add_pp r5.xyz, -r4, c3
mad_pp r2.xyz, r0.x, r5, r4
texldp r0.x, v3, s2
mad r0.x, r0, c0.z, c0.w
rcp r0.x, r0.x
max r0.y, r0, c9
add r0.x, r0, -v3.w
mad oC0.xyz, r0.y, c1, r2
mul_sat oC0.w, r0.x, c4.x
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Vector 2 [_BaseColor]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
Vector 4 [_InvFadeParemeter]
Vector 3 [_ReflectionColor]
Float 5 [_Shininess]
Vector 1 [_SpecularColor]
Vector 6 [_WorldLightDir]
Vector 0 [_ZBufferParams]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 46.67 (35 instructions), vertex: 0, texture: 24,
//   sequencer: 16, interpolator: 20;    8 GPRs, 24 threads,
// Performance (if enough threads): ~46 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaacimaaaaacgiaaaaaaaaaaaaaaceaaaaacdaaaaaacfiaaaaaaaa
aaaaaaaaaaaaacaiaaaaaabmaaaaabpjppppadaaaaaaaaamaaaaaabmaaaaaaaa
aaaaabpcaaaaabamaaacaaacaaabaaaaaaaaabbiaaaaaaaaaaaaabciaaadaaaa
aaabaaaaaaaaabdeaaaaaaaaaaaaabeeaaadaaacaaabaaaaaaaaabdeaaaaaaaa
aaaaabfiaaacaaahaaabaaaaaaaaabbiaaaaaaaaaaaaabghaaacaaaiaaabaaaa
aaaaabhiaaaaaaaaaaaaabiiaaacaaaeaaabaaaaaaaaabbiaaaaaaaaaaaaabjk
aaacaaadaaabaaaaaaaaabbiaaaaaaaaaaaaabklaaadaaabaaabaaaaaaaaabde
aaaaaaaaaaaaablkaaacaaafaaabaaaaaaaaabhiaaaaaaaaaaaaabmfaaacaaab
aaabaaaaaaaaabbiaaaaaaaaaaaaabneaaacaaagaaabaaaaaaaaabbiaaaaaaaa
aaaaabodaaacaaaaaaabaaaaaaaaabbiaaaaaaaafpecgbhdgfedgpgmgphcaakl
aaabaaadaaabaaaeaaabaaaaaaaaaaaafpechfgnhaengbhaaaklklklaaaeaaam
aaabaaabaaabaaaaaaaaaaaafpedgbgngfhcgbeegfhahegifegfhihehfhcgfaa
fpeegjhdhegphchefagbhcgbgnhdaafpeghcgfhdgogfgmfdgdgbgmgfaaklklkl
aaaaaaadaaabaaabaaabaaaaaaaaaaaafpejgohgeggbgegffagbhcgfgngfhegf
hcaafpfcgfgggmgfgdhegjgpgoedgpgmgphcaafpfcgfgghcgbgdhegjgpgofegf
hiaafpfdgigjgogjgogfhdhdaafpfdhagfgdhfgmgbhcedgpgmgphcaafpfhgphc
gmgeemgjghgiheeegjhcaafpfkechfgggggfhcfagbhcgbgnhdaahahdfpddfpda
aadccodacodcdadddfddcodaaaklklklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaa
aaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaacci
baaaahaaaaaaaaaeaaaaaaaaaaaaemkfaabpaabpaaaaaaabaaaapafaaaaahbfb
aaaapcfcaaaapdfdaaaapefeaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
dpiaaaaaebcaaaaalpiaaaaaaacfgaaegaakbcaabcaaaaaaaaaagabagabgbcaa
bcaaaaaaabfefabmaaaabcaameaaaaaaaaaagacbgachbcaaccaaaaaabaaagaeb
bpbpphpjaaaaeaaadiaacaebbpbppofpaaaaeaaaembiacabaaloloblpaababad
emedafafaagmlablobacadaefiibabacaagmmgbloaagaciblabhahabaablleaa
obababpplaehahagaalemaabkaabagppmiacaaahaamgblaaoaahagaamiagaaac
aagbgmmmklahahaamiaiaaabaalclcgmnbacacppmiabaaacaalblbblolaaaaab
fibiacabaalologmpaagagicmiabaaaaaagmlbaaobacaaaafiigaaaaaambgmbl
obacacibkiboacacaapmblebmbagaaaikiecacacacgcmdecnaaaacaimianaaac
aakmgogmgmppacaamiabaaacaemnbeaapaabacaamiajaaaaaalagmaakcacppaa
lkedababaamglaiambafaeppeaedacacaamfmgmgkbaappabmiahaaacaamnmbaa
kbacahaadiidafacaagnlamgoaacaeaceaceaaacaebllbblcaahppiakiboacac
aapmagebmbacafafgebiaaebbpbppehiaaaaeaaababibacbbpbppoiiaaaaeaaa
gecieaebbpbppppiaaaaeaaabacieakbbpbpppmhaaaaeaaamiagaaacaalmmgbl
ilaeaaaaenciaaabaablblmgkaacahacemccacaaaclbbllboaaaadacmiacaaac
aamglbaaofadacaakkiaiaaaaaaaaaebmcaaaaaemiahaaaaaalbbemaomacaaab
miahaaabaemamaaakaaaacaamiahaaaaaamablmaklabacaadiihaaabaelelegm
kaaaadacmiaiaaaaaablgmaakcaappaamiahaaaaaamablleolababaamiahiaaa
aablmaleklaaabaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
"sce_fp_rsx // 75 instructions using 4 registers
[Configuration]
24
ffffffff0007c020001fffe0000000000000840004000000
[Offsets]
9
_ZBufferParams 2 0
0000033000000080
_SpecularColor 1 0
000004a0
_BaseColor 2 0
00000420000003d0
_ReflectionColor 1 0
00000440
_InvFadeParemeter 1 0
00000480
_Shininess 1 0
00000290
_WorldLightDir 1 0
000000f0
_DistortParams 5 0
000003f00000037000000300000000c0000000a0
_FresnelScale 1 0
00000180
[Microcode]
1200
d4021700c8011c9dc8000001c8003fe1d40017005c011c9dc8000001c8003fe1
18800300ba041c9dba000001c8000001f6021804c8011c9dc8000001c8003fe1
10000500a6041c9dc8020001c800000100013f7f00013b7f0001377f00000000
a8000500c8011c9dc8010001c800bfe110040400c8001c9d54020001c8020001
000000000000000000000000000000000a8004405f001c9d0002000000020002
0000000000000000000000000000000010000100aa021c9cc8000001c8000001
00000000000000000000000000000000ae023b00c8011c9d54000001c800bfe1
0e060300c8041c9dc8020001c800000100000000000000000000000000000000
8e800340c8011c9dc9000001c8003fe110800200c8001c9d00020000c8000001
0000412000000000000000000000000008040500c80c1c9dc80c0001c8000001
0e803940c9001c9dc8000029c800000104820140c9001c9dc8000001c8000001
02880540c9001c9fc80c0001c80000010a820200c9001c9d00020000c8000001
0000000000000000000000000000000006800200d1001c9dff000001c8000001
10823b0001101c9c54080001c80000011880014000021c9cc8000001c8000001
0000000000000000000000000000000002040900ff041c9d00020000c8000001
0000000000000000000000000000000008880540c8041c9fc9040001c8000001
08040900c9101c9d00020000c800000100000000000000000000000000000000
1e020301c8011c9dc9000001c8003fe104001d00c8081c9dc8000001c8000001
0280830054081c9f00020000c800000100003f80000000000000000000000000
0e041802c8041c9dc8000001c800000102801d00c9001c9dc8000001c8000001
04000200c8001c9d00020000c800000100000000000000000000000000000000
16021804c8041c9dc8000001c800000102020500a6041c9dc8020001c8000001
00013f7f00013b7f0001377f0000000004021c00aa001c9cc8000001c8000001
f8020100c8011c9dc8000001c8003fe102800200c9001c9d54020001c8000001
0000000000000000000000000000000010801c40c9001c9dc8000001c8000001
02020400c8041c9d54020001fe02000100000000000000000000000000000000
02021a00c8041c9dc8000001c80000010e800140c8081c9dc8000001c8000001
02820440ff001c9dfe020003ff00000100000000000000000000000000000000
10000900aa041c9c00020000c800000100000000000000000000000000000000
117e4a0000041c9c54040001c80000010e801803c8011ff5c8000001c8003fe1
0e880340c9001c9fc8020001c800000100000000000000000000000000000000
1080834001041c9cc8020001c800000100000000000000000000000000000000
08001a00fe081c9dc8000001c80000010e800440c9101c9dfe020001c9000001
000000000000000000000000000000000e840340c9001c9fc8020001c8000001
0000000000000000000000000000000010020300c8041c9f54000001c8000001
0e800440ff001c9dc9080001c900000110808200c8041c9d00020000c8000001
000000000000000000000000000000000e810400fe001c9dc8020001c9000001
00000000000000000000000000000000
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
ConstBuffer "$Globals" 304 // 164 used size, 19 vars
Vector 48 [_SpecularColor] 4
Vector 64 [_BaseColor] 4
Vector 80 [_ReflectionColor] 4
Vector 96 [_InvFadeParemeter] 4
Float 112 [_Shininess]
Vector 128 [_WorldLightDir] 4
Vector 144 [_DistortParams] 4
Float 160 [_FresnelScale]
ConstBuffer "UnityPerCamera" 128 // 128 used size, 8 vars
Vector 112 [_ZBufferParams] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 1
SetTexture 2 [_CameraDepthTexture] 2D 2
// 57 instructions, 4 temp regs, 0 temp arrays:
// ALU 47 float, 0 int, 0 uint
// TEX 6 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedencfdgmknbcifcffhonebpbfjnofajimabaaaaaanmaiaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefclmahaaaa
eaaaaaaaopabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaa
abaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaa
gcbaaaadpcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaadaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaa
adaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahhcaabaaaaaaaaaaa
pganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaadcaaaaamhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaiadpaaaaaaaa
egbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaifcaabaaaabaaaaaa
agacbaaaaaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaabaaaaaa
bkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaakhcaabaaaadaaaaaa
egbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaai
icaabaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaa
aaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaaj
bcaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadp
dccaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaa
aaaaaaaaajaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaafgifcaaa
aaaaaaaaajaaaaaadiaaaaakdcaabaaaabaaaaaaegaabaaaabaaaaaaaceaaaaa
aaaacaebaaaacaebaaaaaaaaaaaaaaaadgaaaaafecaabaaaabaaaaaaabeaaaaa
aaaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegbdbaaaafaaaaaa
aoaaaaahdcaabaaaabaaaaaaegaabaaaabaaaaaakgakbaaaabaaaaaaefaaaaaj
pcaabaaaacaaaaaaegaabaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaadcaaaaalicaabaaaabaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaa
acaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakicaabaaaabaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadbaaaaahicaabaaa
abaaaaaadkaabaaaabaaaaaackbabaaaaeaaaaaaaoaaaaahdcaabaaaacaaaaaa
egbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaa
acaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadhaaaaajhcaabaaaabaaaaaa
pgapbaaaabaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaa
acaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaak
hcaabaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaaegacbaaaacaaaaaaegacbaaa
abaaaaaaaaaaaaajhcaabaaaacaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaa
aaaaaaaaafaaaaaadcaaaaajhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaa
acaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaa
egacbaaaadaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaa
aaaaaaaaahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaak
hccabaaaaaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaa
abaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaacaaaaaaaagabaaa
acaaaaaadcaaaaalbcaabaaaaaaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaa
aaaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaaaaaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaadkbabaiaebaaaaaaaeaaaaaadicaaaaiiccabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaagaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_ReflectionTex] 2D
"ps_3_0
; 44 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c7, -1.00000000, 0.00000000, 1.00000000, 10.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c7.x
mul_pp r0.xy, r0, c5.x
mad_pp r0.xyz, r0.xxyw, c7.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
mul r0.xy, r1.xzzw, c5.y
dp3 r1.w, v1, v1
mov_pp r0.zw, c7.y
mul r0.xy, r0, c7.w
add r2, v3, r0
texldp r2.xyz, r2, s2
add r0, r0, v4
add_pp r3.xyz, -r2, c2
texldp r0.xyz, r0, s1
add_pp r5.xyz, -r0, c1
mad_pp r4.xyz, r3, c2.w, r2
mad_pp r0.xyz, r5, c1.w, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, v1
add r3.xyz, r2, c4
dp3 r0.w, r3, r3
rsq r0.w, r0.w
mul r3.xyz, r0.w, r3
dp3_pp r0.w, r1, -r3
mul_pp r1.xz, r1, c6.x
dp3_pp r1.x, -r2, r1
max_pp r0.w, r0, c7.y
pow r2, r0.w, c3.x
max_pp r1.x, r1, c7.y
add_pp_sat r0.w, -r1.x, c7.z
pow_pp r1, r0.w, c5.z
mov r1.y, r2.x
mov_pp r0.w, c5
add_pp r4.xyz, r4, -r0
add_pp r0.w, c7.z, -r0
mad_pp_sat r0.w, r0, r1.x, c5
mad_pp r2.xyz, r0.w, r4, r0
max r0.x, r1.y, c7.y
mad oC0.xyz, r0.x, c0, r2
mov_pp oC0.w, c7.z
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Vector 1 [_BaseColor]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 0 [_SpecularColor]
Vector 4 [_WorldLightDir]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
SetTexture 2 [_RefractionTex] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 42.67 (32 instructions), vertex: 0, texture: 16,
//   sequencer: 16, interpolator: 20;    7 GPRs, 27 threads,
// Performance (if enough threads): ~42 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaacdmaaaaaccmaaaaaaaaaaaaaaceaaaaaboaaaaaacaiaaaaaaaa
aaaaaaaaaaaaabliaaaaaabmaaaaabklppppadaaaaaaaaakaaaaaabmaaaaaaaa
aaaaabkeaaaaaaoeaaacaaabaaabaaaaaaaaaapaaaaaaaaaaaaaabaaaaadaaaa
aaabaaaaaaaaabamaaaaaaaaaaaaabbmaaacaaafaaabaaaaaaaaaapaaaaaaaaa
aaaaabclaaacaaagaaabaaaaaaaaabdmaaaaaaaaaaaaabemaaacaaacaaabaaaa
aaaaaapaaaaaaaaaaaaaabfnaaadaaabaaabaaaaaaaaabamaaaaaaaaaaaaabgm
aaadaaacaaabaaaaaaaaabamaaaaaaaaaaaaabhlaaacaaadaaabaaaaaaaaabdm
aaaaaaaaaaaaabigaaacaaaaaaabaaaaaaaaaapaaaaaaaaaaaaaabjfaaacaaae
aaabaaaaaaaaaapaaaaaaaaafpecgbhdgfedgpgmgphcaaklaaabaaadaaabaaae
aaabaaaaaaaaaaaafpechfgnhaengbhaaaklklklaaaeaaamaaabaaabaaabaaaa
aaaaaaaafpeegjhdhegphchefagbhcgbgnhdaafpeghcgfhdgogfgmfdgdgbgmgf
aaklklklaaaaaaadaaabaaabaaabaaaaaaaaaaaafpfcgfgggmgfgdhegjgpgoed
gpgmgphcaafpfcgfgggmgfgdhegjgpgofegfhiaafpfcgfgghcgbgdhegjgpgofe
gfhiaafpfdgigjgogjgogfhdhdaafpfdhagfgdhfgmgbhcedgpgmgphcaafpfhgp
hcgmgeemgjghgiheeegjhcaahahdfpddfpdaaadccodacodcdadddfddcodaaakl
aaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaeaaaaaabombaaaagaaaaaaaaaeaaaaaaaaaaaaemkf
aabpaabpaaaaaaabaaaapafaaaaahbfbaaaapcfcaaaapdfdaaaapefeaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaebcaaaaadpiaaaaalpiaaaaaaacfgaae
gaakbcaabcaaaaaaaaaagabagabgbcaabcaaaeaaaaabbabmaaaabcaameaaaaaa
aaaagabnfacdbcaaccaaaaaabaaafaebbpbpphpjaaaaeaaadiaacaebbpbppofp
aaaaeaaamiaiaaabaaloloaapaababaafiibabacaagmmgbloaafaciblachagaf
aablmaaaobababpplaehagabaamamaabkaafaeppmiabaaagaamgblaaoaagafaa
miadaaacaalagmmeklagafaamiaiaaabaagngngmnbacacppmiaiaaabaalblbbl
olaaaaabfiieabacaaloloblpaababibfiibaaaaaabllbmgobabaaicbeigabaa
aalmblgmobacabaakibhabacaamablebmbabaaagkiecababacgcloecnaaaacag
miabaaabaeloboaapaafabaamiajaaaaaalagmaakcabppaalkeaabaaaaaaaama
mcaaaappeaedababaamflbmgkbaappabmialaaabaamambaakbabafaaemcdaaac
aalalabloaabaeaeememaaacaakmkmbloaabadadmiapaaadaaaambaaobacaaaa
libicagbbpbppoiiaaaaeaaabacidagbbpbppoiiaaaaeaaamiahaaaeaemamaaa
kaadabaamiahaaafaemamaaakaacacaamiahaaacaamablmaklafacacmiahaaab
aamablmaklaeabadeaceaaaaaeblmgblcaafppiakibaaaaaaaaaaaebmcaaaaad
dibhaaacaclelegmoaacabaadibiaaaaaagmgmblkcaappabmjabaaaaaamggmbl
mlaaaaafmiahaaaaaamagmleolacaaabmiipmaaaaablmaleklaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_ReflectionTex] 2D
"sce_fp_rsx // 63 instructions using 3 registers
[Configuration]
24
ffffffff0007c020001fffe0000000000000840003000000
[Offsets]
7
_SpecularColor 1 0
000003e0
_BaseColor 2 0
00000310000002f0
_ReflectionColor 2 0
0000027000000250
_Shininess 1 0
000002b0
_WorldLightDir 1 0
000000c0
_DistortParams 5 0
0000035000000330000002900000007000000050
_FresnelScale 1 0
00000130
[Microcode]
1008
d4001700c8011c9dc8000001c8003fe1d40217005c011c9dc8000001c8003fe1
18800300ba001c9dba040001c8000001a8000500c8011c9dc8010001c800bfe1
10000100aa021c9cc8000001c800000100000000000000000000000000000000
0a8004405f001c9d000200000002000200000000000000000000000000000000
10800200c8001c9daa020000c800000100000000000041200000000000000000
ae023b00c8011c9d54000001c800bfe10e040300c8041c9dc8020001c8000001
000000000000000000000000000000008e800340c8011c9dc9000001c8003fe1
10020500c8081c9dc8080001c80000010e803940c9001c9dc8000029c8000001
04820140c9001c9dc8000001c800000104800540c9001c9fc8080001c8000001
0a820200c9001c9d00020000c800000100000000000000000000000000000000
02820540c8041c9fc9040001c800000110883b00ab001c9cfe040001c8000001
06800200d1001c9dff000001c80000011880014000021c9cc8000001c8000001
000000000000000000000000000000001e020301c8011c9dc9000001c8003fe1
02040900c9041c9d00020000c800000100000000000000000000000000000000
10040900c9101c9d00020000c800000100000000000000000000000000000000
fe000300c8011c9dc9000001c8003fe102888300c8081c9f00020000c8000001
00003f8000000000000000000000000010041d00fe081c9dc8000001c8000001
0e001804c8001c9dc8000001c800000108821d00c9101c9dc8000001c8000001
0e040300c8001c9fc8020001c800000100000000000000000000000000000000
0e800400c8081c9dfe020001c800000100000000000000000000000000000000
1082020055041c9d54020001c800000100000000000000000000000000000000
10040200c8081c9d00020000c800000100000000000000000000000000000000
0e041802c8041c9dc8000001c800000110801c40ff041c9dc8000001c8000001
0e820340c8081c9fc8020001c800000100000000000000000000000000000000
0e820440c9041c9dfe020001c808000100000000000000000000000000000000
02880440ff001c9dfe020003ff00000100000000000000000000000000000000
1080834001101c9cc8020001c800000100000000000000000000000000000000
0e800340c9001c9dc9040003c80000010e800440ff001c9dc9000001c9040001
08001c00fe081c9dc8000001c80000010202090054001c9d00020000c8000001
0000000000000000000000000000000010800140aa021c9cc8000001c8000001
0000000000003f8000000000000000000e81040000041c9cc8020001c9000001
00000000000000000000000000000000
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
ConstBuffer "$Globals" 304 // 164 used size, 19 vars
Vector 48 [_SpecularColor] 4
Vector 64 [_BaseColor] 4
Vector 80 [_ReflectionColor] 4
Float 112 [_Shininess]
Vector 128 [_WorldLightDir] 4
Vector 144 [_DistortParams] 4
Float 160 [_FresnelScale]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 2
SetTexture 2 [_ReflectionTex] 2D 1
// 50 instructions, 5 temp regs, 0 temp arrays:
// ALU 42 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedkaacckpopllppchjpbnhhohbjfkacjggabaaaaaaliahaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcjiagaaaa
eaaaaaaakgabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaadlcbabaaaaeaaaaaagcbaaaad
lcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaaaaaaaahhcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaa
aaaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialp
aaaaialpaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaa
aaaaaaaaajaaaaaadcaaaaamhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaaaaaaaaaiadpaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaifcaabaaaabaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaa
akaaaaaadgaaaaafccaabaaaabaaaaaabkaabaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegbcbaaa
acaaaaaadcaaaaakhcaabaaaadaaaaaaegbcbaaaacaaaaaapgapbaaaaaaaaaaa
egiccaaaaaaaaaaaaiaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaa
acaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpdeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaacpaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaiicaabaaa
aaaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaaajaaaaaabjaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaadkiacaiaebaaaaaa
aaaaaaaaajaaaaaaabeaaaaaaaaaiadpdccaaaakicaabaaaaaaaaaaaakaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaajaaaaaadiaaaaaidcaabaaa
abaaaaaaigaabaaaaaaaaaaafgifcaaaaaaaaaaaajaaaaaadiaaaaakdcaabaaa
abaaaaaaegaabaaaabaaaaaaaceaaaaaaaaacaebaaaacaebaaaaaaaaaaaaaaaa
dgaaaaafecaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaahhcaabaaaacaaaaaa
egacbaaaabaaaaaaegbdbaaaaeaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaaegbdbaaaafaaaaaaaoaaaaahdcaabaaaabaaaaaaegaabaaaabaaaaaa
kgakbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaacaaaaaaaoaaaaahdcaabaaaacaaaaaaegaabaaaacaaaaaa
kgakbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaabaaaaaaaaaaaaajhcaabaaaaeaaaaaaegacbaiaebaaaaaa
acaaaaaaegiccaaaaaaaaaaaafaaaaaadcaaaaakhcaabaaaacaaaaaapgipcaaa
aaaaaaaaafaaaaaaegacbaaaaeaaaaaaegacbaaaacaaaaaaaaaaaaajhcaabaaa
aeaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaak
hcaabaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaaegacbaaaaeaaaaaaegacbaaa
abaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaiaebaaaaaaabaaaaaaegacbaaa
acaaaaaadcaaaaajhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaa
egacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaa
ahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakhccabaaa
aaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
"ps_3_0
; 41 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c7, -1.00000000, 0.00000000, 1.00000000, 10.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord4 v3
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c7.x
mul_pp r0.xy, r0, c5.x
mad_pp r0.xyz, r0.xxyw, c7.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
mul r0.xy, r1.xzzw, c5.y
dp3 r0.z, v1, v1
rsq r1.w, r0.z
mul r2.xyz, r1.w, v1
add r3.xyz, r2, c4
mul r0.xy, r0, c7.w
mov_pp r0.zw, c7.y
add r0, v3, r0
texldp r0.xyz, r0, s1
add_pp r4.xyz, -r0, c1
mad_pp r0.xyz, r4, c1.w, r0
dp3 r0.w, r3, r3
rsq r0.w, r0.w
mul r3.xyz, r0.w, r3
dp3_pp r0.w, r1, -r3
mul_pp r1.xz, r1, c6.x
dp3_pp r1.x, -r2, r1
max_pp r0.w, r0, c7.y
pow r2, r0.w, c3.x
max_pp r1.x, r1, c7.y
add_pp_sat r0.w, -r1.x, c7.z
pow_pp r1, r0.w, c5.z
mov r1.y, r2.x
mov_pp r0.w, c5
add_pp r4.xyz, -r0, c2
add_pp r0.w, c7.z, -r0
mad_pp_sat r0.w, r0, r1.x, c5
mad_pp r2.xyz, r0.w, r4, r0
max r0.x, r1.y, c7.y
mad oC0.xyz, r0.x, c0, r2
mov_pp oC0.w, c7.z
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Vector 1 [_BaseColor]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 0 [_SpecularColor]
Vector 4 [_WorldLightDir]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 34.67 (26 instructions), vertex: 0, texture: 12,
//   sequencer: 12, interpolator: 20;    6 GPRs, 30 threads,
// Performance (if enough threads): ~34 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaacbiaaaaabmmaaaaaaaaaaaaaaceaaaaablmaaaaaboeaaaaaaaa
aaaaaaaaaaaaabjeaaaaaabmaaaaabiippppadaaaaaaaaajaaaaaabmaaaaaaaa
aaaaabibaaaaaanaaaacaaabaaabaaaaaaaaaanmaaaaaaaaaaaaaaomaaadaaaa
aaabaaaaaaaaaapiaaaaaaaaaaaaabaiaaacaaafaaabaaaaaaaaaanmaaaaaaaa
aaaaabbhaaacaaagaaabaaaaaaaaabciaaaaaaaaaaaaabdiaaacaaacaaabaaaa
aaaaaanmaaaaaaaaaaaaabejaaadaaabaaabaaaaaaaaaapiaaaaaaaaaaaaabfi
aaacaaadaaabaaaaaaaaabciaaaaaaaaaaaaabgdaaacaaaaaaabaaaaaaaaaanm
aaaaaaaaaaaaabhcaaacaaaeaaabaaaaaaaaaanmaaaaaaaafpecgbhdgfedgpgm
gphcaaklaaabaaadaaabaaaeaaabaaaaaaaaaaaafpechfgnhaengbhaaaklklkl
aaaeaaamaaabaaabaaabaaaaaaaaaaaafpeegjhdhegphchefagbhcgbgnhdaafp
eghcgfhdgogfgmfdgdgbgmgfaaklklklaaaaaaadaaabaaabaaabaaaaaaaaaaaa
fpfcgfgggmgfgdhegjgpgoedgpgmgphcaafpfcgfgghcgbgdhegjgpgofegfhiaa
fpfdgigjgogjgogfhdhdaafpfdhagfgdhfgmgbhcedgpgmgphcaafpfhgphcgmge
emgjghgiheeegjhcaahahdfpddfpdaaadccodacodcdadddfddcodaaaaaaaaaaa
aaaaaaabaaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaeaaaaaabimbaaaafaaaaaaaaaeaaaaaaaaaaaaemkfaabpaabp
aaaaaaabaaaapafaaaaahbfbaaaapcfcaaaapdfdaaaapefeaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaebcaaaaadpiaaaaalpiaaaaaaacfgaadgaajbcaa
bcaaaaaaaaaagaapfabfbcaabcaaabaaaaaaaaaagabkmeaaccaaaaaabaaadaeb
bpbpphpjaaaaeaaadiaacaebbpbppofpaaaaeaaamiaiaaabaaloloaapaababaa
fiibabacaagmmgbloaadaciblachafadaablmaaaobababpplaehafabaamamaab
kaadaeppmiabaaafaamgblaaoaafadaamiadaaacaalagmmeklafafaamiaiaaab
aagngngmnbacacppmiaiaaabaalblbblolaaaaabfiieabacaaloloblpaababib
fiibaaaaaabllbmgobabaaicbeigabaaaalmblgmobacabaakibhabacaamableb
mbabaaagkiecababacgcloecnaaaacagmiabaaabaeloboaapaadabaabeadaaab
ablagmblicabppafafeiacaaaegmmgmgiaabppppeaedaaaaaamflbblkbaappaa
emboaaaaaapmpbblkbaaafaedicdaaacaamflabloaaaaeaaeacnaaaaaakognlb
obacaaiblibibaabbpbppoiiaaaaeaaakichaaacaemamaebiaababadmiaoaaab
aapmblpmklacababdichaaacaemjlelbkaabacaalcbbaaabaalbgmaaicaappaf
miahaaaaaamagmmjolacaaabmiipmaaaaagmmaleklabaaaaaaaaaaaaaaaaaaaa
aaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
"sce_fp_rsx // 58 instructions using 3 registers
[Configuration]
24
ffffffff0005c0200017ffe8000000000000840003000000
[Offsets]
7
_SpecularColor 1 0
00000390
_BaseColor 2 0
00000260000001f0
_ReflectionColor 1 0
000002d0
_Shininess 1 0
000002f0
_WorldLightDir 1 0
00000160
_DistortParams 5 0
0000031000000280000002200000009000000040
_FresnelScale 1 0
00000110
[Microcode]
928
d4001700c8011c9dc8000001c8003fe1d40217005c011c9dc8000001c8003fe1
18800300ba001c9dba040001c800000110000100aa021c9cc8000001c8000001
00000000000000000000000000000000a2000500c8011c9dc8010001c800bfe1
10820200c8001c9daa020000c800000100000000000041200000000000000000
0a8204405f001c9d000200000002000200000000000000000000000000000000
8e820340c8011c9dc9040001c8003fe11884014000021c9cc8000001c8000001
000000000000000000000000000000000e883940c9041c9dc8000029c8000001
04860140c9101c9dc8000001c800000106840200d1101c9dff040001c8000001
0a860200c9101c9d00020000c800000100000000000000000000000000000000
ae003b00c8011c9dc8000001c800bfe108820540c8001c9fc90c0001c8000001
1e020301c8011c9dc9080001c8003fe10e000300c8001c9dc8020001c8000001
000000000000000000000000000000001000090055041c9dc8020001c8000001
0000000000000000000000000000000002880540c9101c9fc8000001c8000001
02000500c8001c9dc8000001c800000110808300c8001c9f00020000c8000001
00003f800000000000000000000000000e021802c8041c9dc8000001c8000001
0e820340c8041c9fc8020001c800000100000000000000000000000000000000
08801d00ff001c9dc8000001c80000011080020055001c9d54020001c8000001
0000000000000000000000000000000002803b00c9101c9dc8000001c8000001
04801c40ff001c9dc8000001c80000010e820440c9041c9dfe020001c8040001
0000000000000000000000000000000002860440ab001c9cfe020003ab000000
000000000000000000000000000000001002090001001c9c00020000c8000001
0000000000000000000000000000000002021d00fe041c9dc8000001c8000001
0e800340c9041c9fc8020001c800000100000000000000000000000000000000
02020200c8041c9d00020000c800000100000000000000000000000000000000
10848340010c1c9cc8020001c800000100000000000000000000000000000000
0e860440ff081c9dc9000001c904000102001c00c8041c9dc8000001c8000001
02000900c8001c9d00020000c800000100000000000000000000000000000000
10800140aa021c9cc8000001c80000010000000000003f800000000000000000
0e81040000001c9cc8020001c90c000100000000000000000000000000000000
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
ConstBuffer "$Globals" 304 // 164 used size, 19 vars
Vector 48 [_SpecularColor] 4
Vector 64 [_BaseColor] 4
Vector 80 [_ReflectionColor] 4
Float 112 [_Shininess]
Vector 128 [_WorldLightDir] 4
Vector 144 [_DistortParams] 4
Float 160 [_FresnelScale]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 1
// 45 instructions, 4 temp regs, 0 temp arrays:
// ALU 38 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedalccaahodpbofjbkbhnmlgbgimhabdoaabaaaaaaomagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcmmafaaaa
eaaaaaaahdabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaadlcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaogbkbaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaah
hcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaa
dcaaaaamhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaa
aaaaiadpaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaai
fcaabaaaabaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaaf
ccaabaaaabaaaaaabkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaak
hcaabaaaadaaaaaaegbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaa
aiaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaa
abaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
aaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadp
deaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaa
aaaaaaaackiacaaaaaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaaaaaaaaajbcaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaa
abeaaaaaaaaaiadpdccaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaa
aaaaaaaadkiacaaaaaaaaaaaajaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaa
aaaaaaaafgifcaaaaaaaaaaaajaaaaaadiaaaaakdcaabaaaabaaaaaaegaabaaa
abaaaaaaaceaaaaaaaaacaebaaaacaebaaaaaaaaaaaaaaaadgaaaaafecaabaaa
abaaaaaaabeaaaaaaaaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaa
egbdbaaaafaaaaaaaoaaaaahdcaabaaaabaaaaaaegaabaaaabaaaaaakgakbaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaaaaaaaajhcaabaaaacaaaaaaegacbaiaebaaaaaaabaaaaaa
egiccaaaaaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaapgipcaaaaaaaaaaa
aeaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaaacaaaaaa
egacbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaadcaaaaajhcaabaaa
abaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaa
egacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaia
ebaaaaaaacaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaahaaaaaabjaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadcaaaaakhccabaaaaaaaaaaaagaabaaaaaaaaaaa
egiccaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
SetTexture 3 [_ReflectionTex] 2D
"ps_3_0
; 53 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c9, -1.00000000, 0.00000000, 1.00000000, 10.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c9.x
mul_pp r0.xy, r0, c7.x
mad_pp r0.xyz, r0.xxyw, c9.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
mul r0.xy, r1.xzzw, c7.y
mul r3.xy, r0, c9.w
mov_pp r3.zw, c9.y
add r2, r3, v4
texldp r0.x, r2, s2
mad r0.x, r0, c0.z, c0.w
rcp r0.x, r0.x
add r0.w, -v3.z, r0.x
texldp r0.xyz, v4, s1
texldp r2.xyz, r2, s1
cmp_pp r2.xyz, r0.w, r2, r0
add r0, v3, r3
texldp r0.xyz, r0, s3
add_pp r3.xyz, -r2, c2
mad_pp r4.xyz, r3, c2.w, r2
add_pp r2.xyz, -r0, c3
mad_pp r0.xyz, r2, c3.w, r0
add_pp r5.xyz, r0, -r4
dp3 r0.w, v1, v1
rsq r0.w, r0.w
mul r2.xyz, r0.w, v1
add r3.xyz, r2, c6
mul_pp r0.xz, r1, c8.x
mov_pp r0.y, r1
dp3_pp r0.y, -r2, r0
dp3 r0.w, r3, r3
rsq r0.x, r0.w
max_pp r0.w, r0.y, c9.y
mul r0.xyz, r0.x, r3
dp3_pp r1.x, r1, -r0
add_pp_sat r1.w, -r0, c9.z
pow_pp r0, r1.w, c7.z
max_pp r0.z, r1.x, c9.y
pow r1, r0.z, c5.x
mov_pp r0.y, c7.w
mov_pp r0.w, r0.x
add_pp r0.x, c9.z, -r0.y
mad_pp_sat r0.x, r0, r0.w, c7.w
mad_pp r2.xyz, r0.x, r5, r4
texldp r0.x, v3, s2
mad r0.x, r0, c0.z, c0.w
mov r0.y, r1.x
rcp r0.x, r0.x
max r0.y, r0, c9
add r0.x, r0, -v3.w
mad oC0.xyz, r0.y, c1, r2
mul_sat oC0.w, r0.x, c4.x
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Vector 2 [_BaseColor]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
Vector 4 [_InvFadeParemeter]
Vector 3 [_ReflectionColor]
Float 5 [_Shininess]
Vector 1 [_SpecularColor]
Vector 6 [_WorldLightDir]
Vector 0 [_ZBufferParams]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
SetTexture 2 [_RefractionTex] 2D
SetTexture 3 [_CameraDepthTexture] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 52.00 (39 instructions), vertex: 0, texture: 28,
//   sequencer: 20, interpolator: 20;    8 GPRs, 24 threads,
// Performance (if enough threads): ~52 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaackmaaaaaclaaaaaaaaaaaaaaaceaaaaacfaaaaaachiaaaaaaaa
aaaaaaaaaaaaacciaaaaaabmaaaaacbmppppadaaaaaaaaanaaaaaabmaaaaaaaa
aaaaacbfaaaaabcaaaacaaacaaabaaaaaaaaabcmaaaaaaaaaaaaabdmaaadaaaa
aaabaaaaaaaaabeiaaaaaaaaaaaaabfiaaadaaadaaabaaaaaaaaabeiaaaaaaaa
aaaaabgmaaacaaahaaabaaaaaaaaabcmaaaaaaaaaaaaabhlaaacaaaiaaabaaaa
aaaaabimaaaaaaaaaaaaabjmaaacaaaeaaabaaaaaaaaabcmaaaaaaaaaaaaabko
aaacaaadaaabaaaaaaaaabcmaaaaaaaaaaaaablpaaadaaabaaabaaaaaaaaabei
aaaaaaaaaaaaabmoaaadaaacaaabaaaaaaaaabeiaaaaaaaaaaaaabnnaaacaaaf
aaabaaaaaaaaabimaaaaaaaaaaaaaboiaaacaaabaaabaaaaaaaaabcmaaaaaaaa
aaaaabphaaacaaagaaabaaaaaaaaabcmaaaaaaaaaaaaacagaaacaaaaaaabaaaa
aaaaabcmaaaaaaaafpecgbhdgfedgpgmgphcaaklaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpechfgnhaengbhaaaklklklaaaeaaamaaabaaabaaabaaaaaaaaaaaa
fpedgbgngfhcgbeegfhahegifegfhihehfhcgfaafpeegjhdhegphchefagbhcgb
gnhdaafpeghcgfhdgogfgmfdgdgbgmgfaaklklklaaaaaaadaaabaaabaaabaaaa
aaaaaaaafpejgohgeggbgegffagbhcgfgngfhegfhcaafpfcgfgggmgfgdhegjgp
goedgpgmgphcaafpfcgfgggmgfgdhegjgpgofegfhiaafpfcgfgghcgbgdhegjgp
gofegfhiaafpfdgigjgogjgogfhdhdaafpfdhagfgdhfgmgbhcedgpgmgphcaafp
fhgphcgmgeemgjghgiheeegjhcaafpfkechfgggggfhcfagbhcgbgnhdaahahdfp
ddfpdaaadccodacodcdadddfddcodaaaaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaa
aaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaacha
baaaahaaaaaaaaaeaaaaaaaaaaaaemkfaabpaabpaaaaaaabaaaapafaaaaahbfb
aaaapcfcaaaapdfdaaaapefeaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
dpiaaaaaebcaaaaalpiaaaaaaacfgaafgaalbcaabcaaaaaaaaaagabbgabhbcaa
bcaaaaaaafjagabncacdbcaabcaaaaafaaaaaaaagacfmeaabcaaaaaaaaaagacl
cadbbcaaccaaaaaabaaafaebbpbpphpjaaaaeaaadiaacaebbpbppofpaaaaeaaa
emiiabacaaloloblpaababademcdagahaabllablobabadaefiibacacaagmmgbl
oaafaciclabhagabaablleaaobacabpplaihagafaalemaabkaabagppmiaeaaag
aablblaaoaagafaamiamaaacaaeggmomklagahaamiabaaacaamhmhgmnbacacpp
miacaaacaalblbgmolaaaaacficbacacaalololbpaafaficmiabaaaaaalblbaa
obacaaaafiigaaaaaabglbgmobacacickiboacacaapmblebmbafaaaikiecacac
acgcmdecnaaaacaimianaaacaakmgogmgmppacaamiabaaacaemnbeaapaabacaa
miajaaaaaalagmaakcacppaalkeaabaaaaaaaaiamcaaaappeaedababaamfmgmg
kbaappabmiahaaacaamnmbaakbabahaabeagaaababgblmblmaacaeahaebgabaa
aagblmlbmaacadppdibmagagaapbblmgobaaabacmiahaaafaamalaaaobabagaa
gecicakbbpbppoiiaaaaeaaaeacdaaabaalblablobagaeiabacibacbbpbppoii
aaaaeaaagedigakbbpbppppiaaaaeaaabadigaobbpbpppmhaaaaeaaalibiaamb
bpbppehiaaaaeaaakiihacaeaebemaebiaaaadafmiahaaaeaamablbeklaeadaa
miadaaaaaalamgblilagaaaaeneiaaabaagmbllbkaafahaaembcaaaaacmgblgm
oaaaadaamiabaaaaaamggmaaofadaaaakkiaiaaaaaaaaaebmcaaaaaemiahaaaa
aagmmamaomaaacabmiahaaabaemamaaakaaaacaamiahaaaaaamablmaklabacaa
diihaaabaclelebloaaeaaacmiaiaaaaaablgmaakcaappaamiahaaaaaamablle
olababaamiahiaaaaablmaleklaaabaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
SetTexture 3 [_ReflectionTex] 2D
"sce_fp_rsx // 82 instructions using 4 registers
[Configuration]
24
ffffffff0007c020001fffe0000000000000840004000000
[Offsets]
9
_ZBufferParams 2 0
000003a000000290
_SpecularColor 1 0
00000510
_BaseColor 2 0
0000049000000450
_ReflectionColor 2 0
0000018000000160
_InvFadeParemeter 1 0
00000420
_Shininess 1 0
00000310
_WorldLightDir 1 0
000001d0
_DistortParams 5 0
000004e000000470000003800000008000000050
_FresnelScale 1 0
00000140
[Microcode]
1312
d4001700c8011c9dc8000001c8003fe1d40217005c011c9dc8000001c8003fe1
18800300ba001c9dba040001c8000001fe040100c8011c9dc8000001c8003fe1
0a8404405f001c9d000200000002000200000000000000000000000000000000
1e7e7d00c8001c9dc8000001c800000110000100aa021c9cc8000001c8000001
000000000000000000000000000000008e800340c8011c9dc9080001c8003fe1
10800200c8001c9d00020000c800000100004120000000000000000000000000
0e803940c9001c9dc8000029c800000104860140c9001c9dc8000001c8000001
1884014000021c9cc8000001c800000100000000000000000000000000000000
06840200d1001c9dff000001c80000011e040300c8081c9dc9080001c8000001
0e041806c8081c9dc8000001c80000010a860200c9001c9d00020000c8000001
000000000000000000000000000000000e060300c8081c9fc8020001c8000001
000000000000000000000000000000000e820400c80c1c9dfe020001c8080001
00000000000000000000000000000000b0040500c8011c9dc8010001c800bfe1
ae063b00c8011c9dfe080001c800bfe110800540c80c1c9fc90c0001c8000001
0e060300c80c1c9dc8020001c800000100000000000000000000000000000000
02800540c9001c9fc80c0001c800000110060900c9001c9d00020000c8000001
0000000000000000000000000000000008060500c80c1c9dc80c0001c8000001
04808300fe0c1c9f00020000c800000100003f80000000000000000000000000
f6061804c8011c9dc8000001c8003fe104000500a60c1c9dc8020001c8000001
00013f7f00013b7f0001377f00000000088c1d00ab001c9cc8000001c8000001
10060400aa001c9c54020001c802000100000000000000000000000000000000
02803b00c9001c9d540c0001c800000102060900c9001c9d00020000c8000001
000000000000000000000000000000001e020301c8011c9dc9080001c8003fe1
02001d00c80c1c9dc8000001c80000010e041802c8041c9dc8000001c8000001
02000200c8001c9d00020000c800000100000000000000000000000000000000
16021804c8041c9dc8000001c800000102020500a6041c9dc8020001c8000001
00013f7f00013b7f0001377f0000000002001c00c8001c9dc8000001c8000001
04001a00fe0c1c9dc8000001c80000010286020055181c9d54020001c8000001
0000000000000000000000000000000002020400c8041c9d54020001fe020001
0000000000000000000000000000000010821c40c90c1c9dc8000001c8000001
0e880140c8081c9dc8000001c800000102021a00c8041c9dc8000001c8000001
f8040100c8011c9dc8000001c8003fe104000300fe081c9fc8000001c8000001
117e4a0000041c9c54080001c800000110808200aa001c9c00020000c8000001
000000000000000000000000000000000e881803c8011ff5c8000001c8003fe1
0e8a0340c9101c9fc8020001c800000100000000000000000000000000000000
10820440c9041c9dc8020003c904000100000000000000000000000000000000
0e840440c9141c9dfe020001c910000100000000000000000000000000000000
1004090000001c9c00020000c800000100000000000000000000000000000000
0e860340c9041c9dc9080003c800000110848340c9041c9dc8020001c8000001
000000000000000000000000000000000e820440ff081c9dc90c0001c9080001
0e810400fe081c9dc8020001c904000100000000000000000000000000000000
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
ConstBuffer "$Globals" 304 // 164 used size, 19 vars
Vector 48 [_SpecularColor] 4
Vector 64 [_BaseColor] 4
Vector 80 [_ReflectionColor] 4
Vector 96 [_InvFadeParemeter] 4
Float 112 [_Shininess]
Vector 128 [_WorldLightDir] 4
Vector 144 [_DistortParams] 4
Float 160 [_FresnelScale]
ConstBuffer "UnityPerCamera" 128 // 128 used size, 8 vars
Vector 112 [_ZBufferParams] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 2
SetTexture 2 [_CameraDepthTexture] 2D 3
SetTexture 3 [_ReflectionTex] 2D 1
// 62 instructions, 6 temp regs, 0 temp arrays:
// ALU 51 float, 0 int, 0 uint
// TEX 7 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefieceddcnmijckmocpocjlfdgompehodohkfjkabaaaaaajmajaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefchmaiaaaa
eaaaaaaabpacaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaa
abaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaadhcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaad
pcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacagaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaafaaaaaapgbpbaaa
afaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaadaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahhcaabaaaabaaaaaapganbaaa
abaaaaaapganbaaaacaaaaaaaaaaaaakhcaabaaaabaaaaaaegacbaaaabaaaaaa
aceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaagiacaaaaaaaaaaaajaaaaaadcaaaaamhcaabaaaabaaaaaa
egacbaaaabaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaiadpaaaaaaaaegbcbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaidcaabaaaacaaaaaaigaabaaa
abaaaaaafgifcaaaaaaaaaaaajaaaaaadiaaaaakdcaabaaaacaaaaaaegaabaaa
acaaaaaaaceaaaaaaaaacaebaaaacaebaaaaaaaaaaaaaaaadgaaaaafecaabaaa
acaaaaaaabeaaaaaaaaaaaaaaaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaa
egbdbaaaafaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegbdbaaa
aeaaaaaaaoaaaaahdcaabaaaacaaaaaaegaabaaaacaaaaaakgakbaaaacaaaaaa
efaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaadaaaaaaaagabaaa
abaaaaaaaoaaaaahdcaabaaaadaaaaaaegaabaaaadaaaaaakgakbaaaadaaaaaa
efaaaaajpcaabaaaaeaaaaaaegaabaaaadaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaaefaaaaajpcaabaaaadaaaaaaegaabaaaadaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaadcaaaaalicaabaaaaaaaaaaackiacaaaabaaaaaaahaaaaaa
akaabaaaaeaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakicaabaaaaaaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaaaaaaaaadbaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaackbabaaaaeaaaaaadhaaaaajhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaadaaaaaaaaaaaaaj
hcaabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaaaaaaaaapgipcaaaaaaaaaaaaeaaaaaaegacbaaaadaaaaaa
egacbaaaaaaaaaaaaaaaaaajhcaabaaaadaaaaaaegacbaiaebaaaaaaacaaaaaa
egiccaaaaaaaaaaaafaaaaaadcaaaaakhcaabaaaacaaaaaapgipcaaaaaaaaaaa
afaaaaaaegacbaaaadaaaaaaegacbaaaacaaaaaaaaaaaaaihcaabaaaacaaaaaa
egacbaiaebaaaaaaaaaaaaaaegacbaaaacaaaaaadiaaaaaifcaabaaaadaaaaaa
agacbaaaabaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaadaaaaaa
bkaabaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aeaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaakhcaabaaaafaaaaaa
egbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaai
icaabaaaaaaaaaaaegacbaiaebaaaaaaaeaaaaaaegacbaaaadaaaaaadeaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaa
aaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaaj
icaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadp
dccaaaakicaabaaaaaaaaaaadkaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaa
aaaaaaaaajaaaaaadcaaaaajhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
acaaaaaaegacbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaafaaaaaa
egacbaaaafaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaafaaaaaabaaaaaaiicaabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaa
aaaaaaaaahaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaak
hccabaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaa
aaaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaadcaaaaalbcaabaaaaaaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaa
aaaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaaaaaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaadkbabaiaebaaaaaaaeaaaaaadicaaaaiiccabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaagaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
"ps_3_0
; 50 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c9, -1.00000000, 0.00000000, 1.00000000, 10.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c9.x
mul_pp r0.xy, r0, c7.x
mad_pp r0.xyz, r0.xxyw, c9.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
mul r0.xy, r1.xzzw, c7.y
mul r0.xy, r0, c9.w
mov_pp r0.zw, c9.y
add r2, v4, r0
texldp r0.x, r2, s2
mad r0.x, r0, c0.z, c0.w
rcp r0.x, r0.x
add r0.w, -v3.z, r0.x
texldp r2.xyz, r2, s1
texldp r0.xyz, v4, s1
cmp_pp r0.xyz, r0.w, r2, r0
add_pp r2.xyz, -r0, c2
mad_pp r4.xyz, r2, c2.w, r0
dp3 r0.w, v1, v1
rsq r0.x, r0.w
mul r2.xyz, r0.x, v1
add r3.xyz, r2, c6
mul_pp r0.xz, r1, c8.x
mov_pp r0.y, r1
dp3_pp r0.y, -r2, r0
dp3 r0.w, r3, r3
rsq r0.x, r0.w
max_pp r0.w, r0.y, c9.y
mul r0.xyz, r0.x, r3
dp3_pp r1.x, r1, -r0
add_pp_sat r1.w, -r0, c9.z
pow_pp r0, r1.w, c7.z
max_pp r0.z, r1.x, c9.y
pow r1, r0.z, c5.x
mov_pp r0.y, c7.w
mov_pp r0.w, r0.x
add_pp r0.x, c9.z, -r0.y
mov r0.y, r1.x
mad_pp_sat r0.x, r0, r0.w, c7.w
add_pp r5.xyz, -r4, c3
mad_pp r2.xyz, r0.x, r5, r4
texldp r0.x, v3, s2
mad r0.x, r0, c0.z, c0.w
rcp r0.x, r0.x
max r0.y, r0, c9
add r0.x, r0, -v3.w
mad oC0.xyz, r0.y, c1, r2
mul_sat oC0.w, r0.x, c4.x
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Vector 2 [_BaseColor]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
Vector 4 [_InvFadeParemeter]
Vector 3 [_ReflectionColor]
Float 5 [_Shininess]
Vector 1 [_SpecularColor]
Vector 6 [_WorldLightDir]
Vector 0 [_ZBufferParams]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 46.67 (35 instructions), vertex: 0, texture: 24,
//   sequencer: 16, interpolator: 20;    8 GPRs, 24 threads,
// Performance (if enough threads): ~46 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaacimaaaaacgiaaaaaaaaaaaaaaceaaaaacdaaaaaacfiaaaaaaaa
aaaaaaaaaaaaacaiaaaaaabmaaaaabpjppppadaaaaaaaaamaaaaaabmaaaaaaaa
aaaaabpcaaaaabamaaacaaacaaabaaaaaaaaabbiaaaaaaaaaaaaabciaaadaaaa
aaabaaaaaaaaabdeaaaaaaaaaaaaabeeaaadaaacaaabaaaaaaaaabdeaaaaaaaa
aaaaabfiaaacaaahaaabaaaaaaaaabbiaaaaaaaaaaaaabghaaacaaaiaaabaaaa
aaaaabhiaaaaaaaaaaaaabiiaaacaaaeaaabaaaaaaaaabbiaaaaaaaaaaaaabjk
aaacaaadaaabaaaaaaaaabbiaaaaaaaaaaaaabklaaadaaabaaabaaaaaaaaabde
aaaaaaaaaaaaablkaaacaaafaaabaaaaaaaaabhiaaaaaaaaaaaaabmfaaacaaab
aaabaaaaaaaaabbiaaaaaaaaaaaaabneaaacaaagaaabaaaaaaaaabbiaaaaaaaa
aaaaabodaaacaaaaaaabaaaaaaaaabbiaaaaaaaafpecgbhdgfedgpgmgphcaakl
aaabaaadaaabaaaeaaabaaaaaaaaaaaafpechfgnhaengbhaaaklklklaaaeaaam
aaabaaabaaabaaaaaaaaaaaafpedgbgngfhcgbeegfhahegifegfhihehfhcgfaa
fpeegjhdhegphchefagbhcgbgnhdaafpeghcgfhdgogfgmfdgdgbgmgfaaklklkl
aaaaaaadaaabaaabaaabaaaaaaaaaaaafpejgohgeggbgegffagbhcgfgngfhegf
hcaafpfcgfgggmgfgdhegjgpgoedgpgmgphcaafpfcgfgghcgbgdhegjgpgofegf
hiaafpfdgigjgogjgogfhdhdaafpfdhagfgdhfgmgbhcedgpgmgphcaafpfhgphc
gmgeemgjghgiheeegjhcaafpfkechfgggggfhcfagbhcgbgnhdaahahdfpddfpda
aadccodacodcdadddfddcodaaaklklklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaa
aaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaacci
baaaahaaaaaaaaaeaaaaaaaaaaaaemkfaabpaabpaaaaaaabaaaapafaaaaahbfb
aaaapcfcaaaapdfdaaaapefeaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
dpiaaaaaebcaaaaalpiaaaaaaacfgaaegaakbcaabcaaaaaaaaaagabagabgbcaa
bcaaaaaaabfefabmaaaabcaameaaaaaaaaaagacbgachbcaaccaaaaaabaaagaeb
bpbpphpjaaaaeaaadiaacaebbpbppofpaaaaeaaaembiacabaaloloblpaababad
emedafafaagmlablobacadaefiibabacaagmmgbloaagaciblabhahabaablleaa
obababpplaehahagaalemaabkaabagppmiacaaahaamgblaaoaahagaamiagaaac
aagbgmmmklahahaamiaiaaabaalclcgmnbacacppmiabaaacaalblbblolaaaaab
fibiacabaalologmpaagagicmiabaaaaaagmlbaaobacaaaafiigaaaaaambgmbl
obacacibkiboacacaapmblebmbagaaaikiecacacacgcmdecnaaaacaimianaaac
aakmgogmgmppacaamiabaaacaemnbeaapaabacaamiajaaaaaalagmaakcacppaa
lkedababaamglaiambafaeppeaedacacaamfmgmgkbaappabmiahaaacaamnmbaa
kbacahaadiidafacaagnlamgoaacaeaceaceaaacaebllbblcaahppiakiboacac
aapmagebmbacafafgebiaaebbpbppehiaaaaeaaababibacbbpbppoiiaaaaeaaa
gecieaebbpbppppiaaaaeaaabacieakbbpbpppmhaaaaeaaamiagaaacaalmmgbl
ilaeaaaaenciaaabaablblmgkaacahacemccacaaaclbbllboaaaadacmiacaaac
aamglbaaofadacaakkiaiaaaaaaaaaebmcaaaaaemiahaaaaaalbbemaomacaaab
miahaaabaemamaaakaaaacaamiahaaaaaamablmaklabacaadiihaaabaelelegm
kaaaadacmiaiaaaaaablgmaakcaappaamiahaaaaaamablleolababaamiahiaaa
aablmaleklaaabaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
"sce_fp_rsx // 75 instructions using 4 registers
[Configuration]
24
ffffffff0007c020001fffe0000000000000840004000000
[Offsets]
9
_ZBufferParams 2 0
0000033000000080
_SpecularColor 1 0
000004a0
_BaseColor 2 0
00000420000003d0
_ReflectionColor 1 0
00000440
_InvFadeParemeter 1 0
00000480
_Shininess 1 0
00000290
_WorldLightDir 1 0
000000f0
_DistortParams 5 0
000003f00000037000000300000000c0000000a0
_FresnelScale 1 0
00000180
[Microcode]
1200
d4021700c8011c9dc8000001c8003fe1d40017005c011c9dc8000001c8003fe1
18800300ba041c9dba000001c8000001f6021804c8011c9dc8000001c8003fe1
10000500a6041c9dc8020001c800000100013f7f00013b7f0001377f00000000
a8000500c8011c9dc8010001c800bfe110040400c8001c9d54020001c8020001
000000000000000000000000000000000a8004405f001c9d0002000000020002
0000000000000000000000000000000010000100aa021c9cc8000001c8000001
00000000000000000000000000000000ae023b00c8011c9d54000001c800bfe1
0e060300c8041c9dc8020001c800000100000000000000000000000000000000
8e800340c8011c9dc9000001c8003fe110800200c8001c9d00020000c8000001
0000412000000000000000000000000008040500c80c1c9dc80c0001c8000001
0e803940c9001c9dc8000029c800000104820140c9001c9dc8000001c8000001
02880540c9001c9fc80c0001c80000010a820200c9001c9d00020000c8000001
0000000000000000000000000000000006800200d1001c9dff000001c8000001
10823b0001101c9c54080001c80000011880014000021c9cc8000001c8000001
0000000000000000000000000000000002040900ff041c9d00020000c8000001
0000000000000000000000000000000008880540c8041c9fc9040001c8000001
08040900c9101c9d00020000c800000100000000000000000000000000000000
1e020301c8011c9dc9000001c8003fe104001d00c8081c9dc8000001c8000001
0280830054081c9f00020000c800000100003f80000000000000000000000000
0e041802c8041c9dc8000001c800000102801d00c9001c9dc8000001c8000001
04000200c8001c9d00020000c800000100000000000000000000000000000000
16021804c8041c9dc8000001c800000102020500a6041c9dc8020001c8000001
00013f7f00013b7f0001377f0000000004021c00aa001c9cc8000001c8000001
f8020100c8011c9dc8000001c8003fe102800200c9001c9d54020001c8000001
0000000000000000000000000000000010801c40c9001c9dc8000001c8000001
02020400c8041c9d54020001fe02000100000000000000000000000000000000
02021a00c8041c9dc8000001c80000010e800140c8081c9dc8000001c8000001
02820440ff001c9dfe020003ff00000100000000000000000000000000000000
10000900aa041c9c00020000c800000100000000000000000000000000000000
117e4a0000041c9c54040001c80000010e801803c8011ff5c8000001c8003fe1
0e880340c9001c9fc8020001c800000100000000000000000000000000000000
1080834001041c9cc8020001c800000100000000000000000000000000000000
08001a00fe081c9dc8000001c80000010e800440c9101c9dfe020001c9000001
000000000000000000000000000000000e840340c9001c9fc8020001c8000001
0000000000000000000000000000000010020300c8041c9f54000001c8000001
0e800440ff001c9dc9080001c900000110808200c8041c9d00020000c8000001
000000000000000000000000000000000e810400fe001c9dc8020001c9000001
00000000000000000000000000000000
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
ConstBuffer "$Globals" 304 // 164 used size, 19 vars
Vector 48 [_SpecularColor] 4
Vector 64 [_BaseColor] 4
Vector 80 [_ReflectionColor] 4
Vector 96 [_InvFadeParemeter] 4
Float 112 [_Shininess]
Vector 128 [_WorldLightDir] 4
Vector 144 [_DistortParams] 4
Float 160 [_FresnelScale]
ConstBuffer "UnityPerCamera" 128 // 128 used size, 8 vars
Vector 112 [_ZBufferParams] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 1
SetTexture 2 [_CameraDepthTexture] 2D 2
// 57 instructions, 4 temp regs, 0 temp arrays:
// ALU 47 float, 0 int, 0 uint
// TEX 6 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedencfdgmknbcifcffhonebpbfjnofajimabaaaaaanmaiaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefclmahaaaa
eaaaaaaaopabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaa
abaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaa
gcbaaaadpcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaadaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaa
adaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahhcaabaaaaaaaaaaa
pganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaadcaaaaamhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaiadpaaaaaaaa
egbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaifcaabaaaabaaaaaa
agacbaaaaaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaabaaaaaa
bkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaakhcaabaaaadaaaaaa
egbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaai
icaabaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaa
aaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaaj
bcaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadp
dccaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaa
aaaaaaaaajaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaafgifcaaa
aaaaaaaaajaaaaaadiaaaaakdcaabaaaabaaaaaaegaabaaaabaaaaaaaceaaaaa
aaaacaebaaaacaebaaaaaaaaaaaaaaaadgaaaaafecaabaaaabaaaaaaabeaaaaa
aaaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegbdbaaaafaaaaaa
aoaaaaahdcaabaaaabaaaaaaegaabaaaabaaaaaakgakbaaaabaaaaaaefaaaaaj
pcaabaaaacaaaaaaegaabaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaadcaaaaalicaabaaaabaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaa
acaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakicaabaaaabaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadbaaaaahicaabaaa
abaaaaaadkaabaaaabaaaaaackbabaaaaeaaaaaaaoaaaaahdcaabaaaacaaaaaa
egbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaa
acaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadhaaaaajhcaabaaaabaaaaaa
pgapbaaaabaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaa
acaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaak
hcaabaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaaegacbaaaacaaaaaaegacbaaa
abaaaaaaaaaaaaajhcaabaaaacaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaa
aaaaaaaaafaaaaaadcaaaaajhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaa
acaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaa
egacbaaaadaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaa
aaaaaaaaahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaak
hccabaaaaaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaa
abaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaacaaaaaaaagabaaa
acaaaaaadcaaaaalbcaabaaaaaaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaa
aaaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaaaaaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaadkbabaiaebaaaaaaaeaaaaaadicaaaaiiccabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaagaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_ReflectionTex] 2D
"ps_3_0
; 44 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c7, -1.00000000, 0.00000000, 1.00000000, 10.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c7.x
mul_pp r0.xy, r0, c5.x
mad_pp r0.xyz, r0.xxyw, c7.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
mul r0.xy, r1.xzzw, c5.y
dp3 r1.w, v1, v1
mov_pp r0.zw, c7.y
mul r0.xy, r0, c7.w
add r2, v3, r0
texldp r2.xyz, r2, s2
add r0, r0, v4
add_pp r3.xyz, -r2, c2
texldp r0.xyz, r0, s1
add_pp r5.xyz, -r0, c1
mad_pp r4.xyz, r3, c2.w, r2
mad_pp r0.xyz, r5, c1.w, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, v1
add r3.xyz, r2, c4
dp3 r0.w, r3, r3
rsq r0.w, r0.w
mul r3.xyz, r0.w, r3
dp3_pp r0.w, r1, -r3
mul_pp r1.xz, r1, c6.x
dp3_pp r1.x, -r2, r1
max_pp r0.w, r0, c7.y
pow r2, r0.w, c3.x
max_pp r1.x, r1, c7.y
add_pp_sat r0.w, -r1.x, c7.z
pow_pp r1, r0.w, c5.z
mov r1.y, r2.x
mov_pp r0.w, c5
add_pp r4.xyz, r4, -r0
add_pp r0.w, c7.z, -r0
mad_pp_sat r0.w, r0, r1.x, c5
mad_pp r2.xyz, r0.w, r4, r0
max r0.x, r1.y, c7.y
mad oC0.xyz, r0.x, c0, r2
mov_pp oC0.w, c7.z
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Vector 1 [_BaseColor]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 0 [_SpecularColor]
Vector 4 [_WorldLightDir]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
SetTexture 2 [_RefractionTex] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 42.67 (32 instructions), vertex: 0, texture: 16,
//   sequencer: 16, interpolator: 20;    7 GPRs, 27 threads,
// Performance (if enough threads): ~42 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaacdmaaaaaccmaaaaaaaaaaaaaaceaaaaaboaaaaaacaiaaaaaaaa
aaaaaaaaaaaaabliaaaaaabmaaaaabklppppadaaaaaaaaakaaaaaabmaaaaaaaa
aaaaabkeaaaaaaoeaaacaaabaaabaaaaaaaaaapaaaaaaaaaaaaaabaaaaadaaaa
aaabaaaaaaaaabamaaaaaaaaaaaaabbmaaacaaafaaabaaaaaaaaaapaaaaaaaaa
aaaaabclaaacaaagaaabaaaaaaaaabdmaaaaaaaaaaaaabemaaacaaacaaabaaaa
aaaaaapaaaaaaaaaaaaaabfnaaadaaabaaabaaaaaaaaabamaaaaaaaaaaaaabgm
aaadaaacaaabaaaaaaaaabamaaaaaaaaaaaaabhlaaacaaadaaabaaaaaaaaabdm
aaaaaaaaaaaaabigaaacaaaaaaabaaaaaaaaaapaaaaaaaaaaaaaabjfaaacaaae
aaabaaaaaaaaaapaaaaaaaaafpecgbhdgfedgpgmgphcaaklaaabaaadaaabaaae
aaabaaaaaaaaaaaafpechfgnhaengbhaaaklklklaaaeaaamaaabaaabaaabaaaa
aaaaaaaafpeegjhdhegphchefagbhcgbgnhdaafpeghcgfhdgogfgmfdgdgbgmgf
aaklklklaaaaaaadaaabaaabaaabaaaaaaaaaaaafpfcgfgggmgfgdhegjgpgoed
gpgmgphcaafpfcgfgggmgfgdhegjgpgofegfhiaafpfcgfgghcgbgdhegjgpgofe
gfhiaafpfdgigjgogjgogfhdhdaafpfdhagfgdhfgmgbhcedgpgmgphcaafpfhgp
hcgmgeemgjghgiheeegjhcaahahdfpddfpdaaadccodacodcdadddfddcodaaakl
aaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaeaaaaaabombaaaagaaaaaaaaaeaaaaaaaaaaaaemkf
aabpaabpaaaaaaabaaaapafaaaaahbfbaaaapcfcaaaapdfdaaaapefeaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaebcaaaaadpiaaaaalpiaaaaaaacfgaae
gaakbcaabcaaaaaaaaaagabagabgbcaabcaaaeaaaaabbabmaaaabcaameaaaaaa
aaaagabnfacdbcaaccaaaaaabaaafaebbpbpphpjaaaaeaaadiaacaebbpbppofp
aaaaeaaamiaiaaabaaloloaapaababaafiibabacaagmmgbloaafaciblachagaf
aablmaaaobababpplaehagabaamamaabkaafaeppmiabaaagaamgblaaoaagafaa
miadaaacaalagmmeklagafaamiaiaaabaagngngmnbacacppmiaiaaabaalblbbl
olaaaaabfiieabacaaloloblpaababibfiibaaaaaabllbmgobabaaicbeigabaa
aalmblgmobacabaakibhabacaamablebmbabaaagkiecababacgcloecnaaaacag
miabaaabaeloboaapaafabaamiajaaaaaalagmaakcabppaalkeaabaaaaaaaama
mcaaaappeaedababaamflbmgkbaappabmialaaabaamambaakbabafaaemcdaaac
aalalabloaabaeaeememaaacaakmkmbloaabadadmiapaaadaaaambaaobacaaaa
libicagbbpbppoiiaaaaeaaabacidagbbpbppoiiaaaaeaaamiahaaaeaemamaaa
kaadabaamiahaaafaemamaaakaacacaamiahaaacaamablmaklafacacmiahaaab
aamablmaklaeabadeaceaaaaaeblmgblcaafppiakibaaaaaaaaaaaebmcaaaaad
dibhaaacaclelegmoaacabaadibiaaaaaagmgmblkcaappabmjabaaaaaamggmbl
mlaaaaafmiahaaaaaamagmleolacaaabmiipmaaaaablmaleklaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_ReflectionTex] 2D
"sce_fp_rsx // 63 instructions using 3 registers
[Configuration]
24
ffffffff0007c020001fffe0000000000000840003000000
[Offsets]
7
_SpecularColor 1 0
000003e0
_BaseColor 2 0
00000310000002f0
_ReflectionColor 2 0
0000027000000250
_Shininess 1 0
000002b0
_WorldLightDir 1 0
000000c0
_DistortParams 5 0
0000035000000330000002900000007000000050
_FresnelScale 1 0
00000130
[Microcode]
1008
d4001700c8011c9dc8000001c8003fe1d40217005c011c9dc8000001c8003fe1
18800300ba001c9dba040001c8000001a8000500c8011c9dc8010001c800bfe1
10000100aa021c9cc8000001c800000100000000000000000000000000000000
0a8004405f001c9d000200000002000200000000000000000000000000000000
10800200c8001c9daa020000c800000100000000000041200000000000000000
ae023b00c8011c9d54000001c800bfe10e040300c8041c9dc8020001c8000001
000000000000000000000000000000008e800340c8011c9dc9000001c8003fe1
10020500c8081c9dc8080001c80000010e803940c9001c9dc8000029c8000001
04820140c9001c9dc8000001c800000104800540c9001c9fc8080001c8000001
0a820200c9001c9d00020000c800000100000000000000000000000000000000
02820540c8041c9fc9040001c800000110883b00ab001c9cfe040001c8000001
06800200d1001c9dff000001c80000011880014000021c9cc8000001c8000001
000000000000000000000000000000001e020301c8011c9dc9000001c8003fe1
02040900c9041c9d00020000c800000100000000000000000000000000000000
10040900c9101c9d00020000c800000100000000000000000000000000000000
fe000300c8011c9dc9000001c8003fe102888300c8081c9f00020000c8000001
00003f8000000000000000000000000010041d00fe081c9dc8000001c8000001
0e001804c8001c9dc8000001c800000108821d00c9101c9dc8000001c8000001
0e040300c8001c9fc8020001c800000100000000000000000000000000000000
0e800400c8081c9dfe020001c800000100000000000000000000000000000000
1082020055041c9d54020001c800000100000000000000000000000000000000
10040200c8081c9d00020000c800000100000000000000000000000000000000
0e041802c8041c9dc8000001c800000110801c40ff041c9dc8000001c8000001
0e820340c8081c9fc8020001c800000100000000000000000000000000000000
0e820440c9041c9dfe020001c808000100000000000000000000000000000000
02880440ff001c9dfe020003ff00000100000000000000000000000000000000
1080834001101c9cc8020001c800000100000000000000000000000000000000
0e800340c9001c9dc9040003c80000010e800440ff001c9dc9000001c9040001
08001c00fe081c9dc8000001c80000010202090054001c9d00020000c8000001
0000000000000000000000000000000010800140aa021c9cc8000001c8000001
0000000000003f8000000000000000000e81040000041c9cc8020001c9000001
00000000000000000000000000000000
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
ConstBuffer "$Globals" 304 // 164 used size, 19 vars
Vector 48 [_SpecularColor] 4
Vector 64 [_BaseColor] 4
Vector 80 [_ReflectionColor] 4
Float 112 [_Shininess]
Vector 128 [_WorldLightDir] 4
Vector 144 [_DistortParams] 4
Float 160 [_FresnelScale]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 2
SetTexture 2 [_ReflectionTex] 2D 1
// 50 instructions, 5 temp regs, 0 temp arrays:
// ALU 42 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedkaacckpopllppchjpbnhhohbjfkacjggabaaaaaaliahaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcjiagaaaa
eaaaaaaakgabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaadlcbabaaaaeaaaaaagcbaaaad
lcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaaaaaaaahhcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaa
aaaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialp
aaaaialpaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaa
aaaaaaaaajaaaaaadcaaaaamhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaaaaaaaaaiadpaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaifcaabaaaabaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaa
akaaaaaadgaaaaafccaabaaaabaaaaaabkaabaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegbcbaaa
acaaaaaadcaaaaakhcaabaaaadaaaaaaegbcbaaaacaaaaaapgapbaaaaaaaaaaa
egiccaaaaaaaaaaaaiaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaa
acaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpdeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaacpaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaiicaabaaa
aaaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaaajaaaaaabjaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaadkiacaiaebaaaaaa
aaaaaaaaajaaaaaaabeaaaaaaaaaiadpdccaaaakicaabaaaaaaaaaaaakaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaajaaaaaadiaaaaaidcaabaaa
abaaaaaaigaabaaaaaaaaaaafgifcaaaaaaaaaaaajaaaaaadiaaaaakdcaabaaa
abaaaaaaegaabaaaabaaaaaaaceaaaaaaaaacaebaaaacaebaaaaaaaaaaaaaaaa
dgaaaaafecaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaahhcaabaaaacaaaaaa
egacbaaaabaaaaaaegbdbaaaaeaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaaegbdbaaaafaaaaaaaoaaaaahdcaabaaaabaaaaaaegaabaaaabaaaaaa
kgakbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaacaaaaaaaoaaaaahdcaabaaaacaaaaaaegaabaaaacaaaaaa
kgakbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaabaaaaaaaaaaaaajhcaabaaaaeaaaaaaegacbaiaebaaaaaa
acaaaaaaegiccaaaaaaaaaaaafaaaaaadcaaaaakhcaabaaaacaaaaaapgipcaaa
aaaaaaaaafaaaaaaegacbaaaaeaaaaaaegacbaaaacaaaaaaaaaaaaajhcaabaaa
aeaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaak
hcaabaaaabaaaaaapgipcaaaaaaaaaaaaeaaaaaaegacbaaaaeaaaaaaegacbaaa
abaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaiaebaaaaaaabaaaaaaegacbaaa
acaaaaaadcaaaaajhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaa
egacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaa
ahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakhccabaaa
aaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
"ps_3_0
; 41 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c7, -1.00000000, 0.00000000, 1.00000000, 10.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord4 v3
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c7.x
mul_pp r0.xy, r0, c5.x
mad_pp r0.xyz, r0.xxyw, c7.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
mul r0.xy, r1.xzzw, c5.y
dp3 r0.z, v1, v1
rsq r1.w, r0.z
mul r2.xyz, r1.w, v1
add r3.xyz, r2, c4
mul r0.xy, r0, c7.w
mov_pp r0.zw, c7.y
add r0, v3, r0
texldp r0.xyz, r0, s1
add_pp r4.xyz, -r0, c1
mad_pp r0.xyz, r4, c1.w, r0
dp3 r0.w, r3, r3
rsq r0.w, r0.w
mul r3.xyz, r0.w, r3
dp3_pp r0.w, r1, -r3
mul_pp r1.xz, r1, c6.x
dp3_pp r1.x, -r2, r1
max_pp r0.w, r0, c7.y
pow r2, r0.w, c3.x
max_pp r1.x, r1, c7.y
add_pp_sat r0.w, -r1.x, c7.z
pow_pp r1, r0.w, c5.z
mov r1.y, r2.x
mov_pp r0.w, c5
add_pp r4.xyz, -r0, c2
add_pp r0.w, c7.z, -r0
mad_pp_sat r0.w, r0, r1.x, c5
mad_pp r2.xyz, r0.w, r4, r0
max r0.x, r1.y, c7.y
mad oC0.xyz, r0.x, c0, r2
mov_pp oC0.w, c7.z
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Vector 1 [_BaseColor]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 0 [_SpecularColor]
Vector 4 [_WorldLightDir]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 34.67 (26 instructions), vertex: 0, texture: 12,
//   sequencer: 12, interpolator: 20;    6 GPRs, 30 threads,
// Performance (if enough threads): ~34 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaacbiaaaaabmmaaaaaaaaaaaaaaceaaaaablmaaaaaboeaaaaaaaa
aaaaaaaaaaaaabjeaaaaaabmaaaaabiippppadaaaaaaaaajaaaaaabmaaaaaaaa
aaaaabibaaaaaanaaaacaaabaaabaaaaaaaaaanmaaaaaaaaaaaaaaomaaadaaaa
aaabaaaaaaaaaapiaaaaaaaaaaaaabaiaaacaaafaaabaaaaaaaaaanmaaaaaaaa
aaaaabbhaaacaaagaaabaaaaaaaaabciaaaaaaaaaaaaabdiaaacaaacaaabaaaa
aaaaaanmaaaaaaaaaaaaabejaaadaaabaaabaaaaaaaaaapiaaaaaaaaaaaaabfi
aaacaaadaaabaaaaaaaaabciaaaaaaaaaaaaabgdaaacaaaaaaabaaaaaaaaaanm
aaaaaaaaaaaaabhcaaacaaaeaaabaaaaaaaaaanmaaaaaaaafpecgbhdgfedgpgm
gphcaaklaaabaaadaaabaaaeaaabaaaaaaaaaaaafpechfgnhaengbhaaaklklkl
aaaeaaamaaabaaabaaabaaaaaaaaaaaafpeegjhdhegphchefagbhcgbgnhdaafp
eghcgfhdgogfgmfdgdgbgmgfaaklklklaaaaaaadaaabaaabaaabaaaaaaaaaaaa
fpfcgfgggmgfgdhegjgpgoedgpgmgphcaafpfcgfgghcgbgdhegjgpgofegfhiaa
fpfdgigjgogjgogfhdhdaafpfdhagfgdhfgmgbhcedgpgmgphcaafpfhgphcgmge
emgjghgiheeegjhcaahahdfpddfpdaaadccodacodcdadddfddcodaaaaaaaaaaa
aaaaaaabaaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaeaaaaaabimbaaaafaaaaaaaaaeaaaaaaaaaaaaemkfaabpaabp
aaaaaaabaaaapafaaaaahbfbaaaapcfcaaaapdfdaaaapefeaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaebcaaaaadpiaaaaalpiaaaaaaacfgaadgaajbcaa
bcaaaaaaaaaagaapfabfbcaabcaaabaaaaaaaaaagabkmeaaccaaaaaabaaadaeb
bpbpphpjaaaaeaaadiaacaebbpbppofpaaaaeaaamiaiaaabaaloloaapaababaa
fiibabacaagmmgbloaadaciblachafadaablmaaaobababpplaehafabaamamaab
kaadaeppmiabaaafaamgblaaoaafadaamiadaaacaalagmmeklafafaamiaiaaab
aagngngmnbacacppmiaiaaabaalblbblolaaaaabfiieabacaaloloblpaababib
fiibaaaaaabllbmgobabaaicbeigabaaaalmblgmobacabaakibhabacaamableb
mbabaaagkiecababacgcloecnaaaacagmiabaaabaeloboaapaadabaabeadaaab
ablagmblicabppafafeiacaaaegmmgmgiaabppppeaedaaaaaamflbblkbaappaa
emboaaaaaapmpbblkbaaafaedicdaaacaamflabloaaaaeaaeacnaaaaaakognlb
obacaaiblibibaabbpbppoiiaaaaeaaakichaaacaemamaebiaababadmiaoaaab
aapmblpmklacababdichaaacaemjlelbkaabacaalcbbaaabaalbgmaaicaappaf
miahaaaaaamagmmjolacaaabmiipmaaaaagmmaleklabaaaaaaaaaaaaaaaaaaaa
aaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
"sce_fp_rsx // 58 instructions using 3 registers
[Configuration]
24
ffffffff0005c0200017ffe8000000000000840003000000
[Offsets]
7
_SpecularColor 1 0
00000390
_BaseColor 2 0
00000260000001f0
_ReflectionColor 1 0
000002d0
_Shininess 1 0
000002f0
_WorldLightDir 1 0
00000160
_DistortParams 5 0
0000031000000280000002200000009000000040
_FresnelScale 1 0
00000110
[Microcode]
928
d4001700c8011c9dc8000001c8003fe1d40217005c011c9dc8000001c8003fe1
18800300ba001c9dba040001c800000110000100aa021c9cc8000001c8000001
00000000000000000000000000000000a2000500c8011c9dc8010001c800bfe1
10820200c8001c9daa020000c800000100000000000041200000000000000000
0a8204405f001c9d000200000002000200000000000000000000000000000000
8e820340c8011c9dc9040001c8003fe11884014000021c9cc8000001c8000001
000000000000000000000000000000000e883940c9041c9dc8000029c8000001
04860140c9101c9dc8000001c800000106840200d1101c9dff040001c8000001
0a860200c9101c9d00020000c800000100000000000000000000000000000000
ae003b00c8011c9dc8000001c800bfe108820540c8001c9fc90c0001c8000001
1e020301c8011c9dc9080001c8003fe10e000300c8001c9dc8020001c8000001
000000000000000000000000000000001000090055041c9dc8020001c8000001
0000000000000000000000000000000002880540c9101c9fc8000001c8000001
02000500c8001c9dc8000001c800000110808300c8001c9f00020000c8000001
00003f800000000000000000000000000e021802c8041c9dc8000001c8000001
0e820340c8041c9fc8020001c800000100000000000000000000000000000000
08801d00ff001c9dc8000001c80000011080020055001c9d54020001c8000001
0000000000000000000000000000000002803b00c9101c9dc8000001c8000001
04801c40ff001c9dc8000001c80000010e820440c9041c9dfe020001c8040001
0000000000000000000000000000000002860440ab001c9cfe020003ab000000
000000000000000000000000000000001002090001001c9c00020000c8000001
0000000000000000000000000000000002021d00fe041c9dc8000001c8000001
0e800340c9041c9fc8020001c800000100000000000000000000000000000000
02020200c8041c9d00020000c800000100000000000000000000000000000000
10848340010c1c9cc8020001c800000100000000000000000000000000000000
0e860440ff081c9dc9000001c904000102001c00c8041c9dc8000001c8000001
02000900c8001c9d00020000c800000100000000000000000000000000000000
10800140aa021c9cc8000001c80000010000000000003f800000000000000000
0e81040000001c9cc8020001c90c000100000000000000000000000000000000
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
ConstBuffer "$Globals" 304 // 164 used size, 19 vars
Vector 48 [_SpecularColor] 4
Vector 64 [_BaseColor] 4
Vector 80 [_ReflectionColor] 4
Float 112 [_Shininess]
Vector 128 [_WorldLightDir] 4
Vector 144 [_DistortParams] 4
Float 160 [_FresnelScale]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_RefractionTex] 2D 1
// 45 instructions, 4 temp regs, 0 temp arrays:
// ALU 38 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedalccaahodpbofjbkbhnmlgbgimhabdoaabaaaaaaomagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcmmafaaaa
eaaaaaaahdabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaadlcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaogbkbaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaah
hcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaa
dcaaaaamhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaa
aaaaiadpaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaai
fcaabaaaabaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaaf
ccaabaaaabaaaaaabkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaak
hcaabaaaadaaaaaaegbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaa
aiaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaa
abaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
aaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadp
deaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaa
aaaaaaaackiacaaaaaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaaaaaaaaajbcaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaa
abeaaaaaaaaaiadpdccaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaa
aaaaaaaadkiacaaaaaaaaaaaajaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaa
aaaaaaaafgifcaaaaaaaaaaaajaaaaaadiaaaaakdcaabaaaabaaaaaaegaabaaa
abaaaaaaaceaaaaaaaaacaebaaaacaebaaaaaaaaaaaaaaaadgaaaaafecaabaaa
abaaaaaaabeaaaaaaaaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaa
egbdbaaaafaaaaaaaoaaaaahdcaabaaaabaaaaaaegaabaaaabaaaaaakgakbaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaaaaaaaajhcaabaaaacaaaaaaegacbaiaebaaaaaaabaaaaaa
egiccaaaaaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaapgipcaaaaaaaaaaa
aeaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaaacaaaaaa
egacbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaadcaaaaajhcaabaaa
abaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaa
egacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaia
ebaaaaaaacaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaahaaaaaabjaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadcaaaaakhccabaaaaaaaaaaaagaabaaaaaaaaaaa
egiccaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES3"
}

}

#LINE 370

	}
}

Subshader 
{ 	
	Tags {"RenderType"="Transparent" "Queue"="Transparent"}
	
	Lod 300
	ColorMask RGB
	
	Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Cull Off
			
			Program "vp" {
// Vertex combos: 8
//   d3d9 - ALU: 17 to 187
//   d3d11 - ALU: 14 to 47, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GSpeed;
uniform vec4 _GSteepness;
uniform vec4 _GFrequency;
uniform vec4 _GAmplitude;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform float _GerstnerIntensity;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = gl_Vertex.w;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec3 offsets_5;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, tmpvar_4.xz);
  tmpvar_8.y = dot (_GDirectionAB.zw, tmpvar_4.xz);
  tmpvar_8.z = dot (_GDirectionCD.xy, tmpvar_4.xz);
  tmpvar_8.w = dot (_GDirectionCD.zw, tmpvar_4.xz);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_5.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_5.z = dot (tmpvar_11, tmpvar_13);
  offsets_5.y = dot (sin((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_14;
  xzVtx_14 = (tmpvar_4.xz + offsets_5.xz);
  vec3 nrml_15;
  nrml_15.y = 2.0;
  vec4 tmpvar_16;
  tmpvar_16 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_17;
  tmpvar_17 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_18;
  tmpvar_18.x = dot (_GDirectionAB.xy, xzVtx_14);
  tmpvar_18.y = dot (_GDirectionAB.zw, xzVtx_14);
  tmpvar_18.z = dot (_GDirectionCD.xy, xzVtx_14);
  tmpvar_18.w = dot (_GDirectionCD.zw, xzVtx_14);
  vec4 tmpvar_19;
  tmpvar_19 = cos(((_GFrequency * tmpvar_18) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_16.xz;
  tmpvar_20.zw = tmpvar_17.xz;
  nrml_15.x = -(dot (tmpvar_19, tmpvar_20));
  vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_16.yw;
  tmpvar_21.zw = tmpvar_17.yw;
  nrml_15.z = -(dot (tmpvar_19, tmpvar_21));
  nrml_15.xz = (nrml_15.xz * _GerstnerIntensity);
  vec3 tmpvar_22;
  tmpvar_22 = normalize(nrml_15);
  nrml_15 = tmpvar_22;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_5);
  vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 o_24;
  vec4 tmpvar_25;
  tmpvar_25 = (tmpvar_23 * 0.5);
  vec2 tmpvar_26;
  tmpvar_26.x = tmpvar_25.x;
  tmpvar_26.y = (tmpvar_25.y * _ProjectionParams.x);
  o_24.xy = (tmpvar_26 + tmpvar_25.w);
  o_24.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_22;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_24;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _InvFadeParemeter;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
uniform vec4 _ZBufferParams;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.0, 0.0);
  tmpvar_7.xy = ((tmpvar_5.xz * _DistortParams.y) * 10.0);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  float tmpvar_8;
  tmpvar_8 = clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0);
  baseColor_1.xyz = (mix (_BaseColor, mix (texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_7)), _ReflectionColor, _ReflectionColor.wwww), vec4(clamp (tmpvar_8, 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = (clamp ((_InvFadeParemeter * ((1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w))) - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + tmpvar_8), 0.0, 1.0));
  gl_FragData[0] = baseColor_1;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 12 [unity_Scale]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 187 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c12.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r3.zw, r3.xyyw
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o1.xyz, r0.w, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
mov r1.w, v0
add r1.xyz, v0, r4
dp4 r2.w, r1, c3
dp4 r2.z, r1, c2
dp4 r2.x, r1, c0
dp4 r2.y, r1, c1
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c10.x
mad o4.xy, r3.z, c11.zwzw, r0
mov r0.x, c8
mad r0, c15, r0.x, r7.xzxz
mov o0, r2
mov o4.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c9
mov o1.w, c23.y
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Vector 15 [_BumpDirection]
Vector 14 [_BumpTiling]
Vector 16 [_GAmplitude]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
Vector 17 [_GFrequency]
Vector 19 [_GSpeed]
Vector 18 [_GSteepness]
Float 13 [_GerstnerIntensity]
Matrix 8 [_Object2World] 4
Vector 2 [_ProjectionParams]
Vector 3 [_ScreenParams]
Vector 0 [_Time]
Vector 1 [_WorldSpaceCameraPos]
Matrix 4 [glstate_matrix_mvp] 4
Vector 12 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 69.33 (52 instructions), vertex: 32, texture: 0,
//   sequencer: 24,  10 GPRs, 18 threads,
// Performance (if enough threads): ~69 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaaddeaaaaadbaaaaaaaaaaaaaaaceaaaaaclmaaaaacoeaaaaaaaa
aaaaaaaaaaaaacjeaaaaaabmaaaaacigpppoadaaaaaaaabaaaaaaabmaaaaaaaa
aaaaachpaaaaabfmaaacaaapaaabaaaaaaaaabgmaaaaaaaaaaaaabhmaaacaaao
aaabaaaaaaaaabgmaaaaaaaaaaaaabiiaaacaabaaaabaaaaaaaaabgmaaaaaaaa
aaaaabjeaaacaabeaaabaaaaaaaaabgmaaaaaaaaaaaaabkcaaacaabfaaabaaaa
aaaaabgmaaaaaaaaaaaaablaaaacaabbaaabaaaaaaaaabgmaaaaaaaaaaaaablm
aaacaabdaaabaaaaaaaaabgmaaaaaaaaaaaaabmeaaacaabcaaabaaaaaaaaabgm
aaaaaaaaaaaaabnaaaacaaanaaabaaaaaaaaaboeaaaaaaaaaaaaabpeaaacaaai
aaaeaaaaaaaaacaeaaaaaaaaaaaaacbeaaacaaacaaabaaaaaaaaabgmaaaaaaaa
aaaaaccgaaacaaadaaabaaaaaaaaabgmaaaaaaaaaaaaacdeaaacaaaaaaabaaaa
aaaaabgmaaaaaaaaaaaaacdkaaacaaabaaabaaaaaaaaacfaaaaaaaaaaaaaacga
aaacaaaeaaaeaaaaaaaaacaeaaaaaaaaaaaaachdaaacaaamaaabaaaaaaaaabgm
aaaaaaaafpechfgnhaeegjhcgfgdhegjgpgoaaklaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpechfgnhafegjgmgjgoghaafpehebgnhagmgjhehfgegfaafpeheegj
hcgfgdhegjgpgoebecaafpeheegjhcgfgdhegjgpgoedeeaafpeheghcgfhbhfgf
gogdhjaafpehfdhagfgfgeaafpehfdhegfgfhagogfhdhdaafpehgfhchdhegogf
hcejgohegfgohdgjhehjaaklaaaaaaadaaabaaabaaabaaaaaaaaaaaafpepgcgk
gfgdhedcfhgphcgmgeaaklklaaadaaadaaaeaaaeaaabaaaaaaaaaaaafpfahcgp
gkgfgdhegjgpgofagbhcgbgnhdaafpfdgdhcgfgfgofagbhcgbgnhdaafpfegjgn
gfaafpfhgphcgmgefdhagbgdgfedgbgngfhcgbfagphdaaklaaabaaadaaabaaad
aaabaaaaaaaaaaaaghgmhdhegbhegffpgngbhehcgjhifpgnhghaaahfgogjhehj
fpfdgdgbgmgfaahghdfpddfpdaaadccodacodcdadddfddcodaaaklklaaaaaaaa
aaaaaaabaaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaeaaaaaacnaaadbaaajaaaaaaaaaaaaaaaaaaaadmieaaaaaaab
aaaaaaabaaaaaaafaaaaacjaaaaaaaagaaaapafaaaabhbfbaaacpcfcaaadpdfd
aaaabadkaaaabaclaaaabacmaaaaaackaaaabacpaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaamaejapnldpaaaaaaeaiaaaaa
doccpjideamjapnlaaaaaaaaaaaaaaaaaaaaaaaabaabbaagaaaabcaamcaaaaaa
aaaagaahgaanbcaabcaaaaaaaaaagabdgabjbcaabcaaaaaaaaaaeabpaaaabcaa
meaaaaaaaaaagacdgacjbcaabcaaaaaaaaaagacpgadfbcaaccaaaaaaafpifaaa
aaaaagiiaaaaaaaamiapaaaaaalbaaaacbaabdaamiahaaabaablleaakbafalaa
miahaaabaamgmaleklafakabmiahaaabaalbleleklafajabmiahaaaeaagmmale
klafaiabmiadaaabaameblaakbaeamaamiapaaadaalmdeaakbabbeaaaabpacag
aalmdeggkbabbfadaacmacacaakmaglloaagagadmiapaaacaaaaaaaaklacbbaa
miapaaacaaaabllbilacpopomiapaaacaaaaaaaaoiacaaaamiapaaaiaaaagmgm
ilacpppomabpadagaaaaaagmcbbcbaaimacpadacaabliilbkbafahaimaepadah
aaakdemgkbagbfaimaipadajaakadeblkbagbeaimeicabagaakhkhlbkpadbaai
meepabadaaaaaagmcbbbbaaimebpagajaaanahmgobajabaimeimagabaapbcmbl
oaajajaimiaeaaagaabkbiblpbahagabmiabaaagaalabimgpbahagabmiahaaaf
aamamaaaoaagafaamiapaaacaamgnapiklafagacmiapaaacaalbdepiklafafac
miapaaafaagmnajeklafaeacmiapiadoaananaaaocafafaamiapaaacaagmkhoo
claaapaemiadaaabaamelaaaoaagabaamiapaaagaalmdeaakbabbeaaaabpabah
aalmdeggkbabbfagaacmababaakmaglloaahahagmiapaaabaaaaaaaaklabbbaa
miahaaaaaamalbaakbafpoaamiamiaadaanlnlaaocafafaamiahiaabacmamaaa
kaaeabaamiapiaacaahkaaaakbacaoaamiapaaabaaaabllbilabpopokiipaaab
aaaaaaebmiabaaacmiadiaadaamgbkbiklaaadaamiapaaabaaaagmgmilabpppo
mebdabacaalabjgmkbadbeabmecmabacaaagdblbkbadbfabmeedabaaaalamemg
kbadbeabmeimabaaaaagomblkbadbfabmiabaaaaaakhkhaaopaaabaamiacaaaa
aakhkhaaopacabaamiagaaaaaelmgmaakbaaanaamiabaaaaaalclcmgnbaaaapo
fibaaaaaaaaaaagmocaaaaiaaaknmaaaaamfgmgmobaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Matrix 256 [glstate_matrix_mvp]
Bind "vertex" Vertex
Vector 467 [_Time]
Vector 466 [_WorldSpaceCameraPos]
Vector 465 [_ProjectionParams]
Matrix 260 [_Object2World]
Vector 464 [unity_Scale]
Float 463 [_GerstnerIntensity]
Vector 462 [_BumpTiling]
Vector 461 [_BumpDirection]
Vector 460 [_GAmplitude]
Vector 459 [_GFrequency]
Vector 458 [_GSteepness]
Vector 457 [_GSpeed]
Vector 456 [_GDirectionAB]
Vector 455 [_GDirectionCD]
"sce_vp_rsx // 57 instructions using 13 registers
[Configuration]
8
0000003900010d00
[Defaults]
1
454 3
3f800000400000003f000000
[Microcode]
912
00001c6c005cc00d8186c0836041fffc00009c6c005d30080186c08360419ffc
401f9c6c005c60000186c08360403f9c00061c6c005c602a8186c08360409ffc
00051c6c0040007f8106c08360403ffc00031c6c01d0600d8106c0c360405ffc
00031c6c01d0500d8106c0c360409ffc00031c6c01d0400d8106c0c360411ffc
401f9c6c00dd208c0186c0830321dfa000039c6c009cb0138089c0c36041fffc
00011c6c009ca0138089c0c36041fffc00001c6c011cd0000286c0c44321fffc
00009c6c009c902a8286c0c36041fffc00021c6c009c702f8486c0c36041fffc
00019c6c009c80050486c0c36041fffc00029c6c009c702f8e86c0c36041fffc
00049c6c009d00100cbfc0c360419ffc00031c6c009c70089286c0c36041fffc
00011c6c009c80089286c0c36041fffc00011c6c00c000100486c08ea1219ffc
00011c6c00c000010c86c08ae3207ffc00031c6c009c80050e86c0c36041fffc
00011c6c009cb00d8486c0c36041fffc00011c6c00c0000d8486c08360a1fffc
401f9c6c009ce00d8086c0c36041ffa400001c6c784000100c86c0800131847c
00001c6c804000010a86c080013063fc00059c6c7840003a8c86c08aa129847c
00031c6c804000100686c08aa12983fc00031c6c804000010886c095412463fc
00019c6c8040003a8686c09fe12383fc00019c6c7840002b8886c0954124647c
00019c6c79c0000d8e86c35fe122447c00019c6c01c0000d8e86c64360411ffc
00019c6c01dcc00d9086c0c360409ffc00051c6c00c0000c0106c08301a1dffc
00011c6c00c000081286c08401a19ffc00021c6c01d0300d9486c0c360403ffc
00019c6c009c70088486c0c36041fffc00011c6c009c80088486c0c36041fffc
00011c6c00c000100486c08ea1219ffc00011c6c00c000010686c08ae1a07ffc
00009c6c011cb00d8486c0c360a1fffc00021c6c01d0200d9486c0c360405ffc
00021c6c81d0100d9486c0c000b080fc00021c6c81d0000d9486c0caa0a900fc
00059c6c8040002b8a86c09540a460fc401f9c6c8040000d8886c09fe0a3e080
401f9c6c004000558886c08360407fa800011c6c01c0000d8286cb4360409ffc
00011c6c01c0000d8286c04360411ffc00001c6c009c600e08aa80c36041dffc
00061c6c009cf082048000c360415ffc00009c6c0140000c18860c4360411ffc
00001c6c209d102a808000c000b080fc401f9c6c00c000080086c09540219fa8
401f9c6c0080000002860c436041df9d
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304 // 304 used size, 19 vars
Float 16 [_GerstnerIntensity]
Vector 176 [_BumpTiling] 4
Vector 192 [_BumpDirection] 4
Vector 208 [_GAmplitude] 4
Vector 224 [_GFrequency] 4
Vector 240 [_GSteepness] 4
Vector 256 [_GSpeed] 4
Vector 272 [_GDirectionAB] 4
Vector 288 [_GDirectionCD] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 0 [_Time] 4
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 59 instructions, 7 temp regs, 0 temp arrays:
// ALU 47 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedglgdjnccceaelhpdglkfonphjipohkojabaaaaaabeajaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefchiahaaaaeaaaabaa
noabaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaa
giaaaaacahaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaa
apaaaaaibcaabaaaacaaaaaaegiacaaaaaaaaaaabbaaaaaaegaabaaaabaaaaaa
apaaaaaiccaabaaaacaaaaaaogikcaaaaaaaaaaabbaaaaaaegaabaaaabaaaaaa
apaaaaaiecaabaaaacaaaaaaegiacaaaaaaaaaaabcaaaaaaegaabaaaabaaaaaa
apaaaaaiicaabaaaacaaaaaaogikcaaaaaaaaaaabcaaaaaaegaabaaaabaaaaaa
diaaaaajpcaabaaaabaaaaaaegiocaaaaaaaaaaabaaaaaaafgifcaaaabaaaaaa
aaaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaaaaaaaaaaoaaaaaaegaobaaa
acaaaaaaegaobaaaabaaaaaaenaaaaahpcaabaaaacaaaaaapcaabaaaadaaaaaa
egaobaaaacaaaaaabbaaaaaiccaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaa
aaaaaaaaanaaaaaadiaaaaajpcaabaaaaeaaaaaaegiocaaaaaaaaaaaanaaaaaa
egiocaaaaaaaaaaaapaaaaaadiaaaaaipcaabaaaafaaaaaaegaebaaaaeaaaaaa
ngiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaeaaaaaakgapbaaaaeaaaaaa
egiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaagaaaaaaogakbaaaafaaaaaa
dgaaaaafmcaabaaaagaaaaaaagaibaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaa
fganbaaaaeaaaaaabbaaaaahecaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaa
afaaaaaabbaaaaahbcaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaaagaaaaaa
aaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaaegbcbaaaaaaaaaaadcaaaaak
dcaabaaaacaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaaigaabaaa
acaaaaaadiaaaaaipcaabaaaaeaaaaaafgafbaaaadaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaeaaaaaaegiocaaaacaaaaaaaaaaaaaaagaabaaa
adaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaaegiocaaaacaaaaaa
acaaaaaakgakbaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaadaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaadaaaaaaapaaaaaibcaabaaaaeaaaaaaegiacaaa
aaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiccaabaaaaeaaaaaaogikcaaa
aaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiecaabaaaaeaaaaaaegiacaaa
aaaaaaaabcaaaaaaegaabaaaacaaaaaaapaaaaaiicaabaaaaeaaaaaaogikcaaa
aaaaaaaabcaaaaaaegaabaaaacaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
aaaaaaaaaoaaaaaaegaobaaaaeaaaaaaegaobaaaabaaaaaaenaaaaagaanaaaaa
pcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaajpcaabaaaacaaaaaaegiocaaa
aaaaaaaaanaaaaaaegiocaaaaaaaaaaaaoaaaaaadiaaaaaipcaabaaaaeaaaaaa
egaebaaaacaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaacaaaaaa
kgapbaaaacaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaafaaaaaa
ogakbaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaaagaibaaaacaaaaaadgaaaaaf
mcaabaaaaeaaaaaafganbaaaacaaaaaabbaaaaahicaabaaaaaaaaaaaegaobaaa
abaaaaaaegaobaaaaeaaaaaabbaaaaahbcaabaaaabaaaaaaegaobaaaabaaaaaa
egaobaaaafaaaaaadgaaaaagbcaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaa
dgaaaaagecaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadiaaaaaifcaabaaa
abaaaaaaagacbaaaabaaaaaaagiacaaaaaaaaaaaabaaaaaadgaaaaafccaabaaa
abaaaaaaabeaaaaaaaaaaaeabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hccabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaa
abaaaaaaabeaaaaaaaaaiadpaaaaaaajhccabaaaacaaaaaaegacbaaaaaaaaaaa
egiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaaaaaaaaaagiacaaa
abaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaaaaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaadiaaaaai
bcaabaaaaaaaaaaabkaabaaaadaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaah
icaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdiaaaaakfcaabaaa
aaaaaaaaagadbaaaadaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaaaa
dgaaaaafmccabaaaaeaaaaaakgaobaaaadaaaaaaaaaaaaahdccabaaaaeaaaaaa
kgakbaaaaaaaaaaamgaabaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = _glesVertex.w;
  mediump vec3 vtxForAni_2;
  mediump vec3 worldSpaceVertex_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_3 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (worldSpaceVertex_3.xzz * unity_Scale.w);
  vtxForAni_2 = tmpvar_6;
  mediump vec4 amplitude_7;
  amplitude_7 = _GAmplitude;
  mediump vec4 frequency_8;
  frequency_8 = _GFrequency;
  mediump vec4 steepness_9;
  steepness_9 = _GSteepness;
  mediump vec4 speed_10;
  speed_10 = _GSpeed;
  mediump vec4 directionAB_11;
  directionAB_11 = _GDirectionAB;
  mediump vec4 directionCD_12;
  directionCD_12 = _GDirectionCD;
  mediump vec4 TIME_13;
  mediump vec3 offsets_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((steepness_9.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_16;
  tmpvar_16 = ((steepness_9.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_17;
  tmpvar_17.x = dot (directionAB_11.xy, vtxForAni_2.xz);
  tmpvar_17.y = dot (directionAB_11.zw, vtxForAni_2.xz);
  tmpvar_17.z = dot (directionCD_12.xy, vtxForAni_2.xz);
  tmpvar_17.w = dot (directionCD_12.zw, vtxForAni_2.xz);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (frequency_8 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (_Time.yyyy * speed_10);
  TIME_13 = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = cos((tmpvar_18 + TIME_13));
  mediump vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_15.xz;
  tmpvar_21.zw = tmpvar_16.xz;
  offsets_14.x = dot (tmpvar_20, tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22.xy = tmpvar_15.yw;
  tmpvar_22.zw = tmpvar_16.yw;
  offsets_14.z = dot (tmpvar_20, tmpvar_22);
  offsets_14.y = dot (sin((tmpvar_18 + TIME_13)), amplitude_7);
  mediump vec2 xzVtx_23;
  xzVtx_23 = (vtxForAni_2.xz + offsets_14.xz);
  mediump vec4 TIME_24;
  mediump vec3 nrml_25;
  nrml_25.y = 2.0;
  mediump vec4 tmpvar_26;
  tmpvar_26 = ((frequency_8.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_27;
  tmpvar_27 = ((frequency_8.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_28;
  tmpvar_28.x = dot (directionAB_11.xy, xzVtx_23);
  tmpvar_28.y = dot (directionAB_11.zw, xzVtx_23);
  tmpvar_28.z = dot (directionCD_12.xy, xzVtx_23);
  tmpvar_28.w = dot (directionCD_12.zw, xzVtx_23);
  highp vec4 tmpvar_29;
  tmpvar_29 = (_Time.yyyy * speed_10);
  TIME_24 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = cos(((frequency_8 * tmpvar_28) + TIME_24));
  mediump vec4 tmpvar_31;
  tmpvar_31.xy = tmpvar_26.xz;
  tmpvar_31.zw = tmpvar_27.xz;
  nrml_25.x = -(dot (tmpvar_30, tmpvar_31));
  mediump vec4 tmpvar_32;
  tmpvar_32.xy = tmpvar_26.yw;
  tmpvar_32.zw = tmpvar_27.yw;
  nrml_25.z = -(dot (tmpvar_30, tmpvar_32));
  nrml_25.xz = (nrml_25.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_33;
  tmpvar_33 = normalize(nrml_25);
  nrml_25 = tmpvar_33;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_14);
  highp vec4 tmpvar_34;
  tmpvar_34 = (glstate_matrix_mvp * tmpvar_1);
  highp vec4 o_35;
  highp vec4 tmpvar_36;
  tmpvar_36 = (tmpvar_34 * 0.5);
  highp vec2 tmpvar_37;
  tmpvar_37.x = tmpvar_36.x;
  tmpvar_37.y = (tmpvar_36.y * _ProjectionParams.x);
  o_35.xy = (tmpvar_37 + tmpvar_36.w);
  o_35.zw = tmpvar_34.zw;
  tmpvar_4.xyz = tmpvar_33;
  tmpvar_4.w = 1.0;
  gl_Position = tmpvar_34;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (worldSpaceVertex_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_35;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _InvFadeParemeter;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _ZBufferParams;
void main ()
{
  mediump vec4 baseColor_1;
  mediump float depth_2;
  mediump vec4 edgeBlendFactors_3;
  highp float nh_4;
  mediump vec3 h_5;
  mediump vec4 rtReflections_6;
  mediump vec4 screenWithOffset_7;
  mediump vec4 distortOffset_8;
  mediump vec3 viewVector_9;
  mediump vec3 worldNormal_10;
  mediump vec4 coords_11;
  coords_11 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_12;
  vertexNormal_12 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_13;
  bumpStrength_13 = _DistortParams.x;
  mediump vec4 bump_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = (texture2D (_BumpMap, coords_11.xy) + texture2D (_BumpMap, coords_11.zw));
  bump_14 = tmpvar_15;
  bump_14.xy = (bump_14.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize((vertexNormal_12 + ((bump_14.xxy * bumpStrength_13) * vec3(1.0, 0.0, 1.0))));
  worldNormal_10.y = tmpvar_16.y;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize(xlv_TEXCOORD1);
  viewVector_9 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.zw = vec2(0.0, 0.0);
  tmpvar_18.xy = ((tmpvar_16.xz * _DistortParams.y) * 10.0);
  distortOffset_8 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19 = (xlv_TEXCOORD3 + distortOffset_8);
  screenWithOffset_7 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2DProj (_ReflectionTex, screenWithOffset_7);
  rtReflections_6 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((_WorldLightDir.xyz + viewVector_9));
  h_5 = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, dot (tmpvar_16, -(h_5)));
  nh_4 = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth_2 = tmpvar_23;
  highp float tmpvar_24;
  highp float z_25;
  z_25 = depth_2;
  tmpvar_24 = (1.0/(((_ZBufferParams.z * z_25) + _ZBufferParams.w)));
  depth_2 = tmpvar_24;
  highp vec4 tmpvar_26;
  tmpvar_26 = clamp ((_InvFadeParemeter * (depth_2 - xlv_TEXCOORD3.z)), 0.0, 1.0);
  edgeBlendFactors_3 = tmpvar_26;
  highp vec2 tmpvar_27;
  tmpvar_27 = (tmpvar_16.xz * _FresnelScale);
  worldNormal_10.xz = tmpvar_27;
  mediump float bias_28;
  bias_28 = _DistortParams.w;
  mediump float power_29;
  power_29 = _DistortParams.z;
  mediump float tmpvar_30;
  tmpvar_30 = clamp ((bias_28 + ((1.0 - bias_28) * pow (clamp ((1.0 - max (dot (-(viewVector_9), worldNormal_10), 0.0)), 0.0, 1.0), power_29))), 0.0, 1.0);
  baseColor_1 = _BaseColor;
  mediump float tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp vec4 tmpvar_32;
  tmpvar_32 = mix (baseColor_1, mix (rtReflections_6, _ReflectionColor, _ReflectionColor.wwww), vec4(tmpvar_31));
  baseColor_1 = tmpvar_32;
  highp vec4 tmpvar_33;
  tmpvar_33 = (baseColor_1 + (max (0.0, pow (nh_4, _Shininess)) * _SpecularColor));
  baseColor_1.xyz = tmpvar_33.xyz;
  baseColor_1.w = (edgeBlendFactors_3.x * clamp ((0.5 + tmpvar_30), 0.0, 1.0));
  gl_FragData[0] = baseColor_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = _glesVertex.w;
  mediump vec3 vtxForAni_2;
  mediump vec3 worldSpaceVertex_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_3 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (worldSpaceVertex_3.xzz * unity_Scale.w);
  vtxForAni_2 = tmpvar_6;
  mediump vec4 amplitude_7;
  amplitude_7 = _GAmplitude;
  mediump vec4 frequency_8;
  frequency_8 = _GFrequency;
  mediump vec4 steepness_9;
  steepness_9 = _GSteepness;
  mediump vec4 speed_10;
  speed_10 = _GSpeed;
  mediump vec4 directionAB_11;
  directionAB_11 = _GDirectionAB;
  mediump vec4 directionCD_12;
  directionCD_12 = _GDirectionCD;
  mediump vec4 TIME_13;
  mediump vec3 offsets_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((steepness_9.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_16;
  tmpvar_16 = ((steepness_9.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_17;
  tmpvar_17.x = dot (directionAB_11.xy, vtxForAni_2.xz);
  tmpvar_17.y = dot (directionAB_11.zw, vtxForAni_2.xz);
  tmpvar_17.z = dot (directionCD_12.xy, vtxForAni_2.xz);
  tmpvar_17.w = dot (directionCD_12.zw, vtxForAni_2.xz);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (frequency_8 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (_Time.yyyy * speed_10);
  TIME_13 = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = cos((tmpvar_18 + TIME_13));
  mediump vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_15.xz;
  tmpvar_21.zw = tmpvar_16.xz;
  offsets_14.x = dot (tmpvar_20, tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22.xy = tmpvar_15.yw;
  tmpvar_22.zw = tmpvar_16.yw;
  offsets_14.z = dot (tmpvar_20, tmpvar_22);
  offsets_14.y = dot (sin((tmpvar_18 + TIME_13)), amplitude_7);
  mediump vec2 xzVtx_23;
  xzVtx_23 = (vtxForAni_2.xz + offsets_14.xz);
  mediump vec4 TIME_24;
  mediump vec3 nrml_25;
  nrml_25.y = 2.0;
  mediump vec4 tmpvar_26;
  tmpvar_26 = ((frequency_8.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_27;
  tmpvar_27 = ((frequency_8.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_28;
  tmpvar_28.x = dot (directionAB_11.xy, xzVtx_23);
  tmpvar_28.y = dot (directionAB_11.zw, xzVtx_23);
  tmpvar_28.z = dot (directionCD_12.xy, xzVtx_23);
  tmpvar_28.w = dot (directionCD_12.zw, xzVtx_23);
  highp vec4 tmpvar_29;
  tmpvar_29 = (_Time.yyyy * speed_10);
  TIME_24 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = cos(((frequency_8 * tmpvar_28) + TIME_24));
  mediump vec4 tmpvar_31;
  tmpvar_31.xy = tmpvar_26.xz;
  tmpvar_31.zw = tmpvar_27.xz;
  nrml_25.x = -(dot (tmpvar_30, tmpvar_31));
  mediump vec4 tmpvar_32;
  tmpvar_32.xy = tmpvar_26.yw;
  tmpvar_32.zw = tmpvar_27.yw;
  nrml_25.z = -(dot (tmpvar_30, tmpvar_32));
  nrml_25.xz = (nrml_25.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_33;
  tmpvar_33 = normalize(nrml_25);
  nrml_25 = tmpvar_33;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_14);
  highp vec4 tmpvar_34;
  tmpvar_34 = (glstate_matrix_mvp * tmpvar_1);
  highp vec4 o_35;
  highp vec4 tmpvar_36;
  tmpvar_36 = (tmpvar_34 * 0.5);
  highp vec2 tmpvar_37;
  tmpvar_37.x = tmpvar_36.x;
  tmpvar_37.y = (tmpvar_36.y * _ProjectionParams.x);
  o_35.xy = (tmpvar_37 + tmpvar_36.w);
  o_35.zw = tmpvar_34.zw;
  tmpvar_4.xyz = tmpvar_33;
  tmpvar_4.w = 1.0;
  gl_Position = tmpvar_34;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (worldSpaceVertex_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_35;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _InvFadeParemeter;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _ZBufferParams;
void main ()
{
  mediump vec4 baseColor_1;
  mediump float depth_2;
  mediump vec4 edgeBlendFactors_3;
  highp float nh_4;
  mediump vec3 h_5;
  mediump vec4 rtReflections_6;
  mediump vec4 screenWithOffset_7;
  mediump vec4 distortOffset_8;
  mediump vec3 viewVector_9;
  mediump vec3 worldNormal_10;
  mediump vec4 coords_11;
  coords_11 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_12;
  vertexNormal_12 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_13;
  bumpStrength_13 = _DistortParams.x;
  mediump vec4 bump_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = (texture2D (_BumpMap, coords_11.xy) + texture2D (_BumpMap, coords_11.zw));
  bump_14 = tmpvar_15;
  bump_14.xy = (bump_14.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize((vertexNormal_12 + ((bump_14.xxy * bumpStrength_13) * vec3(1.0, 0.0, 1.0))));
  worldNormal_10.y = tmpvar_16.y;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize(xlv_TEXCOORD1);
  viewVector_9 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.zw = vec2(0.0, 0.0);
  tmpvar_18.xy = ((tmpvar_16.xz * _DistortParams.y) * 10.0);
  distortOffset_8 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19 = (xlv_TEXCOORD3 + distortOffset_8);
  screenWithOffset_7 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2DProj (_ReflectionTex, screenWithOffset_7);
  rtReflections_6 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((_WorldLightDir.xyz + viewVector_9));
  h_5 = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, dot (tmpvar_16, -(h_5)));
  nh_4 = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth_2 = tmpvar_23;
  highp float tmpvar_24;
  highp float z_25;
  z_25 = depth_2;
  tmpvar_24 = (1.0/(((_ZBufferParams.z * z_25) + _ZBufferParams.w)));
  depth_2 = tmpvar_24;
  highp vec4 tmpvar_26;
  tmpvar_26 = clamp ((_InvFadeParemeter * (depth_2 - xlv_TEXCOORD3.z)), 0.0, 1.0);
  edgeBlendFactors_3 = tmpvar_26;
  highp vec2 tmpvar_27;
  tmpvar_27 = (tmpvar_16.xz * _FresnelScale);
  worldNormal_10.xz = tmpvar_27;
  mediump float bias_28;
  bias_28 = _DistortParams.w;
  mediump float power_29;
  power_29 = _DistortParams.z;
  mediump float tmpvar_30;
  tmpvar_30 = clamp ((bias_28 + ((1.0 - bias_28) * pow (clamp ((1.0 - max (dot (-(viewVector_9), worldNormal_10), 0.0)), 0.0, 1.0), power_29))), 0.0, 1.0);
  baseColor_1 = _BaseColor;
  mediump float tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp vec4 tmpvar_32;
  tmpvar_32 = mix (baseColor_1, mix (rtReflections_6, _ReflectionColor, _ReflectionColor.wwww), vec4(tmpvar_31));
  baseColor_1 = tmpvar_32;
  highp vec4 tmpvar_33;
  tmpvar_33 = (baseColor_1 + (max (0.0, pow (nh_4, _Shininess)) * _SpecularColor));
  baseColor_1.xyz = tmpvar_33.xyz;
  baseColor_1.w = (edgeBlendFactors_3.x * clamp ((0.5 + tmpvar_30), 0.0, 1.0));
  gl_FragData[0] = baseColor_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 485
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 495
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 504
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 348
#line 356
#line 379
#line 396
#line 408
#line 453
#line 474
#line 511
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 515
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 519
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 523
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 527
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 531
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 551
#line 580
#line 621
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 460
mediump vec3 GerstnerNormal4( in mediump vec2 xzVtx, in mediump vec4 amp, in mediump vec4 freq, in mediump vec4 speed, in mediump vec4 dirAB, in mediump vec4 dirCD ) {
    #line 462
    mediump vec3 nrml = vec3( 0.0, 2.0, 0.0);
    mediump vec4 AB = ((freq.xxyy * amp.xxyy) * dirAB.xyzw);
    mediump vec4 CD = ((freq.zzww * amp.zzww) * dirCD.xyzw);
    mediump vec4 dotABCD = (freq.xyzw * vec4( dot( dirAB.xy, xzVtx), dot( dirAB.zw, xzVtx), dot( dirCD.xy, xzVtx), dot( dirCD.zw, xzVtx)));
    #line 466
    mediump vec4 TIME = (_Time.yyyy * speed);
    mediump vec4 COS = cos((dotABCD + TIME));
    nrml.x -= dot( COS, vec4( AB.xz, CD.xz));
    nrml.z -= dot( COS, vec4( AB.yw, CD.yw));
    #line 470
    nrml.xz *= _GerstnerIntensity;
    nrml = normalize(nrml);
    return nrml;
}
#line 439
mediump vec3 GerstnerOffset4( in mediump vec2 xzVtx, in mediump vec4 steepness, in mediump vec4 amp, in mediump vec4 freq, in mediump vec4 speed, in mediump vec4 dirAB, in mediump vec4 dirCD ) {
    #line 441
    mediump vec3 offsets;
    mediump vec4 AB = ((steepness.xxyy * amp.xxyy) * dirAB.xyzw);
    mediump vec4 CD = ((steepness.zzww * amp.zzww) * dirCD.xyzw);
    mediump vec4 dotABCD = (freq.xyzw * vec4( dot( dirAB.xy, xzVtx), dot( dirAB.zw, xzVtx), dot( dirCD.xy, xzVtx), dot( dirCD.zw, xzVtx)));
    #line 445
    mediump vec4 TIME = (_Time.yyyy * speed);
    mediump vec4 COS = cos((dotABCD + TIME));
    mediump vec4 SIN = sin((dotABCD + TIME));
    offsets.x = dot( COS, vec4( AB.xz, CD.xz));
    #line 449
    offsets.z = dot( COS, vec4( AB.yw, CD.yw));
    offsets.y = dot( SIN, amp);
    return offsets;
}
#line 474
void Gerstner( out mediump vec3 offs, out mediump vec3 nrml, in mediump vec3 vtx, in mediump vec3 tileableVtx, in mediump vec4 amplitude, in mediump vec4 frequency, in mediump vec4 steepness, in mediump vec4 speed, in mediump vec4 directionAB, in mediump vec4 directionCD ) {
    offs = GerstnerOffset4( tileableVtx.xz, steepness, amplitude, frequency, speed, directionAB, directionCD);
    nrml = GerstnerNormal4( (tileableVtx.xz + offs.xz), amplitude, frequency, speed, directionAB, directionCD);
}
#line 580
v2f_noGrab vert300( in appdata_full v ) {
    v2f_noGrab o;
    mediump vec3 worldSpaceVertex = (_Object2World * v.vertex).xyz;
    #line 584
    mediump vec3 vtxForAni = (worldSpaceVertex.xzz * unity_Scale.w);
    mediump vec3 nrml;
    mediump vec3 offsets;
    Gerstner( offsets, nrml, v.vertex.xyz, vtxForAni, _GAmplitude, _GFrequency, _GSteepness, _GSpeed, _GDirectionAB, _GDirectionCD);
    #line 588
    v.vertex.xyz += offsets;
    mediump vec2 tileableUv = worldSpaceVertex.xz;
    o.bumpCoords.xyzw = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection.xyzw)) * _BumpTiling.xyzw);
    o.viewInterpolator.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
    #line 592
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.screenPos = ComputeScreenPos( o.pos);
    o.normalInterpolator.xyz = nrml;
    o.normalInterpolator.w = 1.0;
    #line 596
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_noGrab xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert300( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.normalInterpolator);
    xlv_TEXCOORD1 = vec3(xl_retval.viewInterpolator);
    xlv_TEXCOORD2 = vec4(xl_retval.bumpCoords);
    xlv_TEXCOORD3 = vec4(xl_retval.screenPos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 485
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 495
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 504
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 348
#line 356
#line 379
#line 396
#line 408
#line 453
#line 474
#line 511
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 515
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 519
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 523
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 527
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 531
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 551
#line 580
#line 621
#line 390
mediump float Fresnel( in mediump vec3 viewVector, in mediump vec3 worldNormal, in mediump float bias, in mediump float power ) {
    #line 392
    mediump float facing = clamp( (1.0 - max( dot( (-viewVector), worldNormal), 0.0)), 0.0, 1.0);
    mediump float refl2Refr = xll_saturate_f((bias + ((1.0 - bias) * pow( facing, power))));
    return refl2Refr;
}
#line 280
highp float LinearEyeDepth( in highp float z ) {
    #line 282
    return (1.0 / ((_ZBufferParams.z * z) + _ZBufferParams.w));
}
#line 316
mediump vec3 PerPixelNormal( in sampler2D bumpMap, in mediump vec4 coords, in mediump vec3 vertexNormal, in mediump float bumpStrength ) {
    mediump vec4 bump = (texture( bumpMap, coords.xy) + texture( bumpMap, coords.zw));
    #line 319
    bump.xy = (bump.wy - vec2( 1.0, 1.0));
    mediump vec3 worldNormal = (vertexNormal + ((bump.xxy * bumpStrength) * vec3( 1.0, 0.0, 1.0)));
    return normalize(worldNormal);
}
#line 598
mediump vec4 frag300( in v2f_noGrab i ) {
    #line 600
    mediump vec3 worldNormal = PerPixelNormal( _BumpMap, i.bumpCoords, i.normalInterpolator.xyz, _DistortParams.x);
    mediump vec3 viewVector = normalize(i.viewInterpolator.xyz);
    mediump vec4 distortOffset = vec4( ((worldNormal.xz * _DistortParams.y) * 10.0), 0.0, 0.0);
    mediump vec4 screenWithOffset = (i.screenPos + distortOffset);
    #line 604
    mediump vec4 rtReflections = textureProj( _ReflectionTex, screenWithOffset);
    mediump vec3 reflectVector = normalize(reflect( viewVector, worldNormal));
    mediump vec3 h = normalize((_WorldLightDir.xyz + viewVector.xyz));
    highp float nh = max( 0.0, dot( worldNormal, (-h)));
    #line 608
    highp float spec = max( 0.0, pow( nh, _Shininess));
    mediump vec4 edgeBlendFactors = vec4( 1.0, 0.0, 0.0, 0.0);
    mediump float depth = textureProj( _CameraDepthTexture, i.screenPos).x;
    depth = LinearEyeDepth( depth);
    #line 612
    edgeBlendFactors = xll_saturate_vf4((_InvFadeParemeter * (depth - i.screenPos.z)));
    worldNormal.xz *= _FresnelScale;
    mediump float refl2Refr = Fresnel( viewVector, worldNormal, _DistortParams.w, _DistortParams.z);
    mediump vec4 baseColor = _BaseColor;
    #line 616
    baseColor = mix( baseColor, mix( rtReflections, _ReflectionColor, vec4( _ReflectionColor.w)), vec4( xll_saturate_f((refl2Refr * 1.0))));
    baseColor = (baseColor + (spec * _SpecularColor));
    baseColor.w = (edgeBlendFactors.x * xll_saturate_f((0.5 + (refl2Refr * 1.0))));
    return baseColor;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    mediump vec4 xl_retval;
    v2f_noGrab xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.normalInterpolator = vec4(xlv_TEXCOORD0);
    xlt_i.viewInterpolator = vec3(xlv_TEXCOORD1);
    xlt_i.bumpCoords = vec4(xlv_TEXCOORD2);
    xlt_i.screenPos = vec4(xlv_TEXCOORD3);
    xl_retval = frag300( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GSpeed;
uniform vec4 _GSteepness;
uniform vec4 _GFrequency;
uniform vec4 _GAmplitude;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform float _GerstnerIntensity;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = gl_Vertex.w;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec3 offsets_5;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, tmpvar_4.xz);
  tmpvar_8.y = dot (_GDirectionAB.zw, tmpvar_4.xz);
  tmpvar_8.z = dot (_GDirectionCD.xy, tmpvar_4.xz);
  tmpvar_8.w = dot (_GDirectionCD.zw, tmpvar_4.xz);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_5.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_5.z = dot (tmpvar_11, tmpvar_13);
  offsets_5.y = dot (sin((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_14;
  xzVtx_14 = (tmpvar_4.xz + offsets_5.xz);
  vec3 nrml_15;
  nrml_15.y = 2.0;
  vec4 tmpvar_16;
  tmpvar_16 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_17;
  tmpvar_17 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_18;
  tmpvar_18.x = dot (_GDirectionAB.xy, xzVtx_14);
  tmpvar_18.y = dot (_GDirectionAB.zw, xzVtx_14);
  tmpvar_18.z = dot (_GDirectionCD.xy, xzVtx_14);
  tmpvar_18.w = dot (_GDirectionCD.zw, xzVtx_14);
  vec4 tmpvar_19;
  tmpvar_19 = cos(((_GFrequency * tmpvar_18) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_16.xz;
  tmpvar_20.zw = tmpvar_17.xz;
  nrml_15.x = -(dot (tmpvar_19, tmpvar_20));
  vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_16.yw;
  tmpvar_21.zw = tmpvar_17.yw;
  nrml_15.z = -(dot (tmpvar_19, tmpvar_21));
  nrml_15.xz = (nrml_15.xz * _GerstnerIntensity);
  vec3 tmpvar_22;
  tmpvar_22 = normalize(nrml_15);
  nrml_15 = tmpvar_22;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_5);
  vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 o_24;
  vec4 tmpvar_25;
  tmpvar_25 = (tmpvar_23 * 0.5);
  vec2 tmpvar_26;
  tmpvar_26.x = tmpvar_25.x;
  tmpvar_26.y = (tmpvar_25.y * _ProjectionParams.x);
  o_24.xy = (tmpvar_26 + tmpvar_25.w);
  o_24.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_22;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_24;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _InvFadeParemeter;
uniform vec4 _ReflectionColor;
uniform vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform vec4 _ZBufferParams;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  baseColor_1.xyz = (_ReflectionColor + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = (clamp ((_InvFadeParemeter * ((1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w))) - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0)), 0.0, 1.0));
  gl_FragData[0] = baseColor_1;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 12 [unity_Scale]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 187 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c12.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r3.zw, r3.xyyw
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o1.xyz, r0.w, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
mov r1.w, v0
add r1.xyz, v0, r4
dp4 r2.w, r1, c3
dp4 r2.z, r1, c2
dp4 r2.x, r1, c0
dp4 r2.y, r1, c1
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c10.x
mad o4.xy, r3.z, c11.zwzw, r0
mov r0.x, c8
mad r0, c15, r0.x, r7.xzxz
mov o0, r2
mov o4.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c9
mov o1.w, c23.y
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Bind "vertex" Vertex
Vector 15 [_BumpDirection]
Vector 14 [_BumpTiling]
Vector 16 [_GAmplitude]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
Vector 17 [_GFrequency]
Vector 19 [_GSpeed]
Vector 18 [_GSteepness]
Float 13 [_GerstnerIntensity]
Matrix 8 [_Object2World] 4
Vector 2 [_ProjectionParams]
Vector 3 [_ScreenParams]
Vector 0 [_Time]
Vector 1 [_WorldSpaceCameraPos]
Matrix 4 [glstate_matrix_mvp] 4
Vector 12 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 69.33 (52 instructions), vertex: 32, texture: 0,
//   sequencer: 24,  10 GPRs, 18 threads,
// Performance (if enough threads): ~69 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaaddeaaaaadbaaaaaaaaaaaaaaaceaaaaaclmaaaaacoeaaaaaaaa
aaaaaaaaaaaaacjeaaaaaabmaaaaacigpppoadaaaaaaaabaaaaaaabmaaaaaaaa
aaaaachpaaaaabfmaaacaaapaaabaaaaaaaaabgmaaaaaaaaaaaaabhmaaacaaao
aaabaaaaaaaaabgmaaaaaaaaaaaaabiiaaacaabaaaabaaaaaaaaabgmaaaaaaaa
aaaaabjeaaacaabeaaabaaaaaaaaabgmaaaaaaaaaaaaabkcaaacaabfaaabaaaa
aaaaabgmaaaaaaaaaaaaablaaaacaabbaaabaaaaaaaaabgmaaaaaaaaaaaaablm
aaacaabdaaabaaaaaaaaabgmaaaaaaaaaaaaabmeaaacaabcaaabaaaaaaaaabgm
aaaaaaaaaaaaabnaaaacaaanaaabaaaaaaaaaboeaaaaaaaaaaaaabpeaaacaaai
aaaeaaaaaaaaacaeaaaaaaaaaaaaacbeaaacaaacaaabaaaaaaaaabgmaaaaaaaa
aaaaaccgaaacaaadaaabaaaaaaaaabgmaaaaaaaaaaaaacdeaaacaaaaaaabaaaa
aaaaabgmaaaaaaaaaaaaacdkaaacaaabaaabaaaaaaaaacfaaaaaaaaaaaaaacga
aaacaaaeaaaeaaaaaaaaacaeaaaaaaaaaaaaachdaaacaaamaaabaaaaaaaaabgm
aaaaaaaafpechfgnhaeegjhcgfgdhegjgpgoaaklaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpechfgnhafegjgmgjgoghaafpehebgnhagmgjhehfgegfaafpeheegj
hcgfgdhegjgpgoebecaafpeheegjhcgfgdhegjgpgoedeeaafpeheghcgfhbhfgf
gogdhjaafpehfdhagfgfgeaafpehfdhegfgfhagogfhdhdaafpehgfhchdhegogf
hcejgohegfgohdgjhehjaaklaaaaaaadaaabaaabaaabaaaaaaaaaaaafpepgcgk
gfgdhedcfhgphcgmgeaaklklaaadaaadaaaeaaaeaaabaaaaaaaaaaaafpfahcgp
gkgfgdhegjgpgofagbhcgbgnhdaafpfdgdhcgfgfgofagbhcgbgnhdaafpfegjgn
gfaafpfhgphcgmgefdhagbgdgfedgbgngfhcgbfagphdaaklaaabaaadaaabaaad
aaabaaaaaaaaaaaaghgmhdhegbhegffpgngbhehcgjhifpgnhghaaahfgogjhehj
fpfdgdgbgmgfaahghdfpddfpdaaadccodacodcdadddfddcodaaaklklaaaaaaaa
aaaaaaabaaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaeaaaaaacnaaadbaaajaaaaaaaaaaaaaaaaaaaadmieaaaaaaab
aaaaaaabaaaaaaafaaaaacjaaaaaaaagaaaapafaaaabhbfbaaacpcfcaaadpdfd
aaaabadkaaaabaclaaaabacmaaaaaackaaaabacpaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaamaejapnldpaaaaaaeaiaaaaa
doccpjideamjapnlaaaaaaaaaaaaaaaaaaaaaaaabaabbaagaaaabcaamcaaaaaa
aaaagaahgaanbcaabcaaaaaaaaaagabdgabjbcaabcaaaaaaaaaaeabpaaaabcaa
meaaaaaaaaaagacdgacjbcaabcaaaaaaaaaagacpgadfbcaaccaaaaaaafpifaaa
aaaaagiiaaaaaaaamiapaaaaaalbaaaacbaabdaamiahaaabaablleaakbafalaa
miahaaabaamgmaleklafakabmiahaaabaalbleleklafajabmiahaaaeaagmmale
klafaiabmiadaaabaameblaakbaeamaamiapaaadaalmdeaakbabbeaaaabpacag
aalmdeggkbabbfadaacmacacaakmaglloaagagadmiapaaacaaaaaaaaklacbbaa
miapaaacaaaabllbilacpopomiapaaacaaaaaaaaoiacaaaamiapaaaiaaaagmgm
ilacpppomabpadagaaaaaagmcbbcbaaimacpadacaabliilbkbafahaimaepadah
aaakdemgkbagbfaimaipadajaakadeblkbagbeaimeicabagaakhkhlbkpadbaai
meepabadaaaaaagmcbbbbaaimebpagajaaanahmgobajabaimeimagabaapbcmbl
oaajajaimiaeaaagaabkbiblpbahagabmiabaaagaalabimgpbahagabmiahaaaf
aamamaaaoaagafaamiapaaacaamgnapiklafagacmiapaaacaalbdepiklafafac
miapaaafaagmnajeklafaeacmiapiadoaananaaaocafafaamiapaaacaagmkhoo
claaapaemiadaaabaamelaaaoaagabaamiapaaagaalmdeaakbabbeaaaabpabah
aalmdeggkbabbfagaacmababaakmaglloaahahagmiapaaabaaaaaaaaklabbbaa
miahaaaaaamalbaakbafpoaamiamiaadaanlnlaaocafafaamiahiaabacmamaaa
kaaeabaamiapiaacaahkaaaakbacaoaamiapaaabaaaabllbilabpopokiipaaab
aaaaaaebmiabaaacmiadiaadaamgbkbiklaaadaamiapaaabaaaagmgmilabpppo
mebdabacaalabjgmkbadbeabmecmabacaaagdblbkbadbfabmeedabaaaalamemg
kbadbeabmeimabaaaaagomblkbadbfabmiabaaaaaakhkhaaopaaabaamiacaaaa
aakhkhaaopacabaamiagaaaaaelmgmaakbaaanaamiabaaaaaalclcmgnbaaaapo
fibaaaaaaaaaaagmocaaaaiaaaknmaaaaamfgmgmobaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Matrix 256 [glstate_matrix_mvp]
Bind "vertex" Vertex
Vector 467 [_Time]
Vector 466 [_WorldSpaceCameraPos]
Vector 465 [_ProjectionParams]
Matrix 260 [_Object2World]
Vector 464 [unity_Scale]
Float 463 [_GerstnerIntensity]
Vector 462 [_BumpTiling]
Vector 461 [_BumpDirection]
Vector 460 [_GAmplitude]
Vector 459 [_GFrequency]
Vector 458 [_GSteepness]
Vector 457 [_GSpeed]
Vector 456 [_GDirectionAB]
Vector 455 [_GDirectionCD]
"sce_vp_rsx // 57 instructions using 13 registers
[Configuration]
8
0000003900010d00
[Defaults]
1
454 3
3f800000400000003f000000
[Microcode]
912
00001c6c005cc00d8186c0836041fffc00009c6c005d30080186c08360419ffc
401f9c6c005c60000186c08360403f9c00061c6c005c602a8186c08360409ffc
00051c6c0040007f8106c08360403ffc00031c6c01d0600d8106c0c360405ffc
00031c6c01d0500d8106c0c360409ffc00031c6c01d0400d8106c0c360411ffc
401f9c6c00dd208c0186c0830321dfa000039c6c009cb0138089c0c36041fffc
00011c6c009ca0138089c0c36041fffc00001c6c011cd0000286c0c44321fffc
00009c6c009c902a8286c0c36041fffc00021c6c009c702f8486c0c36041fffc
00019c6c009c80050486c0c36041fffc00029c6c009c702f8e86c0c36041fffc
00049c6c009d00100cbfc0c360419ffc00031c6c009c70089286c0c36041fffc
00011c6c009c80089286c0c36041fffc00011c6c00c000100486c08ea1219ffc
00011c6c00c000010c86c08ae3207ffc00031c6c009c80050e86c0c36041fffc
00011c6c009cb00d8486c0c36041fffc00011c6c00c0000d8486c08360a1fffc
401f9c6c009ce00d8086c0c36041ffa400001c6c784000100c86c0800131847c
00001c6c804000010a86c080013063fc00059c6c7840003a8c86c08aa129847c
00031c6c804000100686c08aa12983fc00031c6c804000010886c095412463fc
00019c6c8040003a8686c09fe12383fc00019c6c7840002b8886c0954124647c
00019c6c79c0000d8e86c35fe122447c00019c6c01c0000d8e86c64360411ffc
00019c6c01dcc00d9086c0c360409ffc00051c6c00c0000c0106c08301a1dffc
00011c6c00c000081286c08401a19ffc00021c6c01d0300d9486c0c360403ffc
00019c6c009c70088486c0c36041fffc00011c6c009c80088486c0c36041fffc
00011c6c00c000100486c08ea1219ffc00011c6c00c000010686c08ae1a07ffc
00009c6c011cb00d8486c0c360a1fffc00021c6c01d0200d9486c0c360405ffc
00021c6c81d0100d9486c0c000b080fc00021c6c81d0000d9486c0caa0a900fc
00059c6c8040002b8a86c09540a460fc401f9c6c8040000d8886c09fe0a3e080
401f9c6c004000558886c08360407fa800011c6c01c0000d8286cb4360409ffc
00011c6c01c0000d8286c04360411ffc00001c6c009c600e08aa80c36041dffc
00061c6c009cf082048000c360415ffc00009c6c0140000c18860c4360411ffc
00001c6c209d102a808000c000b080fc401f9c6c00c000080086c09540219fa8
401f9c6c0080000002860c436041df9d
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304 // 304 used size, 19 vars
Float 16 [_GerstnerIntensity]
Vector 176 [_BumpTiling] 4
Vector 192 [_BumpDirection] 4
Vector 208 [_GAmplitude] 4
Vector 224 [_GFrequency] 4
Vector 240 [_GSteepness] 4
Vector 256 [_GSpeed] 4
Vector 272 [_GDirectionAB] 4
Vector 288 [_GDirectionCD] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 0 [_Time] 4
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 59 instructions, 7 temp regs, 0 temp arrays:
// ALU 47 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedglgdjnccceaelhpdglkfonphjipohkojabaaaaaabeajaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefchiahaaaaeaaaabaa
noabaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaa
giaaaaacahaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaa
apaaaaaibcaabaaaacaaaaaaegiacaaaaaaaaaaabbaaaaaaegaabaaaabaaaaaa
apaaaaaiccaabaaaacaaaaaaogikcaaaaaaaaaaabbaaaaaaegaabaaaabaaaaaa
apaaaaaiecaabaaaacaaaaaaegiacaaaaaaaaaaabcaaaaaaegaabaaaabaaaaaa
apaaaaaiicaabaaaacaaaaaaogikcaaaaaaaaaaabcaaaaaaegaabaaaabaaaaaa
diaaaaajpcaabaaaabaaaaaaegiocaaaaaaaaaaabaaaaaaafgifcaaaabaaaaaa
aaaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaaaaaaaaaaoaaaaaaegaobaaa
acaaaaaaegaobaaaabaaaaaaenaaaaahpcaabaaaacaaaaaapcaabaaaadaaaaaa
egaobaaaacaaaaaabbaaaaaiccaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaa
aaaaaaaaanaaaaaadiaaaaajpcaabaaaaeaaaaaaegiocaaaaaaaaaaaanaaaaaa
egiocaaaaaaaaaaaapaaaaaadiaaaaaipcaabaaaafaaaaaaegaebaaaaeaaaaaa
ngiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaeaaaaaakgapbaaaaeaaaaaa
egiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaagaaaaaaogakbaaaafaaaaaa
dgaaaaafmcaabaaaagaaaaaaagaibaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaa
fganbaaaaeaaaaaabbaaaaahecaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaa
afaaaaaabbaaaaahbcaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaaagaaaaaa
aaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaaegbcbaaaaaaaaaaadcaaaaak
dcaabaaaacaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaaigaabaaa
acaaaaaadiaaaaaipcaabaaaaeaaaaaafgafbaaaadaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaeaaaaaaegiocaaaacaaaaaaaaaaaaaaagaabaaa
adaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaaegiocaaaacaaaaaa
acaaaaaakgakbaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaadaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaadaaaaaaapaaaaaibcaabaaaaeaaaaaaegiacaaa
aaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiccaabaaaaeaaaaaaogikcaaa
aaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiecaabaaaaeaaaaaaegiacaaa
aaaaaaaabcaaaaaaegaabaaaacaaaaaaapaaaaaiicaabaaaaeaaaaaaogikcaaa
aaaaaaaabcaaaaaaegaabaaaacaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
aaaaaaaaaoaaaaaaegaobaaaaeaaaaaaegaobaaaabaaaaaaenaaaaagaanaaaaa
pcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaajpcaabaaaacaaaaaaegiocaaa
aaaaaaaaanaaaaaaegiocaaaaaaaaaaaaoaaaaaadiaaaaaipcaabaaaaeaaaaaa
egaebaaaacaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaacaaaaaa
kgapbaaaacaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaafaaaaaa
ogakbaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaaagaibaaaacaaaaaadgaaaaaf
mcaabaaaaeaaaaaafganbaaaacaaaaaabbaaaaahicaabaaaaaaaaaaaegaobaaa
abaaaaaaegaobaaaaeaaaaaabbaaaaahbcaabaaaabaaaaaaegaobaaaabaaaaaa
egaobaaaafaaaaaadgaaaaagbcaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaa
dgaaaaagecaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadiaaaaaifcaabaaa
abaaaaaaagacbaaaabaaaaaaagiacaaaaaaaaaaaabaaaaaadgaaaaafccaabaaa
abaaaaaaabeaaaaaaaaaaaeabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hccabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaa
abaaaaaaabeaaaaaaaaaiadpaaaaaaajhccabaaaacaaaaaaegacbaaaaaaaaaaa
egiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaaaaaaaaaagiacaaa
abaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaaaaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaadiaaaaai
bcaabaaaaaaaaaaabkaabaaaadaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaah
icaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdiaaaaakfcaabaaa
aaaaaaaaagadbaaaadaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaaaa
dgaaaaafmccabaaaaeaaaaaakgaobaaaadaaaaaaaaaaaaahdccabaaaaeaaaaaa
kgakbaaaaaaaaaaamgaabaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = _glesVertex.w;
  mediump vec3 vtxForAni_2;
  mediump vec3 worldSpaceVertex_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_3 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (worldSpaceVertex_3.xzz * unity_Scale.w);
  vtxForAni_2 = tmpvar_6;
  mediump vec4 amplitude_7;
  amplitude_7 = _GAmplitude;
  mediump vec4 frequency_8;
  frequency_8 = _GFrequency;
  mediump vec4 steepness_9;
  steepness_9 = _GSteepness;
  mediump vec4 speed_10;
  speed_10 = _GSpeed;
  mediump vec4 directionAB_11;
  directionAB_11 = _GDirectionAB;
  mediump vec4 directionCD_12;
  directionCD_12 = _GDirectionCD;
  mediump vec4 TIME_13;
  mediump vec3 offsets_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((steepness_9.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_16;
  tmpvar_16 = ((steepness_9.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_17;
  tmpvar_17.x = dot (directionAB_11.xy, vtxForAni_2.xz);
  tmpvar_17.y = dot (directionAB_11.zw, vtxForAni_2.xz);
  tmpvar_17.z = dot (directionCD_12.xy, vtxForAni_2.xz);
  tmpvar_17.w = dot (directionCD_12.zw, vtxForAni_2.xz);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (frequency_8 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (_Time.yyyy * speed_10);
  TIME_13 = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = cos((tmpvar_18 + TIME_13));
  mediump vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_15.xz;
  tmpvar_21.zw = tmpvar_16.xz;
  offsets_14.x = dot (tmpvar_20, tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22.xy = tmpvar_15.yw;
  tmpvar_22.zw = tmpvar_16.yw;
  offsets_14.z = dot (tmpvar_20, tmpvar_22);
  offsets_14.y = dot (sin((tmpvar_18 + TIME_13)), amplitude_7);
  mediump vec2 xzVtx_23;
  xzVtx_23 = (vtxForAni_2.xz + offsets_14.xz);
  mediump vec4 TIME_24;
  mediump vec3 nrml_25;
  nrml_25.y = 2.0;
  mediump vec4 tmpvar_26;
  tmpvar_26 = ((frequency_8.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_27;
  tmpvar_27 = ((frequency_8.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_28;
  tmpvar_28.x = dot (directionAB_11.xy, xzVtx_23);
  tmpvar_28.y = dot (directionAB_11.zw, xzVtx_23);
  tmpvar_28.z = dot (directionCD_12.xy, xzVtx_23);
  tmpvar_28.w = dot (directionCD_12.zw, xzVtx_23);
  highp vec4 tmpvar_29;
  tmpvar_29 = (_Time.yyyy * speed_10);
  TIME_24 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = cos(((frequency_8 * tmpvar_28) + TIME_24));
  mediump vec4 tmpvar_31;
  tmpvar_31.xy = tmpvar_26.xz;
  tmpvar_31.zw = tmpvar_27.xz;
  nrml_25.x = -(dot (tmpvar_30, tmpvar_31));
  mediump vec4 tmpvar_32;
  tmpvar_32.xy = tmpvar_26.yw;
  tmpvar_32.zw = tmpvar_27.yw;
  nrml_25.z = -(dot (tmpvar_30, tmpvar_32));
  nrml_25.xz = (nrml_25.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_33;
  tmpvar_33 = normalize(nrml_25);
  nrml_25 = tmpvar_33;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_14);
  highp vec4 tmpvar_34;
  tmpvar_34 = (glstate_matrix_mvp * tmpvar_1);
  highp vec4 o_35;
  highp vec4 tmpvar_36;
  tmpvar_36 = (tmpvar_34 * 0.5);
  highp vec2 tmpvar_37;
  tmpvar_37.x = tmpvar_36.x;
  tmpvar_37.y = (tmpvar_36.y * _ProjectionParams.x);
  o_35.xy = (tmpvar_37 + tmpvar_36.w);
  o_35.zw = tmpvar_34.zw;
  tmpvar_4.xyz = tmpvar_33;
  tmpvar_4.w = 1.0;
  gl_Position = tmpvar_34;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (worldSpaceVertex_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_35;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _InvFadeParemeter;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _ZBufferParams;
void main ()
{
  mediump vec4 baseColor_1;
  mediump float depth_2;
  mediump vec4 edgeBlendFactors_3;
  highp float nh_4;
  mediump vec3 h_5;
  mediump vec3 viewVector_6;
  mediump vec3 worldNormal_7;
  mediump vec4 coords_8;
  coords_8 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_9;
  vertexNormal_9 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_10;
  bumpStrength_10 = _DistortParams.x;
  mediump vec4 bump_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = (texture2D (_BumpMap, coords_8.xy) + texture2D (_BumpMap, coords_8.zw));
  bump_11 = tmpvar_12;
  bump_11.xy = (bump_11.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_13;
  tmpvar_13 = normalize((vertexNormal_9 + ((bump_11.xxy * bumpStrength_10) * vec3(1.0, 0.0, 1.0))));
  worldNormal_7.y = tmpvar_13.y;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(xlv_TEXCOORD1);
  viewVector_6 = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((_WorldLightDir.xyz + viewVector_6));
  h_5 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = max (0.0, dot (tmpvar_13, -(h_5)));
  nh_4 = tmpvar_16;
  lowp float tmpvar_17;
  tmpvar_17 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth_2 = tmpvar_17;
  highp float tmpvar_18;
  highp float z_19;
  z_19 = depth_2;
  tmpvar_18 = (1.0/(((_ZBufferParams.z * z_19) + _ZBufferParams.w)));
  depth_2 = tmpvar_18;
  highp vec4 tmpvar_20;
  tmpvar_20 = clamp ((_InvFadeParemeter * (depth_2 - xlv_TEXCOORD3.z)), 0.0, 1.0);
  edgeBlendFactors_3 = tmpvar_20;
  highp vec2 tmpvar_21;
  tmpvar_21 = (tmpvar_13.xz * _FresnelScale);
  worldNormal_7.xz = tmpvar_21;
  mediump float bias_22;
  bias_22 = _DistortParams.w;
  mediump float power_23;
  power_23 = _DistortParams.z;
  baseColor_1 = _ReflectionColor;
  highp vec4 tmpvar_24;
  tmpvar_24 = (baseColor_1 + (max (0.0, pow (nh_4, _Shininess)) * _SpecularColor));
  baseColor_1.xyz = tmpvar_24.xyz;
  baseColor_1.w = (edgeBlendFactors_3.x * clamp ((0.5 + clamp ((bias_22 + ((1.0 - bias_22) * pow (clamp ((1.0 - max (dot (-(viewVector_6), worldNormal_7), 0.0)), 0.0, 1.0), power_23))), 0.0, 1.0)), 0.0, 1.0));
  gl_FragData[0] = baseColor_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = _glesVertex.w;
  mediump vec3 vtxForAni_2;
  mediump vec3 worldSpaceVertex_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_3 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (worldSpaceVertex_3.xzz * unity_Scale.w);
  vtxForAni_2 = tmpvar_6;
  mediump vec4 amplitude_7;
  amplitude_7 = _GAmplitude;
  mediump vec4 frequency_8;
  frequency_8 = _GFrequency;
  mediump vec4 steepness_9;
  steepness_9 = _GSteepness;
  mediump vec4 speed_10;
  speed_10 = _GSpeed;
  mediump vec4 directionAB_11;
  directionAB_11 = _GDirectionAB;
  mediump vec4 directionCD_12;
  directionCD_12 = _GDirectionCD;
  mediump vec4 TIME_13;
  mediump vec3 offsets_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((steepness_9.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_16;
  tmpvar_16 = ((steepness_9.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_17;
  tmpvar_17.x = dot (directionAB_11.xy, vtxForAni_2.xz);
  tmpvar_17.y = dot (directionAB_11.zw, vtxForAni_2.xz);
  tmpvar_17.z = dot (directionCD_12.xy, vtxForAni_2.xz);
  tmpvar_17.w = dot (directionCD_12.zw, vtxForAni_2.xz);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (frequency_8 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (_Time.yyyy * speed_10);
  TIME_13 = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = cos((tmpvar_18 + TIME_13));
  mediump vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_15.xz;
  tmpvar_21.zw = tmpvar_16.xz;
  offsets_14.x = dot (tmpvar_20, tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22.xy = tmpvar_15.yw;
  tmpvar_22.zw = tmpvar_16.yw;
  offsets_14.z = dot (tmpvar_20, tmpvar_22);
  offsets_14.y = dot (sin((tmpvar_18 + TIME_13)), amplitude_7);
  mediump vec2 xzVtx_23;
  xzVtx_23 = (vtxForAni_2.xz + offsets_14.xz);
  mediump vec4 TIME_24;
  mediump vec3 nrml_25;
  nrml_25.y = 2.0;
  mediump vec4 tmpvar_26;
  tmpvar_26 = ((frequency_8.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_27;
  tmpvar_27 = ((frequency_8.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_28;
  tmpvar_28.x = dot (directionAB_11.xy, xzVtx_23);
  tmpvar_28.y = dot (directionAB_11.zw, xzVtx_23);
  tmpvar_28.z = dot (directionCD_12.xy, xzVtx_23);
  tmpvar_28.w = dot (directionCD_12.zw, xzVtx_23);
  highp vec4 tmpvar_29;
  tmpvar_29 = (_Time.yyyy * speed_10);
  TIME_24 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = cos(((frequency_8 * tmpvar_28) + TIME_24));
  mediump vec4 tmpvar_31;
  tmpvar_31.xy = tmpvar_26.xz;
  tmpvar_31.zw = tmpvar_27.xz;
  nrml_25.x = -(dot (tmpvar_30, tmpvar_31));
  mediump vec4 tmpvar_32;
  tmpvar_32.xy = tmpvar_26.yw;
  tmpvar_32.zw = tmpvar_27.yw;
  nrml_25.z = -(dot (tmpvar_30, tmpvar_32));
  nrml_25.xz = (nrml_25.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_33;
  tmpvar_33 = normalize(nrml_25);
  nrml_25 = tmpvar_33;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_14);
  highp vec4 tmpvar_34;
  tmpvar_34 = (glstate_matrix_mvp * tmpvar_1);
  highp vec4 o_35;
  highp vec4 tmpvar_36;
  tmpvar_36 = (tmpvar_34 * 0.5);
  highp vec2 tmpvar_37;
  tmpvar_37.x = tmpvar_36.x;
  tmpvar_37.y = (tmpvar_36.y * _ProjectionParams.x);
  o_35.xy = (tmpvar_37 + tmpvar_36.w);
  o_35.zw = tmpvar_34.zw;
  tmpvar_4.xyz = tmpvar_33;
  tmpvar_4.w = 1.0;
  gl_Position = tmpvar_34;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (worldSpaceVertex_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_35;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _InvFadeParemeter;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _ZBufferParams;
void main ()
{
  mediump vec4 baseColor_1;
  mediump float depth_2;
  mediump vec4 edgeBlendFactors_3;
  highp float nh_4;
  mediump vec3 h_5;
  mediump vec3 viewVector_6;
  mediump vec3 worldNormal_7;
  mediump vec4 coords_8;
  coords_8 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_9;
  vertexNormal_9 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_10;
  bumpStrength_10 = _DistortParams.x;
  mediump vec4 bump_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = (texture2D (_BumpMap, coords_8.xy) + texture2D (_BumpMap, coords_8.zw));
  bump_11 = tmpvar_12;
  bump_11.xy = (bump_11.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_13;
  tmpvar_13 = normalize((vertexNormal_9 + ((bump_11.xxy * bumpStrength_10) * vec3(1.0, 0.0, 1.0))));
  worldNormal_7.y = tmpvar_13.y;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(xlv_TEXCOORD1);
  viewVector_6 = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((_WorldLightDir.xyz + viewVector_6));
  h_5 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = max (0.0, dot (tmpvar_13, -(h_5)));
  nh_4 = tmpvar_16;
  lowp float tmpvar_17;
  tmpvar_17 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth_2 = tmpvar_17;
  highp float tmpvar_18;
  highp float z_19;
  z_19 = depth_2;
  tmpvar_18 = (1.0/(((_ZBufferParams.z * z_19) + _ZBufferParams.w)));
  depth_2 = tmpvar_18;
  highp vec4 tmpvar_20;
  tmpvar_20 = clamp ((_InvFadeParemeter * (depth_2 - xlv_TEXCOORD3.z)), 0.0, 1.0);
  edgeBlendFactors_3 = tmpvar_20;
  highp vec2 tmpvar_21;
  tmpvar_21 = (tmpvar_13.xz * _FresnelScale);
  worldNormal_7.xz = tmpvar_21;
  mediump float bias_22;
  bias_22 = _DistortParams.w;
  mediump float power_23;
  power_23 = _DistortParams.z;
  baseColor_1 = _ReflectionColor;
  highp vec4 tmpvar_24;
  tmpvar_24 = (baseColor_1 + (max (0.0, pow (nh_4, _Shininess)) * _SpecularColor));
  baseColor_1.xyz = tmpvar_24.xyz;
  baseColor_1.w = (edgeBlendFactors_3.x * clamp ((0.5 + clamp ((bias_22 + ((1.0 - bias_22) * pow (clamp ((1.0 - max (dot (-(viewVector_6), worldNormal_7), 0.0)), 0.0, 1.0), power_23))), 0.0, 1.0)), 0.0, 1.0));
  gl_FragData[0] = baseColor_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 485
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 495
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 504
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 348
#line 356
#line 379
#line 396
#line 408
#line 453
#line 474
#line 511
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 515
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 519
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 523
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 527
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 531
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 551
#line 579
#line 619
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 460
mediump vec3 GerstnerNormal4( in mediump vec2 xzVtx, in mediump vec4 amp, in mediump vec4 freq, in mediump vec4 speed, in mediump vec4 dirAB, in mediump vec4 dirCD ) {
    #line 462
    mediump vec3 nrml = vec3( 0.0, 2.0, 0.0);
    mediump vec4 AB = ((freq.xxyy * amp.xxyy) * dirAB.xyzw);
    mediump vec4 CD = ((freq.zzww * amp.zzww) * dirCD.xyzw);
    mediump vec4 dotABCD = (freq.xyzw * vec4( dot( dirAB.xy, xzVtx), dot( dirAB.zw, xzVtx), dot( dirCD.xy, xzVtx), dot( dirCD.zw, xzVtx)));
    #line 466
    mediump vec4 TIME = (_Time.yyyy * speed);
    mediump vec4 COS = cos((dotABCD + TIME));
    nrml.x -= dot( COS, vec4( AB.xz, CD.xz));
    nrml.z -= dot( COS, vec4( AB.yw, CD.yw));
    #line 470
    nrml.xz *= _GerstnerIntensity;
    nrml = normalize(nrml);
    return nrml;
}
#line 439
mediump vec3 GerstnerOffset4( in mediump vec2 xzVtx, in mediump vec4 steepness, in mediump vec4 amp, in mediump vec4 freq, in mediump vec4 speed, in mediump vec4 dirAB, in mediump vec4 dirCD ) {
    #line 441
    mediump vec3 offsets;
    mediump vec4 AB = ((steepness.xxyy * amp.xxyy) * dirAB.xyzw);
    mediump vec4 CD = ((steepness.zzww * amp.zzww) * dirCD.xyzw);
    mediump vec4 dotABCD = (freq.xyzw * vec4( dot( dirAB.xy, xzVtx), dot( dirAB.zw, xzVtx), dot( dirCD.xy, xzVtx), dot( dirCD.zw, xzVtx)));
    #line 445
    mediump vec4 TIME = (_Time.yyyy * speed);
    mediump vec4 COS = cos((dotABCD + TIME));
    mediump vec4 SIN = sin((dotABCD + TIME));
    offsets.x = dot( COS, vec4( AB.xz, CD.xz));
    #line 449
    offsets.z = dot( COS, vec4( AB.yw, CD.yw));
    offsets.y = dot( SIN, amp);
    return offsets;
}
#line 474
void Gerstner( out mediump vec3 offs, out mediump vec3 nrml, in mediump vec3 vtx, in mediump vec3 tileableVtx, in mediump vec4 amplitude, in mediump vec4 frequency, in mediump vec4 steepness, in mediump vec4 speed, in mediump vec4 directionAB, in mediump vec4 directionCD ) {
    offs = GerstnerOffset4( tileableVtx.xz, steepness, amplitude, frequency, speed, directionAB, directionCD);
    nrml = GerstnerNormal4( (tileableVtx.xz + offs.xz), amplitude, frequency, speed, directionAB, directionCD);
}
#line 579
v2f_noGrab vert300( in appdata_full v ) {
    v2f_noGrab o;
    mediump vec3 worldSpaceVertex = (_Object2World * v.vertex).xyz;
    #line 583
    mediump vec3 vtxForAni = (worldSpaceVertex.xzz * unity_Scale.w);
    mediump vec3 nrml;
    mediump vec3 offsets;
    Gerstner( offsets, nrml, v.vertex.xyz, vtxForAni, _GAmplitude, _GFrequency, _GSteepness, _GSpeed, _GDirectionAB, _GDirectionCD);
    #line 587
    v.vertex.xyz += offsets;
    mediump vec2 tileableUv = worldSpaceVertex.xz;
    o.bumpCoords.xyzw = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection.xyzw)) * _BumpTiling.xyzw);
    o.viewInterpolator.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
    #line 591
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.screenPos = ComputeScreenPos( o.pos);
    o.normalInterpolator.xyz = nrml;
    o.normalInterpolator.w = 1.0;
    #line 595
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_noGrab xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert300( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.normalInterpolator);
    xlv_TEXCOORD1 = vec3(xl_retval.viewInterpolator);
    xlv_TEXCOORD2 = vec4(xl_retval.bumpCoords);
    xlv_TEXCOORD3 = vec4(xl_retval.screenPos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 485
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 495
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 504
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 348
#line 356
#line 379
#line 396
#line 408
#line 453
#line 474
#line 511
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 515
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 519
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 523
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 527
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 531
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 551
#line 579
#line 619
#line 390
mediump float Fresnel( in mediump vec3 viewVector, in mediump vec3 worldNormal, in mediump float bias, in mediump float power ) {
    #line 392
    mediump float facing = clamp( (1.0 - max( dot( (-viewVector), worldNormal), 0.0)), 0.0, 1.0);
    mediump float refl2Refr = xll_saturate_f((bias + ((1.0 - bias) * pow( facing, power))));
    return refl2Refr;
}
#line 280
highp float LinearEyeDepth( in highp float z ) {
    #line 282
    return (1.0 / ((_ZBufferParams.z * z) + _ZBufferParams.w));
}
#line 316
mediump vec3 PerPixelNormal( in sampler2D bumpMap, in mediump vec4 coords, in mediump vec3 vertexNormal, in mediump float bumpStrength ) {
    mediump vec4 bump = (texture( bumpMap, coords.xy) + texture( bumpMap, coords.zw));
    #line 319
    bump.xy = (bump.wy - vec2( 1.0, 1.0));
    mediump vec3 worldNormal = (vertexNormal + ((bump.xxy * bumpStrength) * vec3( 1.0, 0.0, 1.0)));
    return normalize(worldNormal);
}
#line 597
mediump vec4 frag300( in v2f_noGrab i ) {
    #line 599
    mediump vec3 worldNormal = PerPixelNormal( _BumpMap, i.bumpCoords, i.normalInterpolator.xyz, _DistortParams.x);
    mediump vec3 viewVector = normalize(i.viewInterpolator.xyz);
    mediump vec4 distortOffset = vec4( ((worldNormal.xz * _DistortParams.y) * 10.0), 0.0, 0.0);
    mediump vec4 screenWithOffset = (i.screenPos + distortOffset);
    #line 603
    mediump vec3 reflectVector = normalize(reflect( viewVector, worldNormal));
    mediump vec3 h = normalize((_WorldLightDir.xyz + viewVector.xyz));
    highp float nh = max( 0.0, dot( worldNormal, (-h)));
    highp float spec = max( 0.0, pow( nh, _Shininess));
    #line 607
    mediump vec4 edgeBlendFactors = vec4( 1.0, 0.0, 0.0, 0.0);
    mediump float depth = textureProj( _CameraDepthTexture, i.screenPos).x;
    depth = LinearEyeDepth( depth);
    edgeBlendFactors = xll_saturate_vf4((_InvFadeParemeter * (depth - i.screenPos.z)));
    #line 611
    worldNormal.xz *= _FresnelScale;
    mediump float refl2Refr = Fresnel( viewVector, worldNormal, _DistortParams.w, _DistortParams.z);
    mediump vec4 baseColor = _BaseColor;
    baseColor = _ReflectionColor;
    #line 615
    baseColor = (baseColor + (spec * _SpecularColor));
    baseColor.w = (edgeBlendFactors.x * xll_saturate_f((0.5 + (refl2Refr * 1.0))));
    return baseColor;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    mediump vec4 xl_retval;
    v2f_noGrab xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.normalInterpolator = vec4(xlv_TEXCOORD0);
    xlt_i.viewInterpolator = vec3(xlv_TEXCOORD1);
    xlt_i.bumpCoords = vec4(xlv_TEXCOORD2);
    xlt_i.screenPos = vec4(xlv_TEXCOORD3);
    xl_retval = frag300( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GSpeed;
uniform vec4 _GSteepness;
uniform vec4 _GFrequency;
uniform vec4 _GAmplitude;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform float _GerstnerIntensity;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = gl_Vertex.w;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec3 offsets_5;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, tmpvar_4.xz);
  tmpvar_8.y = dot (_GDirectionAB.zw, tmpvar_4.xz);
  tmpvar_8.z = dot (_GDirectionCD.xy, tmpvar_4.xz);
  tmpvar_8.w = dot (_GDirectionCD.zw, tmpvar_4.xz);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_5.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_5.z = dot (tmpvar_11, tmpvar_13);
  offsets_5.y = dot (sin((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_14;
  xzVtx_14 = (tmpvar_4.xz + offsets_5.xz);
  vec3 nrml_15;
  nrml_15.y = 2.0;
  vec4 tmpvar_16;
  tmpvar_16 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_17;
  tmpvar_17 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_18;
  tmpvar_18.x = dot (_GDirectionAB.xy, xzVtx_14);
  tmpvar_18.y = dot (_GDirectionAB.zw, xzVtx_14);
  tmpvar_18.z = dot (_GDirectionCD.xy, xzVtx_14);
  tmpvar_18.w = dot (_GDirectionCD.zw, xzVtx_14);
  vec4 tmpvar_19;
  tmpvar_19 = cos(((_GFrequency * tmpvar_18) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_16.xz;
  tmpvar_20.zw = tmpvar_17.xz;
  nrml_15.x = -(dot (tmpvar_19, tmpvar_20));
  vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_16.yw;
  tmpvar_21.zw = tmpvar_17.yw;
  nrml_15.z = -(dot (tmpvar_19, tmpvar_21));
  nrml_15.xz = (nrml_15.xz * _GerstnerIntensity);
  vec3 tmpvar_22;
  tmpvar_22 = normalize(nrml_15);
  nrml_15 = tmpvar_22;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_5);
  vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 o_24;
  vec4 tmpvar_25;
  tmpvar_25 = (tmpvar_23 * 0.5);
  vec2 tmpvar_26;
  tmpvar_26.x = tmpvar_25.x;
  tmpvar_26.y = (tmpvar_25.y * _ProjectionParams.x);
  o_24.xy = (tmpvar_26 + tmpvar_25.w);
  o_24.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_22;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_24;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.0, 0.0);
  tmpvar_7.xy = ((tmpvar_5.xz * _DistortParams.y) * 10.0);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  float tmpvar_8;
  tmpvar_8 = clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0);
  baseColor_1.xyz = (mix (_BaseColor, mix (texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_7)), _ReflectionColor, _ReflectionColor.wwww), vec4(clamp (tmpvar_8, 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = clamp ((0.5 + tmpvar_8), 0.0, 1.0);
  gl_FragData[0] = baseColor_1;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 12 [unity_Scale]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 187 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c12.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r3.zw, r3.xyyw
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o1.xyz, r0.w, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
mov r1.w, v0
add r1.xyz, v0, r4
dp4 r2.w, r1, c3
dp4 r2.z, r1, c2
dp4 r2.x, r1, c0
dp4 r2.y, r1, c1
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c10.x
mad o4.xy, r3.z, c11.zwzw, r0
mov r0.x, c8
mad r0, c15, r0.x, r7.xzxz
mov o0, r2
mov o4.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c9
mov o1.w, c23.y
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Vector 15 [_BumpDirection]
Vector 14 [_BumpTiling]
Vector 16 [_GAmplitude]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
Vector 17 [_GFrequency]
Vector 19 [_GSpeed]
Vector 18 [_GSteepness]
Float 13 [_GerstnerIntensity]
Matrix 8 [_Object2World] 4
Vector 2 [_ProjectionParams]
Vector 3 [_ScreenParams]
Vector 0 [_Time]
Vector 1 [_WorldSpaceCameraPos]
Matrix 4 [glstate_matrix_mvp] 4
Vector 12 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 69.33 (52 instructions), vertex: 32, texture: 0,
//   sequencer: 24,  10 GPRs, 18 threads,
// Performance (if enough threads): ~69 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaaddeaaaaadbaaaaaaaaaaaaaaaceaaaaaclmaaaaacoeaaaaaaaa
aaaaaaaaaaaaacjeaaaaaabmaaaaacigpppoadaaaaaaaabaaaaaaabmaaaaaaaa
aaaaachpaaaaabfmaaacaaapaaabaaaaaaaaabgmaaaaaaaaaaaaabhmaaacaaao
aaabaaaaaaaaabgmaaaaaaaaaaaaabiiaaacaabaaaabaaaaaaaaabgmaaaaaaaa
aaaaabjeaaacaabeaaabaaaaaaaaabgmaaaaaaaaaaaaabkcaaacaabfaaabaaaa
aaaaabgmaaaaaaaaaaaaablaaaacaabbaaabaaaaaaaaabgmaaaaaaaaaaaaablm
aaacaabdaaabaaaaaaaaabgmaaaaaaaaaaaaabmeaaacaabcaaabaaaaaaaaabgm
aaaaaaaaaaaaabnaaaacaaanaaabaaaaaaaaaboeaaaaaaaaaaaaabpeaaacaaai
aaaeaaaaaaaaacaeaaaaaaaaaaaaacbeaaacaaacaaabaaaaaaaaabgmaaaaaaaa
aaaaaccgaaacaaadaaabaaaaaaaaabgmaaaaaaaaaaaaacdeaaacaaaaaaabaaaa
aaaaabgmaaaaaaaaaaaaacdkaaacaaabaaabaaaaaaaaacfaaaaaaaaaaaaaacga
aaacaaaeaaaeaaaaaaaaacaeaaaaaaaaaaaaachdaaacaaamaaabaaaaaaaaabgm
aaaaaaaafpechfgnhaeegjhcgfgdhegjgpgoaaklaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpechfgnhafegjgmgjgoghaafpehebgnhagmgjhehfgegfaafpeheegj
hcgfgdhegjgpgoebecaafpeheegjhcgfgdhegjgpgoedeeaafpeheghcgfhbhfgf
gogdhjaafpehfdhagfgfgeaafpehfdhegfgfhagogfhdhdaafpehgfhchdhegogf
hcejgohegfgohdgjhehjaaklaaaaaaadaaabaaabaaabaaaaaaaaaaaafpepgcgk
gfgdhedcfhgphcgmgeaaklklaaadaaadaaaeaaaeaaabaaaaaaaaaaaafpfahcgp
gkgfgdhegjgpgofagbhcgbgnhdaafpfdgdhcgfgfgofagbhcgbgnhdaafpfegjgn
gfaafpfhgphcgmgefdhagbgdgfedgbgngfhcgbfagphdaaklaaabaaadaaabaaad
aaabaaaaaaaaaaaaghgmhdhegbhegffpgngbhehcgjhifpgnhghaaahfgogjhehj
fpfdgdgbgmgfaahghdfpddfpdaaadccodacodcdadddfddcodaaaklklaaaaaaaa
aaaaaaabaaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaeaaaaaacnaaadbaaajaaaaaaaaaaaaaaaaaaaadmieaaaaaaab
aaaaaaabaaaaaaafaaaaacjaaaaaaaagaaaapafaaaabhbfbaaacpcfcaaadpdfd
aaaabadkaaaabaclaaaabacmaaaaaackaaaabacpaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaamaejapnldpaaaaaaeaiaaaaa
doccpjideamjapnlaaaaaaaaaaaaaaaaaaaaaaaabaabbaagaaaabcaamcaaaaaa
aaaagaahgaanbcaabcaaaaaaaaaagabdgabjbcaabcaaaaaaaaaaeabpaaaabcaa
meaaaaaaaaaagacdgacjbcaabcaaaaaaaaaagacpgadfbcaaccaaaaaaafpifaaa
aaaaagiiaaaaaaaamiapaaaaaalbaaaacbaabdaamiahaaabaablleaakbafalaa
miahaaabaamgmaleklafakabmiahaaabaalbleleklafajabmiahaaaeaagmmale
klafaiabmiadaaabaameblaakbaeamaamiapaaadaalmdeaakbabbeaaaabpacag
aalmdeggkbabbfadaacmacacaakmaglloaagagadmiapaaacaaaaaaaaklacbbaa
miapaaacaaaabllbilacpopomiapaaacaaaaaaaaoiacaaaamiapaaaiaaaagmgm
ilacpppomabpadagaaaaaagmcbbcbaaimacpadacaabliilbkbafahaimaepadah
aaakdemgkbagbfaimaipadajaakadeblkbagbeaimeicabagaakhkhlbkpadbaai
meepabadaaaaaagmcbbbbaaimebpagajaaanahmgobajabaimeimagabaapbcmbl
oaajajaimiaeaaagaabkbiblpbahagabmiabaaagaalabimgpbahagabmiahaaaf
aamamaaaoaagafaamiapaaacaamgnapiklafagacmiapaaacaalbdepiklafafac
miapaaafaagmnajeklafaeacmiapiadoaananaaaocafafaamiapaaacaagmkhoo
claaapaemiadaaabaamelaaaoaagabaamiapaaagaalmdeaakbabbeaaaabpabah
aalmdeggkbabbfagaacmababaakmaglloaahahagmiapaaabaaaaaaaaklabbbaa
miahaaaaaamalbaakbafpoaamiamiaadaanlnlaaocafafaamiahiaabacmamaaa
kaaeabaamiapiaacaahkaaaakbacaoaamiapaaabaaaabllbilabpopokiipaaab
aaaaaaebmiabaaacmiadiaadaamgbkbiklaaadaamiapaaabaaaagmgmilabpppo
mebdabacaalabjgmkbadbeabmecmabacaaagdblbkbadbfabmeedabaaaalamemg
kbadbeabmeimabaaaaagomblkbadbfabmiabaaaaaakhkhaaopaaabaamiacaaaa
aakhkhaaopacabaamiagaaaaaelmgmaakbaaanaamiabaaaaaalclcmgnbaaaapo
fibaaaaaaaaaaagmocaaaaiaaaknmaaaaamfgmgmobaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Matrix 256 [glstate_matrix_mvp]
Bind "vertex" Vertex
Vector 467 [_Time]
Vector 466 [_WorldSpaceCameraPos]
Vector 465 [_ProjectionParams]
Matrix 260 [_Object2World]
Vector 464 [unity_Scale]
Float 463 [_GerstnerIntensity]
Vector 462 [_BumpTiling]
Vector 461 [_BumpDirection]
Vector 460 [_GAmplitude]
Vector 459 [_GFrequency]
Vector 458 [_GSteepness]
Vector 457 [_GSpeed]
Vector 456 [_GDirectionAB]
Vector 455 [_GDirectionCD]
"sce_vp_rsx // 57 instructions using 13 registers
[Configuration]
8
0000003900010d00
[Defaults]
1
454 3
3f800000400000003f000000
[Microcode]
912
00001c6c005cc00d8186c0836041fffc00009c6c005d30080186c08360419ffc
401f9c6c005c60000186c08360403f9c00061c6c005c602a8186c08360409ffc
00051c6c0040007f8106c08360403ffc00031c6c01d0600d8106c0c360405ffc
00031c6c01d0500d8106c0c360409ffc00031c6c01d0400d8106c0c360411ffc
401f9c6c00dd208c0186c0830321dfa000039c6c009cb0138089c0c36041fffc
00011c6c009ca0138089c0c36041fffc00001c6c011cd0000286c0c44321fffc
00009c6c009c902a8286c0c36041fffc00021c6c009c702f8486c0c36041fffc
00019c6c009c80050486c0c36041fffc00029c6c009c702f8e86c0c36041fffc
00049c6c009d00100cbfc0c360419ffc00031c6c009c70089286c0c36041fffc
00011c6c009c80089286c0c36041fffc00011c6c00c000100486c08ea1219ffc
00011c6c00c000010c86c08ae3207ffc00031c6c009c80050e86c0c36041fffc
00011c6c009cb00d8486c0c36041fffc00011c6c00c0000d8486c08360a1fffc
401f9c6c009ce00d8086c0c36041ffa400001c6c784000100c86c0800131847c
00001c6c804000010a86c080013063fc00059c6c7840003a8c86c08aa129847c
00031c6c804000100686c08aa12983fc00031c6c804000010886c095412463fc
00019c6c8040003a8686c09fe12383fc00019c6c7840002b8886c0954124647c
00019c6c79c0000d8e86c35fe122447c00019c6c01c0000d8e86c64360411ffc
00019c6c01dcc00d9086c0c360409ffc00051c6c00c0000c0106c08301a1dffc
00011c6c00c000081286c08401a19ffc00021c6c01d0300d9486c0c360403ffc
00019c6c009c70088486c0c36041fffc00011c6c009c80088486c0c36041fffc
00011c6c00c000100486c08ea1219ffc00011c6c00c000010686c08ae1a07ffc
00009c6c011cb00d8486c0c360a1fffc00021c6c01d0200d9486c0c360405ffc
00021c6c81d0100d9486c0c000b080fc00021c6c81d0000d9486c0caa0a900fc
00059c6c8040002b8a86c09540a460fc401f9c6c8040000d8886c09fe0a3e080
401f9c6c004000558886c08360407fa800011c6c01c0000d8286cb4360409ffc
00011c6c01c0000d8286c04360411ffc00001c6c009c600e08aa80c36041dffc
00061c6c009cf082048000c360415ffc00009c6c0140000c18860c4360411ffc
00001c6c209d102a808000c000b080fc401f9c6c00c000080086c09540219fa8
401f9c6c0080000002860c436041df9d
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304 // 304 used size, 19 vars
Float 16 [_GerstnerIntensity]
Vector 176 [_BumpTiling] 4
Vector 192 [_BumpDirection] 4
Vector 208 [_GAmplitude] 4
Vector 224 [_GFrequency] 4
Vector 240 [_GSteepness] 4
Vector 256 [_GSpeed] 4
Vector 272 [_GDirectionAB] 4
Vector 288 [_GDirectionCD] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 0 [_Time] 4
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 59 instructions, 7 temp regs, 0 temp arrays:
// ALU 47 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedglgdjnccceaelhpdglkfonphjipohkojabaaaaaabeajaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefchiahaaaaeaaaabaa
noabaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaa
giaaaaacahaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaa
apaaaaaibcaabaaaacaaaaaaegiacaaaaaaaaaaabbaaaaaaegaabaaaabaaaaaa
apaaaaaiccaabaaaacaaaaaaogikcaaaaaaaaaaabbaaaaaaegaabaaaabaaaaaa
apaaaaaiecaabaaaacaaaaaaegiacaaaaaaaaaaabcaaaaaaegaabaaaabaaaaaa
apaaaaaiicaabaaaacaaaaaaogikcaaaaaaaaaaabcaaaaaaegaabaaaabaaaaaa
diaaaaajpcaabaaaabaaaaaaegiocaaaaaaaaaaabaaaaaaafgifcaaaabaaaaaa
aaaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaaaaaaaaaaoaaaaaaegaobaaa
acaaaaaaegaobaaaabaaaaaaenaaaaahpcaabaaaacaaaaaapcaabaaaadaaaaaa
egaobaaaacaaaaaabbaaaaaiccaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaa
aaaaaaaaanaaaaaadiaaaaajpcaabaaaaeaaaaaaegiocaaaaaaaaaaaanaaaaaa
egiocaaaaaaaaaaaapaaaaaadiaaaaaipcaabaaaafaaaaaaegaebaaaaeaaaaaa
ngiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaeaaaaaakgapbaaaaeaaaaaa
egiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaagaaaaaaogakbaaaafaaaaaa
dgaaaaafmcaabaaaagaaaaaaagaibaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaa
fganbaaaaeaaaaaabbaaaaahecaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaa
afaaaaaabbaaaaahbcaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaaagaaaaaa
aaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaaegbcbaaaaaaaaaaadcaaaaak
dcaabaaaacaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaaigaabaaa
acaaaaaadiaaaaaipcaabaaaaeaaaaaafgafbaaaadaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaeaaaaaaegiocaaaacaaaaaaaaaaaaaaagaabaaa
adaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaaegiocaaaacaaaaaa
acaaaaaakgakbaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaadaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaadaaaaaaapaaaaaibcaabaaaaeaaaaaaegiacaaa
aaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiccaabaaaaeaaaaaaogikcaaa
aaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiecaabaaaaeaaaaaaegiacaaa
aaaaaaaabcaaaaaaegaabaaaacaaaaaaapaaaaaiicaabaaaaeaaaaaaogikcaaa
aaaaaaaabcaaaaaaegaabaaaacaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
aaaaaaaaaoaaaaaaegaobaaaaeaaaaaaegaobaaaabaaaaaaenaaaaagaanaaaaa
pcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaajpcaabaaaacaaaaaaegiocaaa
aaaaaaaaanaaaaaaegiocaaaaaaaaaaaaoaaaaaadiaaaaaipcaabaaaaeaaaaaa
egaebaaaacaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaacaaaaaa
kgapbaaaacaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaafaaaaaa
ogakbaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaaagaibaaaacaaaaaadgaaaaaf
mcaabaaaaeaaaaaafganbaaaacaaaaaabbaaaaahicaabaaaaaaaaaaaegaobaaa
abaaaaaaegaobaaaaeaaaaaabbaaaaahbcaabaaaabaaaaaaegaobaaaabaaaaaa
egaobaaaafaaaaaadgaaaaagbcaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaa
dgaaaaagecaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadiaaaaaifcaabaaa
abaaaaaaagacbaaaabaaaaaaagiacaaaaaaaaaaaabaaaaaadgaaaaafccaabaaa
abaaaaaaabeaaaaaaaaaaaeabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hccabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaa
abaaaaaaabeaaaaaaaaaiadpaaaaaaajhccabaaaacaaaaaaegacbaaaaaaaaaaa
egiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaaaaaaaaaagiacaaa
abaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaaaaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaadiaaaaai
bcaabaaaaaaaaaaabkaabaaaadaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaah
icaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdiaaaaakfcaabaaa
aaaaaaaaagadbaaaadaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaaaa
dgaaaaafmccabaaaaeaaaaaakgaobaaaadaaaaaaaaaaaaahdccabaaaaeaaaaaa
kgakbaaaaaaaaaaamgaabaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = _glesVertex.w;
  mediump vec3 vtxForAni_2;
  mediump vec3 worldSpaceVertex_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_3 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (worldSpaceVertex_3.xzz * unity_Scale.w);
  vtxForAni_2 = tmpvar_6;
  mediump vec4 amplitude_7;
  amplitude_7 = _GAmplitude;
  mediump vec4 frequency_8;
  frequency_8 = _GFrequency;
  mediump vec4 steepness_9;
  steepness_9 = _GSteepness;
  mediump vec4 speed_10;
  speed_10 = _GSpeed;
  mediump vec4 directionAB_11;
  directionAB_11 = _GDirectionAB;
  mediump vec4 directionCD_12;
  directionCD_12 = _GDirectionCD;
  mediump vec4 TIME_13;
  mediump vec3 offsets_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((steepness_9.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_16;
  tmpvar_16 = ((steepness_9.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_17;
  tmpvar_17.x = dot (directionAB_11.xy, vtxForAni_2.xz);
  tmpvar_17.y = dot (directionAB_11.zw, vtxForAni_2.xz);
  tmpvar_17.z = dot (directionCD_12.xy, vtxForAni_2.xz);
  tmpvar_17.w = dot (directionCD_12.zw, vtxForAni_2.xz);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (frequency_8 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (_Time.yyyy * speed_10);
  TIME_13 = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = cos((tmpvar_18 + TIME_13));
  mediump vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_15.xz;
  tmpvar_21.zw = tmpvar_16.xz;
  offsets_14.x = dot (tmpvar_20, tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22.xy = tmpvar_15.yw;
  tmpvar_22.zw = tmpvar_16.yw;
  offsets_14.z = dot (tmpvar_20, tmpvar_22);
  offsets_14.y = dot (sin((tmpvar_18 + TIME_13)), amplitude_7);
  mediump vec2 xzVtx_23;
  xzVtx_23 = (vtxForAni_2.xz + offsets_14.xz);
  mediump vec4 TIME_24;
  mediump vec3 nrml_25;
  nrml_25.y = 2.0;
  mediump vec4 tmpvar_26;
  tmpvar_26 = ((frequency_8.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_27;
  tmpvar_27 = ((frequency_8.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_28;
  tmpvar_28.x = dot (directionAB_11.xy, xzVtx_23);
  tmpvar_28.y = dot (directionAB_11.zw, xzVtx_23);
  tmpvar_28.z = dot (directionCD_12.xy, xzVtx_23);
  tmpvar_28.w = dot (directionCD_12.zw, xzVtx_23);
  highp vec4 tmpvar_29;
  tmpvar_29 = (_Time.yyyy * speed_10);
  TIME_24 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = cos(((frequency_8 * tmpvar_28) + TIME_24));
  mediump vec4 tmpvar_31;
  tmpvar_31.xy = tmpvar_26.xz;
  tmpvar_31.zw = tmpvar_27.xz;
  nrml_25.x = -(dot (tmpvar_30, tmpvar_31));
  mediump vec4 tmpvar_32;
  tmpvar_32.xy = tmpvar_26.yw;
  tmpvar_32.zw = tmpvar_27.yw;
  nrml_25.z = -(dot (tmpvar_30, tmpvar_32));
  nrml_25.xz = (nrml_25.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_33;
  tmpvar_33 = normalize(nrml_25);
  nrml_25 = tmpvar_33;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_14);
  highp vec4 tmpvar_34;
  tmpvar_34 = (glstate_matrix_mvp * tmpvar_1);
  highp vec4 o_35;
  highp vec4 tmpvar_36;
  tmpvar_36 = (tmpvar_34 * 0.5);
  highp vec2 tmpvar_37;
  tmpvar_37.x = tmpvar_36.x;
  tmpvar_37.y = (tmpvar_36.y * _ProjectionParams.x);
  o_35.xy = (tmpvar_37 + tmpvar_36.w);
  o_35.zw = tmpvar_34.zw;
  tmpvar_4.xyz = tmpvar_33;
  tmpvar_4.w = 1.0;
  gl_Position = tmpvar_34;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (worldSpaceVertex_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_35;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
void main ()
{
  mediump vec4 baseColor_1;
  highp float nh_2;
  mediump vec3 h_3;
  mediump vec4 rtReflections_4;
  mediump vec4 screenWithOffset_5;
  mediump vec4 distortOffset_6;
  mediump vec3 viewVector_7;
  mediump vec3 worldNormal_8;
  mediump vec4 coords_9;
  coords_9 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_10;
  vertexNormal_10 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_11;
  bumpStrength_11 = _DistortParams.x;
  mediump vec4 bump_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = (texture2D (_BumpMap, coords_9.xy) + texture2D (_BumpMap, coords_9.zw));
  bump_12 = tmpvar_13;
  bump_12.xy = (bump_12.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize((vertexNormal_10 + ((bump_12.xxy * bumpStrength_11) * vec3(1.0, 0.0, 1.0))));
  worldNormal_8.y = tmpvar_14.y;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(xlv_TEXCOORD1);
  viewVector_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, 0.0);
  tmpvar_16.xy = ((tmpvar_14.xz * _DistortParams.y) * 10.0);
  distortOffset_6 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17 = (xlv_TEXCOORD3 + distortOffset_6);
  screenWithOffset_5 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2DProj (_ReflectionTex, screenWithOffset_5);
  rtReflections_4 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((_WorldLightDir.xyz + viewVector_7));
  h_3 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = max (0.0, dot (tmpvar_14, -(h_3)));
  nh_2 = tmpvar_20;
  highp vec2 tmpvar_21;
  tmpvar_21 = (tmpvar_14.xz * _FresnelScale);
  worldNormal_8.xz = tmpvar_21;
  mediump float bias_22;
  bias_22 = _DistortParams.w;
  mediump float power_23;
  power_23 = _DistortParams.z;
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((bias_22 + ((1.0 - bias_22) * pow (clamp ((1.0 - max (dot (-(viewVector_7), worldNormal_8), 0.0)), 0.0, 1.0), power_23))), 0.0, 1.0);
  baseColor_1 = _BaseColor;
  mediump float tmpvar_25;
  tmpvar_25 = clamp (tmpvar_24, 0.0, 1.0);
  highp vec4 tmpvar_26;
  tmpvar_26 = mix (baseColor_1, mix (rtReflections_4, _ReflectionColor, _ReflectionColor.wwww), vec4(tmpvar_25));
  baseColor_1 = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (baseColor_1 + (max (0.0, pow (nh_2, _Shininess)) * _SpecularColor));
  baseColor_1.xyz = tmpvar_27.xyz;
  baseColor_1.w = clamp ((0.5 + tmpvar_24), 0.0, 1.0);
  gl_FragData[0] = baseColor_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = _glesVertex.w;
  mediump vec3 vtxForAni_2;
  mediump vec3 worldSpaceVertex_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_3 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (worldSpaceVertex_3.xzz * unity_Scale.w);
  vtxForAni_2 = tmpvar_6;
  mediump vec4 amplitude_7;
  amplitude_7 = _GAmplitude;
  mediump vec4 frequency_8;
  frequency_8 = _GFrequency;
  mediump vec4 steepness_9;
  steepness_9 = _GSteepness;
  mediump vec4 speed_10;
  speed_10 = _GSpeed;
  mediump vec4 directionAB_11;
  directionAB_11 = _GDirectionAB;
  mediump vec4 directionCD_12;
  directionCD_12 = _GDirectionCD;
  mediump vec4 TIME_13;
  mediump vec3 offsets_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((steepness_9.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_16;
  tmpvar_16 = ((steepness_9.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_17;
  tmpvar_17.x = dot (directionAB_11.xy, vtxForAni_2.xz);
  tmpvar_17.y = dot (directionAB_11.zw, vtxForAni_2.xz);
  tmpvar_17.z = dot (directionCD_12.xy, vtxForAni_2.xz);
  tmpvar_17.w = dot (directionCD_12.zw, vtxForAni_2.xz);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (frequency_8 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (_Time.yyyy * speed_10);
  TIME_13 = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = cos((tmpvar_18 + TIME_13));
  mediump vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_15.xz;
  tmpvar_21.zw = tmpvar_16.xz;
  offsets_14.x = dot (tmpvar_20, tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22.xy = tmpvar_15.yw;
  tmpvar_22.zw = tmpvar_16.yw;
  offsets_14.z = dot (tmpvar_20, tmpvar_22);
  offsets_14.y = dot (sin((tmpvar_18 + TIME_13)), amplitude_7);
  mediump vec2 xzVtx_23;
  xzVtx_23 = (vtxForAni_2.xz + offsets_14.xz);
  mediump vec4 TIME_24;
  mediump vec3 nrml_25;
  nrml_25.y = 2.0;
  mediump vec4 tmpvar_26;
  tmpvar_26 = ((frequency_8.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_27;
  tmpvar_27 = ((frequency_8.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_28;
  tmpvar_28.x = dot (directionAB_11.xy, xzVtx_23);
  tmpvar_28.y = dot (directionAB_11.zw, xzVtx_23);
  tmpvar_28.z = dot (directionCD_12.xy, xzVtx_23);
  tmpvar_28.w = dot (directionCD_12.zw, xzVtx_23);
  highp vec4 tmpvar_29;
  tmpvar_29 = (_Time.yyyy * speed_10);
  TIME_24 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = cos(((frequency_8 * tmpvar_28) + TIME_24));
  mediump vec4 tmpvar_31;
  tmpvar_31.xy = tmpvar_26.xz;
  tmpvar_31.zw = tmpvar_27.xz;
  nrml_25.x = -(dot (tmpvar_30, tmpvar_31));
  mediump vec4 tmpvar_32;
  tmpvar_32.xy = tmpvar_26.yw;
  tmpvar_32.zw = tmpvar_27.yw;
  nrml_25.z = -(dot (tmpvar_30, tmpvar_32));
  nrml_25.xz = (nrml_25.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_33;
  tmpvar_33 = normalize(nrml_25);
  nrml_25 = tmpvar_33;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_14);
  highp vec4 tmpvar_34;
  tmpvar_34 = (glstate_matrix_mvp * tmpvar_1);
  highp vec4 o_35;
  highp vec4 tmpvar_36;
  tmpvar_36 = (tmpvar_34 * 0.5);
  highp vec2 tmpvar_37;
  tmpvar_37.x = tmpvar_36.x;
  tmpvar_37.y = (tmpvar_36.y * _ProjectionParams.x);
  o_35.xy = (tmpvar_37 + tmpvar_36.w);
  o_35.zw = tmpvar_34.zw;
  tmpvar_4.xyz = tmpvar_33;
  tmpvar_4.w = 1.0;
  gl_Position = tmpvar_34;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (worldSpaceVertex_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_35;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
void main ()
{
  mediump vec4 baseColor_1;
  highp float nh_2;
  mediump vec3 h_3;
  mediump vec4 rtReflections_4;
  mediump vec4 screenWithOffset_5;
  mediump vec4 distortOffset_6;
  mediump vec3 viewVector_7;
  mediump vec3 worldNormal_8;
  mediump vec4 coords_9;
  coords_9 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_10;
  vertexNormal_10 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_11;
  bumpStrength_11 = _DistortParams.x;
  mediump vec4 bump_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = (texture2D (_BumpMap, coords_9.xy) + texture2D (_BumpMap, coords_9.zw));
  bump_12 = tmpvar_13;
  bump_12.xy = (bump_12.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize((vertexNormal_10 + ((bump_12.xxy * bumpStrength_11) * vec3(1.0, 0.0, 1.0))));
  worldNormal_8.y = tmpvar_14.y;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(xlv_TEXCOORD1);
  viewVector_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, 0.0);
  tmpvar_16.xy = ((tmpvar_14.xz * _DistortParams.y) * 10.0);
  distortOffset_6 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17 = (xlv_TEXCOORD3 + distortOffset_6);
  screenWithOffset_5 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2DProj (_ReflectionTex, screenWithOffset_5);
  rtReflections_4 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((_WorldLightDir.xyz + viewVector_7));
  h_3 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = max (0.0, dot (tmpvar_14, -(h_3)));
  nh_2 = tmpvar_20;
  highp vec2 tmpvar_21;
  tmpvar_21 = (tmpvar_14.xz * _FresnelScale);
  worldNormal_8.xz = tmpvar_21;
  mediump float bias_22;
  bias_22 = _DistortParams.w;
  mediump float power_23;
  power_23 = _DistortParams.z;
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((bias_22 + ((1.0 - bias_22) * pow (clamp ((1.0 - max (dot (-(viewVector_7), worldNormal_8), 0.0)), 0.0, 1.0), power_23))), 0.0, 1.0);
  baseColor_1 = _BaseColor;
  mediump float tmpvar_25;
  tmpvar_25 = clamp (tmpvar_24, 0.0, 1.0);
  highp vec4 tmpvar_26;
  tmpvar_26 = mix (baseColor_1, mix (rtReflections_4, _ReflectionColor, _ReflectionColor.wwww), vec4(tmpvar_25));
  baseColor_1 = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (baseColor_1 + (max (0.0, pow (nh_2, _Shininess)) * _SpecularColor));
  baseColor_1.xyz = tmpvar_27.xyz;
  baseColor_1.w = clamp ((0.5 + tmpvar_24), 0.0, 1.0);
  gl_FragData[0] = baseColor_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 485
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 495
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 504
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 348
#line 356
#line 379
#line 396
#line 408
#line 453
#line 474
#line 511
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 515
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 519
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 523
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 527
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 531
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 551
#line 576
#line 624
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 460
mediump vec3 GerstnerNormal4( in mediump vec2 xzVtx, in mediump vec4 amp, in mediump vec4 freq, in mediump vec4 speed, in mediump vec4 dirAB, in mediump vec4 dirCD ) {
    #line 462
    mediump vec3 nrml = vec3( 0.0, 2.0, 0.0);
    mediump vec4 AB = ((freq.xxyy * amp.xxyy) * dirAB.xyzw);
    mediump vec4 CD = ((freq.zzww * amp.zzww) * dirCD.xyzw);
    mediump vec4 dotABCD = (freq.xyzw * vec4( dot( dirAB.xy, xzVtx), dot( dirAB.zw, xzVtx), dot( dirCD.xy, xzVtx), dot( dirCD.zw, xzVtx)));
    #line 466
    mediump vec4 TIME = (_Time.yyyy * speed);
    mediump vec4 COS = cos((dotABCD + TIME));
    nrml.x -= dot( COS, vec4( AB.xz, CD.xz));
    nrml.z -= dot( COS, vec4( AB.yw, CD.yw));
    #line 470
    nrml.xz *= _GerstnerIntensity;
    nrml = normalize(nrml);
    return nrml;
}
#line 439
mediump vec3 GerstnerOffset4( in mediump vec2 xzVtx, in mediump vec4 steepness, in mediump vec4 amp, in mediump vec4 freq, in mediump vec4 speed, in mediump vec4 dirAB, in mediump vec4 dirCD ) {
    #line 441
    mediump vec3 offsets;
    mediump vec4 AB = ((steepness.xxyy * amp.xxyy) * dirAB.xyzw);
    mediump vec4 CD = ((steepness.zzww * amp.zzww) * dirCD.xyzw);
    mediump vec4 dotABCD = (freq.xyzw * vec4( dot( dirAB.xy, xzVtx), dot( dirAB.zw, xzVtx), dot( dirCD.xy, xzVtx), dot( dirCD.zw, xzVtx)));
    #line 445
    mediump vec4 TIME = (_Time.yyyy * speed);
    mediump vec4 COS = cos((dotABCD + TIME));
    mediump vec4 SIN = sin((dotABCD + TIME));
    offsets.x = dot( COS, vec4( AB.xz, CD.xz));
    #line 449
    offsets.z = dot( COS, vec4( AB.yw, CD.yw));
    offsets.y = dot( SIN, amp);
    return offsets;
}
#line 474
void Gerstner( out mediump vec3 offs, out mediump vec3 nrml, in mediump vec3 vtx, in mediump vec3 tileableVtx, in mediump vec4 amplitude, in mediump vec4 frequency, in mediump vec4 steepness, in mediump vec4 speed, in mediump vec4 directionAB, in mediump vec4 directionCD ) {
    offs = GerstnerOffset4( tileableVtx.xz, steepness, amplitude, frequency, speed, directionAB, directionCD);
    nrml = GerstnerNormal4( (tileableVtx.xz + offs.xz), amplitude, frequency, speed, directionAB, directionCD);
}
#line 576
v2f_noGrab vert300( in appdata_full v ) {
    v2f_noGrab o;
    mediump vec3 worldSpaceVertex = (_Object2World * v.vertex).xyz;
    #line 580
    mediump vec3 vtxForAni = (worldSpaceVertex.xzz * unity_Scale.w);
    mediump vec3 nrml;
    mediump vec3 offsets;
    Gerstner( offsets, nrml, v.vertex.xyz, vtxForAni, _GAmplitude, _GFrequency, _GSteepness, _GSpeed, _GDirectionAB, _GDirectionCD);
    #line 584
    v.vertex.xyz += offsets;
    mediump vec2 tileableUv = worldSpaceVertex.xz;
    o.bumpCoords.xyzw = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection.xyzw)) * _BumpTiling.xyzw);
    o.viewInterpolator.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
    #line 588
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.screenPos = ComputeScreenPos( o.pos);
    o.normalInterpolator.xyz = nrml;
    o.normalInterpolator.w = 1.0;
    #line 592
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_noGrab xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert300( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.normalInterpolator);
    xlv_TEXCOORD1 = vec3(xl_retval.viewInterpolator);
    xlv_TEXCOORD2 = vec4(xl_retval.bumpCoords);
    xlv_TEXCOORD3 = vec4(xl_retval.screenPos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 485
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 495
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 504
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 348
#line 356
#line 379
#line 396
#line 408
#line 453
#line 474
#line 511
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 515
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 519
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 523
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 527
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 531
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 551
#line 576
#line 624
#line 390
mediump float Fresnel( in mediump vec3 viewVector, in mediump vec3 worldNormal, in mediump float bias, in mediump float power ) {
    #line 392
    mediump float facing = clamp( (1.0 - max( dot( (-viewVector), worldNormal), 0.0)), 0.0, 1.0);
    mediump float refl2Refr = xll_saturate_f((bias + ((1.0 - bias) * pow( facing, power))));
    return refl2Refr;
}
#line 316
mediump vec3 PerPixelNormal( in sampler2D bumpMap, in mediump vec4 coords, in mediump vec3 vertexNormal, in mediump float bumpStrength ) {
    mediump vec4 bump = (texture( bumpMap, coords.xy) + texture( bumpMap, coords.zw));
    #line 319
    bump.xy = (bump.wy - vec2( 1.0, 1.0));
    mediump vec3 worldNormal = (vertexNormal + ((bump.xxy * bumpStrength) * vec3( 1.0, 0.0, 1.0)));
    return normalize(worldNormal);
}
#line 594
mediump vec4 frag300( in v2f_noGrab i ) {
    #line 596
    mediump vec3 worldNormal = PerPixelNormal( _BumpMap, i.bumpCoords, i.normalInterpolator.xyz, _DistortParams.x);
    mediump vec3 viewVector = normalize(i.viewInterpolator.xyz);
    mediump vec4 distortOffset = vec4( ((worldNormal.xz * _DistortParams.y) * 10.0), 0.0, 0.0);
    mediump vec4 screenWithOffset = (i.screenPos + distortOffset);
    #line 600
    mediump vec4 rtReflections = textureProj( _ReflectionTex, screenWithOffset);
    mediump vec3 reflectVector = normalize(reflect( viewVector, worldNormal));
    mediump vec3 h = normalize((_WorldLightDir.xyz + viewVector.xyz));
    highp float nh = max( 0.0, dot( worldNormal, (-h)));
    #line 604
    highp float spec = max( 0.0, pow( nh, _Shininess));
    mediump vec4 edgeBlendFactors = vec4( 1.0, 0.0, 0.0, 0.0);
    worldNormal.xz *= _FresnelScale;
    mediump float refl2Refr = Fresnel( viewVector, worldNormal, _DistortParams.w, _DistortParams.z);
    #line 608
    mediump vec4 baseColor = _BaseColor;
    baseColor = mix( baseColor, mix( rtReflections, _ReflectionColor, vec4( _ReflectionColor.w)), vec4( xll_saturate_f((refl2Refr * 1.0))));
    baseColor = (baseColor + (spec * _SpecularColor));
    baseColor.w = (edgeBlendFactors.x * xll_saturate_f((0.5 + (refl2Refr * 1.0))));
    #line 612
    return baseColor;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    mediump vec4 xl_retval;
    v2f_noGrab xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.normalInterpolator = vec4(xlv_TEXCOORD0);
    xlt_i.viewInterpolator = vec3(xlv_TEXCOORD1);
    xlt_i.bumpCoords = vec4(xlv_TEXCOORD2);
    xlt_i.screenPos = vec4(xlv_TEXCOORD3);
    xl_retval = frag300( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GSpeed;
uniform vec4 _GSteepness;
uniform vec4 _GFrequency;
uniform vec4 _GAmplitude;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform float _GerstnerIntensity;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = gl_Vertex.w;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec3 offsets_5;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, tmpvar_4.xz);
  tmpvar_8.y = dot (_GDirectionAB.zw, tmpvar_4.xz);
  tmpvar_8.z = dot (_GDirectionCD.xy, tmpvar_4.xz);
  tmpvar_8.w = dot (_GDirectionCD.zw, tmpvar_4.xz);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_5.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_5.z = dot (tmpvar_11, tmpvar_13);
  offsets_5.y = dot (sin((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_14;
  xzVtx_14 = (tmpvar_4.xz + offsets_5.xz);
  vec3 nrml_15;
  nrml_15.y = 2.0;
  vec4 tmpvar_16;
  tmpvar_16 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_17;
  tmpvar_17 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_18;
  tmpvar_18.x = dot (_GDirectionAB.xy, xzVtx_14);
  tmpvar_18.y = dot (_GDirectionAB.zw, xzVtx_14);
  tmpvar_18.z = dot (_GDirectionCD.xy, xzVtx_14);
  tmpvar_18.w = dot (_GDirectionCD.zw, xzVtx_14);
  vec4 tmpvar_19;
  tmpvar_19 = cos(((_GFrequency * tmpvar_18) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_16.xz;
  tmpvar_20.zw = tmpvar_17.xz;
  nrml_15.x = -(dot (tmpvar_19, tmpvar_20));
  vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_16.yw;
  tmpvar_21.zw = tmpvar_17.yw;
  nrml_15.z = -(dot (tmpvar_19, tmpvar_21));
  nrml_15.xz = (nrml_15.xz * _GerstnerIntensity);
  vec3 tmpvar_22;
  tmpvar_22 = normalize(nrml_15);
  nrml_15 = tmpvar_22;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_5);
  vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 o_24;
  vec4 tmpvar_25;
  tmpvar_25 = (tmpvar_23 * 0.5);
  vec2 tmpvar_26;
  tmpvar_26.x = tmpvar_25.x;
  tmpvar_26.y = (tmpvar_25.y * _ProjectionParams.x);
  o_24.xy = (tmpvar_26 + tmpvar_25.w);
  o_24.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_22;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_24;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform vec4 _SpecularColor;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  baseColor_1.xyz = (_ReflectionColor + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = clamp ((0.5 + clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0)), 0.0, 1.0);
  gl_FragData[0] = baseColor_1;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 12 [unity_Scale]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 187 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c12.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r3.zw, r3.xyyw
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o1.xyz, r0.w, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
mov r1.w, v0
add r1.xyz, v0, r4
dp4 r2.w, r1, c3
dp4 r2.z, r1, c2
dp4 r2.x, r1, c0
dp4 r2.y, r1, c1
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c10.x
mad o4.xy, r3.z, c11.zwzw, r0
mov r0.x, c8
mad r0, c15, r0.x, r7.xzxz
mov o0, r2
mov o4.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c9
mov o1.w, c23.y
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Bind "vertex" Vertex
Vector 15 [_BumpDirection]
Vector 14 [_BumpTiling]
Vector 16 [_GAmplitude]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
Vector 17 [_GFrequency]
Vector 19 [_GSpeed]
Vector 18 [_GSteepness]
Float 13 [_GerstnerIntensity]
Matrix 8 [_Object2World] 4
Vector 2 [_ProjectionParams]
Vector 3 [_ScreenParams]
Vector 0 [_Time]
Vector 1 [_WorldSpaceCameraPos]
Matrix 4 [glstate_matrix_mvp] 4
Vector 12 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 69.33 (52 instructions), vertex: 32, texture: 0,
//   sequencer: 24,  10 GPRs, 18 threads,
// Performance (if enough threads): ~69 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaaddeaaaaadbaaaaaaaaaaaaaaaceaaaaaclmaaaaacoeaaaaaaaa
aaaaaaaaaaaaacjeaaaaaabmaaaaacigpppoadaaaaaaaabaaaaaaabmaaaaaaaa
aaaaachpaaaaabfmaaacaaapaaabaaaaaaaaabgmaaaaaaaaaaaaabhmaaacaaao
aaabaaaaaaaaabgmaaaaaaaaaaaaabiiaaacaabaaaabaaaaaaaaabgmaaaaaaaa
aaaaabjeaaacaabeaaabaaaaaaaaabgmaaaaaaaaaaaaabkcaaacaabfaaabaaaa
aaaaabgmaaaaaaaaaaaaablaaaacaabbaaabaaaaaaaaabgmaaaaaaaaaaaaablm
aaacaabdaaabaaaaaaaaabgmaaaaaaaaaaaaabmeaaacaabcaaabaaaaaaaaabgm
aaaaaaaaaaaaabnaaaacaaanaaabaaaaaaaaaboeaaaaaaaaaaaaabpeaaacaaai
aaaeaaaaaaaaacaeaaaaaaaaaaaaacbeaaacaaacaaabaaaaaaaaabgmaaaaaaaa
aaaaaccgaaacaaadaaabaaaaaaaaabgmaaaaaaaaaaaaacdeaaacaaaaaaabaaaa
aaaaabgmaaaaaaaaaaaaacdkaaacaaabaaabaaaaaaaaacfaaaaaaaaaaaaaacga
aaacaaaeaaaeaaaaaaaaacaeaaaaaaaaaaaaachdaaacaaamaaabaaaaaaaaabgm
aaaaaaaafpechfgnhaeegjhcgfgdhegjgpgoaaklaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpechfgnhafegjgmgjgoghaafpehebgnhagmgjhehfgegfaafpeheegj
hcgfgdhegjgpgoebecaafpeheegjhcgfgdhegjgpgoedeeaafpeheghcgfhbhfgf
gogdhjaafpehfdhagfgfgeaafpehfdhegfgfhagogfhdhdaafpehgfhchdhegogf
hcejgohegfgohdgjhehjaaklaaaaaaadaaabaaabaaabaaaaaaaaaaaafpepgcgk
gfgdhedcfhgphcgmgeaaklklaaadaaadaaaeaaaeaaabaaaaaaaaaaaafpfahcgp
gkgfgdhegjgpgofagbhcgbgnhdaafpfdgdhcgfgfgofagbhcgbgnhdaafpfegjgn
gfaafpfhgphcgmgefdhagbgdgfedgbgngfhcgbfagphdaaklaaabaaadaaabaaad
aaabaaaaaaaaaaaaghgmhdhegbhegffpgngbhehcgjhifpgnhghaaahfgogjhehj
fpfdgdgbgmgfaahghdfpddfpdaaadccodacodcdadddfddcodaaaklklaaaaaaaa
aaaaaaabaaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaeaaaaaacnaaadbaaajaaaaaaaaaaaaaaaaaaaadmieaaaaaaab
aaaaaaabaaaaaaafaaaaacjaaaaaaaagaaaapafaaaabhbfbaaacpcfcaaadpdfd
aaaabadkaaaabaclaaaabacmaaaaaackaaaabacpaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaamaejapnldpaaaaaaeaiaaaaa
doccpjideamjapnlaaaaaaaaaaaaaaaaaaaaaaaabaabbaagaaaabcaamcaaaaaa
aaaagaahgaanbcaabcaaaaaaaaaagabdgabjbcaabcaaaaaaaaaaeabpaaaabcaa
meaaaaaaaaaagacdgacjbcaabcaaaaaaaaaagacpgadfbcaaccaaaaaaafpifaaa
aaaaagiiaaaaaaaamiapaaaaaalbaaaacbaabdaamiahaaabaablleaakbafalaa
miahaaabaamgmaleklafakabmiahaaabaalbleleklafajabmiahaaaeaagmmale
klafaiabmiadaaabaameblaakbaeamaamiapaaadaalmdeaakbabbeaaaabpacag
aalmdeggkbabbfadaacmacacaakmaglloaagagadmiapaaacaaaaaaaaklacbbaa
miapaaacaaaabllbilacpopomiapaaacaaaaaaaaoiacaaaamiapaaaiaaaagmgm
ilacpppomabpadagaaaaaagmcbbcbaaimacpadacaabliilbkbafahaimaepadah
aaakdemgkbagbfaimaipadajaakadeblkbagbeaimeicabagaakhkhlbkpadbaai
meepabadaaaaaagmcbbbbaaimebpagajaaanahmgobajabaimeimagabaapbcmbl
oaajajaimiaeaaagaabkbiblpbahagabmiabaaagaalabimgpbahagabmiahaaaf
aamamaaaoaagafaamiapaaacaamgnapiklafagacmiapaaacaalbdepiklafafac
miapaaafaagmnajeklafaeacmiapiadoaananaaaocafafaamiapaaacaagmkhoo
claaapaemiadaaabaamelaaaoaagabaamiapaaagaalmdeaakbabbeaaaabpabah
aalmdeggkbabbfagaacmababaakmaglloaahahagmiapaaabaaaaaaaaklabbbaa
miahaaaaaamalbaakbafpoaamiamiaadaanlnlaaocafafaamiahiaabacmamaaa
kaaeabaamiapiaacaahkaaaakbacaoaamiapaaabaaaabllbilabpopokiipaaab
aaaaaaebmiabaaacmiadiaadaamgbkbiklaaadaamiapaaabaaaagmgmilabpppo
mebdabacaalabjgmkbadbeabmecmabacaaagdblbkbadbfabmeedabaaaalamemg
kbadbeabmeimabaaaaagomblkbadbfabmiabaaaaaakhkhaaopaaabaamiacaaaa
aakhkhaaopacabaamiagaaaaaelmgmaakbaaanaamiabaaaaaalclcmgnbaaaapo
fibaaaaaaaaaaagmocaaaaiaaaknmaaaaamfgmgmobaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Matrix 256 [glstate_matrix_mvp]
Bind "vertex" Vertex
Vector 467 [_Time]
Vector 466 [_WorldSpaceCameraPos]
Vector 465 [_ProjectionParams]
Matrix 260 [_Object2World]
Vector 464 [unity_Scale]
Float 463 [_GerstnerIntensity]
Vector 462 [_BumpTiling]
Vector 461 [_BumpDirection]
Vector 460 [_GAmplitude]
Vector 459 [_GFrequency]
Vector 458 [_GSteepness]
Vector 457 [_GSpeed]
Vector 456 [_GDirectionAB]
Vector 455 [_GDirectionCD]
"sce_vp_rsx // 57 instructions using 13 registers
[Configuration]
8
0000003900010d00
[Defaults]
1
454 3
3f800000400000003f000000
[Microcode]
912
00001c6c005cc00d8186c0836041fffc00009c6c005d30080186c08360419ffc
401f9c6c005c60000186c08360403f9c00061c6c005c602a8186c08360409ffc
00051c6c0040007f8106c08360403ffc00031c6c01d0600d8106c0c360405ffc
00031c6c01d0500d8106c0c360409ffc00031c6c01d0400d8106c0c360411ffc
401f9c6c00dd208c0186c0830321dfa000039c6c009cb0138089c0c36041fffc
00011c6c009ca0138089c0c36041fffc00001c6c011cd0000286c0c44321fffc
00009c6c009c902a8286c0c36041fffc00021c6c009c702f8486c0c36041fffc
00019c6c009c80050486c0c36041fffc00029c6c009c702f8e86c0c36041fffc
00049c6c009d00100cbfc0c360419ffc00031c6c009c70089286c0c36041fffc
00011c6c009c80089286c0c36041fffc00011c6c00c000100486c08ea1219ffc
00011c6c00c000010c86c08ae3207ffc00031c6c009c80050e86c0c36041fffc
00011c6c009cb00d8486c0c36041fffc00011c6c00c0000d8486c08360a1fffc
401f9c6c009ce00d8086c0c36041ffa400001c6c784000100c86c0800131847c
00001c6c804000010a86c080013063fc00059c6c7840003a8c86c08aa129847c
00031c6c804000100686c08aa12983fc00031c6c804000010886c095412463fc
00019c6c8040003a8686c09fe12383fc00019c6c7840002b8886c0954124647c
00019c6c79c0000d8e86c35fe122447c00019c6c01c0000d8e86c64360411ffc
00019c6c01dcc00d9086c0c360409ffc00051c6c00c0000c0106c08301a1dffc
00011c6c00c000081286c08401a19ffc00021c6c01d0300d9486c0c360403ffc
00019c6c009c70088486c0c36041fffc00011c6c009c80088486c0c36041fffc
00011c6c00c000100486c08ea1219ffc00011c6c00c000010686c08ae1a07ffc
00009c6c011cb00d8486c0c360a1fffc00021c6c01d0200d9486c0c360405ffc
00021c6c81d0100d9486c0c000b080fc00021c6c81d0000d9486c0caa0a900fc
00059c6c8040002b8a86c09540a460fc401f9c6c8040000d8886c09fe0a3e080
401f9c6c004000558886c08360407fa800011c6c01c0000d8286cb4360409ffc
00011c6c01c0000d8286c04360411ffc00001c6c009c600e08aa80c36041dffc
00061c6c009cf082048000c360415ffc00009c6c0140000c18860c4360411ffc
00001c6c209d102a808000c000b080fc401f9c6c00c000080086c09540219fa8
401f9c6c0080000002860c436041df9d
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304 // 304 used size, 19 vars
Float 16 [_GerstnerIntensity]
Vector 176 [_BumpTiling] 4
Vector 192 [_BumpDirection] 4
Vector 208 [_GAmplitude] 4
Vector 224 [_GFrequency] 4
Vector 240 [_GSteepness] 4
Vector 256 [_GSpeed] 4
Vector 272 [_GDirectionAB] 4
Vector 288 [_GDirectionCD] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 0 [_Time] 4
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 59 instructions, 7 temp regs, 0 temp arrays:
// ALU 47 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedglgdjnccceaelhpdglkfonphjipohkojabaaaaaabeajaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefchiahaaaaeaaaabaa
noabaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaa
giaaaaacahaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaa
apaaaaaibcaabaaaacaaaaaaegiacaaaaaaaaaaabbaaaaaaegaabaaaabaaaaaa
apaaaaaiccaabaaaacaaaaaaogikcaaaaaaaaaaabbaaaaaaegaabaaaabaaaaaa
apaaaaaiecaabaaaacaaaaaaegiacaaaaaaaaaaabcaaaaaaegaabaaaabaaaaaa
apaaaaaiicaabaaaacaaaaaaogikcaaaaaaaaaaabcaaaaaaegaabaaaabaaaaaa
diaaaaajpcaabaaaabaaaaaaegiocaaaaaaaaaaabaaaaaaafgifcaaaabaaaaaa
aaaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaaaaaaaaaaoaaaaaaegaobaaa
acaaaaaaegaobaaaabaaaaaaenaaaaahpcaabaaaacaaaaaapcaabaaaadaaaaaa
egaobaaaacaaaaaabbaaaaaiccaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaa
aaaaaaaaanaaaaaadiaaaaajpcaabaaaaeaaaaaaegiocaaaaaaaaaaaanaaaaaa
egiocaaaaaaaaaaaapaaaaaadiaaaaaipcaabaaaafaaaaaaegaebaaaaeaaaaaa
ngiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaaeaaaaaakgapbaaaaeaaaaaa
egiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaagaaaaaaogakbaaaafaaaaaa
dgaaaaafmcaabaaaagaaaaaaagaibaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaa
fganbaaaaeaaaaaabbaaaaahecaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaa
afaaaaaabbaaaaahbcaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaaagaaaaaa
aaaaaaahhcaabaaaadaaaaaaegacbaaaacaaaaaaegbcbaaaaaaaaaaadcaaaaak
dcaabaaaacaaaaaaigaabaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaaigaabaaa
acaaaaaadiaaaaaipcaabaaaaeaaaaaafgafbaaaadaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaeaaaaaaegiocaaaacaaaaaaaaaaaaaaagaabaaa
adaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaaegiocaaaacaaaaaa
acaaaaaakgakbaaaadaaaaaaegaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaadaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaadaaaaaaapaaaaaibcaabaaaaeaaaaaaegiacaaa
aaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiccaabaaaaeaaaaaaogikcaaa
aaaaaaaabbaaaaaaegaabaaaacaaaaaaapaaaaaiecaabaaaaeaaaaaaegiacaaa
aaaaaaaabcaaaaaaegaabaaaacaaaaaaapaaaaaiicaabaaaaeaaaaaaogikcaaa
aaaaaaaabcaaaaaaegaabaaaacaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
aaaaaaaaaoaaaaaaegaobaaaaeaaaaaaegaobaaaabaaaaaaenaaaaagaanaaaaa
pcaabaaaabaaaaaaegaobaaaabaaaaaadiaaaaajpcaabaaaacaaaaaaegiocaaa
aaaaaaaaanaaaaaaegiocaaaaaaaaaaaaoaaaaaadiaaaaaipcaabaaaaeaaaaaa
egaebaaaacaaaaaangiicaaaaaaaaaaabbaaaaaadiaaaaaipcaabaaaacaaaaaa
kgapbaaaacaaaaaaegiocaaaaaaaaaaabcaaaaaadgaaaaafdcaabaaaafaaaaaa
ogakbaaaaeaaaaaadgaaaaafmcaabaaaafaaaaaaagaibaaaacaaaaaadgaaaaaf
mcaabaaaaeaaaaaafganbaaaacaaaaaabbaaaaahicaabaaaaaaaaaaaegaobaaa
abaaaaaaegaobaaaaeaaaaaabbaaaaahbcaabaaaabaaaaaaegaobaaaabaaaaaa
egaobaaaafaaaaaadgaaaaagbcaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaa
dgaaaaagecaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadiaaaaaifcaabaaa
abaaaaaaagacbaaaabaaaaaaagiacaaaaaaaaaaaabaaaaaadgaaaaafccaabaaa
abaaaaaaabeaaaaaaaaaaaeabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hccabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaa
abaaaaaaabeaaaaaaaaaiadpaaaaaaajhccabaaaacaaaaaaegacbaaaaaaaaaaa
egiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaaaaaaaaaagiacaaa
abaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaaaaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaadiaaaaai
bcaabaaaaaaaaaaabkaabaaaadaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaah
icaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaadpdiaaaaakfcaabaaa
aaaaaaaaagadbaaaadaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaaaa
dgaaaaafmccabaaaaeaaaaaakgaobaaaadaaaaaaaaaaaaahdccabaaaaeaaaaaa
kgakbaaaaaaaaaaamgaabaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = _glesVertex.w;
  mediump vec3 vtxForAni_2;
  mediump vec3 worldSpaceVertex_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_3 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (worldSpaceVertex_3.xzz * unity_Scale.w);
  vtxForAni_2 = tmpvar_6;
  mediump vec4 amplitude_7;
  amplitude_7 = _GAmplitude;
  mediump vec4 frequency_8;
  frequency_8 = _GFrequency;
  mediump vec4 steepness_9;
  steepness_9 = _GSteepness;
  mediump vec4 speed_10;
  speed_10 = _GSpeed;
  mediump vec4 directionAB_11;
  directionAB_11 = _GDirectionAB;
  mediump vec4 directionCD_12;
  directionCD_12 = _GDirectionCD;
  mediump vec4 TIME_13;
  mediump vec3 offsets_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((steepness_9.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_16;
  tmpvar_16 = ((steepness_9.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_17;
  tmpvar_17.x = dot (directionAB_11.xy, vtxForAni_2.xz);
  tmpvar_17.y = dot (directionAB_11.zw, vtxForAni_2.xz);
  tmpvar_17.z = dot (directionCD_12.xy, vtxForAni_2.xz);
  tmpvar_17.w = dot (directionCD_12.zw, vtxForAni_2.xz);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (frequency_8 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (_Time.yyyy * speed_10);
  TIME_13 = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = cos((tmpvar_18 + TIME_13));
  mediump vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_15.xz;
  tmpvar_21.zw = tmpvar_16.xz;
  offsets_14.x = dot (tmpvar_20, tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22.xy = tmpvar_15.yw;
  tmpvar_22.zw = tmpvar_16.yw;
  offsets_14.z = dot (tmpvar_20, tmpvar_22);
  offsets_14.y = dot (sin((tmpvar_18 + TIME_13)), amplitude_7);
  mediump vec2 xzVtx_23;
  xzVtx_23 = (vtxForAni_2.xz + offsets_14.xz);
  mediump vec4 TIME_24;
  mediump vec3 nrml_25;
  nrml_25.y = 2.0;
  mediump vec4 tmpvar_26;
  tmpvar_26 = ((frequency_8.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_27;
  tmpvar_27 = ((frequency_8.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_28;
  tmpvar_28.x = dot (directionAB_11.xy, xzVtx_23);
  tmpvar_28.y = dot (directionAB_11.zw, xzVtx_23);
  tmpvar_28.z = dot (directionCD_12.xy, xzVtx_23);
  tmpvar_28.w = dot (directionCD_12.zw, xzVtx_23);
  highp vec4 tmpvar_29;
  tmpvar_29 = (_Time.yyyy * speed_10);
  TIME_24 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = cos(((frequency_8 * tmpvar_28) + TIME_24));
  mediump vec4 tmpvar_31;
  tmpvar_31.xy = tmpvar_26.xz;
  tmpvar_31.zw = tmpvar_27.xz;
  nrml_25.x = -(dot (tmpvar_30, tmpvar_31));
  mediump vec4 tmpvar_32;
  tmpvar_32.xy = tmpvar_26.yw;
  tmpvar_32.zw = tmpvar_27.yw;
  nrml_25.z = -(dot (tmpvar_30, tmpvar_32));
  nrml_25.xz = (nrml_25.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_33;
  tmpvar_33 = normalize(nrml_25);
  nrml_25 = tmpvar_33;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_14);
  highp vec4 tmpvar_34;
  tmpvar_34 = (glstate_matrix_mvp * tmpvar_1);
  highp vec4 o_35;
  highp vec4 tmpvar_36;
  tmpvar_36 = (tmpvar_34 * 0.5);
  highp vec2 tmpvar_37;
  tmpvar_37.x = tmpvar_36.x;
  tmpvar_37.y = (tmpvar_36.y * _ProjectionParams.x);
  o_35.xy = (tmpvar_37 + tmpvar_36.w);
  o_35.zw = tmpvar_34.zw;
  tmpvar_4.xyz = tmpvar_33;
  tmpvar_4.w = 1.0;
  gl_Position = tmpvar_34;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (worldSpaceVertex_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_35;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _BumpMap;
void main ()
{
  mediump vec4 baseColor_1;
  highp float nh_2;
  mediump vec3 h_3;
  mediump vec3 viewVector_4;
  mediump vec3 worldNormal_5;
  mediump vec4 coords_6;
  coords_6 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_7;
  vertexNormal_7 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_8;
  bumpStrength_8 = _DistortParams.x;
  mediump vec4 bump_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = (texture2D (_BumpMap, coords_6.xy) + texture2D (_BumpMap, coords_6.zw));
  bump_9 = tmpvar_10;
  bump_9.xy = (bump_9.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize((vertexNormal_7 + ((bump_9.xxy * bumpStrength_8) * vec3(1.0, 0.0, 1.0))));
  worldNormal_5.y = tmpvar_11.y;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(xlv_TEXCOORD1);
  viewVector_4 = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((_WorldLightDir.xyz + viewVector_4));
  h_3 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (tmpvar_11, -(h_3)));
  nh_2 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15 = (tmpvar_11.xz * _FresnelScale);
  worldNormal_5.xz = tmpvar_15;
  mediump float bias_16;
  bias_16 = _DistortParams.w;
  mediump float power_17;
  power_17 = _DistortParams.z;
  baseColor_1 = _ReflectionColor;
  highp vec4 tmpvar_18;
  tmpvar_18 = (baseColor_1 + (max (0.0, pow (nh_2, _Shininess)) * _SpecularColor));
  baseColor_1.xyz = tmpvar_18.xyz;
  baseColor_1.w = clamp ((0.5 + clamp ((bias_16 + ((1.0 - bias_16) * pow (clamp ((1.0 - max (dot (-(viewVector_4), worldNormal_5), 0.0)), 0.0, 1.0), power_17))), 0.0, 1.0)), 0.0, 1.0);
  gl_FragData[0] = baseColor_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = _glesVertex.w;
  mediump vec3 vtxForAni_2;
  mediump vec3 worldSpaceVertex_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_3 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (worldSpaceVertex_3.xzz * unity_Scale.w);
  vtxForAni_2 = tmpvar_6;
  mediump vec4 amplitude_7;
  amplitude_7 = _GAmplitude;
  mediump vec4 frequency_8;
  frequency_8 = _GFrequency;
  mediump vec4 steepness_9;
  steepness_9 = _GSteepness;
  mediump vec4 speed_10;
  speed_10 = _GSpeed;
  mediump vec4 directionAB_11;
  directionAB_11 = _GDirectionAB;
  mediump vec4 directionCD_12;
  directionCD_12 = _GDirectionCD;
  mediump vec4 TIME_13;
  mediump vec3 offsets_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((steepness_9.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_16;
  tmpvar_16 = ((steepness_9.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_17;
  tmpvar_17.x = dot (directionAB_11.xy, vtxForAni_2.xz);
  tmpvar_17.y = dot (directionAB_11.zw, vtxForAni_2.xz);
  tmpvar_17.z = dot (directionCD_12.xy, vtxForAni_2.xz);
  tmpvar_17.w = dot (directionCD_12.zw, vtxForAni_2.xz);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (frequency_8 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (_Time.yyyy * speed_10);
  TIME_13 = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = cos((tmpvar_18 + TIME_13));
  mediump vec4 tmpvar_21;
  tmpvar_21.xy = tmpvar_15.xz;
  tmpvar_21.zw = tmpvar_16.xz;
  offsets_14.x = dot (tmpvar_20, tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22.xy = tmpvar_15.yw;
  tmpvar_22.zw = tmpvar_16.yw;
  offsets_14.z = dot (tmpvar_20, tmpvar_22);
  offsets_14.y = dot (sin((tmpvar_18 + TIME_13)), amplitude_7);
  mediump vec2 xzVtx_23;
  xzVtx_23 = (vtxForAni_2.xz + offsets_14.xz);
  mediump vec4 TIME_24;
  mediump vec3 nrml_25;
  nrml_25.y = 2.0;
  mediump vec4 tmpvar_26;
  tmpvar_26 = ((frequency_8.xxyy * amplitude_7.xxyy) * directionAB_11);
  mediump vec4 tmpvar_27;
  tmpvar_27 = ((frequency_8.zzww * amplitude_7.zzww) * directionCD_12);
  mediump vec4 tmpvar_28;
  tmpvar_28.x = dot (directionAB_11.xy, xzVtx_23);
  tmpvar_28.y = dot (directionAB_11.zw, xzVtx_23);
  tmpvar_28.z = dot (directionCD_12.xy, xzVtx_23);
  tmpvar_28.w = dot (directionCD_12.zw, xzVtx_23);
  highp vec4 tmpvar_29;
  tmpvar_29 = (_Time.yyyy * speed_10);
  TIME_24 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = cos(((frequency_8 * tmpvar_28) + TIME_24));
  mediump vec4 tmpvar_31;
  tmpvar_31.xy = tmpvar_26.xz;
  tmpvar_31.zw = tmpvar_27.xz;
  nrml_25.x = -(dot (tmpvar_30, tmpvar_31));
  mediump vec4 tmpvar_32;
  tmpvar_32.xy = tmpvar_26.yw;
  tmpvar_32.zw = tmpvar_27.yw;
  nrml_25.z = -(dot (tmpvar_30, tmpvar_32));
  nrml_25.xz = (nrml_25.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_33;
  tmpvar_33 = normalize(nrml_25);
  nrml_25 = tmpvar_33;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_14);
  highp vec4 tmpvar_34;
  tmpvar_34 = (glstate_matrix_mvp * tmpvar_1);
  highp vec4 o_35;
  highp vec4 tmpvar_36;
  tmpvar_36 = (tmpvar_34 * 0.5);
  highp vec2 tmpvar_37;
  tmpvar_37.x = tmpvar_36.x;
  tmpvar_37.y = (tmpvar_36.y * _ProjectionParams.x);
  o_35.xy = (tmpvar_37 + tmpvar_36.w);
  o_35.zw = tmpvar_34.zw;
  tmpvar_4.xyz = tmpvar_33;
  tmpvar_4.w = 1.0;
  gl_Position = tmpvar_34;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (worldSpaceVertex_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_3.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_35;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _BumpMap;
void main ()
{
  mediump vec4 baseColor_1;
  highp float nh_2;
  mediump vec3 h_3;
  mediump vec3 viewVector_4;
  mediump vec3 worldNormal_5;
  mediump vec4 coords_6;
  coords_6 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_7;
  vertexNormal_7 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_8;
  bumpStrength_8 = _DistortParams.x;
  mediump vec4 bump_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = (texture2D (_BumpMap, coords_6.xy) + texture2D (_BumpMap, coords_6.zw));
  bump_9 = tmpvar_10;
  bump_9.xy = (bump_9.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize((vertexNormal_7 + ((bump_9.xxy * bumpStrength_8) * vec3(1.0, 0.0, 1.0))));
  worldNormal_5.y = tmpvar_11.y;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(xlv_TEXCOORD1);
  viewVector_4 = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((_WorldLightDir.xyz + viewVector_4));
  h_3 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (tmpvar_11, -(h_3)));
  nh_2 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15 = (tmpvar_11.xz * _FresnelScale);
  worldNormal_5.xz = tmpvar_15;
  mediump float bias_16;
  bias_16 = _DistortParams.w;
  mediump float power_17;
  power_17 = _DistortParams.z;
  baseColor_1 = _ReflectionColor;
  highp vec4 tmpvar_18;
  tmpvar_18 = (baseColor_1 + (max (0.0, pow (nh_2, _Shininess)) * _SpecularColor));
  baseColor_1.xyz = tmpvar_18.xyz;
  baseColor_1.w = clamp ((0.5 + clamp ((bias_16 + ((1.0 - bias_16) * pow (clamp ((1.0 - max (dot (-(viewVector_4), worldNormal_5), 0.0)), 0.0, 1.0), power_17))), 0.0, 1.0)), 0.0, 1.0);
  gl_FragData[0] = baseColor_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 485
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 495
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 504
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 348
#line 356
#line 379
#line 396
#line 408
#line 453
#line 474
#line 511
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 515
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 519
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 523
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 527
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 531
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 551
#line 575
#line 612
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 460
mediump vec3 GerstnerNormal4( in mediump vec2 xzVtx, in mediump vec4 amp, in mediump vec4 freq, in mediump vec4 speed, in mediump vec4 dirAB, in mediump vec4 dirCD ) {
    #line 462
    mediump vec3 nrml = vec3( 0.0, 2.0, 0.0);
    mediump vec4 AB = ((freq.xxyy * amp.xxyy) * dirAB.xyzw);
    mediump vec4 CD = ((freq.zzww * amp.zzww) * dirCD.xyzw);
    mediump vec4 dotABCD = (freq.xyzw * vec4( dot( dirAB.xy, xzVtx), dot( dirAB.zw, xzVtx), dot( dirCD.xy, xzVtx), dot( dirCD.zw, xzVtx)));
    #line 466
    mediump vec4 TIME = (_Time.yyyy * speed);
    mediump vec4 COS = cos((dotABCD + TIME));
    nrml.x -= dot( COS, vec4( AB.xz, CD.xz));
    nrml.z -= dot( COS, vec4( AB.yw, CD.yw));
    #line 470
    nrml.xz *= _GerstnerIntensity;
    nrml = normalize(nrml);
    return nrml;
}
#line 439
mediump vec3 GerstnerOffset4( in mediump vec2 xzVtx, in mediump vec4 steepness, in mediump vec4 amp, in mediump vec4 freq, in mediump vec4 speed, in mediump vec4 dirAB, in mediump vec4 dirCD ) {
    #line 441
    mediump vec3 offsets;
    mediump vec4 AB = ((steepness.xxyy * amp.xxyy) * dirAB.xyzw);
    mediump vec4 CD = ((steepness.zzww * amp.zzww) * dirCD.xyzw);
    mediump vec4 dotABCD = (freq.xyzw * vec4( dot( dirAB.xy, xzVtx), dot( dirAB.zw, xzVtx), dot( dirCD.xy, xzVtx), dot( dirCD.zw, xzVtx)));
    #line 445
    mediump vec4 TIME = (_Time.yyyy * speed);
    mediump vec4 COS = cos((dotABCD + TIME));
    mediump vec4 SIN = sin((dotABCD + TIME));
    offsets.x = dot( COS, vec4( AB.xz, CD.xz));
    #line 449
    offsets.z = dot( COS, vec4( AB.yw, CD.yw));
    offsets.y = dot( SIN, amp);
    return offsets;
}
#line 474
void Gerstner( out mediump vec3 offs, out mediump vec3 nrml, in mediump vec3 vtx, in mediump vec3 tileableVtx, in mediump vec4 amplitude, in mediump vec4 frequency, in mediump vec4 steepness, in mediump vec4 speed, in mediump vec4 directionAB, in mediump vec4 directionCD ) {
    offs = GerstnerOffset4( tileableVtx.xz, steepness, amplitude, frequency, speed, directionAB, directionCD);
    nrml = GerstnerNormal4( (tileableVtx.xz + offs.xz), amplitude, frequency, speed, directionAB, directionCD);
}
#line 575
v2f_noGrab vert300( in appdata_full v ) {
    v2f_noGrab o;
    mediump vec3 worldSpaceVertex = (_Object2World * v.vertex).xyz;
    #line 579
    mediump vec3 vtxForAni = (worldSpaceVertex.xzz * unity_Scale.w);
    mediump vec3 nrml;
    mediump vec3 offsets;
    Gerstner( offsets, nrml, v.vertex.xyz, vtxForAni, _GAmplitude, _GFrequency, _GSteepness, _GSpeed, _GDirectionAB, _GDirectionCD);
    #line 583
    v.vertex.xyz += offsets;
    mediump vec2 tileableUv = worldSpaceVertex.xz;
    o.bumpCoords.xyzw = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection.xyzw)) * _BumpTiling.xyzw);
    o.viewInterpolator.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
    #line 587
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.screenPos = ComputeScreenPos( o.pos);
    o.normalInterpolator.xyz = nrml;
    o.normalInterpolator.w = 1.0;
    #line 591
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_noGrab xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert300( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.normalInterpolator);
    xlv_TEXCOORD1 = vec3(xl_retval.viewInterpolator);
    xlv_TEXCOORD2 = vec4(xl_retval.bumpCoords);
    xlv_TEXCOORD3 = vec4(xl_retval.screenPos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 485
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 495
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 504
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 348
#line 356
#line 379
#line 396
#line 408
#line 453
#line 474
#line 511
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 515
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 519
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 523
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 527
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 531
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 551
#line 575
#line 612
#line 390
mediump float Fresnel( in mediump vec3 viewVector, in mediump vec3 worldNormal, in mediump float bias, in mediump float power ) {
    #line 392
    mediump float facing = clamp( (1.0 - max( dot( (-viewVector), worldNormal), 0.0)), 0.0, 1.0);
    mediump float refl2Refr = xll_saturate_f((bias + ((1.0 - bias) * pow( facing, power))));
    return refl2Refr;
}
#line 316
mediump vec3 PerPixelNormal( in sampler2D bumpMap, in mediump vec4 coords, in mediump vec3 vertexNormal, in mediump float bumpStrength ) {
    mediump vec4 bump = (texture( bumpMap, coords.xy) + texture( bumpMap, coords.zw));
    #line 319
    bump.xy = (bump.wy - vec2( 1.0, 1.0));
    mediump vec3 worldNormal = (vertexNormal + ((bump.xxy * bumpStrength) * vec3( 1.0, 0.0, 1.0)));
    return normalize(worldNormal);
}
#line 593
mediump vec4 frag300( in v2f_noGrab i ) {
    #line 595
    mediump vec3 worldNormal = PerPixelNormal( _BumpMap, i.bumpCoords, i.normalInterpolator.xyz, _DistortParams.x);
    mediump vec3 viewVector = normalize(i.viewInterpolator.xyz);
    mediump vec4 distortOffset = vec4( ((worldNormal.xz * _DistortParams.y) * 10.0), 0.0, 0.0);
    mediump vec4 screenWithOffset = (i.screenPos + distortOffset);
    #line 599
    mediump vec3 reflectVector = normalize(reflect( viewVector, worldNormal));
    mediump vec3 h = normalize((_WorldLightDir.xyz + viewVector.xyz));
    highp float nh = max( 0.0, dot( worldNormal, (-h)));
    highp float spec = max( 0.0, pow( nh, _Shininess));
    #line 603
    mediump vec4 edgeBlendFactors = vec4( 1.0, 0.0, 0.0, 0.0);
    worldNormal.xz *= _FresnelScale;
    mediump float refl2Refr = Fresnel( viewVector, worldNormal, _DistortParams.w, _DistortParams.z);
    mediump vec4 baseColor = _BaseColor;
    #line 607
    baseColor = _ReflectionColor;
    baseColor = (baseColor + (spec * _SpecularColor));
    baseColor.w = (edgeBlendFactors.x * xll_saturate_f((0.5 + (refl2Refr * 1.0))));
    return baseColor;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    mediump vec4 xl_retval;
    v2f_noGrab xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.normalInterpolator = vec4(xlv_TEXCOORD0);
    xlt_i.viewInterpolator = vec3(xlv_TEXCOORD1);
    xlt_i.bumpCoords = vec4(xlv_TEXCOORD2);
    xlt_i.screenPos = vec4(xlv_TEXCOORD3);
    xl_retval = frag300( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_4;
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (tmpvar_2 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_2.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_4;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _InvFadeParemeter;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
uniform vec4 _ZBufferParams;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.0, 0.0);
  tmpvar_7.xy = ((tmpvar_5.xz * _DistortParams.y) * 10.0);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  float tmpvar_8;
  tmpvar_8 = clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0);
  baseColor_1.xyz = (mix (_BaseColor, mix (texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_7)), _ReflectionColor, _ReflectionColor.wwww), vec4(clamp (tmpvar_8, 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = (clamp ((_InvFadeParemeter * ((1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w))) - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + tmpvar_8), 0.0, 1.0));
  gl_FragData[0] = baseColor_1;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 17 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c14.x
mul r1.y, r1, c10.x
mov o0, r0
dp4 r2.x, v0, c4
dp4 r2.z, v0, c6
dp4 r2.y, v0, c5
mad o4.xy, r1.z, c11.zwzw, r1
mov r0.x, c8
mad r1, c13, r0.x, r2.xzxz
mov o1, c14.yzyz
mul o3, r1, c12
mov o4.zw, r0
add o2.xyz, r2, -c9
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Vector 13 [_BumpDirection]
Vector 12 [_BumpTiling]
Matrix 8 [_Object2World] 4
Vector 2 [_ProjectionParams]
Vector 3 [_ScreenParams]
Vector 0 [_Time]
Vector 1 [_WorldSpaceCameraPos]
Matrix 4 [glstate_matrix_mvp] 4
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 22.67 (17 instructions), vertex: 32, texture: 0,
//   sequencer: 12,  4 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaacbmaaaaabeiaaaaaaaaaaaaaaceaaaaabkeaaaaabmmaaaaaaaa
aaaaaaaaaaaaabhmaaaaaabmaaaaabgopppoadaaaaaaaaaiaaaaaabmaaaaaaaa
aaaaabghaaaaaalmaaacaaanaaabaaaaaaaaaammaaaaaaaaaaaaaanmaaacaaam
aaabaaaaaaaaaammaaaaaaaaaaaaaaoiaaacaaaiaaaeaaaaaaaaaapiaaaaaaaa
aaaaabaiaaacaaacaaabaaaaaaaaaammaaaaaaaaaaaaabbkaaacaaadaaabaaaa
aaaaaammaaaaaaaaaaaaabciaaacaaaaaaabaaaaaaaaaammaaaaaaaaaaaaabco
aaacaaabaaabaaaaaaaaabeeaaaaaaaaaaaaabfeaaacaaaeaaaeaaaaaaaaaapi
aaaaaaaafpechfgnhaeegjhcgfgdhegjgpgoaaklaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpechfgnhafegjgmgjgoghaafpepgcgkgfgdhedcfhgphcgmgeaaklkl
aaadaaadaaaeaaaeaaabaaaaaaaaaaaafpfahcgpgkgfgdhegjgpgofagbhcgbgn
hdaafpfdgdhcgfgfgofagbhcgbgnhdaafpfegjgngfaafpfhgphcgmgefdhagbgd
gfedgbgngfhcgbfagphdaaklaaabaaadaaabaaadaaabaaaaaaaaaaaaghgmhdhe
gbhegffpgngbhehcgjhifpgnhghaaahghdfpddfpdaaadccodacodcdadddfddco
daaaklklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaabaiaadbaaadaaaaaaaaaaaaaaaa
aaaadmieaaaaaaabaaaaaaabaaaaaaafaaaaacjaaaaaaaadaaaapafaaaabhbfb
aaacpcfcaaadpdfdaaaabaapaaaababcaaaababdaaaaaabbaaaababeaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabaabbaad
aaaabcaamcaaaaaaaaaafaaeaaaabcaameaaaaaaaaaagaajgaapbcaaccaaaaaa
afpiaaaaaaaaaanbaaaaaaaamiapaaabaamgiiaakbaaahaamiapaaabaalbnapi
klaaagabmiapaaabaagmdepiklaaafabmiapaaadaablnajeklaaaeabmiapiado
aananaaaocadadaamiahaaabaamgleaakbaaalaamiahaaabaalbmaleklaaakab
miahaaaaaagmleleklaaajabmiahaaacaablmaleklaaaiaamiapaaabaagmkhoo
claaanacmiahaaaaaamagmaakbadppaacalkmaaaabaaaagmocaaaaiakiiaaaaa
aaaaaaebmcaaaaacmiamiaadaanlnlaaocadadaamiahiaabacmamaaakaacabaa
miapiaacaahkaaaakbabamaamiadiaadaamgbkbiklaaadaaaaaaaaaaaaaaaaaa
aaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Matrix 256 [glstate_matrix_mvp]
Bind "vertex" Vertex
Vector 467 [_Time]
Vector 466 [_WorldSpaceCameraPos]
Vector 465 [_ProjectionParams]
Matrix 260 [_Object2World]
Vector 464 [_BumpTiling]
Vector 463 [_BumpDirection]
"sce_vp_rsx // 17 instructions using 3 registers
[Configuration]
8
0000001100010300
[Defaults]
1
462 3
000000003f8000003f000000
[Microcode]
272
401f9c6c005ce0088186c0836041ff9c00009c6c005cf00d8186c0836041fffc
00001c6c01d0300d8106c0c360403ffc00001c6c01d0200d8106c0c360405ffc
00001c6c01d0100d8106c0c360409ffc00001c6c01d0000d8106c0c360411ffc
00011c6c01d0500d8106c0c360409ffc00011c6c01d0600d8106c0c360405ffc
00011c6c01d0400d8106c0c360411ffc00009c6c011d300d828000c44121fffc
401f9c6c00dd208c0186c0830121dfa0401f9c6c0040000d8086c0836041ff80
401f9c6c004000558086c08360407fa800001c6c009ce00e00aa80c36041dffc
401f9c6c009d000d8286c0c36041ffa400001c6c009d102a808000c360409ffc
401f9c6c00c000080086c09540219fa9
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304 // 208 used size, 19 vars
Vector 176 [_BumpTiling] 4
Vector 192 [_BumpDirection] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 0 [_Time] 4
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 18 instructions, 2 temp regs, 0 temp arrays:
// ALU 14 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecednacbbikjnbbodgboeepnfpmghpcmgpenabaaaaaahiaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcnmacaaaaeaaaabaa
lhaaaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaipccabaaaabaaaaaa
aceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaiadpdiaaaaaihcaabaaaabaaaaaa
fgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaaaabaaaaaa
egiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaabaaaaaaagiacaaa
abaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaabaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaalaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
aeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 worldSpaceVertex_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_1 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  tmpvar_2.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex_1 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_1.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_5;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _InvFadeParemeter;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _ZBufferParams;
void main ()
{
  mediump vec4 baseColor_1;
  mediump float depth_2;
  mediump vec4 edgeBlendFactors_3;
  highp float nh_4;
  mediump vec3 h_5;
  mediump vec4 rtReflections_6;
  mediump vec4 screenWithOffset_7;
  mediump vec4 distortOffset_8;
  mediump vec3 viewVector_9;
  mediump vec3 worldNormal_10;
  mediump vec4 coords_11;
  coords_11 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_12;
  vertexNormal_12 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_13;
  bumpStrength_13 = _DistortParams.x;
  mediump vec4 bump_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = (texture2D (_BumpMap, coords_11.xy) + texture2D (_BumpMap, coords_11.zw));
  bump_14 = tmpvar_15;
  bump_14.xy = (bump_14.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize((vertexNormal_12 + ((bump_14.xxy * bumpStrength_13) * vec3(1.0, 0.0, 1.0))));
  worldNormal_10.y = tmpvar_16.y;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize(xlv_TEXCOORD1);
  viewVector_9 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.zw = vec2(0.0, 0.0);
  tmpvar_18.xy = ((tmpvar_16.xz * _DistortParams.y) * 10.0);
  distortOffset_8 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19 = (xlv_TEXCOORD3 + distortOffset_8);
  screenWithOffset_7 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2DProj (_ReflectionTex, screenWithOffset_7);
  rtReflections_6 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((_WorldLightDir.xyz + viewVector_9));
  h_5 = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, dot (tmpvar_16, -(h_5)));
  nh_4 = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth_2 = tmpvar_23;
  highp float tmpvar_24;
  highp float z_25;
  z_25 = depth_2;
  tmpvar_24 = (1.0/(((_ZBufferParams.z * z_25) + _ZBufferParams.w)));
  depth_2 = tmpvar_24;
  highp vec4 tmpvar_26;
  tmpvar_26 = clamp ((_InvFadeParemeter * (depth_2 - xlv_TEXCOORD3.z)), 0.0, 1.0);
  edgeBlendFactors_3 = tmpvar_26;
  highp vec2 tmpvar_27;
  tmpvar_27 = (tmpvar_16.xz * _FresnelScale);
  worldNormal_10.xz = tmpvar_27;
  mediump float bias_28;
  bias_28 = _DistortParams.w;
  mediump float power_29;
  power_29 = _DistortParams.z;
  mediump float tmpvar_30;
  tmpvar_30 = clamp ((bias_28 + ((1.0 - bias_28) * pow (clamp ((1.0 - max (dot (-(viewVector_9), worldNormal_10), 0.0)), 0.0, 1.0), power_29))), 0.0, 1.0);
  baseColor_1 = _BaseColor;
  mediump float tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp vec4 tmpvar_32;
  tmpvar_32 = mix (baseColor_1, mix (rtReflections_6, _ReflectionColor, _ReflectionColor.wwww), vec4(tmpvar_31));
  baseColor_1 = tmpvar_32;
  highp vec4 tmpvar_33;
  tmpvar_33 = (baseColor_1 + (max (0.0, pow (nh_4, _Shininess)) * _SpecularColor));
  baseColor_1.xyz = tmpvar_33.xyz;
  baseColor_1.w = (edgeBlendFactors_3.x * clamp ((0.5 + tmpvar_30), 0.0, 1.0));
  gl_FragData[0] = baseColor_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 worldSpaceVertex_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_1 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  tmpvar_2.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex_1 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_1.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_5;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _InvFadeParemeter;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
uniform highp vec4 _ZBufferParams;
void main ()
{
  mediump vec4 baseColor_1;
  mediump float depth_2;
  mediump vec4 edgeBlendFactors_3;
  highp float nh_4;
  mediump vec3 h_5;
  mediump vec4 rtReflections_6;
  mediump vec4 screenWithOffset_7;
  mediump vec4 distortOffset_8;
  mediump vec3 viewVector_9;
  mediump vec3 worldNormal_10;
  mediump vec4 coords_11;
  coords_11 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_12;
  vertexNormal_12 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_13;
  bumpStrength_13 = _DistortParams.x;
  mediump vec4 bump_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = (texture2D (_BumpMap, coords_11.xy) + texture2D (_BumpMap, coords_11.zw));
  bump_14 = tmpvar_15;
  bump_14.xy = (bump_14.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize((vertexNormal_12 + ((bump_14.xxy * bumpStrength_13) * vec3(1.0, 0.0, 1.0))));
  worldNormal_10.y = tmpvar_16.y;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize(xlv_TEXCOORD1);
  viewVector_9 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.zw = vec2(0.0, 0.0);
  tmpvar_18.xy = ((tmpvar_16.xz * _DistortParams.y) * 10.0);
  distortOffset_8 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19 = (xlv_TEXCOORD3 + distortOffset_8);
  screenWithOffset_7 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2DProj (_ReflectionTex, screenWithOffset_7);
  rtReflections_6 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((_WorldLightDir.xyz + viewVector_9));
  h_5 = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, dot (tmpvar_16, -(h_5)));
  nh_4 = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth_2 = tmpvar_23;
  highp float tmpvar_24;
  highp float z_25;
  z_25 = depth_2;
  tmpvar_24 = (1.0/(((_ZBufferParams.z * z_25) + _ZBufferParams.w)));
  depth_2 = tmpvar_24;
  highp vec4 tmpvar_26;
  tmpvar_26 = clamp ((_InvFadeParemeter * (depth_2 - xlv_TEXCOORD3.z)), 0.0, 1.0);
  edgeBlendFactors_3 = tmpvar_26;
  highp vec2 tmpvar_27;
  tmpvar_27 = (tmpvar_16.xz * _FresnelScale);
  worldNormal_10.xz = tmpvar_27;
  mediump float bias_28;
  bias_28 = _DistortParams.w;
  mediump float power_29;
  power_29 = _DistortParams.z;
  mediump float tmpvar_30;
  tmpvar_30 = clamp ((bias_28 + ((1.0 - bias_28) * pow (clamp ((1.0 - max (dot (-(viewVector_9), worldNormal_10), 0.0)), 0.0, 1.0), power_29))), 0.0, 1.0);
  baseColor_1 = _BaseColor;
  mediump float tmpvar_31;
  tmpvar_31 = clamp (tmpvar_30, 0.0, 1.0);
  highp vec4 tmpvar_32;
  tmpvar_32 = mix (baseColor_1, mix (rtReflections_6, _ReflectionColor, _ReflectionColor.wwww), vec4(tmpvar_31));
  baseColor_1 = tmpvar_32;
  highp vec4 tmpvar_33;
  tmpvar_33 = (baseColor_1 + (max (0.0, pow (nh_4, _Shininess)) * _SpecularColor));
  baseColor_1.xyz = tmpvar_33.xyz;
  baseColor_1.w = (edgeBlendFactors_3.x * clamp ((0.5 + tmpvar_30), 0.0, 1.0));
  gl_FragData[0] = baseColor_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 480
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 490
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 499
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 351
#line 374
#line 391
#line 403
#line 448
#line 469
#line 506
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 510
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 514
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 518
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 522
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 526
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 546
#line 575
#line 616
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 469
void Gerstner( out mediump vec3 offs, out mediump vec3 nrml, in mediump vec3 vtx, in mediump vec3 tileableVtx, in mediump vec4 amplitude, in mediump vec4 frequency, in mediump vec4 steepness, in mediump vec4 speed, in mediump vec4 directionAB, in mediump vec4 directionCD ) {
    offs = vec3( 0.0, 0.0, 0.0);
    nrml = vec3( 0.0, 1.0, 0.0);
}
#line 575
v2f_noGrab vert300( in appdata_full v ) {
    v2f_noGrab o;
    mediump vec3 worldSpaceVertex = (_Object2World * v.vertex).xyz;
    #line 579
    mediump vec3 vtxForAni = (worldSpaceVertex.xzz * unity_Scale.w);
    mediump vec3 nrml;
    mediump vec3 offsets;
    Gerstner( offsets, nrml, v.vertex.xyz, vtxForAni, _GAmplitude, _GFrequency, _GSteepness, _GSpeed, _GDirectionAB, _GDirectionCD);
    #line 583
    v.vertex.xyz += offsets;
    mediump vec2 tileableUv = worldSpaceVertex.xz;
    o.bumpCoords.xyzw = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection.xyzw)) * _BumpTiling.xyzw);
    o.viewInterpolator.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
    #line 587
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.screenPos = ComputeScreenPos( o.pos);
    o.normalInterpolator.xyz = nrml;
    o.normalInterpolator.w = 1.0;
    #line 591
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_noGrab xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert300( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.normalInterpolator);
    xlv_TEXCOORD1 = vec3(xl_retval.viewInterpolator);
    xlv_TEXCOORD2 = vec4(xl_retval.bumpCoords);
    xlv_TEXCOORD3 = vec4(xl_retval.screenPos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 480
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 490
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 499
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 351
#line 374
#line 391
#line 403
#line 448
#line 469
#line 506
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 510
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 514
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 518
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 522
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 526
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 546
#line 575
#line 616
#line 385
mediump float Fresnel( in mediump vec3 viewVector, in mediump vec3 worldNormal, in mediump float bias, in mediump float power ) {
    #line 387
    mediump float facing = clamp( (1.0 - max( dot( (-viewVector), worldNormal), 0.0)), 0.0, 1.0);
    mediump float refl2Refr = xll_saturate_f((bias + ((1.0 - bias) * pow( facing, power))));
    return refl2Refr;
}
#line 280
highp float LinearEyeDepth( in highp float z ) {
    #line 282
    return (1.0 / ((_ZBufferParams.z * z) + _ZBufferParams.w));
}
#line 316
mediump vec3 PerPixelNormal( in sampler2D bumpMap, in mediump vec4 coords, in mediump vec3 vertexNormal, in mediump float bumpStrength ) {
    mediump vec4 bump = (texture( bumpMap, coords.xy) + texture( bumpMap, coords.zw));
    #line 319
    bump.xy = (bump.wy - vec2( 1.0, 1.0));
    mediump vec3 worldNormal = (vertexNormal + ((bump.xxy * bumpStrength) * vec3( 1.0, 0.0, 1.0)));
    return normalize(worldNormal);
}
#line 593
mediump vec4 frag300( in v2f_noGrab i ) {
    #line 595
    mediump vec3 worldNormal = PerPixelNormal( _BumpMap, i.bumpCoords, i.normalInterpolator.xyz, _DistortParams.x);
    mediump vec3 viewVector = normalize(i.viewInterpolator.xyz);
    mediump vec4 distortOffset = vec4( ((worldNormal.xz * _DistortParams.y) * 10.0), 0.0, 0.0);
    mediump vec4 screenWithOffset = (i.screenPos + distortOffset);
    #line 599
    mediump vec4 rtReflections = textureProj( _ReflectionTex, screenWithOffset);
    mediump vec3 reflectVector = normalize(reflect( viewVector, worldNormal));
    mediump vec3 h = normalize((_WorldLightDir.xyz + viewVector.xyz));
    highp float nh = max( 0.0, dot( worldNormal, (-h)));
    #line 603
    highp float spec = max( 0.0, pow( nh, _Shininess));
    mediump vec4 edgeBlendFactors = vec4( 1.0, 0.0, 0.0, 0.0);
    mediump float depth = textureProj( _CameraDepthTexture, i.screenPos).x;
    depth = LinearEyeDepth( depth);
    #line 607
    edgeBlendFactors = xll_saturate_vf4((_InvFadeParemeter * (depth - i.screenPos.z)));
    worldNormal.xz *= _FresnelScale;
    mediump float refl2Refr = Fresnel( viewVector, worldNormal, _DistortParams.w, _DistortParams.z);
    mediump vec4 baseColor = _BaseColor;
    #line 611
    baseColor = mix( baseColor, mix( rtReflections, _ReflectionColor, vec4( _ReflectionColor.w)), vec4( xll_saturate_f((refl2Refr * 1.0))));
    baseColor = (baseColor + (spec * _SpecularColor));
    baseColor.w = (edgeBlendFactors.x * xll_saturate_f((0.5 + (refl2Refr * 1.0))));
    return baseColor;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    mediump vec4 xl_retval;
    v2f_noGrab xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.normalInterpolator = vec4(xlv_TEXCOORD0);
    xlt_i.viewInterpolator = vec3(xlv_TEXCOORD1);
    xlt_i.bumpCoords = vec4(xlv_TEXCOORD2);
    xlt_i.screenPos = vec4(xlv_TEXCOORD3);
    xl_retval = frag300( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_4;
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (tmpvar_2 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_2.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_4;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _InvFadeParemeter;
uniform vec4 _ReflectionColor;
uniform vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform vec4 _ZBufferParams;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  baseColor_1.xyz = (_ReflectionColor + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = (clamp ((_InvFadeParemeter * ((1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w))) - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0)), 0.0, 1.0));
  gl_FragData[0] = baseColor_1;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 17 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c14.x
mul r1.y, r1, c10.x
mov o0, r0
dp4 r2.x, v0, c4
dp4 r2.z, v0, c6
dp4 r2.y, v0, c5
mad o4.xy, r1.z, c11.zwzw, r1
mov r0.x, c8
mad r1, c13, r0.x, r2.xzxz
mov o1, c14.yzyz
mul o3, r1, c12
mov o4.zw, r0
add o2.xyz, r2, -c9
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Bind "vertex" Vertex
Vector 13 [_BumpDirection]
Vector 12 [_BumpTiling]
Matrix 8 [_Object2World] 4
Vector 2 [_ProjectionParams]
Vector 3 [_ScreenParams]
Vector 0 [_Time]
Vector 1 [_WorldSpaceCameraPos]
Matrix 4 [glstate_matrix_mvp] 4
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 22.67 (17 instructions), vertex: 32, texture: 0,
//   sequencer: 12,  4 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaacbmaaaaabeiaaaaaaaaaaaaaaceaaaaabkeaaaaabmmaaaaaaaa
aaaaaaaaaaaaabhmaaaaaabmaaaaabgopppoadaaaaaaaaaiaaaaaabmaaaaaaaa
aaaaabghaaaaaalmaaacaaanaaabaaaaaaaaaammaaaaaaaaaaaaaanmaaacaaam
aaabaaaaaaaaaammaaaaaaaaaaaaaaoiaaacaaaiaaaeaaaaaaaaaapiaaaaaaaa
aaaaabaiaaacaaacaaabaaaaaaaaaammaaaaaaaaaaaaabbkaaacaaadaaabaaaa
aaaaaammaaaaaaaaaaaaabciaaacaaaaaaabaaaaaaaaaammaaaaaaaaaaaaabco
aaacaaabaaabaaaaaaaaabeeaaaaaaaaaaaaabfeaaacaaaeaaaeaaaaaaaaaapi
aaaaaaaafpechfgnhaeegjhcgfgdhegjgpgoaaklaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpechfgnhafegjgmgjgoghaafpepgcgkgfgdhedcfhgphcgmgeaaklkl
aaadaaadaaaeaaaeaaabaaaaaaaaaaaafpfahcgpgkgfgdhegjgpgofagbhcgbgn
hdaafpfdgdhcgfgfgofagbhcgbgnhdaafpfegjgngfaafpfhgphcgmgefdhagbgd
gfedgbgngfhcgbfagphdaaklaaabaaadaaabaaadaaabaaaaaaaaaaaaghgmhdhe
gbhegffpgngbhehcgjhifpgnhghaaahghdfpddfpdaaadccodacodcdadddfddco
daaaklklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaabaiaadbaaadaaaaaaaaaaaaaaaa
aaaadmieaaaaaaabaaaaaaabaaaaaaafaaaaacjaaaaaaaadaaaapafaaaabhbfb
aaacpcfcaaadpdfdaaaabaapaaaababcaaaababdaaaaaabbaaaababeaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabaabbaad
aaaabcaamcaaaaaaaaaafaaeaaaabcaameaaaaaaaaaagaajgaapbcaaccaaaaaa
afpiaaaaaaaaaanbaaaaaaaamiapaaabaamgiiaakbaaahaamiapaaabaalbnapi
klaaagabmiapaaabaagmdepiklaaafabmiapaaadaablnajeklaaaeabmiapiado
aananaaaocadadaamiahaaabaamgleaakbaaalaamiahaaabaalbmaleklaaakab
miahaaaaaagmleleklaaajabmiahaaacaablmaleklaaaiaamiapaaabaagmkhoo
claaanacmiahaaaaaamagmaakbadppaacalkmaaaabaaaagmocaaaaiakiiaaaaa
aaaaaaebmcaaaaacmiamiaadaanlnlaaocadadaamiahiaabacmamaaakaacabaa
miapiaacaahkaaaakbabamaamiadiaadaamgbkbiklaaadaaaaaaaaaaaaaaaaaa
aaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Matrix 256 [glstate_matrix_mvp]
Bind "vertex" Vertex
Vector 467 [_Time]
Vector 466 [_WorldSpaceCameraPos]
Vector 465 [_ProjectionParams]
Matrix 260 [_Object2World]
Vector 464 [_BumpTiling]
Vector 463 [_BumpDirection]
"sce_vp_rsx // 17 instructions using 3 registers
[Configuration]
8
0000001100010300
[Defaults]
1
462 3
000000003f8000003f000000
[Microcode]
272
401f9c6c005ce0088186c0836041ff9c00009c6c005cf00d8186c0836041fffc
00001c6c01d0300d8106c0c360403ffc00001c6c01d0200d8106c0c360405ffc
00001c6c01d0100d8106c0c360409ffc00001c6c01d0000d8106c0c360411ffc
00011c6c01d0500d8106c0c360409ffc00011c6c01d0600d8106c0c360405ffc
00011c6c01d0400d8106c0c360411ffc00009c6c011d300d828000c44121fffc
401f9c6c00dd208c0186c0830121dfa0401f9c6c0040000d8086c0836041ff80
401f9c6c004000558086c08360407fa800001c6c009ce00e00aa80c36041dffc
401f9c6c009d000d8286c0c36041ffa400001c6c009d102a808000c360409ffc
401f9c6c00c000080086c09540219fa9
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304 // 208 used size, 19 vars
Vector 176 [_BumpTiling] 4
Vector 192 [_BumpDirection] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 0 [_Time] 4
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 18 instructions, 2 temp regs, 0 temp arrays:
// ALU 14 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecednacbbikjnbbodgboeepnfpmghpcmgpenabaaaaaahiaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcnmacaaaaeaaaabaa
lhaaaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaipccabaaaabaaaaaa
aceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaiadpdiaaaaaihcaabaaaabaaaaaa
fgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaaaabaaaaaa
egiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaabaaaaaaagiacaaa
abaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaabaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaalaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
aeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 worldSpaceVertex_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_1 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  tmpvar_2.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex_1 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_1.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_5;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _InvFadeParemeter;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _ZBufferParams;
void main ()
{
  mediump vec4 baseColor_1;
  mediump float depth_2;
  mediump vec4 edgeBlendFactors_3;
  highp float nh_4;
  mediump vec3 h_5;
  mediump vec3 viewVector_6;
  mediump vec3 worldNormal_7;
  mediump vec4 coords_8;
  coords_8 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_9;
  vertexNormal_9 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_10;
  bumpStrength_10 = _DistortParams.x;
  mediump vec4 bump_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = (texture2D (_BumpMap, coords_8.xy) + texture2D (_BumpMap, coords_8.zw));
  bump_11 = tmpvar_12;
  bump_11.xy = (bump_11.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_13;
  tmpvar_13 = normalize((vertexNormal_9 + ((bump_11.xxy * bumpStrength_10) * vec3(1.0, 0.0, 1.0))));
  worldNormal_7.y = tmpvar_13.y;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(xlv_TEXCOORD1);
  viewVector_6 = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((_WorldLightDir.xyz + viewVector_6));
  h_5 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = max (0.0, dot (tmpvar_13, -(h_5)));
  nh_4 = tmpvar_16;
  lowp float tmpvar_17;
  tmpvar_17 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth_2 = tmpvar_17;
  highp float tmpvar_18;
  highp float z_19;
  z_19 = depth_2;
  tmpvar_18 = (1.0/(((_ZBufferParams.z * z_19) + _ZBufferParams.w)));
  depth_2 = tmpvar_18;
  highp vec4 tmpvar_20;
  tmpvar_20 = clamp ((_InvFadeParemeter * (depth_2 - xlv_TEXCOORD3.z)), 0.0, 1.0);
  edgeBlendFactors_3 = tmpvar_20;
  highp vec2 tmpvar_21;
  tmpvar_21 = (tmpvar_13.xz * _FresnelScale);
  worldNormal_7.xz = tmpvar_21;
  mediump float bias_22;
  bias_22 = _DistortParams.w;
  mediump float power_23;
  power_23 = _DistortParams.z;
  baseColor_1 = _ReflectionColor;
  highp vec4 tmpvar_24;
  tmpvar_24 = (baseColor_1 + (max (0.0, pow (nh_4, _Shininess)) * _SpecularColor));
  baseColor_1.xyz = tmpvar_24.xyz;
  baseColor_1.w = (edgeBlendFactors_3.x * clamp ((0.5 + clamp ((bias_22 + ((1.0 - bias_22) * pow (clamp ((1.0 - max (dot (-(viewVector_6), worldNormal_7), 0.0)), 0.0, 1.0), power_23))), 0.0, 1.0)), 0.0, 1.0));
  gl_FragData[0] = baseColor_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 worldSpaceVertex_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_1 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  tmpvar_2.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex_1 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_1.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_5;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _InvFadeParemeter;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _ZBufferParams;
void main ()
{
  mediump vec4 baseColor_1;
  mediump float depth_2;
  mediump vec4 edgeBlendFactors_3;
  highp float nh_4;
  mediump vec3 h_5;
  mediump vec3 viewVector_6;
  mediump vec3 worldNormal_7;
  mediump vec4 coords_8;
  coords_8 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_9;
  vertexNormal_9 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_10;
  bumpStrength_10 = _DistortParams.x;
  mediump vec4 bump_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = (texture2D (_BumpMap, coords_8.xy) + texture2D (_BumpMap, coords_8.zw));
  bump_11 = tmpvar_12;
  bump_11.xy = (bump_11.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_13;
  tmpvar_13 = normalize((vertexNormal_9 + ((bump_11.xxy * bumpStrength_10) * vec3(1.0, 0.0, 1.0))));
  worldNormal_7.y = tmpvar_13.y;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(xlv_TEXCOORD1);
  viewVector_6 = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((_WorldLightDir.xyz + viewVector_6));
  h_5 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = max (0.0, dot (tmpvar_13, -(h_5)));
  nh_4 = tmpvar_16;
  lowp float tmpvar_17;
  tmpvar_17 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth_2 = tmpvar_17;
  highp float tmpvar_18;
  highp float z_19;
  z_19 = depth_2;
  tmpvar_18 = (1.0/(((_ZBufferParams.z * z_19) + _ZBufferParams.w)));
  depth_2 = tmpvar_18;
  highp vec4 tmpvar_20;
  tmpvar_20 = clamp ((_InvFadeParemeter * (depth_2 - xlv_TEXCOORD3.z)), 0.0, 1.0);
  edgeBlendFactors_3 = tmpvar_20;
  highp vec2 tmpvar_21;
  tmpvar_21 = (tmpvar_13.xz * _FresnelScale);
  worldNormal_7.xz = tmpvar_21;
  mediump float bias_22;
  bias_22 = _DistortParams.w;
  mediump float power_23;
  power_23 = _DistortParams.z;
  baseColor_1 = _ReflectionColor;
  highp vec4 tmpvar_24;
  tmpvar_24 = (baseColor_1 + (max (0.0, pow (nh_4, _Shininess)) * _SpecularColor));
  baseColor_1.xyz = tmpvar_24.xyz;
  baseColor_1.w = (edgeBlendFactors_3.x * clamp ((0.5 + clamp ((bias_22 + ((1.0 - bias_22) * pow (clamp ((1.0 - max (dot (-(viewVector_6), worldNormal_7), 0.0)), 0.0, 1.0), power_23))), 0.0, 1.0)), 0.0, 1.0));
  gl_FragData[0] = baseColor_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 480
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 490
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 499
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 351
#line 374
#line 391
#line 403
#line 448
#line 469
#line 506
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 510
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 514
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 518
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 522
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 526
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 546
#line 574
#line 614
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 469
void Gerstner( out mediump vec3 offs, out mediump vec3 nrml, in mediump vec3 vtx, in mediump vec3 tileableVtx, in mediump vec4 amplitude, in mediump vec4 frequency, in mediump vec4 steepness, in mediump vec4 speed, in mediump vec4 directionAB, in mediump vec4 directionCD ) {
    offs = vec3( 0.0, 0.0, 0.0);
    nrml = vec3( 0.0, 1.0, 0.0);
}
#line 574
v2f_noGrab vert300( in appdata_full v ) {
    v2f_noGrab o;
    mediump vec3 worldSpaceVertex = (_Object2World * v.vertex).xyz;
    #line 578
    mediump vec3 vtxForAni = (worldSpaceVertex.xzz * unity_Scale.w);
    mediump vec3 nrml;
    mediump vec3 offsets;
    Gerstner( offsets, nrml, v.vertex.xyz, vtxForAni, _GAmplitude, _GFrequency, _GSteepness, _GSpeed, _GDirectionAB, _GDirectionCD);
    #line 582
    v.vertex.xyz += offsets;
    mediump vec2 tileableUv = worldSpaceVertex.xz;
    o.bumpCoords.xyzw = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection.xyzw)) * _BumpTiling.xyzw);
    o.viewInterpolator.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
    #line 586
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.screenPos = ComputeScreenPos( o.pos);
    o.normalInterpolator.xyz = nrml;
    o.normalInterpolator.w = 1.0;
    #line 590
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_noGrab xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert300( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.normalInterpolator);
    xlv_TEXCOORD1 = vec3(xl_retval.viewInterpolator);
    xlv_TEXCOORD2 = vec4(xl_retval.bumpCoords);
    xlv_TEXCOORD3 = vec4(xl_retval.screenPos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 480
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 490
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 499
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 351
#line 374
#line 391
#line 403
#line 448
#line 469
#line 506
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 510
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 514
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 518
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 522
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 526
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 546
#line 574
#line 614
#line 385
mediump float Fresnel( in mediump vec3 viewVector, in mediump vec3 worldNormal, in mediump float bias, in mediump float power ) {
    #line 387
    mediump float facing = clamp( (1.0 - max( dot( (-viewVector), worldNormal), 0.0)), 0.0, 1.0);
    mediump float refl2Refr = xll_saturate_f((bias + ((1.0 - bias) * pow( facing, power))));
    return refl2Refr;
}
#line 280
highp float LinearEyeDepth( in highp float z ) {
    #line 282
    return (1.0 / ((_ZBufferParams.z * z) + _ZBufferParams.w));
}
#line 316
mediump vec3 PerPixelNormal( in sampler2D bumpMap, in mediump vec4 coords, in mediump vec3 vertexNormal, in mediump float bumpStrength ) {
    mediump vec4 bump = (texture( bumpMap, coords.xy) + texture( bumpMap, coords.zw));
    #line 319
    bump.xy = (bump.wy - vec2( 1.0, 1.0));
    mediump vec3 worldNormal = (vertexNormal + ((bump.xxy * bumpStrength) * vec3( 1.0, 0.0, 1.0)));
    return normalize(worldNormal);
}
#line 592
mediump vec4 frag300( in v2f_noGrab i ) {
    #line 594
    mediump vec3 worldNormal = PerPixelNormal( _BumpMap, i.bumpCoords, i.normalInterpolator.xyz, _DistortParams.x);
    mediump vec3 viewVector = normalize(i.viewInterpolator.xyz);
    mediump vec4 distortOffset = vec4( ((worldNormal.xz * _DistortParams.y) * 10.0), 0.0, 0.0);
    mediump vec4 screenWithOffset = (i.screenPos + distortOffset);
    #line 598
    mediump vec3 reflectVector = normalize(reflect( viewVector, worldNormal));
    mediump vec3 h = normalize((_WorldLightDir.xyz + viewVector.xyz));
    highp float nh = max( 0.0, dot( worldNormal, (-h)));
    highp float spec = max( 0.0, pow( nh, _Shininess));
    #line 602
    mediump vec4 edgeBlendFactors = vec4( 1.0, 0.0, 0.0, 0.0);
    mediump float depth = textureProj( _CameraDepthTexture, i.screenPos).x;
    depth = LinearEyeDepth( depth);
    edgeBlendFactors = xll_saturate_vf4((_InvFadeParemeter * (depth - i.screenPos.z)));
    #line 606
    worldNormal.xz *= _FresnelScale;
    mediump float refl2Refr = Fresnel( viewVector, worldNormal, _DistortParams.w, _DistortParams.z);
    mediump vec4 baseColor = _BaseColor;
    baseColor = _ReflectionColor;
    #line 610
    baseColor = (baseColor + (spec * _SpecularColor));
    baseColor.w = (edgeBlendFactors.x * xll_saturate_f((0.5 + (refl2Refr * 1.0))));
    return baseColor;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    mediump vec4 xl_retval;
    v2f_noGrab xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.normalInterpolator = vec4(xlv_TEXCOORD0);
    xlt_i.viewInterpolator = vec3(xlv_TEXCOORD1);
    xlt_i.bumpCoords = vec4(xlv_TEXCOORD2);
    xlt_i.screenPos = vec4(xlv_TEXCOORD3);
    xl_retval = frag300( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_4;
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (tmpvar_2 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_2.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_4;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform vec4 _BaseColor;
uniform vec4 _SpecularColor;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.0, 0.0);
  tmpvar_7.xy = ((tmpvar_5.xz * _DistortParams.y) * 10.0);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  float tmpvar_8;
  tmpvar_8 = clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0);
  baseColor_1.xyz = (mix (_BaseColor, mix (texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_7)), _ReflectionColor, _ReflectionColor.wwww), vec4(clamp (tmpvar_8, 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = clamp ((0.5 + tmpvar_8), 0.0, 1.0);
  gl_FragData[0] = baseColor_1;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 17 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c14.x
mul r1.y, r1, c10.x
mov o0, r0
dp4 r2.x, v0, c4
dp4 r2.z, v0, c6
dp4 r2.y, v0, c5
mad o4.xy, r1.z, c11.zwzw, r1
mov r0.x, c8
mad r1, c13, r0.x, r2.xzxz
mov o1, c14.yzyz
mul o3, r1, c12
mov o4.zw, r0
add o2.xyz, r2, -c9
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Vector 13 [_BumpDirection]
Vector 12 [_BumpTiling]
Matrix 8 [_Object2World] 4
Vector 2 [_ProjectionParams]
Vector 3 [_ScreenParams]
Vector 0 [_Time]
Vector 1 [_WorldSpaceCameraPos]
Matrix 4 [glstate_matrix_mvp] 4
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 22.67 (17 instructions), vertex: 32, texture: 0,
//   sequencer: 12,  4 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaacbmaaaaabeiaaaaaaaaaaaaaaceaaaaabkeaaaaabmmaaaaaaaa
aaaaaaaaaaaaabhmaaaaaabmaaaaabgopppoadaaaaaaaaaiaaaaaabmaaaaaaaa
aaaaabghaaaaaalmaaacaaanaaabaaaaaaaaaammaaaaaaaaaaaaaanmaaacaaam
aaabaaaaaaaaaammaaaaaaaaaaaaaaoiaaacaaaiaaaeaaaaaaaaaapiaaaaaaaa
aaaaabaiaaacaaacaaabaaaaaaaaaammaaaaaaaaaaaaabbkaaacaaadaaabaaaa
aaaaaammaaaaaaaaaaaaabciaaacaaaaaaabaaaaaaaaaammaaaaaaaaaaaaabco
aaacaaabaaabaaaaaaaaabeeaaaaaaaaaaaaabfeaaacaaaeaaaeaaaaaaaaaapi
aaaaaaaafpechfgnhaeegjhcgfgdhegjgpgoaaklaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpechfgnhafegjgmgjgoghaafpepgcgkgfgdhedcfhgphcgmgeaaklkl
aaadaaadaaaeaaaeaaabaaaaaaaaaaaafpfahcgpgkgfgdhegjgpgofagbhcgbgn
hdaafpfdgdhcgfgfgofagbhcgbgnhdaafpfegjgngfaafpfhgphcgmgefdhagbgd
gfedgbgngfhcgbfagphdaaklaaabaaadaaabaaadaaabaaaaaaaaaaaaghgmhdhe
gbhegffpgngbhehcgjhifpgnhghaaahghdfpddfpdaaadccodacodcdadddfddco
daaaklklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaabaiaadbaaadaaaaaaaaaaaaaaaa
aaaadmieaaaaaaabaaaaaaabaaaaaaafaaaaacjaaaaaaaadaaaapafaaaabhbfb
aaacpcfcaaadpdfdaaaabaapaaaababcaaaababdaaaaaabbaaaababeaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabaabbaad
aaaabcaamcaaaaaaaaaafaaeaaaabcaameaaaaaaaaaagaajgaapbcaaccaaaaaa
afpiaaaaaaaaaanbaaaaaaaamiapaaabaamgiiaakbaaahaamiapaaabaalbnapi
klaaagabmiapaaabaagmdepiklaaafabmiapaaadaablnajeklaaaeabmiapiado
aananaaaocadadaamiahaaabaamgleaakbaaalaamiahaaabaalbmaleklaaakab
miahaaaaaagmleleklaaajabmiahaaacaablmaleklaaaiaamiapaaabaagmkhoo
claaanacmiahaaaaaamagmaakbadppaacalkmaaaabaaaagmocaaaaiakiiaaaaa
aaaaaaebmcaaaaacmiamiaadaanlnlaaocadadaamiahiaabacmamaaakaacabaa
miapiaacaahkaaaakbabamaamiadiaadaamgbkbiklaaadaaaaaaaaaaaaaaaaaa
aaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Matrix 256 [glstate_matrix_mvp]
Bind "vertex" Vertex
Vector 467 [_Time]
Vector 466 [_WorldSpaceCameraPos]
Vector 465 [_ProjectionParams]
Matrix 260 [_Object2World]
Vector 464 [_BumpTiling]
Vector 463 [_BumpDirection]
"sce_vp_rsx // 17 instructions using 3 registers
[Configuration]
8
0000001100010300
[Defaults]
1
462 3
000000003f8000003f000000
[Microcode]
272
401f9c6c005ce0088186c0836041ff9c00009c6c005cf00d8186c0836041fffc
00001c6c01d0300d8106c0c360403ffc00001c6c01d0200d8106c0c360405ffc
00001c6c01d0100d8106c0c360409ffc00001c6c01d0000d8106c0c360411ffc
00011c6c01d0500d8106c0c360409ffc00011c6c01d0600d8106c0c360405ffc
00011c6c01d0400d8106c0c360411ffc00009c6c011d300d828000c44121fffc
401f9c6c00dd208c0186c0830121dfa0401f9c6c0040000d8086c0836041ff80
401f9c6c004000558086c08360407fa800001c6c009ce00e00aa80c36041dffc
401f9c6c009d000d8286c0c36041ffa400001c6c009d102a808000c360409ffc
401f9c6c00c000080086c09540219fa9
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304 // 208 used size, 19 vars
Vector 176 [_BumpTiling] 4
Vector 192 [_BumpDirection] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 0 [_Time] 4
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 18 instructions, 2 temp regs, 0 temp arrays:
// ALU 14 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecednacbbikjnbbodgboeepnfpmghpcmgpenabaaaaaahiaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcnmacaaaaeaaaabaa
lhaaaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaipccabaaaabaaaaaa
aceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaiadpdiaaaaaihcaabaaaabaaaaaa
fgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaaaabaaaaaa
egiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaabaaaaaaagiacaaa
abaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaabaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaalaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
aeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 worldSpaceVertex_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_1 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  tmpvar_2.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex_1 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_1.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_5;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
void main ()
{
  mediump vec4 baseColor_1;
  highp float nh_2;
  mediump vec3 h_3;
  mediump vec4 rtReflections_4;
  mediump vec4 screenWithOffset_5;
  mediump vec4 distortOffset_6;
  mediump vec3 viewVector_7;
  mediump vec3 worldNormal_8;
  mediump vec4 coords_9;
  coords_9 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_10;
  vertexNormal_10 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_11;
  bumpStrength_11 = _DistortParams.x;
  mediump vec4 bump_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = (texture2D (_BumpMap, coords_9.xy) + texture2D (_BumpMap, coords_9.zw));
  bump_12 = tmpvar_13;
  bump_12.xy = (bump_12.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize((vertexNormal_10 + ((bump_12.xxy * bumpStrength_11) * vec3(1.0, 0.0, 1.0))));
  worldNormal_8.y = tmpvar_14.y;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(xlv_TEXCOORD1);
  viewVector_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, 0.0);
  tmpvar_16.xy = ((tmpvar_14.xz * _DistortParams.y) * 10.0);
  distortOffset_6 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17 = (xlv_TEXCOORD3 + distortOffset_6);
  screenWithOffset_5 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2DProj (_ReflectionTex, screenWithOffset_5);
  rtReflections_4 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((_WorldLightDir.xyz + viewVector_7));
  h_3 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = max (0.0, dot (tmpvar_14, -(h_3)));
  nh_2 = tmpvar_20;
  highp vec2 tmpvar_21;
  tmpvar_21 = (tmpvar_14.xz * _FresnelScale);
  worldNormal_8.xz = tmpvar_21;
  mediump float bias_22;
  bias_22 = _DistortParams.w;
  mediump float power_23;
  power_23 = _DistortParams.z;
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((bias_22 + ((1.0 - bias_22) * pow (clamp ((1.0 - max (dot (-(viewVector_7), worldNormal_8), 0.0)), 0.0, 1.0), power_23))), 0.0, 1.0);
  baseColor_1 = _BaseColor;
  mediump float tmpvar_25;
  tmpvar_25 = clamp (tmpvar_24, 0.0, 1.0);
  highp vec4 tmpvar_26;
  tmpvar_26 = mix (baseColor_1, mix (rtReflections_4, _ReflectionColor, _ReflectionColor.wwww), vec4(tmpvar_25));
  baseColor_1 = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (baseColor_1 + (max (0.0, pow (nh_2, _Shininess)) * _SpecularColor));
  baseColor_1.xyz = tmpvar_27.xyz;
  baseColor_1.w = clamp ((0.5 + tmpvar_24), 0.0, 1.0);
  gl_FragData[0] = baseColor_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 worldSpaceVertex_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_1 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  tmpvar_2.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex_1 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_1.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_5;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ReflectionTex;
uniform sampler2D _BumpMap;
void main ()
{
  mediump vec4 baseColor_1;
  highp float nh_2;
  mediump vec3 h_3;
  mediump vec4 rtReflections_4;
  mediump vec4 screenWithOffset_5;
  mediump vec4 distortOffset_6;
  mediump vec3 viewVector_7;
  mediump vec3 worldNormal_8;
  mediump vec4 coords_9;
  coords_9 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_10;
  vertexNormal_10 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_11;
  bumpStrength_11 = _DistortParams.x;
  mediump vec4 bump_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = (texture2D (_BumpMap, coords_9.xy) + texture2D (_BumpMap, coords_9.zw));
  bump_12 = tmpvar_13;
  bump_12.xy = (bump_12.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize((vertexNormal_10 + ((bump_12.xxy * bumpStrength_11) * vec3(1.0, 0.0, 1.0))));
  worldNormal_8.y = tmpvar_14.y;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(xlv_TEXCOORD1);
  viewVector_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, 0.0);
  tmpvar_16.xy = ((tmpvar_14.xz * _DistortParams.y) * 10.0);
  distortOffset_6 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17 = (xlv_TEXCOORD3 + distortOffset_6);
  screenWithOffset_5 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2DProj (_ReflectionTex, screenWithOffset_5);
  rtReflections_4 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((_WorldLightDir.xyz + viewVector_7));
  h_3 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = max (0.0, dot (tmpvar_14, -(h_3)));
  nh_2 = tmpvar_20;
  highp vec2 tmpvar_21;
  tmpvar_21 = (tmpvar_14.xz * _FresnelScale);
  worldNormal_8.xz = tmpvar_21;
  mediump float bias_22;
  bias_22 = _DistortParams.w;
  mediump float power_23;
  power_23 = _DistortParams.z;
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((bias_22 + ((1.0 - bias_22) * pow (clamp ((1.0 - max (dot (-(viewVector_7), worldNormal_8), 0.0)), 0.0, 1.0), power_23))), 0.0, 1.0);
  baseColor_1 = _BaseColor;
  mediump float tmpvar_25;
  tmpvar_25 = clamp (tmpvar_24, 0.0, 1.0);
  highp vec4 tmpvar_26;
  tmpvar_26 = mix (baseColor_1, mix (rtReflections_4, _ReflectionColor, _ReflectionColor.wwww), vec4(tmpvar_25));
  baseColor_1 = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (baseColor_1 + (max (0.0, pow (nh_2, _Shininess)) * _SpecularColor));
  baseColor_1.xyz = tmpvar_27.xyz;
  baseColor_1.w = clamp ((0.5 + tmpvar_24), 0.0, 1.0);
  gl_FragData[0] = baseColor_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 480
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 490
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 499
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 351
#line 374
#line 391
#line 403
#line 448
#line 469
#line 506
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 510
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 514
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 518
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 522
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 526
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 546
#line 571
#line 619
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 469
void Gerstner( out mediump vec3 offs, out mediump vec3 nrml, in mediump vec3 vtx, in mediump vec3 tileableVtx, in mediump vec4 amplitude, in mediump vec4 frequency, in mediump vec4 steepness, in mediump vec4 speed, in mediump vec4 directionAB, in mediump vec4 directionCD ) {
    offs = vec3( 0.0, 0.0, 0.0);
    nrml = vec3( 0.0, 1.0, 0.0);
}
#line 571
v2f_noGrab vert300( in appdata_full v ) {
    v2f_noGrab o;
    mediump vec3 worldSpaceVertex = (_Object2World * v.vertex).xyz;
    #line 575
    mediump vec3 vtxForAni = (worldSpaceVertex.xzz * unity_Scale.w);
    mediump vec3 nrml;
    mediump vec3 offsets;
    Gerstner( offsets, nrml, v.vertex.xyz, vtxForAni, _GAmplitude, _GFrequency, _GSteepness, _GSpeed, _GDirectionAB, _GDirectionCD);
    #line 579
    v.vertex.xyz += offsets;
    mediump vec2 tileableUv = worldSpaceVertex.xz;
    o.bumpCoords.xyzw = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection.xyzw)) * _BumpTiling.xyzw);
    o.viewInterpolator.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
    #line 583
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.screenPos = ComputeScreenPos( o.pos);
    o.normalInterpolator.xyz = nrml;
    o.normalInterpolator.w = 1.0;
    #line 587
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_noGrab xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert300( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.normalInterpolator);
    xlv_TEXCOORD1 = vec3(xl_retval.viewInterpolator);
    xlv_TEXCOORD2 = vec4(xl_retval.bumpCoords);
    xlv_TEXCOORD3 = vec4(xl_retval.screenPos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 480
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 490
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 499
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 351
#line 374
#line 391
#line 403
#line 448
#line 469
#line 506
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 510
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 514
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 518
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 522
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 526
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 546
#line 571
#line 619
#line 385
mediump float Fresnel( in mediump vec3 viewVector, in mediump vec3 worldNormal, in mediump float bias, in mediump float power ) {
    #line 387
    mediump float facing = clamp( (1.0 - max( dot( (-viewVector), worldNormal), 0.0)), 0.0, 1.0);
    mediump float refl2Refr = xll_saturate_f((bias + ((1.0 - bias) * pow( facing, power))));
    return refl2Refr;
}
#line 316
mediump vec3 PerPixelNormal( in sampler2D bumpMap, in mediump vec4 coords, in mediump vec3 vertexNormal, in mediump float bumpStrength ) {
    mediump vec4 bump = (texture( bumpMap, coords.xy) + texture( bumpMap, coords.zw));
    #line 319
    bump.xy = (bump.wy - vec2( 1.0, 1.0));
    mediump vec3 worldNormal = (vertexNormal + ((bump.xxy * bumpStrength) * vec3( 1.0, 0.0, 1.0)));
    return normalize(worldNormal);
}
#line 589
mediump vec4 frag300( in v2f_noGrab i ) {
    #line 591
    mediump vec3 worldNormal = PerPixelNormal( _BumpMap, i.bumpCoords, i.normalInterpolator.xyz, _DistortParams.x);
    mediump vec3 viewVector = normalize(i.viewInterpolator.xyz);
    mediump vec4 distortOffset = vec4( ((worldNormal.xz * _DistortParams.y) * 10.0), 0.0, 0.0);
    mediump vec4 screenWithOffset = (i.screenPos + distortOffset);
    #line 595
    mediump vec4 rtReflections = textureProj( _ReflectionTex, screenWithOffset);
    mediump vec3 reflectVector = normalize(reflect( viewVector, worldNormal));
    mediump vec3 h = normalize((_WorldLightDir.xyz + viewVector.xyz));
    highp float nh = max( 0.0, dot( worldNormal, (-h)));
    #line 599
    highp float spec = max( 0.0, pow( nh, _Shininess));
    mediump vec4 edgeBlendFactors = vec4( 1.0, 0.0, 0.0, 0.0);
    worldNormal.xz *= _FresnelScale;
    mediump float refl2Refr = Fresnel( viewVector, worldNormal, _DistortParams.w, _DistortParams.z);
    #line 603
    mediump vec4 baseColor = _BaseColor;
    baseColor = mix( baseColor, mix( rtReflections, _ReflectionColor, vec4( _ReflectionColor.w)), vec4( xll_saturate_f((refl2Refr * 1.0))));
    baseColor = (baseColor + (spec * _SpecularColor));
    baseColor.w = (edgeBlendFactors.x * xll_saturate_f((0.5 + (refl2Refr * 1.0))));
    #line 607
    return baseColor;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    mediump vec4 xl_retval;
    v2f_noGrab xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.normalInterpolator = vec4(xlv_TEXCOORD0);
    xlt_i.viewInterpolator = vec3(xlv_TEXCOORD1);
    xlt_i.bumpCoords = vec4(xlv_TEXCOORD2);
    xlt_i.screenPos = vec4(xlv_TEXCOORD3);
    xl_retval = frag300( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _BumpDirection;
uniform vec4 _BumpTiling;
uniform mat4 _Object2World;

uniform vec4 _ProjectionParams;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
void main ()
{
  vec4 tmpvar_1;
  vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex).xyz;
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_4;
  vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (tmpvar_2 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tmpvar_2.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_4;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform vec4 _WorldLightDir;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform vec4 _SpecularColor;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 baseColor_1;
  vec3 worldNormal_2;
  vec4 bump_3;
  vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump_3.zw = tmpvar_4.zw;
  bump_3.xy = (tmpvar_4.wy - vec2(1.0, 1.0));
  vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD0.xyz + ((bump_3.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal_2.y = tmpvar_5.y;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD1);
  worldNormal_2.xz = (tmpvar_5.xz * _FresnelScale);
  baseColor_1.xyz = (_ReflectionColor + (max (0.0, pow (max (0.0, dot (tmpvar_5, -(normalize((_WorldLightDir.xyz + tmpvar_6))))), _Shininess)) * _SpecularColor)).xyz;
  baseColor_1.w = clamp ((0.5 + clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_6), worldNormal_2), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0)), 0.0, 1.0);
  gl_FragData[0] = baseColor_1;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 17 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c14.x
mul r1.y, r1, c10.x
mov o0, r0
dp4 r2.x, v0, c4
dp4 r2.z, v0, c6
dp4 r2.y, v0, c5
mad o4.xy, r1.z, c11.zwzw, r1
mov r0.x, c8
mad r1, c13, r0.x, r2.xzxz
mov o1, c14.yzyz
mul o3, r1, c12
mov o4.zw, r0
add o2.xyz, r2, -c9
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Bind "vertex" Vertex
Vector 13 [_BumpDirection]
Vector 12 [_BumpTiling]
Matrix 8 [_Object2World] 4
Vector 2 [_ProjectionParams]
Vector 3 [_ScreenParams]
Vector 0 [_Time]
Vector 1 [_WorldSpaceCameraPos]
Matrix 4 [glstate_matrix_mvp] 4
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 22.67 (17 instructions), vertex: 32, texture: 0,
//   sequencer: 12,  4 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaacbmaaaaabeiaaaaaaaaaaaaaaceaaaaabkeaaaaabmmaaaaaaaa
aaaaaaaaaaaaabhmaaaaaabmaaaaabgopppoadaaaaaaaaaiaaaaaabmaaaaaaaa
aaaaabghaaaaaalmaaacaaanaaabaaaaaaaaaammaaaaaaaaaaaaaanmaaacaaam
aaabaaaaaaaaaammaaaaaaaaaaaaaaoiaaacaaaiaaaeaaaaaaaaaapiaaaaaaaa
aaaaabaiaaacaaacaaabaaaaaaaaaammaaaaaaaaaaaaabbkaaacaaadaaabaaaa
aaaaaammaaaaaaaaaaaaabciaaacaaaaaaabaaaaaaaaaammaaaaaaaaaaaaabco
aaacaaabaaabaaaaaaaaabeeaaaaaaaaaaaaabfeaaacaaaeaaaeaaaaaaaaaapi
aaaaaaaafpechfgnhaeegjhcgfgdhegjgpgoaaklaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpechfgnhafegjgmgjgoghaafpepgcgkgfgdhedcfhgphcgmgeaaklkl
aaadaaadaaaeaaaeaaabaaaaaaaaaaaafpfahcgpgkgfgdhegjgpgofagbhcgbgn
hdaafpfdgdhcgfgfgofagbhcgbgnhdaafpfegjgngfaafpfhgphcgmgefdhagbgd
gfedgbgngfhcgbfagphdaaklaaabaaadaaabaaadaaabaaaaaaaaaaaaghgmhdhe
gbhegffpgngbhehcgjhifpgnhghaaahghdfpddfpdaaadccodacodcdadddfddco
daaaklklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaabaiaadbaaadaaaaaaaaaaaaaaaa
aaaadmieaaaaaaabaaaaaaabaaaaaaafaaaaacjaaaaaaaadaaaapafaaaabhbfb
aaacpcfcaaadpdfdaaaabaapaaaababcaaaababdaaaaaabbaaaababeaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabaabbaad
aaaabcaamcaaaaaaaaaafaaeaaaabcaameaaaaaaaaaagaajgaapbcaaccaaaaaa
afpiaaaaaaaaaanbaaaaaaaamiapaaabaamgiiaakbaaahaamiapaaabaalbnapi
klaaagabmiapaaabaagmdepiklaaafabmiapaaadaablnajeklaaaeabmiapiado
aananaaaocadadaamiahaaabaamgleaakbaaalaamiahaaabaalbmaleklaaakab
miahaaaaaagmleleklaaajabmiahaaacaablmaleklaaaiaamiapaaabaagmkhoo
claaanacmiahaaaaaamagmaakbadppaacalkmaaaabaaaagmocaaaaiakiiaaaaa
aaaaaaebmcaaaaacmiamiaadaanlnlaaocadadaamiahiaabacmamaaakaacabaa
miapiaacaahkaaaakbabamaamiadiaadaamgbkbiklaaadaaaaaaaaaaaaaaaaaa
aaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Matrix 256 [glstate_matrix_mvp]
Bind "vertex" Vertex
Vector 467 [_Time]
Vector 466 [_WorldSpaceCameraPos]
Vector 465 [_ProjectionParams]
Matrix 260 [_Object2World]
Vector 464 [_BumpTiling]
Vector 463 [_BumpDirection]
"sce_vp_rsx // 17 instructions using 3 registers
[Configuration]
8
0000001100010300
[Defaults]
1
462 3
000000003f8000003f000000
[Microcode]
272
401f9c6c005ce0088186c0836041ff9c00009c6c005cf00d8186c0836041fffc
00001c6c01d0300d8106c0c360403ffc00001c6c01d0200d8106c0c360405ffc
00001c6c01d0100d8106c0c360409ffc00001c6c01d0000d8106c0c360411ffc
00011c6c01d0500d8106c0c360409ffc00011c6c01d0600d8106c0c360405ffc
00011c6c01d0400d8106c0c360411ffc00009c6c011d300d828000c44121fffc
401f9c6c00dd208c0186c0830121dfa0401f9c6c0040000d8086c0836041ff80
401f9c6c004000558086c08360407fa800001c6c009ce00e00aa80c36041dffc
401f9c6c009d000d8286c0c36041ffa400001c6c009d102a808000c360409ffc
401f9c6c00c000080086c09540219fa9
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304 // 208 used size, 19 vars
Vector 176 [_BumpTiling] 4
Vector 192 [_BumpDirection] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 0 [_Time] 4
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 18 instructions, 2 temp regs, 0 temp arrays:
// ALU 14 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecednacbbikjnbbodgboeepnfpmghpcmgpenabaaaaaahiaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcnmacaaaaeaaaabaa
lhaaaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaipccabaaaabaaaaaa
aceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaiadpdiaaaaaihcaabaaaabaaaaaa
fgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaacaaaaaaegacbaaaabaaaaaa
egiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaabaaaaaaagiacaaa
abaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaabaaaaaadiaaaaai
pccabaaaadaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaalaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
aeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 worldSpaceVertex_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_1 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  tmpvar_2.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex_1 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_1.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_5;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _BumpMap;
void main ()
{
  mediump vec4 baseColor_1;
  highp float nh_2;
  mediump vec3 h_3;
  mediump vec3 viewVector_4;
  mediump vec3 worldNormal_5;
  mediump vec4 coords_6;
  coords_6 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_7;
  vertexNormal_7 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_8;
  bumpStrength_8 = _DistortParams.x;
  mediump vec4 bump_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = (texture2D (_BumpMap, coords_6.xy) + texture2D (_BumpMap, coords_6.zw));
  bump_9 = tmpvar_10;
  bump_9.xy = (bump_9.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize((vertexNormal_7 + ((bump_9.xxy * bumpStrength_8) * vec3(1.0, 0.0, 1.0))));
  worldNormal_5.y = tmpvar_11.y;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(xlv_TEXCOORD1);
  viewVector_4 = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((_WorldLightDir.xyz + viewVector_4));
  h_3 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (tmpvar_11, -(h_3)));
  nh_2 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15 = (tmpvar_11.xz * _FresnelScale);
  worldNormal_5.xz = tmpvar_15;
  mediump float bias_16;
  bias_16 = _DistortParams.w;
  mediump float power_17;
  power_17 = _DistortParams.z;
  baseColor_1 = _ReflectionColor;
  highp vec4 tmpvar_18;
  tmpvar_18 = (baseColor_1 + (max (0.0, pow (nh_2, _Shininess)) * _SpecularColor));
  baseColor_1.xyz = tmpvar_18.xyz;
  baseColor_1.w = clamp ((0.5 + clamp ((bias_16 + ((1.0 - bias_16) * pow (clamp ((1.0 - max (dot (-(viewVector_4), worldNormal_5), 0.0)), 0.0, 1.0), power_17))), 0.0, 1.0)), 0.0, 1.0);
  gl_FragData[0] = baseColor_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 worldSpaceVertex_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_1 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  tmpvar_2.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex_1 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((worldSpaceVertex_1.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_5;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _BumpMap;
void main ()
{
  mediump vec4 baseColor_1;
  highp float nh_2;
  mediump vec3 h_3;
  mediump vec3 viewVector_4;
  mediump vec3 worldNormal_5;
  mediump vec4 coords_6;
  coords_6 = xlv_TEXCOORD2;
  mediump vec3 vertexNormal_7;
  vertexNormal_7 = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength_8;
  bumpStrength_8 = _DistortParams.x;
  mediump vec4 bump_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = (texture2D (_BumpMap, coords_6.xy) + texture2D (_BumpMap, coords_6.zw));
  bump_9 = tmpvar_10;
  bump_9.xy = (bump_9.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize((vertexNormal_7 + ((bump_9.xxy * bumpStrength_8) * vec3(1.0, 0.0, 1.0))));
  worldNormal_5.y = tmpvar_11.y;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(xlv_TEXCOORD1);
  viewVector_4 = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((_WorldLightDir.xyz + viewVector_4));
  h_3 = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (tmpvar_11, -(h_3)));
  nh_2 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15 = (tmpvar_11.xz * _FresnelScale);
  worldNormal_5.xz = tmpvar_15;
  mediump float bias_16;
  bias_16 = _DistortParams.w;
  mediump float power_17;
  power_17 = _DistortParams.z;
  baseColor_1 = _ReflectionColor;
  highp vec4 tmpvar_18;
  tmpvar_18 = (baseColor_1 + (max (0.0, pow (nh_2, _Shininess)) * _SpecularColor));
  baseColor_1.xyz = tmpvar_18.xyz;
  baseColor_1.w = clamp ((0.5 + clamp ((bias_16 + ((1.0 - bias_16) * pow (clamp ((1.0 - max (dot (-(viewVector_4), worldNormal_5), 0.0)), 0.0, 1.0), power_17))), 0.0, 1.0)), 0.0, 1.0);
  gl_FragData[0] = baseColor_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 480
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 490
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 499
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 351
#line 374
#line 391
#line 403
#line 448
#line 469
#line 506
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 510
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 514
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 518
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 522
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 526
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 546
#line 570
#line 607
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 469
void Gerstner( out mediump vec3 offs, out mediump vec3 nrml, in mediump vec3 vtx, in mediump vec3 tileableVtx, in mediump vec4 amplitude, in mediump vec4 frequency, in mediump vec4 steepness, in mediump vec4 speed, in mediump vec4 directionAB, in mediump vec4 directionCD ) {
    offs = vec3( 0.0, 0.0, 0.0);
    nrml = vec3( 0.0, 1.0, 0.0);
}
#line 570
v2f_noGrab vert300( in appdata_full v ) {
    v2f_noGrab o;
    mediump vec3 worldSpaceVertex = (_Object2World * v.vertex).xyz;
    #line 574
    mediump vec3 vtxForAni = (worldSpaceVertex.xzz * unity_Scale.w);
    mediump vec3 nrml;
    mediump vec3 offsets;
    Gerstner( offsets, nrml, v.vertex.xyz, vtxForAni, _GAmplitude, _GFrequency, _GSteepness, _GSpeed, _GDirectionAB, _GDirectionCD);
    #line 578
    v.vertex.xyz += offsets;
    mediump vec2 tileableUv = worldSpaceVertex.xz;
    o.bumpCoords.xyzw = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection.xyzw)) * _BumpTiling.xyzw);
    o.viewInterpolator.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
    #line 582
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.screenPos = ComputeScreenPos( o.pos);
    o.normalInterpolator.xyz = nrml;
    o.normalInterpolator.w = 1.0;
    #line 586
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_noGrab xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert300( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.normalInterpolator);
    xlv_TEXCOORD1 = vec3(xl_retval.viewInterpolator);
    xlv_TEXCOORD2 = vec4(xl_retval.bumpCoords);
    xlv_TEXCOORD3 = vec4(xl_retval.screenPos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 480
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 490
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 499
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 351
#line 374
#line 391
#line 403
#line 448
#line 469
#line 506
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 510
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 514
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 518
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 522
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 526
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 546
#line 570
#line 607
#line 385
mediump float Fresnel( in mediump vec3 viewVector, in mediump vec3 worldNormal, in mediump float bias, in mediump float power ) {
    #line 387
    mediump float facing = clamp( (1.0 - max( dot( (-viewVector), worldNormal), 0.0)), 0.0, 1.0);
    mediump float refl2Refr = xll_saturate_f((bias + ((1.0 - bias) * pow( facing, power))));
    return refl2Refr;
}
#line 316
mediump vec3 PerPixelNormal( in sampler2D bumpMap, in mediump vec4 coords, in mediump vec3 vertexNormal, in mediump float bumpStrength ) {
    mediump vec4 bump = (texture( bumpMap, coords.xy) + texture( bumpMap, coords.zw));
    #line 319
    bump.xy = (bump.wy - vec2( 1.0, 1.0));
    mediump vec3 worldNormal = (vertexNormal + ((bump.xxy * bumpStrength) * vec3( 1.0, 0.0, 1.0)));
    return normalize(worldNormal);
}
#line 588
mediump vec4 frag300( in v2f_noGrab i ) {
    #line 590
    mediump vec3 worldNormal = PerPixelNormal( _BumpMap, i.bumpCoords, i.normalInterpolator.xyz, _DistortParams.x);
    mediump vec3 viewVector = normalize(i.viewInterpolator.xyz);
    mediump vec4 distortOffset = vec4( ((worldNormal.xz * _DistortParams.y) * 10.0), 0.0, 0.0);
    mediump vec4 screenWithOffset = (i.screenPos + distortOffset);
    #line 594
    mediump vec3 reflectVector = normalize(reflect( viewVector, worldNormal));
    mediump vec3 h = normalize((_WorldLightDir.xyz + viewVector.xyz));
    highp float nh = max( 0.0, dot( worldNormal, (-h)));
    highp float spec = max( 0.0, pow( nh, _Shininess));
    #line 598
    mediump vec4 edgeBlendFactors = vec4( 1.0, 0.0, 0.0, 0.0);
    worldNormal.xz *= _FresnelScale;
    mediump float refl2Refr = Fresnel( viewVector, worldNormal, _DistortParams.w, _DistortParams.z);
    mediump vec4 baseColor = _BaseColor;
    #line 602
    baseColor = _ReflectionColor;
    baseColor = (baseColor + (spec * _SpecularColor));
    baseColor.w = (edgeBlendFactors.x * xll_saturate_f((0.5 + (refl2Refr * 1.0))));
    return baseColor;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    mediump vec4 xl_retval;
    v2f_noGrab xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.normalInterpolator = vec4(xlv_TEXCOORD0);
    xlt_i.viewInterpolator = vec3(xlv_TEXCOORD1);
    xlt_i.bumpCoords = vec4(xlv_TEXCOORD2);
    xlt_i.screenPos = vec4(xlv_TEXCOORD3);
    xl_retval = frag300( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 8
//   d3d9 - ALU: 34 to 48, TEX: 2 to 4
//   d3d11 - ALU: 32 to 46, TEX: 2 to 4, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
"ps_3_0
; 48 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c9, 1.00000000, 0.00000000, -1.00000000, 0.50000000
def c10, 10.00000000, 0, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c9.z
mul_pp r0.xy, r0, c7.x
mad_pp r0.xyz, r0.xxyw, c9.xyxw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r0
mul r0.xy, r2.xzzw, c7.y
mov_pp r0.zw, c9.y
mul r0.xy, r0, c10.x
add r0, v3, r0
texldp r0.xyz, r0, s1
add_pp r1.xyz, -r0, c3
mad_pp r0.xyz, r1, c3.w, r0
add_pp r4.xyz, r0, -c2
dp3 r0.w, v1, v1
rsq r0.w, r0.w
mul r1.xyz, r0.w, v1
add r3.xyz, r1, c6
dp3 r0.w, r3, r3
mul_pp r0.xz, r2, c8.x
mov_pp r0.y, r2
dp3_pp r1.x, -r1, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r3
dp3_pp r0.y, r2, -r0
max_pp r0.w, r1.x, c9.y
add_pp_sat r0.x, -r0.w, c9
pow_pp r1, r0.x, c7.z
max_pp r2.x, r0.y, c9.y
pow r0, r2.x, c5.x
mov_pp r0.z, r1.x
mov_pp r0.y, c7.w
add_pp r0.y, c9.x, -r0
mad_pp_sat r0.y, r0, r0.z, c7.w
mad_pp r2.xyz, r0.y, r4, c2
mov r0.z, r0.x
texldp r1.x, v3, s2
mad r0.x, r1, c0.z, c0.w
max r0.z, r0, c9.y
rcp r0.x, r0.x
add r0.x, r0, -v3.z
add_pp_sat r0.y, r0, c9.w
mul_sat r0.x, r0, c4
mad oC0.xyz, r0.z, c1, r2
mul_pp oC0.w, r0.x, r0.y
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Vector 2 [_BaseColor]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
Vector 4 [_InvFadeParemeter]
Vector 3 [_ReflectionColor]
Float 5 [_Shininess]
Vector 1 [_SpecularColor]
Vector 6 [_WorldLightDir]
Vector 0 [_ZBufferParams]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 44.00 (33 instructions), vertex: 0, texture: 16,
//   sequencer: 16, interpolator: 16;    6 GPRs, 30 threads,
// Performance (if enough threads): ~44 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaaciiaaaaacdiaaaaaaaaaaaaaaceaaaaacdaaaaaacfiaaaaaaaa
aaaaaaaaaaaaacaiaaaaaabmaaaaabpjppppadaaaaaaaaamaaaaaabmaaaaaaaa
aaaaabpcaaaaabamaaacaaacaaabaaaaaaaaabbiaaaaaaaaaaaaabciaaadaaaa
aaabaaaaaaaaabdeaaaaaaaaaaaaabeeaaadaaacaaabaaaaaaaaabdeaaaaaaaa
aaaaabfiaaacaaahaaabaaaaaaaaabbiaaaaaaaaaaaaabghaaacaaaiaaabaaaa
aaaaabhiaaaaaaaaaaaaabiiaaacaaaeaaabaaaaaaaaabbiaaaaaaaaaaaaabjk
aaacaaadaaabaaaaaaaaabbiaaaaaaaaaaaaabklaaadaaabaaabaaaaaaaaabde
aaaaaaaaaaaaablkaaacaaafaaabaaaaaaaaabhiaaaaaaaaaaaaabmfaaacaaab
aaabaaaaaaaaabbiaaaaaaaaaaaaabneaaacaaagaaabaaaaaaaaabbiaaaaaaaa
aaaaabodaaacaaaaaaabaaaaaaaaabbiaaaaaaaafpecgbhdgfedgpgmgphcaakl
aaabaaadaaabaaaeaaabaaaaaaaaaaaafpechfgnhaengbhaaaklklklaaaeaaam
aaabaaabaaabaaaaaaaaaaaafpedgbgngfhcgbeegfhahegifegfhihehfhcgfaa
fpeegjhdhegphchefagbhcgbgnhdaafpeghcgfhdgogfgmfdgdgbgmgfaaklklkl
aaaaaaadaaabaaabaaabaaaaaaaaaaaafpejgohgeggbgegffagbhcgfgngfhegf
hcaafpfcgfgggmgfgdhegjgpgoedgpgmgphcaafpfcgfgggmgfgdhegjgpgofegf
hiaafpfdgigjgogjgogfhdhdaafpfdhagfgdhfgmgbhcedgpgmgphcaafpfhgphc
gmgeemgjghgiheeegjhcaafpfkechfgggggfhcfagbhcgbgnhdaahahdfpddfpda
aadccodacodcdadddfddcodaaaklklklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaa
aaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaabpi
baaaafaaaaaaaaaeaaaaaaaaaaaadmieaaapaaapaaaaaaabaaaapafaaaaahbfb
aaaapcfcaaaapdfdaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaebcaaaaadpiaaaaalpiaaaaadpaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaacfgaaegaakbcaabcaaaaaaaaaagabagabgbcaabcaaaaaa
aafaeabmaaaabcaameaaaaaaaaaagacadacgbcaaccaaaaaabaaaeaebbpbpphpj
aaaaeaaadiaacaebbpbppofpaaaaeaaamiaiaaabaaloloaapaababaafiibabac
aagmmgbloaaeacibmiahaaafaablmaaaobababaalachabaeaamamaaakaafagpo
laeiababaaloloabpaaeaepofibbacabaamgblbloaabaeibmiakaaabaalmgmmm
klabahaamiabaaabaaldldgmnbababpomiabaaabaalblbgmolaaaaabfibeabab
aeblmggmcaahpoibbeahaaacaalegmgmobaeacabamedaeabaabjgmlbobababaa
beiaabaaaaaaaamgocaaaaaemiabaaaaacbnmnaapaabacaaemebaaaaaagmgmbl
kcaapoadeacdaaaeaalagmgmkbabaiiakibdaaacaamglaebmbaaadafdibcaaaa
aelomngmpaafaeaamiadaaaaaalagmaakcaapoaalkcaaaaaaaaaaambmcaaaapo
eabkababaagblblbkbabpoaamialaaabaagdmbaakbabahaadiidaaabaalalabl
oaabadabmiaoaaaaaakgmlaaobabaaaalibibaabbpbppoiiaaaaeaaabacibaeb
bpbppbppaaaaeaaamiaiaaabaablmgblilabaaaaemihabacaemamablkaabadab
lcehaaabacmamaabiaabacahmiahaaabaamablmaklacadabmiacaaaaacblmgaa
oaabadaamiahaaabaamgmamamlaaabacklieaaaaaamggmebiaaappaemiaiiaaa
aablmgaaobaaaaaamiahiaaaaagmmamaklaaababaaaaaaaaaaaaaaaaaaaaaaaa
"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
"sce_fp_rsx // 70 instructions using 3 registers
[Configuration]
24
ffffffff0003c020000ffff0000000000000840003000000
[Offsets]
9
_ZBufferParams 1 0
00000250
_SpecularColor 1 0
00000440
_BaseColor 2 0
000003c0000003a0
_ReflectionColor 2 0
0000033000000310
_InvFadeParemeter 1 0
00000420
_Shininess 1 0
000002e0
_WorldLightDir 1 0
00000090
_DistortParams 5 0
0000038000000350000002c00000013000000050
_FresnelScale 1 0
00000100
[Microcode]
1120
d4001700c8011c9dc8000001c8003fe1d40217005c011c9dc8000001c8003fe1
18800300ba001c9dba040001c8000001a8000500c8011c9dc8010001c800bfe1
0a8004405f001c9d000200000002000200000000000000000000000000000000
8e880340c8011c9dc9000001c8003fe1ae023b00c8011c9d54000001c800bfe1
0e000300c8041c9dc8020001c800000100000000000000000000000000000000
0e883940c9101c9dc8000029c8000001048a0140c9101c9dc8000001c8000001
08820540c9101c9fc8000001c800000102000500c8001c9dc8000001c8000001
10883b0055041c9dc8000001c80000010a8a0200c9101c9d00020000c8000001
0000000000000000000000000000000004880540c8041c9fc9140001c8000001
10040100aa021c9cc8000001c800000100000000000000000000000000000000
02840200fe081c9d00020000c800000100004120000000000000000000000000
18840140aa021c9cc8000001c800000100000000000000000000000000000000
06840200d1101c9d01080000c800000110040900ab101c9c00020000c8000001
00000000000000000000000000000000fe000100c8011c9dc8000001c8003fe1
1e020300c8001c9dc9080001c8000001f6001804c8011c9dc8000001c8003fe1
02000500a6001c9dc8020001c800000100013f7f00013b7f0001377f00000000
10808300c8081c9fc8020001c800000100000000000000000000000000003f80
0e021802c8041c9dc8000001c800000108801d00ff001c9dc8000001c8000001
02000400c8001c9d54020001fe02000100000000000000000000000000000000
02041a00c8001c9dc8000001c800000102000900ff101c9d00020000c8000001
000000000000000000000000000000000204030054001c9fc8080001c8000001
10001d00c8001c9dc8000001c8000001028a020055001c9d54020001c8000001
0000000000000000000000000000000010000200c8001c9d00020000c8000001
0000000000000000000000000000000008881c40c9141c9dc8000001c8000001
0e000300c8041c9fc8020001c800000100000000000000000000000000000000
0e000400c8001c9dfe020001c804000100000000000000000000000000000000
028a044055101c9dfe0200035510000100000000000000000000000000000000
10001c00fe001c9dc8000001c80000011088834001141c9cc8020001c8000001
000000000000000000000000000000000e000300c8001c9dc8020003c8000001
000000000000000000000000000000000e000400ff101c9dc8000001c8020001
0000000000000000000000000000000010000900c8001c9dc8020001c8000001
0000000000000000000000000000000002848340ff101c9daa020000c8000001
0000000000003f0000000000000000001084820000081c9c00020000c8000001
000000000000000000000000000000000e800400fe001c9dc8020001c8000001
0000000000000000000000000000000010810240c9081c9d01080000c8000001
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
ConstBuffer "$Globals" 304 // 164 used size, 19 vars
Vector 48 [_SpecularColor] 4
Vector 64 [_BaseColor] 4
Vector 80 [_ReflectionColor] 4
Vector 96 [_InvFadeParemeter] 4
Float 112 [_Shininess]
Vector 128 [_WorldLightDir] 4
Vector 144 [_DistortParams] 4
Float 160 [_FresnelScale]
ConstBuffer "UnityPerCamera" 128 // 128 used size, 8 vars
Vector 112 [_ZBufferParams] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_ReflectionTex] 2D 1
SetTexture 2 [_CameraDepthTexture] 2D 2
// 53 instructions, 4 temp regs, 0 temp arrays:
// ALU 46 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedjnolchnheceibcjdncnpmhcdckbhbcenabaaaaaabiaiaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcbaahaaaaeaaaaaaameabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fjaaaaaeegiocaaaabaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
pcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaadaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahhcaabaaaaaaaaaaapganbaaa
aaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
aceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaadcaaaaamhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaiadpaaaaaaaaegbcbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaifcaabaaaabaaaaaaagacbaaa
aaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaabaaaaaabkaabaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaakhcaabaaaadaaaaaaegbcbaaa
acaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaaiicaabaaa
aaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
ajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaajbcaabaaa
abaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadpdccaaaak
icaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaa
ajaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaafgifcaaaaaaaaaaa
ajaaaaaadiaaaaakdcaabaaaabaaaaaaegaabaaaabaaaaaaaceaaaaaaaaacaeb
aaaacaebaaaaaaaaaaaaaaaadgaaaaafecaabaaaabaaaaaaabeaaaaaaaaaaaaa
aaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegbdbaaaaeaaaaaaaoaaaaah
dcaabaaaabaaaaaaegaabaaaabaaaaaakgakbaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaaj
hcaabaaaacaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaa
dcaaaaakhcaabaaaabaaaaaapgipcaaaaaaaaaaaafaaaaaaegacbaaaacaaaaaa
egacbaaaabaaaaaaaaaaaaajhcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaia
ebaaaaaaaaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaapgapbaaaaaaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaaeaaaaaaaaaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaadpddaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaiadpbaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaa
egacbaaaadaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaa
aaaaaaaaahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaak
hccabaaaaaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaa
abaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaaaaaaaaaeghobaaaacaaaaaaaagabaaa
acaaaaaadcaaaaalbcaabaaaaaaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaa
abaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaaaaaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaackbabaiaebaaaaaaaeaaaaaadicaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaahiccabaaa
aaaaaaaadkaabaaaaaaaaaaaakaabaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_ReflectionColor]
Vector 3 [_InvFadeParemeter]
Float 4 [_Shininess]
Vector 5 [_WorldLightDir]
Vector 6 [_DistortParams]
Float 7 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_CameraDepthTexture] 2D
"ps_3_0
; 40 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c8, 1.00000000, 0.00000000, -1.00000000, 0.50000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dp3 r0.x, v1, v1
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.zw, r0.xyyw, r1.xyyw
add_pp r0.zw, r0.xywz, c8.z
mul_pp r2.xy, r0.zwzw, c6.x
rsq r0.x, r0.x
mul r1.xyz, r0.x, v1
add r0.xyz, r1, c5
mad_pp r2.xyz, r2.xxyw, c8.xyxw, v0
dp3 r1.w, r0, r0
dp3_pp r0.w, r2, r2
rsq r1.w, r1.w
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r2
mul r0.xyz, r1.w, r0
dp3_pp r0.x, r2, -r0
max_pp r1.w, r0.x, c8.y
pow r0, r1.w, c4.x
mul_pp r2.xz, r2, c7.x
dp3_pp r0.y, -r1, r2
mov r0.z, r0.x
max_pp r0.x, r0.y, c8.y
max r0.y, r0.z, c8
mul r1.xyz, r0.y, c1
add_pp_sat r1.w, -r0.x, c8.x
pow_pp r0, r1.w, c6.z
add oC0.xyz, r1, c2
mov_pp r0.y, c6.w
mov_pp r0.z, r0.x
texldp r1.x, v3, s1
mad r0.x, r1, c0.z, c0.w
rcp r0.x, r0.x
add_pp r0.y, c8.x, -r0
mad_pp_sat r0.y, r0, r0.z, c6.w
add r0.x, r0, -v3.z
add_pp_sat r0.y, r0, c8.w
mul_sat r0.x, r0, c3
mul_pp oC0.w, r0.x, r0.y
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Vector 6 [_DistortParams]
Float 7 [_FresnelScale]
Vector 3 [_InvFadeParemeter]
Vector 2 [_ReflectionColor]
Float 4 [_Shininess]
Vector 1 [_SpecularColor]
Vector 5 [_WorldLightDir]
Vector 0 [_ZBufferParams]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_CameraDepthTexture] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 37.33 (28 instructions), vertex: 0, texture: 12,
//   sequencer: 14, interpolator: 16;    7 GPRs, 27 threads,
// Performance (if enough threads): ~37 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaaceeaaaaabpaaaaaaaaaaaaaaaceaaaaabomaaaaacbeaaaaaaaa
aaaaaaaaaaaaabmeaaaaaabmaaaaablgppppadaaaaaaaaakaaaaaabmaaaaaaaa
aaaaabkpaaaaaaoeaaadaaaaaaabaaaaaaaaaapaaaaaaaaaaaaaabaaaaadaaab
aaabaaaaaaaaaapaaaaaaaaaaaaaabbeaaacaaagaaabaaaaaaaaabceaaaaaaaa
aaaaabdeaaacaaahaaabaaaaaaaaabeeaaaaaaaaaaaaabfeaaacaaadaaabaaaa
aaaaabceaaaaaaaaaaaaabggaaacaaacaaabaaaaaaaaabceaaaaaaaaaaaaabhh
aaacaaaeaaabaaaaaaaaabeeaaaaaaaaaaaaabicaaacaaabaaabaaaaaaaaabce
aaaaaaaaaaaaabjbaaacaaafaaabaaaaaaaaabceaaaaaaaaaaaaabkaaaacaaaa
aaabaaaaaaaaabceaaaaaaaafpechfgnhaengbhaaaklklklaaaeaaamaaabaaab
aaabaaaaaaaaaaaafpedgbgngfhcgbeegfhahegifegfhihehfhcgfaafpeegjhd
hegphchefagbhcgbgnhdaaklaaabaaadaaabaaaeaaabaaaaaaaaaaaafpeghcgf
hdgogfgmfdgdgbgmgfaaklklaaaaaaadaaabaaabaaabaaaaaaaaaaaafpejgohg
eggbgegffagbhcgfgngfhegfhcaafpfcgfgggmgfgdhegjgpgoedgpgmgphcaafp
fdgigjgogjgogfhdhdaafpfdhagfgdhfgmgbhcedgpgmgphcaafpfhgphcgmgeem
gjghgiheeegjhcaafpfkechfgggggfhcfagbhcgbgnhdaahahdfpddfpdaaadcco
dacodcdadddfddcodaaaklklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabe
abpmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaablabaaaagaa
aaaaaaaeaaaaaaaaaaaadmieaaapaaapaaaaaaabaaaapafaaaaahbfbaaaapcfc
aaaapdfdaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadpiaaaaalpiaaaaa
dpaaaaaaabfafaaeaaaabcaameaaaaaaaaaagaajgaapbcaabcaaaaaaaaaagabf
gablbcaabcaaaaaaaaaacacbaaaaccaaaaaaaaaaemicabaeaaloloblpaababad
miadaaafaabllaaaobabadaabaaieaebbpbpphpjaaaaeaaadiaicaebbpbppohl
aaaaeaaababibakbbpbppbppaaaaeaaamiaiaaabaablmgblilabaaaafiicacac
aagmmglboaaeaciemiahaaaeaablmaaaobacabaalaehagafaamamamakaaeafpp
lacbagabaalolombpaafafppfiebabagaamgblgmoaagaeibmiadaaacaalagmme
klagagaamiabaaabaagngngmnbacacppmiacaaabaalblbgmolaaaaabficbabab
aebllblbcaagppibbeahaaafaamamglbobafababamedacacaalalblbobacabaa
miabaaaaacmnloaapaacafaamiacaaaaaagmgmaakcaappaaeacfaaaaaalagmlb
kbacahiabeicaaaaaalbgmmgkbaaaeacdicbaaaaaelobolbpaaeaaaamiadaaaa
aalagmaakcaappaamiahiaaaaalbmamailaaabacencbaaaaaegmlbblkaaappab
eabcaaaaaclbmggmoaaaadaakibaaaaaaaaaaamamcaaaaagdjbcaaaaaalbgmgm
kbaaadaamjabaaaaaagmgmblmlabaaaglcbaaaaaaaaaaaaamcaaaappmiaiiaaa
aalbgmaaobaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_ReflectionColor]
Vector 3 [_InvFadeParemeter]
Float 4 [_Shininess]
Vector 5 [_WorldLightDir]
Vector 6 [_DistortParams]
Float 7 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_CameraDepthTexture] 2D
"sce_fp_rsx // 54 instructions using 3 registers
[Configuration]
24
ffffffff0003c020000ffff0000000000000840003000000
[Offsets]
8
_ZBufferParams 1 0
00000200
_SpecularColor 1 0
00000300
_ReflectionColor 1 0
00000290
_InvFadeParemeter 1 0
00000340
_Shininess 1 0
000001e0
_WorldLightDir 1 0
00000080
_DistortParams 4 0
000002e0000002b00000023000000050
_FresnelScale 1 0
000000e0
[Microcode]
864
d4001700c8011c9dc8000001c8003fe1d40217005c011c9dc8000001c8003fe1
18800300ba001c9dba040001c8000001a8000500c8011c9dc8010001c800bfe1
0a8004405f001c9d000200000002000200000000000000000000000000000000
ae023b00c8011c9d54000001c800bfe10e040300c8041c9dc8020001c8000001
000000000000000000000000000000008e800340c8011c9dc9000001c8003fe1
0e803940c9001c9dc8000029c800000104820140c9001c9dc8000001c8000001
088a0540c9001c9fc8080001c80000010a820200c9001c9d00020000c8000001
0000000000000000000000000000000002800540c8041c9fc9040001c8000001
1000090001001c9c00020000c800000100000000000000000000000000000000
04000500c8081c9dc8080001c800000102803b0055141c9daa000000c8000001
10808300c8001c9f00020000c800000100003f80000000000000000000000000
02821d00ff001c9dc8000001c800000102020900c9001c9d00020000c8000001
00000000000000000000000000000000f6001802c8011c9dc8000001c8003fe1
02000500a6001c9dc8020001c800000100013f7f00013b7f0001377f00000000
02021d00c8041c9dc8000001c80000011000020000041c9c00020000c8000001
000000000000000000000000000000000400040000001c9c54020001fe020001
0000000000000000000000000000000002001c00fe001c9dc8000001c8000001
02820200c9041c9d54020001c800000100000000000000000000000000000000
02000900c8001c9d00020000c800000100000000000000000000000000000000
04001a00aa001c9cc8000001c800000102821c40c9041c9dc8000001c8000001
0e020100c8021c9dc8000001c800000100000000000000000000000000000000
02820440c9041c9dfe020003c904000100000000000000000000000000000000
f000030054011c9faa000000c8003fe11086834001041c9cc8020001c8000001
000000000000000000000000000000000e80040000001c9cc8020001c8040001
0000000000000000000000000000000002828340ff0c1c9daa020000c8000001
0000000000003f00000000000000000010808200c8001c9d00020000c8000001
0000000000000000000000000000000010810240c9001c9d01040000c8000001
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
ConstBuffer "$Globals" 304 // 164 used size, 19 vars
Vector 48 [_SpecularColor] 4
Vector 80 [_ReflectionColor] 4
Vector 96 [_InvFadeParemeter] 4
Float 112 [_Shininess]
Vector 128 [_WorldLightDir] 4
Vector 144 [_DistortParams] 4
Float 160 [_FresnelScale]
ConstBuffer "UnityPerCamera" 128 // 128 used size, 8 vars
Vector 112 [_ZBufferParams] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_CameraDepthTexture] 2D 1
// 43 instructions, 4 temp regs, 0 temp arrays:
// ALU 38 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedcpmolfnjoofpphognjpbcnemhdcobfbmabaaaaaalaagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefckiafaaaaeaaaaaaagkabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fjaaaaaeegiocaaaabaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadpcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaadaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaa
adaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahhcaabaaaaaaaaaaa
pganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaadcaaaaamhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaiadpaaaaaaaa
egbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaifcaabaaaabaaaaaa
agacbaaaaaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaabaaaaaa
bkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaakhcaabaaaadaaaaaa
egbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaai
icaabaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaa
aaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaaj
bcaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadp
dccaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaa
aaaaaaaaajaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaadpddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadp
aoaaaaahdcaabaaaabaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaaefaaaaaj
pcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaa
dcaaaaalbcaabaaaabaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaaabaaaaaa
dkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaaabaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpakaabaaaabaaaaaaaaaaaaaibcaabaaaabaaaaaa
akaabaaaabaaaaaackbabaiaebaaaaaaaeaaaaaadicaaaaibcaabaaaabaaaaaa
akaabaaaabaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaahiccabaaaaaaaaaaa
dkaabaaaaaaaaaaaakaabaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
adaaaaaaegacbaaaadaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaai
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
dcaaaaalhccabaaaaaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaa
egiccaaaaaaaaaaaafaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
"ps_3_0
; 42 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c7, 1.00000000, 0.00000000, -1.00000000, 0.50000000
def c8, 10.00000000, 0, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c7.z
mul_pp r0.xy, r0, c5.x
mad_pp r0.xyz, r0.xxyw, c7.xyxw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r0
mul r0.xy, r2.xzzw, c5.y
dp3 r0.z, v1, v1
rsq r1.x, r0.z
mul r1.xyz, r1.x, v1
add r3.xyz, r1, c4
mul r0.xy, r0, c8.x
mov_pp r0.zw, c7.y
add r0, v3, r0
texldp r0.xyz, r0, s1
dp3 r0.w, r3, r3
rsq r0.w, r0.w
mul r3.xyz, r0.w, r3
dp3_pp r1.w, r2, -r3
mul_pp r2.xz, r2, c6.x
dp3_pp r0.w, -r1, r2
max_pp r2.x, r1.w, c7.y
pow r1, r2.x, c3.x
add_pp r4.xyz, -r0, c2
mad_pp r0.xyz, r4, c2.w, r0
max_pp r0.w, r0, c7.y
add_pp_sat r0.w, -r0, c7.x
pow_pp r2, r0.w, c5.z
mov_pp r0.w, c5
add_pp r0.xyz, r0, -c1
mov r1.y, r1.x
mov_pp r1.x, r2
add_pp r0.w, c7.x, -r0
mad_pp_sat r0.w, r0, r1.x, c5
mad_pp r2.xyz, r0.w, r0, c1
max r0.x, r1.y, c7.y
mad oC0.xyz, r0.x, c0, r2
add_pp_sat oC0.w, r0, c7
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Vector 1 [_BaseColor]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 0 [_SpecularColor]
Vector 4 [_WorldLightDir]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 36.00 (27 instructions), vertex: 0, texture: 12,
//   sequencer: 14, interpolator: 16;    6 GPRs, 30 threads,
// Performance (if enough threads): ~36 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaacbeaaaaaboeaaaaaaaaaaaaaaceaaaaablmaaaaaboeaaaaaaaa
aaaaaaaaaaaaabjeaaaaaabmaaaaabiippppadaaaaaaaaajaaaaaabmaaaaaaaa
aaaaabibaaaaaanaaaacaaabaaabaaaaaaaaaanmaaaaaaaaaaaaaaomaaadaaaa
aaabaaaaaaaaaapiaaaaaaaaaaaaabaiaaacaaafaaabaaaaaaaaaanmaaaaaaaa
aaaaabbhaaacaaagaaabaaaaaaaaabciaaaaaaaaaaaaabdiaaacaaacaaabaaaa
aaaaaanmaaaaaaaaaaaaabejaaadaaabaaabaaaaaaaaaapiaaaaaaaaaaaaabfi
aaacaaadaaabaaaaaaaaabciaaaaaaaaaaaaabgdaaacaaaaaaabaaaaaaaaaanm
aaaaaaaaaaaaabhcaaacaaaeaaabaaaaaaaaaanmaaaaaaaafpecgbhdgfedgpgm
gphcaaklaaabaaadaaabaaaeaaabaaaaaaaaaaaafpechfgnhaengbhaaaklklkl
aaaeaaamaaabaaabaaabaaaaaaaaaaaafpeegjhdhegphchefagbhcgbgnhdaafp
eghcgfhdgogfgmfdgdgbgmgfaaklklklaaaaaaadaaabaaabaaabaaaaaaaaaaaa
fpfcgfgggmgfgdhegjgpgoedgpgmgphcaafpfcgfgggmgfgdhegjgpgofegfhiaa
fpfdgigjgogjgogfhdhdaafpfdhagfgdhfgmgbhcedgpgmgphcaafpfhgphcgmge
emgjghgiheeegjhcaahahdfpddfpdaaadccodacodcdadddfddcodaaaaaaaaaaa
aaaaaaabaaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaeaaaaaabkebaaaafaaaaaaaaaeaaaaaaaaaaaadmieaaapaaap
aaaaaaabaaaapafaaaaahbfbaaaapcfcaaaapdfdaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadpaaaaaaaaaaaaaaebcaaaaa
dpiaaaaalpiaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacfgaaegaakbcaabcaaaaaa
aaaagabafabgbcaabcaaabaaaaaaaaaagablmeaabcaaaaaaaaaabacbaaaaccaa
aaaaaaaabaaaeaebbpbpphpjaaaaeaaadiaacaebbpbppopjaaaaeaaamiaiaaab
aaloloaapaababaafiicabacaagmgmbloaaeacibmiahaaafaablmaaaobababaa
lachabaeaamamaebkaafaepplaeiababaaloloecpaaeaeppfiibababaamgblbl
oaabaeibmiadaaabaalagmmeklabafaamiaeaaabaagngnlbnbababpomiaeaaab
aalblbmgolaaaaabfiehabacaaleblmgobaeabibbeadaaabaalamgmgobababab
amedaeaeaalagmlbkbabagaabeibabaaaelomnmgpaafaeaemiacaaaaacbnmnaa
paabacaabeadaaaaablalbblicaapoafafeeabaaaegmblbliaaapopoeabkabab
aagbmgmgkbabpoaaemelaaabaagdmbblkbabafaddiidaaabaalalabloaabadab
eacnaaaaaakomhlbobabaaialibibaabbpbppoiiaaaaeaaakichaaacaemamaeb
iaabacaddichaaabacmamalbkaababaamiaoaaabaapmblpmklacacablccbaaab
aalblbaaicaapoaflciaiaaaaaaaaaebmcaaaapomiahaaaaaalbbfmamlaaabab
miahiaaaaagmmamaklabaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
"sce_fp_rsx // 59 instructions using 3 registers
[Configuration]
24
ffffffff0003c020000ffff0000000000000840003000000
[Offsets]
7
_SpecularColor 1 0
00000380
_BaseColor 2 0
0000034000000280
_ReflectionColor 2 0
00000220000001f0
_Shininess 1 0
00000310
_WorldLightDir 1 0
00000160
_DistortParams 5 0
000002f0000002c0000002500000009000000040
_FresnelScale 1 0
00000120
[Microcode]
944
d4001700c8011c9dc8000001c8003fe1d40217005c011c9dc8000001c8003fe1
18820300ba001c9dba040001c800000110020100aa021c9cc8000001c8000001
00000000000000000000000000000000a8000500c8011c9dc8010001c800bfe1
10800200c8041c9daa020000c800000100000000000041200000000000000000
0a8004405f041c9d000200000002000200000000000000000000000000000000
8e800340c8011c9dc9000001c8003fe11882014000021c9cc8000001c8000001
000000000000000000000000000000000e803940c9001c9dc8000029c8000001
04840140c9001c9dc8000001c8000001ae043b00c8011c9d54000001c800bfe1
06820200d1001c9dff000001c80000010a840200c9001c9d00020000c8000001
0000000000000000000000000000000010800540c8081c9fc9080001c8000001
fe020300c9041c9dc8010001c8003fe10e040300c8081c9dc8020001c8000001
0000000000000000000000000000000010000900c9001c9dc8020001c8000001
0000000000000000000000000000000002800540c9001c9fc8080001c8000001
10828300c8001c9f00020000c800000100003f80000000000000000000000000
0e021802c8041c9dc8000001c800000104000500c8081c9dc8080001c8000001
0e040300c8041c9fc8020001c800000100000000000000000000000000000000
08861d00ff041c9dc8000001c80000010e020400c8081c9dfe020001c8040001
0000000000000000000000000000000010863b0001001c9caa000000c8000001
08860200c90c1c9dc8020001c800000100000000000000000000000000000000
02801c40550c1c9dc8000001c80000010e020300c8041c9dc8020003c8000001
0000000000000000000000000000000010000900c90c1c9d00020000c8000001
0000000000000000000000000000000002800440c9001c9dfe020003c9000001
0000000000000000000000000000000004001d00fe001c9dc8000001c8000001
02828340c9001c9dfe020001c800000100000000000000000000000000000000
10000200aa001c9c00020000c800000100000000000000000000000000000000
02001c00fe001c9dc8000001c80000010e02040001041c9cc8040001c8020001
0000000000000000000000000000000002000900c8001c9d00020000c8000001
000000000000000000000000000000000e80040000001c9cc8020001c8040001
000000000000000000000000000000001081834001041c9cc8020001c8000001
00000000000000000000000000003f00
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
ConstBuffer "$Globals" 304 // 164 used size, 19 vars
Vector 48 [_SpecularColor] 4
Vector 64 [_BaseColor] 4
Vector 80 [_ReflectionColor] 4
Float 112 [_Shininess]
Vector 128 [_WorldLightDir] 4
Vector 144 [_DistortParams] 4
Float 160 [_FresnelScale]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_ReflectionTex] 2D 1
// 46 instructions, 4 temp regs, 0 temp arrays:
// ALU 40 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedekijejogacbmpgejcncafnodliedoeghabaaaaaapmagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcpeafaaaaeaaaaaaahnabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaadhcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaad
lcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaaaaaaaahhcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaa
aaaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialp
aaaaialpaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaa
aaaaaaaaajaaaaaadcaaaaamhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaaaaaaaaaiadpaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaifcaabaaaabaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaa
akaaaaaadgaaaaafccaabaaaabaaaaaabkaabaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegbcbaaa
acaaaaaadcaaaaakhcaabaaaadaaaaaaegbcbaaaacaaaaaapgapbaaaaaaaaaaa
egiccaaaaaaaaaaaaiaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaa
acaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpdeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaacpaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaiicaabaaa
aaaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaaajaaaaaabjaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaadkiacaiaebaaaaaa
aaaaaaaaajaaaaaaabeaaaaaaaaaiadpdccaaaakicaabaaaaaaaaaaaakaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaajaaaaaadiaaaaaidcaabaaa
abaaaaaaigaabaaaaaaaaaaafgifcaaaaaaaaaaaajaaaaaadiaaaaakdcaabaaa
abaaaaaaegaabaaaabaaaaaaaceaaaaaaaaacaebaaaacaebaaaaaaaaaaaaaaaa
dgaaaaafecaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegbdbaaaaeaaaaaaaoaaaaahdcaabaaaabaaaaaaegaabaaa
abaaaaaakgakbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaajhcaabaaaacaaaaaaegacbaia
ebaaaaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaadcaaaaakhcaabaaaabaaaaaa
pgipcaaaaaaaaaaaafaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaaj
hcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaiaebaaaaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaaeaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaadpddaaaaahiccabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadp
baaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
aaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaahaaaaaabjaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakhccabaaaaaaaaaaaagaabaaa
aaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Vector 0 [_SpecularColor]
Vector 1 [_ReflectionColor]
Float 2 [_Shininess]
Vector 3 [_WorldLightDir]
Vector 4 [_DistortParams]
Float 5 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
"ps_3_0
; 34 ALU, 2 TEX
dcl_2d s0
def c6, 1.00000000, 0.00000000, -1.00000000, 0.50000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dp3 r0.x, v1, v1
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.zw, r0.xyyw, r1.xyyw
add_pp r0.zw, r0.xywz, c6.z
mul_pp r2.xy, r0.zwzw, c4.x
rsq r0.x, r0.x
mul r1.xyz, r0.x, v1
add r0.xyz, r1, c3
mad_pp r2.xyz, r2.xxyw, c6.xyxw, v0
dp3 r1.w, r0, r0
dp3_pp r0.w, r2, r2
rsq r1.w, r1.w
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r2
mul r0.xyz, r1.w, r0
dp3_pp r0.x, r2, -r0
max_pp r1.w, r0.x, c6.y
pow r0, r1.w, c2.x
mul_pp r2.xz, r2, c5.x
dp3_pp r0.y, -r1, r2
max_pp r0.y, r0, c6
add_pp_sat r1.x, -r0.y, c6
max r1.y, r0.x, c6
pow_pp r0, r1.x, c4.z
mul r1.xyz, r1.y, c0
mov_pp r0.z, r0.x
mov_pp r0.y, c4.w
add_pp r0.x, c6, -r0.y
mad_pp_sat r0.x, r0, r0.z, c4.w
add oC0.xyz, r1, c1
add_pp_sat oC0.w, r0.x, c6
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Vector 4 [_DistortParams]
Float 5 [_FresnelScale]
Vector 1 [_ReflectionColor]
Float 2 [_Shininess]
Vector 0 [_SpecularColor]
Vector 3 [_WorldLightDir]
SetTexture 0 [_BumpMap] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 33.33 (25 instructions), vertex: 0, texture: 8,
//   sequencer: 14, interpolator: 16;    5 GPRs, 36 threads,
// Performance (if enough threads): ~33 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabneaaaaabmaaaaaaaaaaaaaaaceaaaaabhmaaaaabkeaaaaaaaa
aaaaaaaaaaaaabfeaaaaaabmaaaaabefppppadaaaaaaaaahaaaaaabmaaaaaaaa
aaaaabdoaaaaaakiaaadaaaaaaabaaaaaaaaaaleaaaaaaaaaaaaaameaaacaaae
aaabaaaaaaaaaaneaaaaaaaaaaaaaaoeaaacaaafaaabaaaaaaaaaapeaaaaaaaa
aaaaabaeaaacaaabaaabaaaaaaaaaaneaaaaaaaaaaaaabbfaaacaaacaaabaaaa
aaaaaapeaaaaaaaaaaaaabcaaaacaaaaaaabaaaaaaaaaaneaaaaaaaaaaaaabcp
aaacaaadaaabaaaaaaaaaaneaaaaaaaafpechfgnhaengbhaaaklklklaaaeaaam
aaabaaabaaabaaaaaaaaaaaafpeegjhdhegphchefagbhcgbgnhdaaklaaabaaad
aaabaaaeaaabaaaaaaaaaaaafpeghcgfhdgogfgmfdgdgbgmgfaaklklaaaaaaad
aaabaaabaaabaaaaaaaaaaaafpfcgfgggmgfgdhegjgpgoedgpgmgphcaafpfdgi
gjgogjgogfhdhdaafpfdhagfgdhfgmgbhcedgpgmgphcaafpfhgphcgmgeemgjgh
giheeegjhcaahahdfpddfpdaaadccodacodcdadddfddcodaaaklklklaaaaaaaa
aaaaaaabaaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaeaaaaaabiabaaaaeaaaaaaaaaeaaaaaaaaaaaadmieaaapaaap
aaaaaaabaaaapafaaaaahbfbaaaapcfcaaaapdfdaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaadpiaaaaalpiaaaaadpaaaaaaaaafcaaeaaaabcaameaaaaaa
aaaagaaggaambcaabcaaaaaaaaaagabcgabibcaabcaaaaaaaaaababoaaaaccaa
aaaaaaaabaaidaebbpbpphpjaaaaeaaadiaicaebbpbppohlaaaaeaaamiaiaaab
aaloloaapaababaafiicabacaagmmgbloaadacibmiahaaabaablmaaaobababaa
laehaeadaamamamakaabadpplaciaeabaalolombpaadadppfiebacaeaamgblbl
oaaeadibmiadaaacaalagmmeklaeaeaamiaiaaabaagngngmnbacacppmiaiaaab
aalblbblolaaaaabfiiaabaaaaaaaablocaaaaibbeahaaadaamamgblobadacab
amedacacaalabllbobacabaamiabaaaaacmnloaapaacadaamiabaaaaaagmgmaa
kcaappaaeabgaaaaaalmgmgmkbacafiabeibaaaaaagmgmmgkbaaacacdibcaaaa
aelobcgmpaabaaaamiadaaaaaagngmaakcaappaamiahiaaaaalbmamailaaaaab
lkbaaaaaaaaaaaiamcaaaappeabaaaaaaaaaaagmocaaaaaakibaaaaaaaaaaama
mcaaaaaedibcaaaaaebllbgmcaaeppaamjabaaaaaalbgmblmlaaaaaelciaiaaa
aaaaaaaamcaaaappaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Vector 0 [_SpecularColor]
Vector 1 [_ReflectionColor]
Float 2 [_Shininess]
Vector 3 [_WorldLightDir]
Vector 4 [_DistortParams]
Float 5 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
"sce_fp_rsx // 43 instructions using 3 registers
[Configuration]
24
ffffffff0001c0200007fff8000000000000840003000000
[Offsets]
6
_SpecularColor 1 0
00000280
_ReflectionColor 1 0
000001f0
_Shininess 1 0
00000190
_WorldLightDir 1 0
00000080
_DistortParams 4 0
0000023000000210000001c000000050
_FresnelScale 1 0
000000f0
[Microcode]
688
d4001700c8011c9dc8000001c8003fe1d40217005c011c9dc8000001c8003fe1
18800300ba001c9dba040001c8000001a8000500c8011c9dc8010001c800bfe1
0a8004405f001c9d000200000002000200000000000000000000000000000000
ae023b00c8011c9d54000001c800bfe10e040300c8041c9dc8020001c8000001
000000000000000000000000000000008e800340c8011c9dc9000001c8003fe1
08000500c8081c9dc8080001c80000010e803940c9001c9dc8000029c8000001
10800540c9001c9fc8080001c800000110803b00c9001c9d54000001c8000001
0a800200c9001c9d00020000c800000100000000000000000000000000000000
02840540c8041c9fc9000001c800000110000900c9001c9d00020000c8000001
0000000000000000000000000000000002020900c9081c9d00020000c8000001
0000000000000000000000000000000004021d00fe001c9dc8000001c8000001
02808300c8041c9f00020000c800000100003f80000000000000000000000000
10020200aa041c9c00020000c800000100000000000000000000000000000000
02801d00c9001c9dc8000001c800000102800200c9001c9d54020001c8000001
0000000000000000000000000000000008821c40c9001c9dc8000001c8000001
0e000100c8021c9dc8000001c800000100000000000000000000000000000000
0284044055041c9dfe0200035504000100000000000000000000000000000000
02848340c9081c9dfe020001c800000100000000000000000000000000000000
10001c00fe041c9dc8000001c800000102040900fe001c9d00020000c8000001
000000000000000000000000000000000e80040000081c9cc8020001c8000001
000000000000000000000000000000001081834001081c9cc8020001c8000001
00000000000000000000000000003f00
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
ConstBuffer "$Globals" 304 // 164 used size, 19 vars
Vector 48 [_SpecularColor] 4
Vector 80 [_ReflectionColor] 4
Float 112 [_Shininess]
Vector 128 [_WorldLightDir] 4
Vector 144 [_DistortParams] 4
Float 160 [_FresnelScale]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 0
// 36 instructions, 4 temp regs, 0 temp arrays:
// ALU 32 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedfjonkajjjfejdllgemfphgdffiegbeoaabaaaaaaiiafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefciaaeaaaaeaaaaaaacaabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaogbkbaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaah
hcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaa
dcaaaaamhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaa
aaaaiadpaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaai
fcaabaaaabaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaaf
ccaabaaaabaaaaaabkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaak
hcaabaaaadaaaaaaegbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaa
aiaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaa
abaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
aaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadp
deaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaa
aaaaaaaackiacaaaaaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaaaaaaaaajbcaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaa
abeaaaaaaaaaiadpdccaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaa
aaaaaaaadkiacaaaaaaaaaaaajaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaaadpddaaaaahiccabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaiadpbaaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
abaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaa
ahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaalhccabaaa
aaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegiccaaaaaaaaaaa
afaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
"ps_3_0
; 48 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c9, 1.00000000, 0.00000000, -1.00000000, 0.50000000
def c10, 10.00000000, 0, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c9.z
mul_pp r0.xy, r0, c7.x
mad_pp r0.xyz, r0.xxyw, c9.xyxw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r0
mul r0.xy, r2.xzzw, c7.y
mov_pp r0.zw, c9.y
mul r0.xy, r0, c10.x
add r0, v3, r0
texldp r0.xyz, r0, s1
add_pp r1.xyz, -r0, c3
mad_pp r0.xyz, r1, c3.w, r0
add_pp r4.xyz, r0, -c2
dp3 r0.w, v1, v1
rsq r0.w, r0.w
mul r1.xyz, r0.w, v1
add r3.xyz, r1, c6
dp3 r0.w, r3, r3
mul_pp r0.xz, r2, c8.x
mov_pp r0.y, r2
dp3_pp r1.x, -r1, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r3
dp3_pp r0.y, r2, -r0
max_pp r0.w, r1.x, c9.y
add_pp_sat r0.x, -r0.w, c9
pow_pp r1, r0.x, c7.z
max_pp r2.x, r0.y, c9.y
pow r0, r2.x, c5.x
mov_pp r0.z, r1.x
mov_pp r0.y, c7.w
add_pp r0.y, c9.x, -r0
mad_pp_sat r0.y, r0, r0.z, c7.w
mad_pp r2.xyz, r0.y, r4, c2
mov r0.z, r0.x
texldp r1.x, v3, s2
mad r0.x, r1, c0.z, c0.w
max r0.z, r0, c9.y
rcp r0.x, r0.x
add r0.x, r0, -v3.z
add_pp_sat r0.y, r0, c9.w
mul_sat r0.x, r0, c4
mad oC0.xyz, r0.z, c1, r2
mul_pp oC0.w, r0.x, r0.y
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Vector 2 [_BaseColor]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
Vector 4 [_InvFadeParemeter]
Vector 3 [_ReflectionColor]
Float 5 [_Shininess]
Vector 1 [_SpecularColor]
Vector 6 [_WorldLightDir]
Vector 0 [_ZBufferParams]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 44.00 (33 instructions), vertex: 0, texture: 16,
//   sequencer: 16, interpolator: 16;    6 GPRs, 30 threads,
// Performance (if enough threads): ~44 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaaciiaaaaacdiaaaaaaaaaaaaaaceaaaaacdaaaaaacfiaaaaaaaa
aaaaaaaaaaaaacaiaaaaaabmaaaaabpjppppadaaaaaaaaamaaaaaabmaaaaaaaa
aaaaabpcaaaaabamaaacaaacaaabaaaaaaaaabbiaaaaaaaaaaaaabciaaadaaaa
aaabaaaaaaaaabdeaaaaaaaaaaaaabeeaaadaaacaaabaaaaaaaaabdeaaaaaaaa
aaaaabfiaaacaaahaaabaaaaaaaaabbiaaaaaaaaaaaaabghaaacaaaiaaabaaaa
aaaaabhiaaaaaaaaaaaaabiiaaacaaaeaaabaaaaaaaaabbiaaaaaaaaaaaaabjk
aaacaaadaaabaaaaaaaaabbiaaaaaaaaaaaaabklaaadaaabaaabaaaaaaaaabde
aaaaaaaaaaaaablkaaacaaafaaabaaaaaaaaabhiaaaaaaaaaaaaabmfaaacaaab
aaabaaaaaaaaabbiaaaaaaaaaaaaabneaaacaaagaaabaaaaaaaaabbiaaaaaaaa
aaaaabodaaacaaaaaaabaaaaaaaaabbiaaaaaaaafpecgbhdgfedgpgmgphcaakl
aaabaaadaaabaaaeaaabaaaaaaaaaaaafpechfgnhaengbhaaaklklklaaaeaaam
aaabaaabaaabaaaaaaaaaaaafpedgbgngfhcgbeegfhahegifegfhihehfhcgfaa
fpeegjhdhegphchefagbhcgbgnhdaafpeghcgfhdgogfgmfdgdgbgmgfaaklklkl
aaaaaaadaaabaaabaaabaaaaaaaaaaaafpejgohgeggbgegffagbhcgfgngfhegf
hcaafpfcgfgggmgfgdhegjgpgoedgpgmgphcaafpfcgfgggmgfgdhegjgpgofegf
hiaafpfdgigjgogjgogfhdhdaafpfdhagfgdhfgmgbhcedgpgmgphcaafpfhgphc
gmgeemgjghgiheeegjhcaafpfkechfgggggfhcfagbhcgbgnhdaahahdfpddfpda
aadccodacodcdadddfddcodaaaklklklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaa
aaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaabpi
baaaafaaaaaaaaaeaaaaaaaaaaaadmieaaapaaapaaaaaaabaaaapafaaaaahbfb
aaaapcfcaaaapdfdaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaebcaaaaadpiaaaaalpiaaaaadpaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaacfgaaegaakbcaabcaaaaaaaaaagabagabgbcaabcaaaaaa
aafaeabmaaaabcaameaaaaaaaaaagacadacgbcaaccaaaaaabaaaeaebbpbpphpj
aaaaeaaadiaacaebbpbppofpaaaaeaaamiaiaaabaaloloaapaababaafiibabac
aagmmgbloaaeacibmiahaaafaablmaaaobababaalachabaeaamamaaakaafagpo
laeiababaaloloabpaaeaepofibbacabaamgblbloaabaeibmiakaaabaalmgmmm
klabahaamiabaaabaaldldgmnbababpomiabaaabaalblbgmolaaaaabfibeabab
aeblmggmcaahpoibbeahaaacaalegmgmobaeacabamedaeabaabjgmlbobababaa
beiaabaaaaaaaamgocaaaaaemiabaaaaacbnmnaapaabacaaemebaaaaaagmgmbl
kcaapoadeacdaaaeaalagmgmkbabaiiakibdaaacaamglaebmbaaadafdibcaaaa
aelomngmpaafaeaamiadaaaaaalagmaakcaapoaalkcaaaaaaaaaaambmcaaaapo
eabkababaagblblbkbabpoaamialaaabaagdmbaakbabahaadiidaaabaalalabl
oaabadabmiaoaaaaaakgmlaaobabaaaalibibaabbpbppoiiaaaaeaaabacibaeb
bpbppbppaaaaeaaamiaiaaabaablmgblilabaaaaemihabacaemamablkaabadab
lcehaaabacmamaabiaabacahmiahaaabaamablmaklacadabmiacaaaaacblmgaa
oaabadaamiahaaabaamgmamamlaaabacklieaaaaaamggmebiaaappaemiaiiaaa
aablmgaaobaaaaaamiahiaaaaagmmamaklaaababaaaaaaaaaaaaaaaaaaaaaaaa
"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
"sce_fp_rsx // 70 instructions using 3 registers
[Configuration]
24
ffffffff0003c020000ffff0000000000000840003000000
[Offsets]
9
_ZBufferParams 1 0
00000250
_SpecularColor 1 0
00000440
_BaseColor 2 0
000003c0000003a0
_ReflectionColor 2 0
0000033000000310
_InvFadeParemeter 1 0
00000420
_Shininess 1 0
000002e0
_WorldLightDir 1 0
00000090
_DistortParams 5 0
0000038000000350000002c00000013000000050
_FresnelScale 1 0
00000100
[Microcode]
1120
d4001700c8011c9dc8000001c8003fe1d40217005c011c9dc8000001c8003fe1
18800300ba001c9dba040001c8000001a8000500c8011c9dc8010001c800bfe1
0a8004405f001c9d000200000002000200000000000000000000000000000000
8e880340c8011c9dc9000001c8003fe1ae023b00c8011c9d54000001c800bfe1
0e000300c8041c9dc8020001c800000100000000000000000000000000000000
0e883940c9101c9dc8000029c8000001048a0140c9101c9dc8000001c8000001
08820540c9101c9fc8000001c800000102000500c8001c9dc8000001c8000001
10883b0055041c9dc8000001c80000010a8a0200c9101c9d00020000c8000001
0000000000000000000000000000000004880540c8041c9fc9140001c8000001
10040100aa021c9cc8000001c800000100000000000000000000000000000000
02840200fe081c9d00020000c800000100004120000000000000000000000000
18840140aa021c9cc8000001c800000100000000000000000000000000000000
06840200d1101c9d01080000c800000110040900ab101c9c00020000c8000001
00000000000000000000000000000000fe000100c8011c9dc8000001c8003fe1
1e020300c8001c9dc9080001c8000001f6001804c8011c9dc8000001c8003fe1
02000500a6001c9dc8020001c800000100013f7f00013b7f0001377f00000000
10808300c8081c9fc8020001c800000100000000000000000000000000003f80
0e021802c8041c9dc8000001c800000108801d00ff001c9dc8000001c8000001
02000400c8001c9d54020001fe02000100000000000000000000000000000000
02041a00c8001c9dc8000001c800000102000900ff101c9d00020000c8000001
000000000000000000000000000000000204030054001c9fc8080001c8000001
10001d00c8001c9dc8000001c8000001028a020055001c9d54020001c8000001
0000000000000000000000000000000010000200c8001c9d00020000c8000001
0000000000000000000000000000000008881c40c9141c9dc8000001c8000001
0e000300c8041c9fc8020001c800000100000000000000000000000000000000
0e000400c8001c9dfe020001c804000100000000000000000000000000000000
028a044055101c9dfe0200035510000100000000000000000000000000000000
10001c00fe001c9dc8000001c80000011088834001141c9cc8020001c8000001
000000000000000000000000000000000e000300c8001c9dc8020003c8000001
000000000000000000000000000000000e000400ff101c9dc8000001c8020001
0000000000000000000000000000000010000900c8001c9dc8020001c8000001
0000000000000000000000000000000002848340ff101c9daa020000c8000001
0000000000003f0000000000000000001084820000081c9c00020000c8000001
000000000000000000000000000000000e800400fe001c9dc8020001c8000001
0000000000000000000000000000000010810240c9081c9d01080000c8000001
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
ConstBuffer "$Globals" 304 // 164 used size, 19 vars
Vector 48 [_SpecularColor] 4
Vector 64 [_BaseColor] 4
Vector 80 [_ReflectionColor] 4
Vector 96 [_InvFadeParemeter] 4
Float 112 [_Shininess]
Vector 128 [_WorldLightDir] 4
Vector 144 [_DistortParams] 4
Float 160 [_FresnelScale]
ConstBuffer "UnityPerCamera" 128 // 128 used size, 8 vars
Vector 112 [_ZBufferParams] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_ReflectionTex] 2D 1
SetTexture 2 [_CameraDepthTexture] 2D 2
// 53 instructions, 4 temp regs, 0 temp arrays:
// ALU 46 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedjnolchnheceibcjdncnpmhcdckbhbcenabaaaaaabiaiaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcbaahaaaaeaaaaaaameabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fjaaaaaeegiocaaaabaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
pcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaadaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahhcaabaaaaaaaaaaapganbaaa
aaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
aceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaadcaaaaamhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaiadpaaaaaaaaegbcbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaifcaabaaaabaaaaaaagacbaaa
aaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaabaaaaaabkaabaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaakhcaabaaaadaaaaaaegbcbaaa
acaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaaiicaabaaa
aaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaa
ajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaajbcaabaaa
abaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadpdccaaaak
icaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaa
ajaaaaaadiaaaaaidcaabaaaabaaaaaaigaabaaaaaaaaaaafgifcaaaaaaaaaaa
ajaaaaaadiaaaaakdcaabaaaabaaaaaaegaabaaaabaaaaaaaceaaaaaaaaacaeb
aaaacaebaaaaaaaaaaaaaaaadgaaaaafecaabaaaabaaaaaaabeaaaaaaaaaaaaa
aaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegbdbaaaaeaaaaaaaoaaaaah
dcaabaaaabaaaaaaegaabaaaabaaaaaakgakbaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaaj
hcaabaaaacaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaa
dcaaaaakhcaabaaaabaaaaaapgipcaaaaaaaaaaaafaaaaaaegacbaaaacaaaaaa
egacbaaaabaaaaaaaaaaaaajhcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaia
ebaaaaaaaaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaapgapbaaaaaaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaaeaaaaaaaaaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaadpddaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaiadpbaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaa
egacbaaaadaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaa
aaaaaaaaahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaak
hccabaaaaaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaa
abaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaaaaaaaaaeghobaaaacaaaaaaaagabaaa
acaaaaaadcaaaaalbcaabaaaaaaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaa
abaaaaaadkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaaaaaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaackbabaiaebaaaaaaaeaaaaaadicaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaahiccabaaa
aaaaaaaadkaabaaaaaaaaaaaakaabaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_ReflectionColor]
Vector 3 [_InvFadeParemeter]
Float 4 [_Shininess]
Vector 5 [_WorldLightDir]
Vector 6 [_DistortParams]
Float 7 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_CameraDepthTexture] 2D
"ps_3_0
; 40 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c8, 1.00000000, 0.00000000, -1.00000000, 0.50000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dp3 r0.x, v1, v1
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.zw, r0.xyyw, r1.xyyw
add_pp r0.zw, r0.xywz, c8.z
mul_pp r2.xy, r0.zwzw, c6.x
rsq r0.x, r0.x
mul r1.xyz, r0.x, v1
add r0.xyz, r1, c5
mad_pp r2.xyz, r2.xxyw, c8.xyxw, v0
dp3 r1.w, r0, r0
dp3_pp r0.w, r2, r2
rsq r1.w, r1.w
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r2
mul r0.xyz, r1.w, r0
dp3_pp r0.x, r2, -r0
max_pp r1.w, r0.x, c8.y
pow r0, r1.w, c4.x
mul_pp r2.xz, r2, c7.x
dp3_pp r0.y, -r1, r2
mov r0.z, r0.x
max_pp r0.x, r0.y, c8.y
max r0.y, r0.z, c8
mul r1.xyz, r0.y, c1
add_pp_sat r1.w, -r0.x, c8.x
pow_pp r0, r1.w, c6.z
add oC0.xyz, r1, c2
mov_pp r0.y, c6.w
mov_pp r0.z, r0.x
texldp r1.x, v3, s1
mad r0.x, r1, c0.z, c0.w
rcp r0.x, r0.x
add_pp r0.y, c8.x, -r0
mad_pp_sat r0.y, r0, r0.z, c6.w
add r0.x, r0, -v3.z
add_pp_sat r0.y, r0, c8.w
mul_sat r0.x, r0, c3
mul_pp oC0.w, r0.x, r0.y
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Vector 6 [_DistortParams]
Float 7 [_FresnelScale]
Vector 3 [_InvFadeParemeter]
Vector 2 [_ReflectionColor]
Float 4 [_Shininess]
Vector 1 [_SpecularColor]
Vector 5 [_WorldLightDir]
Vector 0 [_ZBufferParams]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_CameraDepthTexture] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 37.33 (28 instructions), vertex: 0, texture: 12,
//   sequencer: 14, interpolator: 16;    7 GPRs, 27 threads,
// Performance (if enough threads): ~37 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaaceeaaaaabpaaaaaaaaaaaaaaaceaaaaabomaaaaacbeaaaaaaaa
aaaaaaaaaaaaabmeaaaaaabmaaaaablgppppadaaaaaaaaakaaaaaabmaaaaaaaa
aaaaabkpaaaaaaoeaaadaaaaaaabaaaaaaaaaapaaaaaaaaaaaaaabaaaaadaaab
aaabaaaaaaaaaapaaaaaaaaaaaaaabbeaaacaaagaaabaaaaaaaaabceaaaaaaaa
aaaaabdeaaacaaahaaabaaaaaaaaabeeaaaaaaaaaaaaabfeaaacaaadaaabaaaa
aaaaabceaaaaaaaaaaaaabggaaacaaacaaabaaaaaaaaabceaaaaaaaaaaaaabhh
aaacaaaeaaabaaaaaaaaabeeaaaaaaaaaaaaabicaaacaaabaaabaaaaaaaaabce
aaaaaaaaaaaaabjbaaacaaafaaabaaaaaaaaabceaaaaaaaaaaaaabkaaaacaaaa
aaabaaaaaaaaabceaaaaaaaafpechfgnhaengbhaaaklklklaaaeaaamaaabaaab
aaabaaaaaaaaaaaafpedgbgngfhcgbeegfhahegifegfhihehfhcgfaafpeegjhd
hegphchefagbhcgbgnhdaaklaaabaaadaaabaaaeaaabaaaaaaaaaaaafpeghcgf
hdgogfgmfdgdgbgmgfaaklklaaaaaaadaaabaaabaaabaaaaaaaaaaaafpejgohg
eggbgegffagbhcgfgngfhegfhcaafpfcgfgggmgfgdhegjgpgoedgpgmgphcaafp
fdgigjgogjgogfhdhdaafpfdhagfgdhfgmgbhcedgpgmgphcaafpfhgphcgmgeem
gjghgiheeegjhcaafpfkechfgggggfhcfagbhcgbgnhdaahahdfpddfpdaaadcco
dacodcdadddfddcodaaaklklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabe
abpmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaablabaaaagaa
aaaaaaaeaaaaaaaaaaaadmieaaapaaapaaaaaaabaaaapafaaaaahbfbaaaapcfc
aaaapdfdaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadpiaaaaalpiaaaaa
dpaaaaaaabfafaaeaaaabcaameaaaaaaaaaagaajgaapbcaabcaaaaaaaaaagabf
gablbcaabcaaaaaaaaaacacbaaaaccaaaaaaaaaaemicabaeaaloloblpaababad
miadaaafaabllaaaobabadaabaaieaebbpbpphpjaaaaeaaadiaicaebbpbppohl
aaaaeaaababibakbbpbppbppaaaaeaaamiaiaaabaablmgblilabaaaafiicacac
aagmmglboaaeaciemiahaaaeaablmaaaobacabaalaehagafaamamamakaaeafpp
lacbagabaalolombpaafafppfiebabagaamgblgmoaagaeibmiadaaacaalagmme
klagagaamiabaaabaagngngmnbacacppmiacaaabaalblbgmolaaaaabficbabab
aebllblbcaagppibbeahaaafaamamglbobafababamedacacaalalblbobacabaa
miabaaaaacmnloaapaacafaamiacaaaaaagmgmaakcaappaaeacfaaaaaalagmlb
kbacahiabeicaaaaaalbgmmgkbaaaeacdicbaaaaaelobolbpaaeaaaamiadaaaa
aalagmaakcaappaamiahiaaaaalbmamailaaabacencbaaaaaegmlbblkaaappab
eabcaaaaaclbmggmoaaaadaakibaaaaaaaaaaamamcaaaaagdjbcaaaaaalbgmgm
kbaaadaamjabaaaaaagmgmblmlabaaaglcbaaaaaaaaaaaaamcaaaappmiaiiaaa
aalbgmaaobaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_ReflectionColor]
Vector 3 [_InvFadeParemeter]
Float 4 [_Shininess]
Vector 5 [_WorldLightDir]
Vector 6 [_DistortParams]
Float 7 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_CameraDepthTexture] 2D
"sce_fp_rsx // 54 instructions using 3 registers
[Configuration]
24
ffffffff0003c020000ffff0000000000000840003000000
[Offsets]
8
_ZBufferParams 1 0
00000200
_SpecularColor 1 0
00000300
_ReflectionColor 1 0
00000290
_InvFadeParemeter 1 0
00000340
_Shininess 1 0
000001e0
_WorldLightDir 1 0
00000080
_DistortParams 4 0
000002e0000002b00000023000000050
_FresnelScale 1 0
000000e0
[Microcode]
864
d4001700c8011c9dc8000001c8003fe1d40217005c011c9dc8000001c8003fe1
18800300ba001c9dba040001c8000001a8000500c8011c9dc8010001c800bfe1
0a8004405f001c9d000200000002000200000000000000000000000000000000
ae023b00c8011c9d54000001c800bfe10e040300c8041c9dc8020001c8000001
000000000000000000000000000000008e800340c8011c9dc9000001c8003fe1
0e803940c9001c9dc8000029c800000104820140c9001c9dc8000001c8000001
088a0540c9001c9fc8080001c80000010a820200c9001c9d00020000c8000001
0000000000000000000000000000000002800540c8041c9fc9040001c8000001
1000090001001c9c00020000c800000100000000000000000000000000000000
04000500c8081c9dc8080001c800000102803b0055141c9daa000000c8000001
10808300c8001c9f00020000c800000100003f80000000000000000000000000
02821d00ff001c9dc8000001c800000102020900c9001c9d00020000c8000001
00000000000000000000000000000000f6001802c8011c9dc8000001c8003fe1
02000500a6001c9dc8020001c800000100013f7f00013b7f0001377f00000000
02021d00c8041c9dc8000001c80000011000020000041c9c00020000c8000001
000000000000000000000000000000000400040000001c9c54020001fe020001
0000000000000000000000000000000002001c00fe001c9dc8000001c8000001
02820200c9041c9d54020001c800000100000000000000000000000000000000
02000900c8001c9d00020000c800000100000000000000000000000000000000
04001a00aa001c9cc8000001c800000102821c40c9041c9dc8000001c8000001
0e020100c8021c9dc8000001c800000100000000000000000000000000000000
02820440c9041c9dfe020003c904000100000000000000000000000000000000
f000030054011c9faa000000c8003fe11086834001041c9cc8020001c8000001
000000000000000000000000000000000e80040000001c9cc8020001c8040001
0000000000000000000000000000000002828340ff0c1c9daa020000c8000001
0000000000003f00000000000000000010808200c8001c9d00020000c8000001
0000000000000000000000000000000010810240c9001c9d01040000c8000001
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
ConstBuffer "$Globals" 304 // 164 used size, 19 vars
Vector 48 [_SpecularColor] 4
Vector 80 [_ReflectionColor] 4
Vector 96 [_InvFadeParemeter] 4
Float 112 [_Shininess]
Vector 128 [_WorldLightDir] 4
Vector 144 [_DistortParams] 4
Float 160 [_FresnelScale]
ConstBuffer "UnityPerCamera" 128 // 128 used size, 8 vars
Vector 112 [_ZBufferParams] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_CameraDepthTexture] 2D 1
// 43 instructions, 4 temp regs, 0 temp arrays:
// ALU 38 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedcpmolfnjoofpphognjpbcnemhdcobfbmabaaaaaalaagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefckiafaaaaeaaaaaaagkabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fjaaaaaeegiocaaaabaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadpcbabaaaadaaaaaagcbaaaadpcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaadaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaa
adaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahhcaabaaaaaaaaaaa
pganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaadcaaaaamhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaiadpaaaaaaaa
egbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaifcaabaaaabaaaaaa
agacbaaaaaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaabaaaaaa
bkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaa
acaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaakhcaabaaaadaaaaaa
egbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaai
icaabaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaa
aaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaaj
bcaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadp
dccaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaa
aaaaaaaaajaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaadpddaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadp
aoaaaaahdcaabaaaabaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaaefaaaaaj
pcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaa
dcaaaaalbcaabaaaabaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaaabaaaaaa
dkiacaaaabaaaaaaahaaaaaaaoaaaaakbcaabaaaabaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpakaabaaaabaaaaaaaaaaaaaibcaabaaaabaaaaaa
akaabaaaabaaaaaackbabaiaebaaaaaaaeaaaaaadicaaaaibcaabaaaabaaaaaa
akaabaaaabaaaaaaakiacaaaaaaaaaaaagaaaaaadiaaaaahiccabaaaaaaaaaaa
dkaabaaaaaaaaaaaakaabaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
adaaaaaaegacbaaaadaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaai
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
dcaaaaalhccabaaaaaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaa
egiccaaaaaaaaaaaafaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
"ps_3_0
; 42 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c7, 1.00000000, 0.00000000, -1.00000000, 0.50000000
def c8, 10.00000000, 0, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c7.z
mul_pp r0.xy, r0, c5.x
mad_pp r0.xyz, r0.xxyw, c7.xyxw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r0
mul r0.xy, r2.xzzw, c5.y
dp3 r0.z, v1, v1
rsq r1.x, r0.z
mul r1.xyz, r1.x, v1
add r3.xyz, r1, c4
mul r0.xy, r0, c8.x
mov_pp r0.zw, c7.y
add r0, v3, r0
texldp r0.xyz, r0, s1
dp3 r0.w, r3, r3
rsq r0.w, r0.w
mul r3.xyz, r0.w, r3
dp3_pp r1.w, r2, -r3
mul_pp r2.xz, r2, c6.x
dp3_pp r0.w, -r1, r2
max_pp r2.x, r1.w, c7.y
pow r1, r2.x, c3.x
add_pp r4.xyz, -r0, c2
mad_pp r0.xyz, r4, c2.w, r0
max_pp r0.w, r0, c7.y
add_pp_sat r0.w, -r0, c7.x
pow_pp r2, r0.w, c5.z
mov_pp r0.w, c5
add_pp r0.xyz, r0, -c1
mov r1.y, r1.x
mov_pp r1.x, r2
add_pp r0.w, c7.x, -r0
mad_pp_sat r0.w, r0, r1.x, c5
mad_pp r2.xyz, r0.w, r0, c1
max r0.x, r1.y, c7.y
mad oC0.xyz, r0.x, c0, r2
add_pp_sat oC0.w, r0, c7
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Vector 1 [_BaseColor]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 0 [_SpecularColor]
Vector 4 [_WorldLightDir]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 36.00 (27 instructions), vertex: 0, texture: 12,
//   sequencer: 14, interpolator: 16;    6 GPRs, 30 threads,
// Performance (if enough threads): ~36 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaacbeaaaaaboeaaaaaaaaaaaaaaceaaaaablmaaaaaboeaaaaaaaa
aaaaaaaaaaaaabjeaaaaaabmaaaaabiippppadaaaaaaaaajaaaaaabmaaaaaaaa
aaaaabibaaaaaanaaaacaaabaaabaaaaaaaaaanmaaaaaaaaaaaaaaomaaadaaaa
aaabaaaaaaaaaapiaaaaaaaaaaaaabaiaaacaaafaaabaaaaaaaaaanmaaaaaaaa
aaaaabbhaaacaaagaaabaaaaaaaaabciaaaaaaaaaaaaabdiaaacaaacaaabaaaa
aaaaaanmaaaaaaaaaaaaabejaaadaaabaaabaaaaaaaaaapiaaaaaaaaaaaaabfi
aaacaaadaaabaaaaaaaaabciaaaaaaaaaaaaabgdaaacaaaaaaabaaaaaaaaaanm
aaaaaaaaaaaaabhcaaacaaaeaaabaaaaaaaaaanmaaaaaaaafpecgbhdgfedgpgm
gphcaaklaaabaaadaaabaaaeaaabaaaaaaaaaaaafpechfgnhaengbhaaaklklkl
aaaeaaamaaabaaabaaabaaaaaaaaaaaafpeegjhdhegphchefagbhcgbgnhdaafp
eghcgfhdgogfgmfdgdgbgmgfaaklklklaaaaaaadaaabaaabaaabaaaaaaaaaaaa
fpfcgfgggmgfgdhegjgpgoedgpgmgphcaafpfcgfgggmgfgdhegjgpgofegfhiaa
fpfdgigjgogjgogfhdhdaafpfdhagfgdhfgmgbhcedgpgmgphcaafpfhgphcgmge
emgjghgiheeegjhcaahahdfpddfpdaaadccodacodcdadddfddcodaaaaaaaaaaa
aaaaaaabaaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaeaaaaaabkebaaaafaaaaaaaaaeaaaaaaaaaaaadmieaaapaaap
aaaaaaabaaaapafaaaaahbfbaaaapcfcaaaapdfdaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadpaaaaaaaaaaaaaaebcaaaaa
dpiaaaaalpiaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacfgaaegaakbcaabcaaaaaa
aaaagabafabgbcaabcaaabaaaaaaaaaagablmeaabcaaaaaaaaaabacbaaaaccaa
aaaaaaaabaaaeaebbpbpphpjaaaaeaaadiaacaebbpbppopjaaaaeaaamiaiaaab
aaloloaapaababaafiicabacaagmgmbloaaeacibmiahaaafaablmaaaobababaa
lachabaeaamamaebkaafaepplaeiababaaloloecpaaeaeppfiibababaamgblbl
oaabaeibmiadaaabaalagmmeklabafaamiaeaaabaagngnlbnbababpomiaeaaab
aalblbmgolaaaaabfiehabacaaleblmgobaeabibbeadaaabaalamgmgobababab
amedaeaeaalagmlbkbabagaabeibabaaaelomnmgpaafaeaemiacaaaaacbnmnaa
paabacaabeadaaaaablalbblicaapoafafeeabaaaegmblbliaaapopoeabkabab
aagbmgmgkbabpoaaemelaaabaagdmbblkbabafaddiidaaabaalalabloaabadab
eacnaaaaaakomhlbobabaaialibibaabbpbppoiiaaaaeaaakichaaacaemamaeb
iaabacaddichaaabacmamalbkaababaamiaoaaabaapmblpmklacacablccbaaab
aalblbaaicaapoaflciaiaaaaaaaaaebmcaaaapomiahaaaaaalbbfmamlaaabab
miahiaaaaagmmamaklabaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
"sce_fp_rsx // 59 instructions using 3 registers
[Configuration]
24
ffffffff0003c020000ffff0000000000000840003000000
[Offsets]
7
_SpecularColor 1 0
00000380
_BaseColor 2 0
0000034000000280
_ReflectionColor 2 0
00000220000001f0
_Shininess 1 0
00000310
_WorldLightDir 1 0
00000160
_DistortParams 5 0
000002f0000002c0000002500000009000000040
_FresnelScale 1 0
00000120
[Microcode]
944
d4001700c8011c9dc8000001c8003fe1d40217005c011c9dc8000001c8003fe1
18820300ba001c9dba040001c800000110020100aa021c9cc8000001c8000001
00000000000000000000000000000000a8000500c8011c9dc8010001c800bfe1
10800200c8041c9daa020000c800000100000000000041200000000000000000
0a8004405f041c9d000200000002000200000000000000000000000000000000
8e800340c8011c9dc9000001c8003fe11882014000021c9cc8000001c8000001
000000000000000000000000000000000e803940c9001c9dc8000029c8000001
04840140c9001c9dc8000001c8000001ae043b00c8011c9d54000001c800bfe1
06820200d1001c9dff000001c80000010a840200c9001c9d00020000c8000001
0000000000000000000000000000000010800540c8081c9fc9080001c8000001
fe020300c9041c9dc8010001c8003fe10e040300c8081c9dc8020001c8000001
0000000000000000000000000000000010000900c9001c9dc8020001c8000001
0000000000000000000000000000000002800540c9001c9fc8080001c8000001
10828300c8001c9f00020000c800000100003f80000000000000000000000000
0e021802c8041c9dc8000001c800000104000500c8081c9dc8080001c8000001
0e040300c8041c9fc8020001c800000100000000000000000000000000000000
08861d00ff041c9dc8000001c80000010e020400c8081c9dfe020001c8040001
0000000000000000000000000000000010863b0001001c9caa000000c8000001
08860200c90c1c9dc8020001c800000100000000000000000000000000000000
02801c40550c1c9dc8000001c80000010e020300c8041c9dc8020003c8000001
0000000000000000000000000000000010000900c90c1c9d00020000c8000001
0000000000000000000000000000000002800440c9001c9dfe020003c9000001
0000000000000000000000000000000004001d00fe001c9dc8000001c8000001
02828340c9001c9dfe020001c800000100000000000000000000000000000000
10000200aa001c9c00020000c800000100000000000000000000000000000000
02001c00fe001c9dc8000001c80000010e02040001041c9cc8040001c8020001
0000000000000000000000000000000002000900c8001c9d00020000c8000001
000000000000000000000000000000000e80040000001c9cc8020001c8040001
000000000000000000000000000000001081834001041c9cc8020001c8000001
00000000000000000000000000003f00
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
ConstBuffer "$Globals" 304 // 164 used size, 19 vars
Vector 48 [_SpecularColor] 4
Vector 64 [_BaseColor] 4
Vector 80 [_ReflectionColor] 4
Float 112 [_Shininess]
Vector 128 [_WorldLightDir] 4
Vector 144 [_DistortParams] 4
Float 160 [_FresnelScale]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 0
SetTexture 1 [_ReflectionTex] 2D 1
// 46 instructions, 4 temp regs, 0 temp arrays:
// ALU 40 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedekijejogacbmpgejcncafnodliedoeghabaaaaaapmagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcpeafaaaaeaaaaaaahnabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaadhcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaagcbaaaad
lcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaaaaaaaahhcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaa
aaaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialp
aaaaialpaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaa
aaaaaaaaajaaaaaadcaaaaamhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaa
aaaaiadpaaaaaaaaaaaaiadpaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaifcaabaaaabaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaa
akaaaaaadgaaaaafccaabaaaabaaaaaabkaabaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegbcbaaaacaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegbcbaaa
acaaaaaadcaaaaakhcaabaaaadaaaaaaegbcbaaaacaaaaaapgapbaaaaaaaaaaa
egiccaaaaaaaaaaaaiaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaa
acaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaa
abeaaaaaaaaaiadpdeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaacpaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaiicaabaaa
aaaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaaajaaaaaabjaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaadkiacaiaebaaaaaa
aaaaaaaaajaaaaaaabeaaaaaaaaaiadpdccaaaakicaabaaaaaaaaaaaakaabaaa
abaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaajaaaaaadiaaaaaidcaabaaa
abaaaaaaigaabaaaaaaaaaaafgifcaaaaaaaaaaaajaaaaaadiaaaaakdcaabaaa
abaaaaaaegaabaaaabaaaaaaaceaaaaaaaaacaebaaaacaebaaaaaaaaaaaaaaaa
dgaaaaafecaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegbdbaaaaeaaaaaaaoaaaaahdcaabaaaabaaaaaaegaabaaa
abaaaaaakgakbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaabaaaaaaaaaaaaajhcaabaaaacaaaaaaegacbaia
ebaaaaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaadcaaaaakhcaabaaaabaaaaaa
pgipcaaaaaaaaaaaafaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaaaaaaaaj
hcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaiaebaaaaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaaeaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaadpddaaaaahiccabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadp
baaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
aaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaahaaaaaabjaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakhccabaaaaaaaaaaaagaabaaa
aaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Vector 0 [_SpecularColor]
Vector 1 [_ReflectionColor]
Float 2 [_Shininess]
Vector 3 [_WorldLightDir]
Vector 4 [_DistortParams]
Float 5 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
"ps_3_0
; 34 ALU, 2 TEX
dcl_2d s0
def c6, 1.00000000, 0.00000000, -1.00000000, 0.50000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dp3 r0.x, v1, v1
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.zw, r0.xyyw, r1.xyyw
add_pp r0.zw, r0.xywz, c6.z
mul_pp r2.xy, r0.zwzw, c4.x
rsq r0.x, r0.x
mul r1.xyz, r0.x, v1
add r0.xyz, r1, c3
mad_pp r2.xyz, r2.xxyw, c6.xyxw, v0
dp3 r1.w, r0, r0
dp3_pp r0.w, r2, r2
rsq r1.w, r1.w
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r2
mul r0.xyz, r1.w, r0
dp3_pp r0.x, r2, -r0
max_pp r1.w, r0.x, c6.y
pow r0, r1.w, c2.x
mul_pp r2.xz, r2, c5.x
dp3_pp r0.y, -r1, r2
max_pp r0.y, r0, c6
add_pp_sat r1.x, -r0.y, c6
max r1.y, r0.x, c6
pow_pp r0, r1.x, c4.z
mul r1.xyz, r1.y, c0
mov_pp r0.z, r0.x
mov_pp r0.y, c4.w
add_pp r0.x, c6, -r0.y
mad_pp_sat r0.x, r0, r0.z, c4.w
add oC0.xyz, r1, c1
add_pp_sat oC0.w, r0.x, c6
"
}

SubProgram "xbox360 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Vector 4 [_DistortParams]
Float 5 [_FresnelScale]
Vector 1 [_ReflectionColor]
Float 2 [_Shininess]
Vector 0 [_SpecularColor]
Vector 3 [_WorldLightDir]
SetTexture 0 [_BumpMap] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 33.33 (25 instructions), vertex: 0, texture: 8,
//   sequencer: 14, interpolator: 16;    5 GPRs, 36 threads,
// Performance (if enough threads): ~33 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabneaaaaabmaaaaaaaaaaaaaaaceaaaaabhmaaaaabkeaaaaaaaa
aaaaaaaaaaaaabfeaaaaaabmaaaaabefppppadaaaaaaaaahaaaaaabmaaaaaaaa
aaaaabdoaaaaaakiaaadaaaaaaabaaaaaaaaaaleaaaaaaaaaaaaaameaaacaaae
aaabaaaaaaaaaaneaaaaaaaaaaaaaaoeaaacaaafaaabaaaaaaaaaapeaaaaaaaa
aaaaabaeaaacaaabaaabaaaaaaaaaaneaaaaaaaaaaaaabbfaaacaaacaaabaaaa
aaaaaapeaaaaaaaaaaaaabcaaaacaaaaaaabaaaaaaaaaaneaaaaaaaaaaaaabcp
aaacaaadaaabaaaaaaaaaaneaaaaaaaafpechfgnhaengbhaaaklklklaaaeaaam
aaabaaabaaabaaaaaaaaaaaafpeegjhdhegphchefagbhcgbgnhdaaklaaabaaad
aaabaaaeaaabaaaaaaaaaaaafpeghcgfhdgogfgmfdgdgbgmgfaaklklaaaaaaad
aaabaaabaaabaaaaaaaaaaaafpfcgfgggmgfgdhegjgpgoedgpgmgphcaafpfdgi
gjgogjgogfhdhdaafpfdhagfgdhfgmgbhcedgpgmgphcaafpfhgphcgmgeemgjgh
giheeegjhcaahahdfpddfpdaaadccodacodcdadddfddcodaaaklklklaaaaaaaa
aaaaaaabaaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaeaaaaaabiabaaaaeaaaaaaaaaeaaaaaaaaaaaadmieaaapaaap
aaaaaaabaaaapafaaaaahbfbaaaapcfcaaaapdfdaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaadpiaaaaalpiaaaaadpaaaaaaaaafcaaeaaaabcaameaaaaaa
aaaagaaggaambcaabcaaaaaaaaaagabcgabibcaabcaaaaaaaaaababoaaaaccaa
aaaaaaaabaaidaebbpbpphpjaaaaeaaadiaicaebbpbppohlaaaaeaaamiaiaaab
aaloloaapaababaafiicabacaagmmgbloaadacibmiahaaabaablmaaaobababaa
laehaeadaamamamakaabadpplaciaeabaalolombpaadadppfiebacaeaamgblbl
oaaeadibmiadaaacaalagmmeklaeaeaamiaiaaabaagngngmnbacacppmiaiaaab
aalblbblolaaaaabfiiaabaaaaaaaablocaaaaibbeahaaadaamamgblobadacab
amedacacaalabllbobacabaamiabaaaaacmnloaapaacadaamiabaaaaaagmgmaa
kcaappaaeabgaaaaaalmgmgmkbacafiabeibaaaaaagmgmmgkbaaacacdibcaaaa
aelobcgmpaabaaaamiadaaaaaagngmaakcaappaamiahiaaaaalbmamailaaaaab
lkbaaaaaaaaaaaiamcaaaappeabaaaaaaaaaaagmocaaaaaakibaaaaaaaaaaama
mcaaaaaedibcaaaaaebllbgmcaaeppaamjabaaaaaalbgmblmlaaaaaelciaiaaa
aaaaaaaamcaaaappaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Vector 0 [_SpecularColor]
Vector 1 [_ReflectionColor]
Float 2 [_Shininess]
Vector 3 [_WorldLightDir]
Vector 4 [_DistortParams]
Float 5 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
"sce_fp_rsx // 43 instructions using 3 registers
[Configuration]
24
ffffffff0001c0200007fff8000000000000840003000000
[Offsets]
6
_SpecularColor 1 0
00000280
_ReflectionColor 1 0
000001f0
_Shininess 1 0
00000190
_WorldLightDir 1 0
00000080
_DistortParams 4 0
0000023000000210000001c000000050
_FresnelScale 1 0
000000f0
[Microcode]
688
d4001700c8011c9dc8000001c8003fe1d40217005c011c9dc8000001c8003fe1
18800300ba001c9dba040001c8000001a8000500c8011c9dc8010001c800bfe1
0a8004405f001c9d000200000002000200000000000000000000000000000000
ae023b00c8011c9d54000001c800bfe10e040300c8041c9dc8020001c8000001
000000000000000000000000000000008e800340c8011c9dc9000001c8003fe1
08000500c8081c9dc8080001c80000010e803940c9001c9dc8000029c8000001
10800540c9001c9fc8080001c800000110803b00c9001c9d54000001c8000001
0a800200c9001c9d00020000c800000100000000000000000000000000000000
02840540c8041c9fc9000001c800000110000900c9001c9d00020000c8000001
0000000000000000000000000000000002020900c9081c9d00020000c8000001
0000000000000000000000000000000004021d00fe001c9dc8000001c8000001
02808300c8041c9f00020000c800000100003f80000000000000000000000000
10020200aa041c9c00020000c800000100000000000000000000000000000000
02801d00c9001c9dc8000001c800000102800200c9001c9d54020001c8000001
0000000000000000000000000000000008821c40c9001c9dc8000001c8000001
0e000100c8021c9dc8000001c800000100000000000000000000000000000000
0284044055041c9dfe0200035504000100000000000000000000000000000000
02848340c9081c9dfe020001c800000100000000000000000000000000000000
10001c00fe041c9dc8000001c800000102040900fe001c9d00020000c8000001
000000000000000000000000000000000e80040000081c9cc8020001c8000001
000000000000000000000000000000001081834001081c9cc8020001c8000001
00000000000000000000000000003f00
"
}

SubProgram "d3d11 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
ConstBuffer "$Globals" 304 // 164 used size, 19 vars
Vector 48 [_SpecularColor] 4
Vector 80 [_ReflectionColor] 4
Float 112 [_Shininess]
Vector 128 [_WorldLightDir] 4
Vector 144 [_DistortParams] 4
Float 160 [_FresnelScale]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 0
// 36 instructions, 4 temp regs, 0 temp arrays:
// ALU 32 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedfjonkajjjfejdllgemfphgdffiegbeoaabaaaaaaiiafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefciaaeaaaaeaaaaaaacaabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaogbkbaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaah
hcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaaajaaaaaa
dcaaaaamhcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadpaaaaaaaa
aaaaiadpaaaaaaaaegbcbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaai
fcaabaaaabaaaaaaagacbaaaaaaaaaaaagiacaaaaaaaaaaaakaaaaaadgaaaaaf
ccaabaaaabaaaaaabkaabaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegbcbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegbcbaaaacaaaaaadcaaaaak
hcaabaaaadaaaaaaegbcbaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaa
aiaaaaaabaaaaaaiicaabaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaaegacbaaa
abaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
aaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadp
deaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaa
aaaaaaaackiacaaaaaaaaaaaajaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaaaaaaaaajbcaabaaaabaaaaaadkiacaiaebaaaaaaaaaaaaaaajaaaaaa
abeaaaaaaaaaiadpdccaaaakicaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaa
aaaaaaaadkiacaaaaaaaaaaaajaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaaadpddaaaaahiccabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaiadpbaaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
abaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaa
ahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaalhccabaaa
aaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegiccaaaaaaaaaaa
afaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES3"
}

}

#LINE 401

	}	
}

Subshader 
{ 	
	Tags {"RenderType"="Transparent" "Queue"="Transparent"}
	
	Lod 200
	ColorMask RGB
	
	Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Cull Off
			
			Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 11 to 11
//   d3d9 - ALU: 11 to 11
//   d3d11 - ALU: 11 to 11, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 11 to 11, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Vector 9 [_Time]
Vector 10 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Vector 11 [_BumpTiling]
Vector 12 [_BumpDirection]
"!!ARBvp1.0
# 11 ALU
PARAM c[13] = { program.local[0],
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
TEMP R1;
DP4 R0.x, vertex.position, c[5];
DP4 R0.z, vertex.position, c[7];
MOV R1, c[12];
MAD R1, R1, c[9].x, R0.xzxz;
DP4 R0.y, vertex.position, c[6];
MUL result.texcoord[1], R1, c[11];
ADD result.texcoord[0].xyz, R0, -c[10];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 11 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 10 [_BumpTiling]
Vector 11 [_BumpDirection]
"vs_2_0
; 11 ALU
dcl_position0 v0
mov r0.y, c8.x
dp4 r0.x, v0, c4
dp4 r0.z, v0, c6
mad r1, c11, r0.y, r0.xzxz
dp4 r0.y, v0, c5
mul oT1, r1, c10
add oT0.xyz, r0, -c9
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "xbox360 " {
Keywords { }
Bind "vertex" Vertex
Vector 11 [_BumpDirection]
Vector 10 [_BumpTiling]
Matrix 6 [_Object2World] 4
Vector 0 [_Time]
Vector 1 [_WorldSpaceCameraPos]
Matrix 2 [glstate_matrix_mvp] 4
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 14.67 (11 instructions), vertex: 32, texture: 0,
//   sequencer: 12,  2 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaabjiaaaaaamaaaaaaaaaaaaaaaceaaaaaaaaaaaaabfmaaaaaaaa
aaaaaaaaaaaaabdeaaaaaabmaaaaabcgpppoadaaaaaaaaagaaaaaabmaaaaaaaa
aaaaabbpaaaaaajeaaacaaalaaabaaaaaaaaaakeaaaaaaaaaaaaaaleaaacaaak
aaabaaaaaaaaaakeaaaaaaaaaaaaaamaaaacaaagaaaeaaaaaaaaaanaaaaaaaaa
aaaaaaoaaaacaaaaaaabaaaaaaaaaakeaaaaaaaaaaaaaaogaaacaaabaaabaaaa
aaaaaapmaaaaaaaaaaaaabamaaacaaacaaaeaaaaaaaaaanaaaaaaaaafpechfgn
haeegjhcgfgdhegjgpgoaaklaaabaaadaaabaaaeaaabaaaaaaaaaaaafpechfgn
hafegjgmgjgoghaafpepgcgkgfgdhedcfhgphcgmgeaaklklaaadaaadaaaeaaae
aaabaaaaaaaaaaaafpfegjgngfaafpfhgphcgmgefdhagbgdgfedgbgngfhcgbfa
gphdaaklaaabaaadaaabaaadaaabaaaaaaaaaaaaghgmhdhegbhegffpgngbhehc
gjhifpgnhghaaahghdfpddfpdaaadccodacodcdadddfddcodaaaklklaaaaaaaa
aaaaaamaaabbaaabaaaaaaaaaaaaaaaaaaaabmecaaaaaaabaaaaaaabaaaaaaac
aaaaacjaaaaaaaadaaaahafaaaabpbfbaaaabaamaaaabaaobaabbaadaaaabcaa
mcaaaaaaaaaaeaaeaaaabcaameaaaaaaaaaagaaibaaobcaaccaaaaaaafpiaaaa
aaaaaanbaaaaaaaamiapaaabaamgiiaakbaaafaamiapaaabaalbiiaaklaaaeab
miapaaabaagmdejeklaaadabmiapiadoaablaadeklaaacabmiahaaabaamgleaa
kbaaajaamiahaaabaalbmaleklaaaiabmiahaaaaaagmleleklaaahabmiahaaaa
aablmaleklaaagaamiahiaaaacmamaaakaaaabaamiapaaaaaagmkhooclaaalaa
miapiaabaahkaaaakbaaakaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { }
Matrix 256 [glstate_matrix_mvp]
Bind "vertex" Vertex
Vector 467 [_Time]
Vector 466 [_WorldSpaceCameraPos]
Matrix 260 [_Object2World]
Vector 465 [_BumpTiling]
Vector 464 [_BumpDirection]
"sce_vp_rsx // 11 instructions using 2 registers
[Configuration]
8
0000000b00010200
[Microcode]
176
00009c6c005d000d8186c0836041fffc401f9c6c01d0300d8106c0c360403f80
401f9c6c01d0200d8106c0c360405f80401f9c6c01d0100d8106c0c360409f80
401f9c6c01d0000d8106c0c360411f8000001c6c01d0500d8106c0c360409ffc
00001c6c01d0600d8106c0c360405ffc00001c6c01d0400d8106c0c360411ffc
00009c6c011d300d828000c44021fffc401f9c6c00dd208c0186c0830021df9c
401f9c6c009d100d8286c0c36041ffa1
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304 // 208 used size, 19 vars
Vector 176 [_BumpTiling] 4
Vector 192 [_BumpDirection] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 0 [_Time] 4
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 12 instructions, 1 temp regs, 0 temp arrays:
// ALU 11 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedadkolaekfkijjkjplcfhfjahhaggecdkabaaaaaaieadaaaaadaaaaaa
cmaaaaaapeaaaaaageabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheogiaaaaaaadaaaaaa
aiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaafmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcbiacaaaaeaaaabaaigaaaaaafjaaaaaeegiocaaaaaaaaaaa
anaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
baaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadhccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaabaaaaaaegacbaaa
aaaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaaaaaaaaaa
agiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaaaaaaaaaa
diaaaaaipccabaaaacaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 worldSpaceVertex_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_1 = tmpvar_2;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (worldSpaceVertex_1 - _WorldSpaceCameraPos);
  xlv_TEXCOORD1 = ((worldSpaceVertex_1.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _BumpMap;
void main ()
{
  mediump vec4 baseColor_1;
  highp float nh_2;
  mediump vec3 h_3;
  mediump vec3 viewVector_4;
  mediump vec3 worldNormal_5;
  mediump vec4 coords_6;
  coords_6 = xlv_TEXCOORD1;
  mediump float bumpStrength_7;
  bumpStrength_7 = _DistortParams.x;
  mediump vec4 bump_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = (texture2D (_BumpMap, coords_6.xy) + texture2D (_BumpMap, coords_6.zw));
  bump_8 = tmpvar_9;
  bump_8.xy = (bump_8.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize((vec3(0.0, 1.0, 0.0) + ((bump_8.xxy * bumpStrength_7) * vec3(1.0, 0.0, 1.0))));
  worldNormal_5.y = tmpvar_10.y;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize(xlv_TEXCOORD0);
  viewVector_4 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize((_WorldLightDir.xyz + viewVector_4));
  h_3 = tmpvar_12;
  mediump float tmpvar_13;
  tmpvar_13 = max (0.0, dot (tmpvar_10, -(h_3)));
  nh_2 = tmpvar_13;
  highp vec2 tmpvar_14;
  tmpvar_14 = (tmpvar_10.xz * _FresnelScale);
  worldNormal_5.xz = tmpvar_14;
  mediump float bias_15;
  bias_15 = _DistortParams.w;
  mediump float power_16;
  power_16 = _DistortParams.z;
  mediump float tmpvar_17;
  tmpvar_17 = clamp ((bias_15 + ((1.0 - bias_15) * pow (clamp ((1.0 - max (dot (-(viewVector_4), worldNormal_5), 0.0)), 0.0, 1.0), power_16))), 0.0, 1.0);
  baseColor_1 = _BaseColor;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((tmpvar_17 * 2.0), 0.0, 1.0);
  highp vec4 tmpvar_19;
  tmpvar_19 = mix (baseColor_1, _ReflectionColor, vec4(tmpvar_18));
  baseColor_1.xyz = tmpvar_19.xyz;
  baseColor_1.w = clamp (((2.0 * tmpvar_17) + 0.5), 0.0, 1.0);
  highp vec3 tmpvar_20;
  tmpvar_20 = (baseColor_1.xyz + (max (0.0, pow (nh_2, _Shininess)) * _SpecularColor.xyz));
  baseColor_1.xyz = tmpvar_20;
  gl_FragData[0] = baseColor_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 _BumpDirection;
uniform highp vec4 _BumpTiling;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec3 worldSpaceVertex_1;
  highp vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex_1 = tmpvar_2;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (worldSpaceVertex_1 - _WorldSpaceCameraPos);
  xlv_TEXCOORD1 = ((worldSpaceVertex_1.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform highp vec4 _WorldLightDir;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _BaseColor;
uniform highp vec4 _SpecularColor;
uniform sampler2D _BumpMap;
void main ()
{
  mediump vec4 baseColor_1;
  highp float nh_2;
  mediump vec3 h_3;
  mediump vec3 viewVector_4;
  mediump vec3 worldNormal_5;
  mediump vec4 coords_6;
  coords_6 = xlv_TEXCOORD1;
  mediump float bumpStrength_7;
  bumpStrength_7 = _DistortParams.x;
  mediump vec4 bump_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = (texture2D (_BumpMap, coords_6.xy) + texture2D (_BumpMap, coords_6.zw));
  bump_8 = tmpvar_9;
  bump_8.xy = (bump_8.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize((vec3(0.0, 1.0, 0.0) + ((bump_8.xxy * bumpStrength_7) * vec3(1.0, 0.0, 1.0))));
  worldNormal_5.y = tmpvar_10.y;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize(xlv_TEXCOORD0);
  viewVector_4 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize((_WorldLightDir.xyz + viewVector_4));
  h_3 = tmpvar_12;
  mediump float tmpvar_13;
  tmpvar_13 = max (0.0, dot (tmpvar_10, -(h_3)));
  nh_2 = tmpvar_13;
  highp vec2 tmpvar_14;
  tmpvar_14 = (tmpvar_10.xz * _FresnelScale);
  worldNormal_5.xz = tmpvar_14;
  mediump float bias_15;
  bias_15 = _DistortParams.w;
  mediump float power_16;
  power_16 = _DistortParams.z;
  mediump float tmpvar_17;
  tmpvar_17 = clamp ((bias_15 + ((1.0 - bias_15) * pow (clamp ((1.0 - max (dot (-(viewVector_4), worldNormal_5), 0.0)), 0.0, 1.0), power_16))), 0.0, 1.0);
  baseColor_1 = _BaseColor;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((tmpvar_17 * 2.0), 0.0, 1.0);
  highp vec4 tmpvar_19;
  tmpvar_19 = mix (baseColor_1, _ReflectionColor, vec4(tmpvar_18));
  baseColor_1.xyz = tmpvar_19.xyz;
  baseColor_1.w = clamp (((2.0 * tmpvar_17) + 0.5), 0.0, 1.0);
  highp vec3 tmpvar_20;
  tmpvar_20 = (baseColor_1.xyz + (max (0.0, pow (nh_2, _Shininess)) * _SpecularColor.xyz));
  baseColor_1.xyz = tmpvar_20;
  gl_FragData[0] = baseColor_1;
}



#endif"
}

SubProgram "flash " {
Keywords { }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 10 [_BumpTiling]
Vector 11 [_BumpDirection]
"agal_vs
[bc]
aaaaaaaaaaaaacacaiaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c8.x
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
adaaaaaaabaaapacalaaaaoeabaaaaaaaaaaaaffacaaaaaa mul r1, c11, r0.y
abaaaaaaabaaapacabaaaaoeacaaaaaaaaaaaaiiacaaaaaa add r1, r1, r0.xzxz
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
adaaaaaaabaaapaeabaaaaoeacaaaaaaakaaaaoeabaaaaaa mul v1, r1, c10
acaaaaaaaaaaahaeaaaaaakeacaaaaaaajaaaaoeabaaaaaa sub v0.xyz, r0.xyzz, c9
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { }
Bind "vertex" Vertex
Bind "color" Color
ConstBuffer "$Globals" 304 // 208 used size, 19 vars
Vector 176 [_BumpTiling] 4
Vector 192 [_BumpDirection] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 0 [_Time] 4
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 12 instructions, 1 temp regs, 0 temp arrays:
// ALU 11 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedioabhedglngefckigfpliikcjemhdnnnabaaaaaaaaafaaaaaeaaaaaa
daaaaaaakiabaaaamiadaaaajaaeaaaaebgpgodjhaabaaaahaabaaaaaaacpopp
amabaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaalaa
acaaabaaaaaaaaaaabaaaaaaabaaadaaaaaaaaaaabaaaeaaabaaaeaaaaaaaaaa
acaaaaaaaeaaafaaaaaaaaaaacaaamaaaeaaajaaaaaaaaaaaaaaaaaaaaacpopp
bpaaaaacafaaaaiaaaaaapjaafaaaaadaaaaahiaaaaaffjaakaaoekaaeaaaaae
aaaaahiaajaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiaalaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaahiaamaaoekaaaaappjaaaaaoeiaabaaaaacabaaabia
adaaaakaaeaaaaaeabaaapiaabaaaaiaacaaoekaaaaaiiiaacaaaaadaaaaahoa
aaaaoeiaaeaaoekbafaaaaadabaaapoaabaaoeiaabaaoekaafaaaaadaaaaapia
aaaaffjaagaaoekaaeaaaaaeaaaaapiaafaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaapiaahaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaiaaoekaaaaappja
aaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaamma
aaaaoeiappppaaaafdeieefcbiacaaaaeaaaabaaigaaaaaafjaaaaaeegiocaaa
aaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaa
acaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagiaaaaac
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaabaaaaaa
egacbaaaaaaaaaaaegiccaiaebaaaaaaabaaaaaaaeaaaaaadcaaaaalpcaabaaa
aaaaaaaaagiacaaaabaaaaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaigaibaaa
aaaaaaaadiaaaaaipccabaaaacaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaa
alaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaa
laaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
afaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaa
feeffiedepepfceeaaedepemepfcaaklepfdeheogiaaaaaaadaaaaaaaiaaaaaa
faaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaahaiaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaa
acaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 480
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 490
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 499
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 351
#line 374
#line 391
#line 403
#line 448
#line 469
#line 506
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 510
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 514
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 518
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 522
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 526
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 546
#line 570
#line 607
#line 607
v2f_simple vert200( in appdata_full v ) {
    v2f_simple o;
    mediump vec3 worldSpaceVertex = (_Object2World * v.vertex).xyz;
    #line 611
    mediump vec2 tileableUv = worldSpaceVertex.xz;
    o.bumpCoords.xyzw = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection.xyzw)) * _BumpTiling.xyzw);
    o.viewInterpolator.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 615
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
void main() {
    v2f_simple xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert200( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.viewInterpolator);
    xlv_TEXCOORD1 = vec4(xl_retval.bumpCoords);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 480
struct v2f {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
    highp vec4 grabPassPos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 490
struct v2f_noGrab {
    highp vec4 pos;
    highp vec4 normalInterpolator;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
    highp vec4 screenPos;
};
#line 499
struct v2f_simple {
    highp vec4 pos;
    highp vec3 viewInterpolator;
    highp vec4 bumpCoords;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform mediump float _GerstnerIntensity;
#line 323
#line 331
#line 335
#line 339
#line 351
#line 374
#line 391
#line 403
#line 448
#line 469
#line 506
uniform sampler2D _BumpMap;
uniform sampler2D _ReflectionTex;
uniform sampler2D _RefractionTex;
uniform sampler2D _ShoreTex;
#line 510
uniform sampler2D _CameraDepthTexture;
uniform highp vec4 _RefrColorDepth;
uniform highp vec4 _SpecularColor;
uniform highp vec4 _BaseColor;
#line 514
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _Shininess;
uniform highp vec4 _WorldLightDir;
#line 518
uniform highp vec4 _DistortParams;
uniform highp float _FresnelScale;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
#line 522
uniform highp vec4 _GAmplitude;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
#line 526
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GDirectionCD;
#line 546
#line 570
#line 607
#line 385
mediump float Fresnel( in mediump vec3 viewVector, in mediump vec3 worldNormal, in mediump float bias, in mediump float power ) {
    #line 387
    mediump float facing = clamp( (1.0 - max( dot( (-viewVector), worldNormal), 0.0)), 0.0, 1.0);
    mediump float refl2Refr = xll_saturate_f((bias + ((1.0 - bias) * pow( facing, power))));
    return refl2Refr;
}
#line 316
mediump vec3 PerPixelNormal( in sampler2D bumpMap, in mediump vec4 coords, in mediump vec3 vertexNormal, in mediump float bumpStrength ) {
    mediump vec4 bump = (texture( bumpMap, coords.xy) + texture( bumpMap, coords.zw));
    #line 319
    bump.xy = (bump.wy - vec2( 1.0, 1.0));
    mediump vec3 worldNormal = (vertexNormal + ((bump.xxy * bumpStrength) * vec3( 1.0, 0.0, 1.0)));
    return normalize(worldNormal);
}
#line 617
mediump vec4 frag200( in v2f_simple i ) {
    #line 619
    mediump vec3 worldNormal = PerPixelNormal( _BumpMap, i.bumpCoords, vec3( 0.0, 1.0, 0.0), _DistortParams.x);
    mediump vec3 viewVector = normalize(i.viewInterpolator.xyz);
    mediump vec3 reflectVector = normalize(reflect( viewVector, worldNormal));
    mediump vec3 h = normalize((_WorldLightDir.xyz + viewVector.xyz));
    #line 623
    highp float nh = max( 0.0, dot( worldNormal, (-h)));
    highp float spec = max( 0.0, pow( nh, _Shininess));
    worldNormal.xz *= _FresnelScale;
    mediump float refl2Refr = Fresnel( viewVector, worldNormal, _DistortParams.w, _DistortParams.z);
    #line 627
    mediump vec4 baseColor = _BaseColor;
    baseColor = mix( baseColor, _ReflectionColor, vec4( xll_saturate_f((refl2Refr * 2.0))));
    baseColor.w = xll_saturate_f(((2.0 * refl2Refr) + 0.5));
    baseColor.xyz += (spec * _SpecularColor.xyz);
    #line 631
    return baseColor;
}
in highp vec3 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
void main() {
    mediump vec4 xl_retval;
    v2f_simple xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.viewInterpolator = vec3(xlv_TEXCOORD0);
    xlt_i.bumpCoords = vec4(xlv_TEXCOORD1);
    xl_retval = frag200( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 35 to 35, TEX: 2 to 2
//   d3d9 - ALU: 51 to 51, TEX: 2 to 2
//   d3d11 - ALU: 36 to 36, TEX: 2 to 2, FLOW: 1 to 1
//   d3d11_9x - ALU: 36 to 36, TEX: 2 to 2, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 35 ALU, 2 TEX
PARAM c[8] = { program.local[0..6],
		{ 1, 0, 2, 0.5 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1.yw, fragment.texcoord[1].zwzw, texture[0], 2D;
TEX R0.yw, fragment.texcoord[1], texture[0], 2D;
ADD R0.zw, R0.xyyw, R1.xyyw;
ADD R1.xy, R0.wzzw, -c[7].x;
DP3 R0.x, fragment.texcoord[0], fragment.texcoord[0];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[0];
ADD R2.xyz, R0, c[4];
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R1.xy, R1, c[5].x;
MAD R1.xyz, R1.xxyw, c[7].xyxw, c[7].yxyw;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R1;
MUL R2.xyz, R1.w, R2;
DP3 R0.w, R1, -R2;
MUL R1.xz, R1, c[6].x;
DP3 R0.x, -R0, R1;
MAX R0.w, R0, c[7].y;
POW R0.y, R0.w, c[3].x;
MAX R0.x, R0, c[7].y;
ADD_SAT R0.w, -R0.x, c[7].x;
POW R1.w, R0.w, c[5].z;
MAX R0.y, R0, c[7];
MOV R0.w, c[7].x;
MOV R1.xyz, c[1];
ADD R0.w, R0, -c[5];
MAD_SAT R0.w, R0, R1, c[5];
MUL R0.xyz, R0.y, c[0];
ADD R1.xyz, -R1, c[2];
MUL_SAT R1.w, R0, c[7].z;
MAD R1.xyz, R1.w, R1, c[1];
ADD result.color.xyz, R1, R0;
MAD_SAT result.color.w, R0, c[7].z, c[7];
END
# 35 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
"ps_2_0
; 51 ALU, 2 TEX
dcl_2d s0
def c7, 1.00000000, 0.00000000, -1.00000000, 2.00000000
def c8, 2.00000000, 0.50000000, 0, 0
dcl t0.xyz
dcl t1
texld r1, t1, s0
mov r0.y, t1.w
mov r0.x, t1.z
mov r1.xz, c7.x
texld r0, r0, s0
add r0.yw, r1, r0
mov r0.x, r0.w
add_pp r0.xy, r0, c7.z
mov_pp r0.z, r0.y
mul_pp r0.xz, r0, c5.x
mov_pp r2.xy, r0.x
mov_pp r2.z, r0
mov r0.xz, c7.y
mov r0.y, c7.x
mov r1.y, c7
mad_pp r1.xyz, r2, r1, r0
dp3_pp r0.x, r1, r1
rsq_pp r0.x, r0.x
mul_pp r2.xyz, r0.x, r1
dp3 r0.x, t0, t0
rsq r0.x, r0.x
mul r3.xyz, r0.x, t0
mul_pp r1.xz, r2, c6.x
mov_pp r1.y, r2
dp3_pp r0.x, -r3, r1
add r4.xyz, r3, c4
max_pp r0.x, r0, c7.y
add_pp_sat r0.x, -r0, c7
pow_pp r3.x, r0.x, c5.z
dp3 r1.x, r4, r4
rsq r0.x, r1.x
mul r1.xyz, r0.x, r4
dp3_pp r1.x, r2, -r1
mov_pp r0.w, c5
add_pp r2.x, c7, -r0.w
mov_pp r0.x, r3.x
mad_pp_sat r0.x, r2, r0, c5.w
max_pp r1.x, r1, c7.y
pow r2.w, r1.x, c3.x
mad_pp_sat r0.w, r0.x, c8.x, c8.y
mov r1.x, r2.w
mov_pp r2.xyz, c2
max r1.x, r1, c7.y
mul_pp_sat r0.x, r0, c7.w
add_pp r2.xyz, -c1, r2
mul r1.xyz, r1.x, c0
mad_pp r0.xyz, r0.x, r2, c1
add_pp r0.xyz, r0, r1
mov_pp oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { }
Vector 1 [_BaseColor]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 0 [_SpecularColor]
Vector 4 [_WorldLightDir]
SetTexture 0 [_BumpMap] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 40.00 (30 instructions), vertex: 0, texture: 8,
//   sequencer: 14, interpolator: 8;    4 GPRs, 48 threads,
// Performance (if enough threads): ~40 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabomaaaaabpmaaaaaaaaaaaaaaceaaaaabjmaaaaabmeaaaaaaaa
aaaaaaaaaaaaabheaaaaaabmaaaaabgfppppadaaaaaaaaaiaaaaaabmaaaaaaaa
aaaaabfoaaaaaalmaaacaaabaaabaaaaaaaaaamiaaaaaaaaaaaaaaniaaadaaaa
aaabaaaaaaaaaaoeaaaaaaaaaaaaaapeaaacaaafaaabaaaaaaaaaamiaaaaaaaa
aaaaabadaaacaaagaaabaaaaaaaaabbeaaaaaaaaaaaaabceaaacaaacaaabaaaa
aaaaaamiaaaaaaaaaaaaabdfaaacaaadaaabaaaaaaaaabbeaaaaaaaaaaaaabea
aaacaaaaaaabaaaaaaaaaamiaaaaaaaaaaaaabepaaacaaaeaaabaaaaaaaaaami
aaaaaaaafpecgbhdgfedgpgmgphcaaklaaabaaadaaabaaaeaaabaaaaaaaaaaaa
fpechfgnhaengbhaaaklklklaaaeaaamaaabaaabaaabaaaaaaaaaaaafpeegjhd
hegphchefagbhcgbgnhdaafpeghcgfhdgogfgmfdgdgbgmgfaaklklklaaaaaaad
aaabaaabaaabaaaaaaaaaaaafpfcgfgggmgfgdhegjgpgoedgpgmgphcaafpfdgi
gjgogjgogfhdhdaafpfdhagfgdhfgmgbhcedgpgmgphcaafpfhgphcgmgeemgjgh
giheeegjhcaahahdfpddfpdaaadccodacodcdadddfddcodaaaklklklaaaaaaaa
aaaaaaabaaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaeaaaaaablmbaaaadaaaaaaaaaeaaaaaaaaaaaabmecaaadaaad
aaaaaaabaaaahafaaaaapbfbaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadpaaaaaa
aaaaaaaadpiaaaaalpiaaaaaaaafcaaeaaaabcaameaaaaaaaaaagaaggaambcaa
bcaaaaaaaaaagabcgabibcaabcaaaaaaaaaagaboaaaaccaaaaaaaaaabaaicacb
bpbpppnjaaaaeaaadiaibacbbpbppompaaaaeaaamiaiaaaaaaloloaapaaaaaaa
fiibaaabaagmlbbloaacabiamiahaaaaaablmaaaobaaaaaamiagaaabaammblaa
kaabppaamiabaaabaamglbaaoaabacaamiadaaabaalagmaakbabafaamiaiaaaa
aagngnmgnbababppfiehabacaamamablkaaaaeiamiadaaadaalamgaaobababaa
miadaaabaalagmaakbadagaamiabaaaaaelomnaapaaaabaamiabaaaaaagmlbaa
kcaappaalkcaaaaaaaaaaamamcaaaappeacbaaaaaalololbpaacacaafibcaaaa
aalbmggmkbaaafiadiciaaacaeblmglbcaafppaamiapaaacaajehmaaobacaaaa
beboaaaaacpmpmmgcaacabaclcedacacaclalaaambadacafacbiaaacaeblmgmg
obacabacmiahaaabaagmbfmamlaaaaabmiadaaaaaamemhaaoaacacaalciaiaaa
aaaaaaebmcaaaappmiabaaaaaagmlbaaoaaaacaamiabaaaaaagmlbaakcaappaa
eacaaaaaaaaaaagmocaaaaiakibaaaaaaaaaaaebmcaaaaaddibaaaaaaaaaaagm
ocaaaaaamiabaaaaaagmlbaakcaappaamiahiaaaaagmmamaklaaaaabaaaaaaaa
aaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
"sce_fp_rsx // 52 instructions using 3 registers
[Configuration]
24
ffffffff0000c0200003fffc000000000000840003000000
[Offsets]
7
_SpecularColor 1 0
00000310
_BaseColor 2 0
0000025000000020
_ReflectionColor 1 0
00000270
_Shininess 1 0
000002a0
_WorldLightDir 1 0
00000150
_DistortParams 4 0
00000220000001d00000019000000070
_FresnelScale 1 0
000000e0
[Microcode]
832
b4001700c8011c9dc8000001c8003fe10e040100c8021c9dc8000001c8000001
00000000000000000000000000000000b40217005c011c9dc8000001c8003fe1
18800300ba001c9dba040001c800000182020500c8011c9dc8010001c800bfe1
0a8604405f001c9d000200000002000200000000000000000000000000000000
0e800340c90c1c9d08020000c80000010000000000003f800000000000000000
0e803940c9001c9dc8000029c800000104820140c9001c9dc8000001c8000001
8e023b00c8011c9dc8040001c800bfe10a820200c9001c9d00020000c8000001
0000000000000000000000000000000010800540c8041c9fc9040001c8000001
10040900c9001c9d00020000c800000100000000000000000000000000000000
10868300c8081c9fc8020001c800000100000000000000000000000000003f80
0e020300c8041c9dc8020001c800000100000000000000000000000000000000
08860540c9001c9fc8040001c800000102801d00ff0c1c9dc8000001c8000001
1080020001001c9c54020001c800000100000000000000000000000000000000
08000500c8041c9dc8040001c800000102801c40ff001c9dc8000001c8000001
1084044001001c9cc80200030100000000000000000000000000000000000000
02863b00550c1c9d54000001c800000110040900010c1c9c00020000c8000001
0000000000000000000000000000000002848340ff081c9dfe020001c8000001
000000000000000000000000000000001082814001081c9cc8001001c8000001
0e000100c8021c9dc8000001c800000100000000000000000000000000000000
0e000400c8021c9dff040001c800000100000000000000000000000000000000
10041d00fe081c9dc8000001c800000110020200c8081c9d00020000c8000001
000000000000000000000000000000000e000400ff041c9dc8080003c8000001
10001c00fe041c9dc8000001c800000102040900fe001c9d00020000c8000001
000000000000000000000000000000001082014001081c9cc8001001c8000001
0e80040000081c9cc8020001c800000100000000000000000000000000000000
10818340c9041c9dc8020001c800000100000000000000000000000000003f00
"
}

SubProgram "d3d11 " {
Keywords { }
ConstBuffer "$Globals" 304 // 164 used size, 19 vars
Vector 48 [_SpecularColor] 4
Vector 64 [_BaseColor] 4
Vector 80 [_ReflectionColor] 4
Float 112 [_Shininess]
Vector 128 [_WorldLightDir] 4
Vector 144 [_DistortParams] 4
Float 160 [_FresnelScale]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 0
// 40 instructions, 4 temp regs, 0 temp arrays:
// ALU 36 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedocjgjknbbkofadmlpdelhmjnmlnempokabaaaaaaoeafaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcamafaaaaeaaaaaaaedabaaaa
fjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadpcbabaaa
acaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaacaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
aaaaaaahhcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialp
aaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaa
ajaaaaaadcaaaaaphcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaaaaaaaaaiadpaaaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaadiaaaaaifcaabaaaabaaaaaaagacbaaaaaaaaaaa
agiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaabaaaaaabkaabaaaaaaaaaaa
baaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
aaaaaaaaegbcbaaaabaaaaaadcaaaaakhcaabaaaadaaaaaaegbcbaaaabaaaaaa
pgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaaiicaabaaaaaaaaaaa
egacbaiaebaaaaaaacaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaia
ebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaaajaaaaaa
bjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaa
dkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadpdccaaaakicaabaaa
aaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaajaaaaaa
aaaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaaj
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaeaabeaaaaaaaaaaadp
ddaaaaahiccabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpddaaaaah
icaabaaaaaaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaiadpaaaaaaakhcaabaaa
abaaaaaaegiccaiaebaaaaaaaaaaaaaaaeaaaaaaegiccaaaaaaaaaaaafaaaaaa
dcaaaaakhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaa
ahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakhccabaaa
aaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "flash " {
Keywords { }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
"agal_ps
c7 1.0 0.0 -1.0 2.0
c8 2.0 0.5 0.0 0.0
[bc]
ciaaaaaaabaaapacabaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v1, s0 <2d wrap linear point>
aaaaaaaaaaaaacacabaaaappaeaaaaaaaaaaaaaaaaaaaaaa mov r0.y, v1.w
aaaaaaaaaaaaabacabaaaakkaeaaaaaaaaaaaaaaaaaaaaaa mov r0.x, v1.z
aaaaaaaaabaaafacahaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.xz, c7.x
ciaaaaaaaaaaapacaaaaaafeacaaaaaaaaaaaaaaafaababb tex r0, r0.xyyy, s0 <2d wrap linear point>
abaaaaaaaaaaakacabaaaaphacaaaaaaaaaaaaphacaaaaaa add r0.yw, r1.wyww, r0.wyww
aaaaaaaaaaaaabacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r0.w
abaaaaaaaaaaadacaaaaaafeacaaaaaaahaaaakkabaaaaaa add r0.xy, r0.xyyy, c7.z
aaaaaaaaaaaaaeacaaaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r0.z, r0.y
adaaaaaaaaaaafacaaaaaakiacaaaaaaafaaaaaaabaaaaaa mul r0.xz, r0.xzzz, c5.x
aaaaaaaaacaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r2.xy, r0.x
aaaaaaaaacaaaeacaaaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r2.z, r0.z
aaaaaaaaaaaaafacahaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r0.xz, c7.y
aaaaaaaaaaaaacacahaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c7.x
aaaaaaaaabaaacacahaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.y, c7
adaaaaaaabaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r2.xyzz, r1.xyzz
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
bcaaaaaaaaaaabacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r1.xyzz, r1.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaacaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r2.xyz, r0.x, r1.xyzz
bcaaaaaaaaaaabacaaaaaaoeaeaaaaaaaaaaaaoeaeaaaaaa dp3 r0.x, v0, v0
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaadaaahacaaaaaaaaacaaaaaaaaaaaaoeaeaaaaaa mul r3.xyz, r0.x, v0
adaaaaaaabaaafacacaaaakiacaaaaaaagaaaaaaabaaaaaa mul r1.xz, r2.xzzz, c6.x
aaaaaaaaabaaacacacaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r1.y, r2.y
bfaaaaaaaeaaahacadaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r3.xyzz
bcaaaaaaaaaaabacaeaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r4.xyzz, r1.xyzz
abaaaaaaaeaaahacadaaaakeacaaaaaaaeaaaaoeabaaaaaa add r4.xyz, r3.xyzz, c4
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaffabaaaaaa max r0.x, r0.x, c7.y
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaoeabaaaaaa add r0.x, r0.x, c7
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaadaaapacaaaaaaaaacaaaaaaafaaaakkabaaaaaa pow r3, r0.x, c5.z
bcaaaaaaabaaabacaeaaaakeacaaaaaaaeaaaakeacaaaaaa dp3 r1.x, r4.xyzz, r4.xyzz
akaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r1.x
adaaaaaaabaaahacaaaaaaaaacaaaaaaaeaaaakeacaaaaaa mul r1.xyz, r0.x, r4.xyzz
bfaaaaaaaeaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r1.xyzz
bcaaaaaaabaaabacacaaaakeacaaaaaaaeaaaakeacaaaaaa dp3 r1.x, r2.xyzz, r4.xyzz
aaaaaaaaaaaaaiacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c5
acaaaaaaacaaabacahaaaaoeabaaaaaaaaaaaappacaaaaaa sub r2.x, c7, r0.w
aaaaaaaaaaaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r3.x
adaaaaaaaaaaabacacaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r0.x, r2.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaafaaaappabaaaaaa add r0.x, r0.x, c5.w
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
ahaaaaaaabaaabacabaaaaaaacaaaaaaahaaaaffabaaaaaa max r1.x, r1.x, c7.y
alaaaaaaacaaapacabaaaaaaacaaaaaaadaaaaaaabaaaaaa pow r2, r1.x, c3.x
adaaaaaaaaaaaiacaaaaaaaaacaaaaaaaiaaaaaaabaaaaaa mul r0.w, r0.x, c8.x
abaaaaaaaaaaaiacaaaaaappacaaaaaaaiaaaaffabaaaaaa add r0.w, r0.w, c8.y
bgaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa sat r0.w, r0.w
aaaaaaaaabaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r2.x
aaaaaaaaacaaahacacaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2.xyz, c2
ahaaaaaaabaaabacabaaaaaaacaaaaaaahaaaaffabaaaaaa max r1.x, r1.x, c7.y
adaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaappabaaaaaa mul r0.x, r0.x, c7.w
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
aaaaaaaaaeaaapacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r4, c1
bfaaaaaaadaaahacaeaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r3.xyz, r4.xyzz
abaaaaaaacaaahacadaaaakeacaaaaaaacaaaakeacaaaaaa add r2.xyz, r3.xyzz, r2.xyzz
adaaaaaaabaaahacabaaaaaaacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r1.x, c0
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaakeacaaaaaa mul r0.xyz, r0.x, r2.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaaoeabaaaaaa add r0.xyz, r0.xyzz, c1
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { }
ConstBuffer "$Globals" 304 // 164 used size, 19 vars
Vector 48 [_SpecularColor] 4
Vector 64 [_BaseColor] 4
Vector 80 [_ReflectionColor] 4
Float 112 [_Shininess]
Vector 128 [_WorldLightDir] 4
Vector 144 [_DistortParams] 4
Float 160 [_FresnelScale]
BindCB "$Globals" 0
SetTexture 0 [_BumpMap] 2D 0
// 40 instructions, 4 temp regs, 0 temp arrays:
// ALU 36 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecededpcpeogancdmkdpknnfcnckkjffepimabaaaaaamiaiaaaaaeaaaaaa
daaaaaaabaadaaaaceaiaaaajeaiaaaaebgpgodjniacaaaaniacaaaaaaacpppp
jiacaaaaeaaaaaaaacaaciaaaaaaeaaaaaaaeaaaabaaceaaaaaaeaaaaaaaaaaa
aaaaadaaadaaaaaaaaaaaaaaaaaaahaaaeaaadaaaaaaaaaaaaacppppfbaaaaaf
ahaaapkaaaaaialpaaaaiadpaaaaaaaaaaaaiadpfbaaaaafaiaaapkaaaaaaaea
aaaaaadpaaaaaaaaaaaaaaaafbaaaaafajaaapkaaaaaaaaaaaaaiadpaaaaaaaa
aaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaiaabaacplabpaaaaac
aaaaaajaaaaiapkaabaaaaacaaaacbiaabaakklaabaaaaacaaaacciaabaappla
ecaaaaadaaaaapiaaaaaoeiaaaaioekaecaaaaadabaaapiaabaaoelaaaaioeka
acaaaaadacaacdiaaaaappiaabaappiaacaaaaadacaaceiaaaaaffiaabaaffia
acaaaaadaaaachiaacaaoeiaahaaaakaafaaaaadaaaachiaaaaaoeiaafaaaaka
abaaaaacabaaaoiaahaaoekaaeaaaaaeaaaachiaaaaaoeiaabaabliaajaaoeka
ceaaaaacabaachiaaaaaoeiaafaaaaadaaaacfiaabaaoeiaagaaaakaabaaaaac
aaaacciaabaaffiaaiaaaaadaaaaaiiaaaaaoelaaaaaoelaahaaaaacaaaaaiia
aaaappiaafaaaaadacaachiaaaaappiaaaaaoelaaeaaaaaeadaaahiaaaaaoela
aaaappiaaeaaoekaceaaaaacaeaachiaadaaoeiaaiaaaaadaaaaciiaabaaoeia
aeaaoeibalaaaaadacaaaiiaaaaappiaahaakkkacaaaaaadaaaaaiiaacaappia
adaaaakaaiaaaaadaaaacbiaacaaoeibaaaaoeiaacaaaaadaaaacciaaaaaaaib
ahaappkafiaaaaaeaaaacbiaaaaaaaiaaaaaffiaahaappkaalaaaaadabaacbia
aaaaaaiaahaakkkacaaaaaadaaaacbiaabaaaaiaafaakkkabcaaaaaeacaadbia
aaaaaaiaabaappiaafaappkaacaaaaadaaaacbiaacaaaaiaacaaaaiaaeaaaaae
abaadiiaacaaaaiaaiaaaakaaiaaffkaabaaaaacaaaabbiaaaaaaaiaabaaaaac
acaaahiaabaaoekaacaaaaadacaaahiaacaaoeibacaaoekaaeaaaaaeaaaachia
aaaaaaiaacaaoeiaabaaoekaaeaaaaaeabaachiaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaicpiaabaaoeiappppaaaafdeieefcamafaaaaeaaaaaaaedabaaaa
fjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadpcbabaaa
acaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaacaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
aaaaaaahhcaabaaaaaaaaaaapganbaaaaaaaaaaapganbaaaabaaaaaaaaaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialp
aaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaagiacaaaaaaaaaaa
ajaaaaaadcaaaaaphcaabaaaaaaaaaaaegacbaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaaaaaaaaaiadpaaaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaadiaaaaaifcaabaaaabaaaaaaagacbaaaaaaaaaaa
agiacaaaaaaaaaaaakaaaaaadgaaaaafccaabaaaabaaaaaabkaabaaaaaaaaaaa
baaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
aaaaaaaaegbcbaaaabaaaaaadcaaaaakhcaabaaaadaaaaaaegbcbaaaabaaaaaa
pgapbaaaaaaaaaaaegiccaaaaaaaaaaaaiaaaaaabaaaaaaiicaabaaaaaaaaaaa
egacbaiaebaaaaaaacaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaadkaabaia
ebaaaaaaaaaaaaaaabeaaaaaaaaaiadpdeaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaackiacaaaaaaaaaaaajaaaaaa
bjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaajbcaabaaaabaaaaaa
dkiacaiaebaaaaaaaaaaaaaaajaaaaaaabeaaaaaaaaaiadpdccaaaakicaabaaa
aaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaajaaaaaa
aaaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaaj
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaeaabeaaaaaaaaaaadp
ddaaaaahiccabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpddaaaaah
icaabaaaaaaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaiadpaaaaaaakhcaabaaa
abaaaaaaegiccaiaebaaaaaaaaaaaaaaaeaaaaaaegiccaaaaaaaaaaaafaaaaaa
dcaaaaakhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaabaaaaaaibcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaiaebaaaaaaacaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaa
ahaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakhccabaaa
aaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaaegacbaaaabaaaaaa
doaaaaabejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
ahahaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapapaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3"
}

}

#LINE 424

	}	
}

Fallback "Transparent/Diffuse"
}
