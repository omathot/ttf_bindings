package bindings

import "core:c"
import sdl "vendor:sdl3"

when ODIN_OS == .Windows {
	foreign import lib "SDL3_image.lib"
} else {
	foreign import lib "system:SDL3_ttf"
}

Uint32 :: u32

// odinfmt: disable
TTF_Font :: struct {}

FontStyleFlags :: distinct bit_set[FontStyleFlag;Uint32]
FontStyleFlag :: enum Uint32 {
	NORMAL        = 0, /**< No special style */
	BOLD          = 1, /**< Bold style */
	ITALIC        = 2, /**< Italic style */
	UNDERLINE     = 4, /**< Underlined text */
	STRIKETHROUGH = 8, /**< Strikethrough text */
}
STYLE_NORMAL		:: FontStyleFlags{.NORMAL}
STYLE_BOLD			:: FontStyleFlags{.BOLD}
STYLE_ITALIC		:: FontStyleFlags{.ITALIC}
STYLE_UNDERLINE		:: FontStyleFlags{.UNDERLINE}
STYLE_STRIKETHROUGH	:: FontStyleFlags{.STRIKETHROUGH}

HintingFlags :: enum c.int {
	INVALID = -1,
	NORMAL,			/**< Normal hinting applies standard grid-fitting. */
	LIGHT,			/**< Light hinting applies subtle adjustments to improve rendering. */
	MONO,			/**< Monochrome hinting adjusts the font for better rendering at lower resolutions. */
	NONE,			/**< No hinting, the font is rendered without any grid-fitting. */
	LIGHT_SUBPIXEL, /**< Light hinting with subpixel rendering for more precise font edges. */
}

HorizontalAlignment :: enum c.int {
	TTF_HORIZONTAL_ALIGN_INVALID = -1,
	TTF_HORIZONTAL_ALIGN_LEFT,
	TTF_HORIZONTAL_ALIGN_CENTER,
	TTF_HORIZONTAL_ALIGN_RIGHT,
}

Direction :: enum c.int {
	TTF_DIRECTION_INVALID = 0,
	TTF_DIRECTION_LTR = 4,	/**< Left to Right */
	TTF_DIRECTION_RTL,		/**< Right to Left */
	TTF_DIRECTION_TTB,		/**< Top to Bottom */
	TTF_DIRECTION_BTT,		/**< Bottom to Top */
}

ImageType :: enum c.int {
	TTF_IMAGE_INVALID,
	TTF_IMAGE_ALPHA,	/**< The color channels are white */
	TTF_IMAGE_COLOR,	/**< The color channels have image data */
	TTF_IMAGE_SDF,		/**< The alpha channel has signed distance field information */
}
// odinfmt: enable

