package test

import ttf "../src"
import sdl "vendor:sdl3"
import img "vendor:sdl3/image"

import "core:c"
import "core:fmt"

main :: proc() {
	if !sdl.Init(sdl.INIT_VIDEO) {
		return
	}

	if !ttf.Init() {
		fmt.println("Error during ttf init")
		return
	}

	ver := ttf.Version()
	fmt.println("ver: ", ver)

	major, minor, patch: c.int
	ttf.GetFreeTypeVersion(&major, &minor, &patch)
	fmt.println("major: ", major, ", minor: ", minor, ", patch: ", patch)
	ttf.GetHarfBuzzVersion(&major, &minor, &patch)
	fmt.println("major: ", major, ", minor: ", minor, ", patch: ", patch)


	font := ttf.OpenFont("/home/omathot/dev/odin/ttf_bindings/Jack Sphinx.ttf", 12)
	assert(font != nil)
	gen := ttf.GetFontGeneration(font)
	fmt.println("gen: ", gen)
	fallback := ttf.OpenFont("/home/omathot/dev/odin/ttf_bindings/Jack Sphinx.ttf", 12)
	if !ttf.AddFallbackFont(font, fallback) {
		fmt.println("Failed to add fallback: ", sdl.GetError())
	}

	if !ttf.SetFontSize(font, 20) {
		fmt.println("Failed to set font size")
		return
	}
	size := ttf.GetFontSize(font)
	fmt.println("size: ", size)
	assert(20 == size)

	if !ttf.SetFontSizeDPI(font, 24, 10, 10) {
		fmt.println("failed to set font size DPI")
		return
	}
	hdpi, vdpi: c.int
	ttf.GetFontDPI(font, &hdpi, &vdpi)
	fmt.println("hdpi: ", hdpi, " vdpi: ", vdpi)

	ttf.SetFontStyle(font, {.BOLD, .ITALIC})
	styles := ttf.GetFontStyle(font)
	fmt.println("styles: ", styles)
	assert(styles == {.BOLD, .ITALIC})

	ttf.SetFontOutline(font, 5)
	outline := ttf.GetFontOutline(font)
	fmt.println("outline: ", outline)
	assert(outline == 5)

	ttf.SetFontHinting(font, .LIGHT)
	hinting := ttf.GetFontHinting(font)
	fmt.println("hinting: ", hinting)
	assert(hinting == .LIGHT)

	num_faces := ttf.GetNumFontFaces(font)
	fmt.println("num faces: ", num_faces)

	sdf := ttf.GetFontSDF(font)
	fmt.println("sdf: ", sdf)
	ttf.SetFontSDF(font, true)
	sdf = ttf.GetFontSDF(font)
	fmt.println("sdf after: ", sdf)
	assert(sdf == true)

	weight := ttf.GetFontWeight(font)
	fmt.println("weight: ", weight)

	ttf.SetFontWrapAlignment(font, .TTF_HORIZONTAL_ALIGN_CENTER)
	align := ttf.GetFontWrapAlignment(font)
	fmt.println("align: ", align)
	assert(align == .TTF_HORIZONTAL_ALIGN_CENTER)

	height := ttf.GetFontHeight(font)
	ascent := ttf.GetFontAscent(font)
	descent := ttf.GetFontDescent(font)
	fmt.println("height: ", height, " ascent: ", ascent, " descent: ", descent)

	family_name := ttf.GetFontFamilyName(font)
	style_name := ttf.GetFontStyleName(font)
	fmt.println("family name: ", family_name, " style name: ", style_name)
}

