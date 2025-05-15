package bindings

import "core:c"
import sdl "vendor:sdl3"

when ODIN_OS == .Windows {
	foreign import lib "SDL3_image.lib"
} else {
	foreign import lib "system:SDL3_ttf"
}

Uint32 :: u32
Uint8 :: u8


// odinfmt: disable
Font :: struct {}

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


// 
// text engine
// 
TextData :: struct{}
Text :: struct {
	text: cstring,		/**< A copy of the UTF-8 string that this text object represents, useful for layout, debugging and retrieving substring text. This is updated when the text object is modified and will be freed automatically when the object is destroyed. */
	num_lines: c.int,	/**< The number of lines in the text, 0 if it's empty */

	refcount: c.int,	/**< Application reference count, used when freeing surface */
	internal: TextData,	/**< Private */
}

EngineCreateText :: #type proc "c" (userdata: rawptr, text: ^Text)
EngineDestroyText :: #type proc "c" (userdata: rawptr, text: ^Text)
TextEngine :: struct {
	version: Uint32,	/**< The version of this interface */
	userdata: rawptr,	/**< User data pointer passed to callbacks */

	/* Create a text representation from draw instructions.
	*
	* All fields of `text` except `internal->engine_text` will already be filled out.
	*
	* This function should set the `internal->engine_text` field to a non-NULL value.
	*
	* \param userdata the userdata pointer in this interface.
	* \param text the text object being created.
	*/
	create_text: EngineCreateText,
	/**
	* Destroy a text representation.
	*/
	destroy_text: EngineDestroyText,
}

GPUAtlasDrawSequence :: struct {
	atlas_texture: ^sdl.GPUTexture,
	xy: ^sdl.FPoint,
	uv: ^sdl.FPoint,
	num_vertices: c.int,
	indices: ^c.int,
	num_indices: c.int,
	image_type: ImageType,

	next: ^GPUAtlasDrawSequence,
}

GPUTextEngineWinding :: enum c.int {
	TTF_GPU_TEXTENGINE_WINDING_INVALID = -1,
	TTF_GPU_TEXTENGINE_WINDING_CLOCKWISE,
	TTF_GPU_TEXTENGINE_WINDING_COUNTER_CLOCKWISE
}

// TODO! AT THIS POINT SUbSTRINGFLAGS
SubString :: struct {
	// TTF_SubStringFlags flags;   /**< The flags for this substring */
	offset: int,                 /**< The byte offset from the beginning of the text */
	length: int,                /**< The byte length starting at the offset */
	line_index: int,           /**< The index of the line that contains this substring */
	cluster_index: int,       /**< The internal cluster index, used for quickly iterating */
	rect: sdl.Rect,        /**< The rectangle, relative to the top left of the text, containing the substring */
}

// odinfmt: enable