@(default_calling_convention = "c", link_prefix = "TTF_")
foreign lib {
	Version :: proc() -> c.int ---
	GetFreeTypeVersion :: proc(major, minor, patch: ^c.int) ---
	GetHarfBuzzVersion :: proc(major, minor, patch: ^c.int) ---

	Init :: proc() -> bool ---

	OpenFont :: proc(file: cstring, ptsize: f32) -> ^TTF_Font ---
	OpenFontIO :: proc(src: ^sdl.IOStream, closeio: bool, ptsize: f32) -> ^TTF_Font ---
	OpenFontWithProperties :: proc(props: sdl.PropertiesID) -> ^TTF_Font ---
	CopyFont :: proc(existing_font: ^TTF_Font) -> TTF_Font ---
	GetFontProperties :: proc(font: ^TTF_Font) -> sdl.PropertiesID ---
	GetFontGeneration :: proc(font: ^TTF_Font) -> u32 ---

	AddFallbackFont :: proc(font: ^TTF_Font, fallback: ^TTF_Font) -> bool ---
	RemoveFallbackFont :: proc(font: ^TTF_Font, fallback: ^TTF_Font) ---
	ClearFallbackFonts :: proc(font: ^TTF_Font) ---

	SetFontSize :: proc(font: ^TTF_Font, ptsize: f32) -> bool ---
	SetFontSizeDPI :: proc(font: ^TTF_Font, ptsize: f32, hdpi: c.int, vdpi: c.int) -> bool ---
	GetFontSize :: proc(font: ^TTF_Font) -> f32 ---
	GetFontDPI :: proc(font: ^TTF_Font, hdpi: ^c.int, vdpi: ^c.int) -> bool ---
	SetFontStyle :: proc(font: ^TTF_Font, style: FontStyleFlags) ---
	GetFontStyle :: proc(font: ^TTF_Font) -> FontStyleFlags ---
	SetFontOutline :: proc(font: ^TTF_Font, outline: c.int) -> bool ---
	GetFontOutline :: proc(font: ^TTF_Font) -> c.int ---
	SetFontHinting :: proc(font: ^TTF_Font, hinting: HintingFlags) ---
	GetNumFontFaces :: proc(font: ^TTF_Font) -> c.int ---
	GetFontHinting :: proc(font: ^TTF_Font) -> HintingFlags ---
	SetFontSDF :: proc(font: ^TTF_Font, enabled: bool) -> bool ---
	GetFontSDF :: proc(font: ^TTF_Font) -> bool ---
	GetFontWeight :: proc(font: ^TTF_Font) -> c.int ---
	SetFontWrapAlignment :: proc(font: ^TTF_Font, align: HorizontalAlignment) ---
	GetFontWrapAlignment :: proc(font: ^TTF_Font) -> HorizontalAlignment ---
	GetFontHeight :: proc(font: ^TTF_Font) -> c.int ---
	GetFontAscent :: proc(font: ^TTF_Font) -> c.int ---
	GetFontDescent :: proc(font: ^TTF_Font) -> c.int ---
	SetFontLineSkip :: proc(font: ^TTF_Font, lineskip: c.int) ---
	GetFontLineSkip :: proc(font: ^TTF_Font) -> c.int ---
	SetFontKerning :: proc(font: ^TTF_Font, enabled: bool) ---
	GetFontKerning :: proc(font: ^TTF_Font) -> bool ---
	FontIsFixedWidth :: proc(font: ^TTF_Font) -> bool ---
	FontIsScalable :: proc(font: ^TTF_Font) -> bool ---
	GetFontFamilyName :: proc(font: ^TTF_Font) -> cstring ---
	GetFontStyleName :: proc(font: ^TTF_Font) -> cstring ---
	SetFontDirection :: proc(font: ^TTF_Font, direction: Direction) -> bool ---
	GetFontDirection :: proc(font: ^TTF_Font) -> Direction ---
	StringToTag :: proc(str: cstring) -> Uint32 ---
	TagToString :: proc(tag: Uint32, str: [^]byte, size: c.size_t) ---
	SetFontScript :: proc(font: ^TTF_Font, script: Uint32) -> bool ---
	GetFontScript :: proc(font: ^TTF_Font) -> Uint32 ---
	GetGlyphScript :: proc(ch: Uint32) -> Uint32 ---
	SetFontLanguage :: proc(font: ^TTF_Font, language_bcp47: [^]byte) -> bool ---
	FontHasGlyph :: proc(font: ^TTF_Font, ch: Uint32) -> bool ---
	GetGlyphImage :: proc(font: ^TTF_Font, ch: Uint32, image_type: ^ImageType) -> ^sdl.Surface ---
	GetGlyphImageForIndex :: proc(font: ^TTF_Font, glyph_index: Uint32, image_type: ^ImageType) -> ^sdl.Surface ---
	GetGlyphMetrics :: proc(font: ^TTF_Font, ch: Uint32, minxx, maxx, miny, maxy, advance: ^c.int) -> bool ---
	GetGlyphKerning :: proc(font: ^TTF_Font, previous_ch: Uint32, ch: Uint32, kerning: ^c.int) -> bool ---
	GetStringSize :: proc(font: ^TTF_Font, text: [^]byte, length: c.size_t, w, h: ^c.int) -> bool ---
	GetStringSizeWrapped :: proc(font: ^TTF_Font, text: [^]byte, length: c.size_t, wrap_width: c.int, w, h: ^c.int) -> bool ---
	MeasureString :: proc(font: ^TTF_Font, text: [^]byte, length: c.size_t, max_width: c.int, measured_width: ^c.int, measured_length: ^c.size_t) -> bool ---
	RenderText_Solid :: proc(font: ^TTF_Font, text: [^]byte, length: c.size_t, fg: sdl.Color) -> ^sdl.Surface ---
	RenderText_Solid_Wrapped :: proc(font: ^TTF_Font, text: [^]byte, length: c.size_t, fg: sdl.Color, wrapLength: c.int) -> ^sdl.Surface ---
	RenderGlyph_Solid :: proc(font: ^TTF_Font, ch: Uint32, fg: sdl.Color) -> ^sdl.Surface ---
	RenderText_Shaded :: proc(font: ^TTF_Font, text: [^]byte, length: c.size_t, fg, bg: sdl.Color) -> ^sdl.Surface ---
	RenderText_Shaded_Wrapped :: proc(font: ^TTF_Font, text: [^]byte, length: c.size_t, fg, bg: sdl.Color, wrap_width: c.int) -> ^sdl.Surface ---
	RenderGlyph_Shaded :: proc(font: ^TTF_Font, ch: Uint32, fg, bg: sdl.Color) -> ^sdl.Surface ---
	RenderText_Blended :: proc(font: ^TTF_Font, text: [^]byte, length: c.size_t, fg: sdl.Color) -> ^sdl.Surface ---
	RenderText_Blended_Wrapped :: proc(font: ^TTF_Font, text: [^]byte, length: c.size_t, fg: sdl.Color, wrap_width: c.int) -> ^sdl.Surface ---
}


// 


// odinfmt: disable
// odin helpers cause [^]byte sucks to work with
// 

render_text_solid :: proc(font: ^TTF_Font, text: string, length: c.size_t, fg: sdl.Color) -> ^sdl.Surface {
	return RenderText_Solid(font, raw_data(transmute([]byte)text), length, fg)
}
render_text_solid_wrapped :: proc(font: ^TTF_Font, text: string, length: c.size_t, fg: sdl.Color, wrap_length: c.int) -> ^sdl.Surface {
	return RenderText_Solid_Wrapped(font, raw_data(transmute([]byte)text), length, fg, wrap_length)
}
render_text_shaded :: proc(font: ^TTF_Font, text: string, length: c.size_t, fg, bg: sdl.Color) -> ^sdl.Surface {
	return RenderText_Shaded(font, raw_data(transmute([]byte)text), length, fg, bg)
}
render_text_shaded_wrapped :: proc(font: ^TTF_Font, text: string, length: c.size_t, fg, bg: sdl.Color, wrap_width: c.int) -> ^sdl.Surface {
	return RenderText_Shaded_Wrapped(font, raw_data(transmute([]byte)text), length, fg, bg, wrap_width)
}
render_text_blended :: proc(font: ^TTF_Font, text: string, length: c.size_t, fg: sdl.Color) -> ^sdl.Surface {
	return RenderText_Blended(font, raw_data(transmute([]byte)text), length, fg)
}
render_text_blended_wrapped :: proc(font: ^TTF_Font, text: string, length: c.size_t, fg: sdl.Color, wrap_width: c.int) -> ^sdl.Surface {
	return RenderText_Blended_Wrapped(font, raw_data(transmute([]byte)text), length, fg, wrap_width)
}


// odinfmt: enable

