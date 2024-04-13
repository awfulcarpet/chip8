// TODO: Flesh me out
use types::c;

export type SDL_Color = struct {
	r: u8,
	g: u8,
	b: u8,
	a: u8,
};

export type SDL_Palette = struct {
	ncolors: int,
	colors: *SDL_Color,
	version: u32,
	refcount: int,
};

// Note: Everything in the pixel format structure is read-only.
export type SDL_PixelFormat = struct {
	format: u32, // TODO
	palette: *SDL_Palette,
	bitsperpixel: u8,
	bytesperpixel: u8,
	padding: [2]u8,
	rmask: u32,
	gmask: u32,
	bmask: u32,
	amask: u32,
	rloss: u8,
	gloss: u8,
	bloss: u8,
	aloss: u8,
	rshift: u8,
	gshift: u8,
	bshift: u8,
	ashift: u8,
	refcount: int,
	next: nullable *SDL_PixelFormat,
};

export def SDL_PIXELFORMAT_ARGB8888: u32 = 0x16362004;

@symbol("SDL_GetPixelFormatName") fn _SDL_GetPixelFormatName(format: u32)
	const *c::char;

// Get the human readable name of a pixel format.
export fn SDL_GetPixelFormatName(format: u32) str = {
	return c::tostr(_SDL_GetPixelFormatName(format))!;
};

// Map an RGB triple to an opaque pixel value for a given pixel format.
export @symbol("SDL_MapRGB") fn SDL_MapRGB(format: *SDL_PixelFormat, r: u8, g: u8, b: u8) u32;

// Map an RGBA quadruple to a pixel value for a given pixel format.
export @symbol("SDL_MapRGBA") fn SDL_MapRGBA(format: *SDL_PixelFormat, r: u8, g: u8, b: u8, a: u8) u32;