@(default_calling_convention = "c", link_prefix = "TTF_")
foreign lib {
	Version :: proc() -> c.int ---
	GetFreeTypeVersion :: proc(major, minor, patch: ^c.int) ---
	GetHarfBuzzVersion :: proc(major, minor, patch: ^c.int) ---

	Init :: proc() -> bool ---

	OpenFont :: proc(file: cstring, ptsize: f32) -> ^Font ---
	OpenFontIO :: proc(src: ^sdl.IOStream, closeio: bool, ptsize: f32) -> ^Font ---
	OpenFontWithProperties :: proc(props: sdl.PropertiesID) -> ^Font ---
	CopyFont :: proc(existing_font: ^Font) -> Font ---
	GetFontProperties :: proc(font: ^Font) -> sdl.PropertiesID ---
	GetFontGeneration :: proc(font: ^Font) -> u32 ---

	AddFallbackFont :: proc(font: ^Font, fallback: ^Font) -> bool ---
	RemoveFallbackFont :: proc(font: ^Font, fallback: ^Font) ---
	ClearFallbackFonts :: proc(font: ^Font) ---

	SetFontSize :: proc(font: ^Font, ptsize: f32) -> bool ---
	SetFontSizeDPI :: proc(font: ^Font, ptsize: f32, hdpi: c.int, vdpi: c.int) -> bool ---
	GetFontSize :: proc(font: ^Font) -> f32 ---
	GetFontDPI :: proc(font: ^Font, hdpi: ^c.int, vdpi: ^c.int) -> bool ---
	SetFontStyle :: proc(font: ^Font, style: FontStyleFlags) ---
	GetFontStyle :: proc(font: ^Font) -> FontStyleFlags ---
	SetFontOutline :: proc(font: ^Font, outline: c.int) -> bool ---
	GetFontOutline :: proc(font: ^Font) -> c.int ---
	SetFontHinting :: proc(font: ^Font, hinting: HintingFlags) ---
	GetNumFontFaces :: proc(font: ^Font) -> c.int ---
	GetFontHinting :: proc(font: ^Font) -> HintingFlags ---
	SetFontSDF :: proc(font: ^Font, enabled: bool) -> bool ---
	GetFontSDF :: proc(font: ^Font) -> bool ---
	GetFontWeight :: proc(font: ^Font) -> c.int ---
	SetFontWrapAlignment :: proc(font: ^Font, align: HorizontalAlignment) ---
	GetFontWrapAlignment :: proc(font: ^Font) -> HorizontalAlignment ---
	GetFontHeight :: proc(font: ^Font) -> c.int ---
	GetFontAscent :: proc(font: ^Font) -> c.int ---
	GetFontDescent :: proc(font: ^Font) -> c.int ---
	SetFontLineSkip :: proc(font: ^Font, lineskip: c.int) ---
	GetFontLineSkip :: proc(font: ^Font) -> c.int ---
	SetFontKerning :: proc(font: ^Font, enabled: bool) ---
	GetFontKerning :: proc(font: ^Font) -> bool ---
	FontIsFixedWidth :: proc(font: ^Font) -> bool ---
	FontIsScalable :: proc(font: ^Font) -> bool ---
	GetFontFamilyName :: proc(font: ^Font) -> cstring ---
	GetFontStyleName :: proc(font: ^Font) -> cstring ---
	SetFontDirection :: proc(font: ^Font, direction: Direction) -> bool ---
	GetFontDirection :: proc(font: ^Font) -> Direction ---
	StringToTag :: proc(str: cstring) -> Uint32 ---
	TagToString :: proc(tag: Uint32, str: [^]byte, size: c.size_t) ---
	SetFontScript :: proc(font: ^Font, script: Uint32) -> bool ---
	GetFontScript :: proc(font: ^Font) -> Uint32 ---
	GetGlyphScript :: proc(ch: Uint32) -> Uint32 ---
	SetFontLanguage :: proc(font: ^Font, language_bcp47: [^]byte) -> bool ---
	FontHasGlyph :: proc(font: ^Font, ch: Uint32) -> bool ---
	GetGlyphImage :: proc(font: ^Font, ch: Uint32, image_type: ^ImageType) -> ^sdl.Surface ---
	GetGlyphImageForIndex :: proc(font: ^Font, glyph_index: Uint32, image_type: ^ImageType) -> ^sdl.Surface ---
	GetGlyphMetrics :: proc(font: ^Font, ch: Uint32, minxx, maxx, miny, maxy, advance: ^c.int) -> bool ---
	GetGlyphKerning :: proc(font: ^Font, previous_ch: Uint32, ch: Uint32, kerning: ^c.int) -> bool ---
	GetStringSize :: proc(font: ^Font, text: [^]byte, length: c.size_t, w, h: ^c.int) -> bool ---
	GetStringSizeWrapped :: proc(font: ^Font, text: [^]byte, length: c.size_t, wrap_width: c.int, w, h: ^c.int) -> bool ---
	MeasureString :: proc(font: ^Font, text: [^]byte, length: c.size_t, max_width: c.int, measured_width: ^c.int, measured_length: ^c.size_t) -> bool ---
	RenderText_Solid :: proc(font: ^Font, text: [^]byte, length: c.size_t, fg: sdl.Color) -> ^sdl.Surface ---
	RenderText_Solid_Wrapped :: proc(font: ^Font, text: [^]byte, length: c.size_t, fg: sdl.Color, wrapLength: c.int) -> ^sdl.Surface ---
	RenderGlyph_Solid :: proc(font: ^Font, ch: Uint32, fg: sdl.Color) -> ^sdl.Surface ---
	RenderText_Shaded :: proc(font: ^Font, text: [^]byte, length: c.size_t, fg, bg: sdl.Color) -> ^sdl.Surface ---
	RenderText_Shaded_Wrapped :: proc(font: ^Font, text: [^]byte, length: c.size_t, fg, bg: sdl.Color, wrap_width: c.int) -> ^sdl.Surface ---
	RenderGlyph_Shaded :: proc(font: ^Font, ch: Uint32, fg, bg: sdl.Color) -> ^sdl.Surface ---
	RenderText_Blended :: proc(font: ^Font, text: [^]byte, length: c.size_t, fg: sdl.Color) -> ^sdl.Surface ---
	RenderText_Blended_Wrapped :: proc(font: ^Font, text: [^]byte, length: c.size_t, fg: sdl.Color, wrap_width: c.int) -> ^sdl.Surface ---
	RenderGlyph_Blended :: proc(font: ^Font, ch: Uint32, fg: sdl.Color) -> ^sdl.Surface ---
	RenderText_LCD :: proc(font: ^Font, text: [^]byte, length: c.size_t, fg, bg: sdl.Color) -> ^sdl.Surface ---
	RenderText_LCD_Wrapped :: proc(font: ^Font, text: [^]byte, length: c.size_t, fg, bg: sdl.Color, wrap_width: c.int) -> ^sdl.Surface ---
	RenderGlyph_LCD :: proc(font: ^Font, ch: Uint32, fg, bg: sdl.Color) -> ^sdl.Surface ---
	CreateSurfaceTextEngine :: proc() -> ^TextEngine ---
	DrawSurfaceText :: proc(text: ^Text, x, y: c.int, surface: ^sdl.Surface) -> bool ---
	DestroySurfaceTextEngine :: proc(engine: ^TextEngine) ---
	CreateRendererTextEngine :: proc(renderer: ^sdl.Renderer) -> ^TextEngine ---
	CreateRendererTextEngineWithProperties :: proc(props: sdl.PropertiesID) -> ^TextEngine ---
	DrawRendererText :: proc(text: ^Text, y, x: f32) -> bool ---
	DestroyRendererTextEngine :: proc(engine: ^TextEngine) ---
	CreateGPUTextEngine :: proc(device: ^sdl.GPUDevice) -> ^TextEngine ---
	CreateGPUTextEngineWithProperties :: proc(props: sdl.PropertiesID) -> ^TextEngine ---
	GetGPUTextDrawData :: proc(text: ^Text) -> GPUAtlasDrawSequence ---
	DestroyGPUTextEngine :: proc(engine: ^TextEngine) ---
	SetGPUTextEngineWinding :: proc(engine: ^TextEngine, winding: GPUTextEngineWinding) ---
	GetGPUTextEngineWinding :: proc(engine: ^TextEngine) -> GPUTextEngineWinding ---
	CreateText :: proc(engine: ^TextEngine, font: ^Font, text: [^]byte, length: c.size_t) -> ^Text ---
	GetTextProperties :: proc(text: ^Text) -> sdl.PropertiesID ---
	SetTextEngine :: proc(text: ^Text, engine: ^TextEngine) -> bool ---
	GetTextEngine :: proc(text: ^Text) -> ^TextEngine ---
	SetTextFont :: proc(text: ^Text, font: ^Font) -> bool ---
	GetTextFont :: proc(text: ^Text) -> ^Font ---
	SetTextDirection :: proc(text: ^Text, direction: Direction) -> bool ---
	GetTextDirection :: proc(text: ^Text) -> Direction ---
	SetTextScript :: proc(text: ^Text, script: Uint32) -> bool ---
	GetTextScript :: proc(text: ^Text) -> Uint32 ---
	SetTextColor :: proc(text: ^Text, r, g, b, a: Uint8) -> bool ---
	SetTextColorFloat :: proc(text: ^Text, r, g, b, a: f32) -> bool ---
	GetTextColor :: proc(text: ^Text, r, g, b, a: ^Uint8) -> bool ---
	GetTextColorFloat :: proc(text: ^Text, r, g, b, a: ^f32) -> bool ---
	SetTextPosition :: proc(text: ^Text, x, y: c.int) -> bool ---
	GetTextPosition :: proc(text: ^Text, x, y: ^c.int) -> bool ---
	SetTextWrapWidth :: proc(text: ^Text, wrap_width: c.int) -> bool ---
	GetTextWrapWidth :: proc(text: ^Text, wrap_width: ^c.int) -> bool ---
	SetTextWrapWhitespaceVisible :: proc(text: ^Text, visible: bool) -> bool ---
	TextWrapWhitespaceVisible :: proc(text: ^Text) -> bool ---
	SetTextString :: proc(text: ^Text, string: [^]byte, length: c.size_t) -> bool ---
	InsertTextString :: proc(text: ^Text, offset: c.int, string: [^]byte, length: c.size_t) -> bool ---
	AppendTextString :: proc(text: ^Text, string: [^]byte, length: c.size_t) -> bool ---
	DeleteTextString :: proc(text: ^Text, offset, length: c.int) -> bool ---
	GetTextSize :: proc(text: ^Text, w, h: ^c.int) -> bool ---
	GetTextSubstring :: proc(text: ^Text, offset: c.int, substring: ^SubString) -> bool ---
}



// odinfmt: disable
// odin helpers cause [^]byte sucks to work with
// 

render_text_solid :: proc(font: ^Font, text: string, length: c.size_t, fg: sdl.Color) -> ^sdl.Surface {
	return RenderText_Solid(font, raw_data(transmute([]byte)text), length, fg)
}
render_text_solid_wrapped :: proc(font: ^Font, text: string, length: c.size_t, fg: sdl.Color, wrap_length: c.int) -> ^sdl.Surface {
	return RenderText_Solid_Wrapped(font, raw_data(transmute([]byte)text), length, fg, wrap_length)
}
render_text_shaded :: proc(font: ^Font, text: string, length: c.size_t, fg, bg: sdl.Color) -> ^sdl.Surface {
	return RenderText_Shaded(font, raw_data(transmute([]byte)text), length, fg, bg)
}
render_text_shaded_wrapped :: proc(font: ^Font, text: string, length: c.size_t, fg, bg: sdl.Color, wrap_width: c.int) -> ^sdl.Surface {
	return RenderText_Shaded_Wrapped(font, raw_data(transmute([]byte)text), length, fg, bg, wrap_width)
}
render_text_blended :: proc(font: ^Font, text: string, length: c.size_t, fg: sdl.Color) -> ^sdl.Surface {
	return RenderText_Blended(font, raw_data(transmute([]byte)text), length, fg)
}
render_text_blended_wrapped :: proc(font: ^Font, text: string, length: c.size_t, fg: sdl.Color, wrap_width: c.int) -> ^sdl.Surface {
	return RenderText_Blended_Wrapped(font, raw_data(transmute([]byte)text), length, fg, wrap_width)
}
render_text_lcd :: proc(font: ^Font, text: string, length: c.size_t, fg, bg: sdl.Color) -> ^sdl.Surface {
	return RenderText_LCD(font, raw_data(transmute([]byte)text), length, fg, bg)
}
render_text_lcd_wrapped :: proc(font: ^Font, text: string, length: c.size_t, fg, bg: sdl.Color, wrap_width: c.int) -> ^sdl.Surface {
	return RenderText_LCD_Wrapped(font, raw_data(transmute([]byte)text), length, fg, bg, wrap_width)
}
get_string_size :: proc(font: ^Font, text: string, length: c.size_t, w, h: ^c.int) -> bool {
	return GetStringSize(font, raw_data(transmute([]byte)text), length, w, h)
}
get_string_size_wrapped :: proc(font: ^Font, text: string, length: c.size_t, wrap_width: c.int, w, h: ^c.int) -> bool {
	return GetStringSizeWrapped(font, raw_data(transmute([]byte)text), length, wrap_width, w, h)
}
measure_string :: proc(font: ^Font, text: string, length: c.size_t, max_width: c.int, measured_width: ^c.int, measured_length: ^c.size_t) -> bool {
	return MeasureString(font, raw_data(transmute([]byte)text), length, max_width, measured_width, measured_length)
}
set_font_language :: proc(font: ^Font, language_bcp47: string) {
	SetFontLanguage(font, raw_data(transmute([]byte)language_bcp47))
}
create_text :: proc(engine: ^TextEngine, font: ^Font, text: string, length: c.size_t) -> ^Text {
	return CreateText(engine, font, raw_data(transmute([]byte)text), length)
}
set_text_string :: proc(text: ^Text, string: string, length: c.size_t) -> bool {
	return SetTextString(text, raw_data(transmute([]byte)string), length)
}
insert_text_string :: proc(text: ^Text, offset: c.int, string: string, length: c.size_t) -> bool {
	return InsertTextString(text, offset, raw_data(transmute([]byte)string), length)
}
append_text_string :: proc(text: ^Text, string: string, length: c.size_t) -> bool {
	return AppendTextString(text, raw_data(transmute([]byte)string), length)
}

// 
// odinfmt: enable

