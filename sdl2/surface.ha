// A collection of pixels used in software blitting.
//
// This structure should be treated as read-only, except for 'pixels', which, if
// not null, contains the raw pixel data for the surface.
export type SDL_Surface = struct {
	flags: u32,
	format: *SDL_PixelFormat,
	w: int,
	h: int,
	pitch: int,
	pixels: nullable *opaque,

	userdata: *opaque,

	locked: int,
	lock_data: *opaque,

	clip_rect: SDL_Rect,

	map: *SDL_BlitMap,

	refcount: int,
};

export type SDL_BlitMap = opaque;

@symbol("SDL_CreateRGBSurface") fn _SDL_CreateRGBSurface(flags: u32,
	width: int, height: int, depth: int, Rmask: u32, Gmask: u32, Bmask: u32,
	Amask: u32) *SDL_Surface;

// Allocate a new RGB surface.
export fn SDL_CreateRGBSurface(flags: u32,
	width: int, height: int, depth: int, Rmask: u32, Gmask: u32, Bmask: u32,
	Amask: u32) (*SDL_Surface | error) = {
	return wrapptr(_SDL_CreateRGBSurface(flags, width, height, depth, Rmask,
	Gmask, Bmask, Amask))?: *SDL_Surface;
};

@symbol("SDL_FreeSurface") fn _SDL_FreeSurface(surface: nullable *SDL_Surface) void;

// Free an RGB surface.
export fn SDL_FreeSurface(surface: nullable *SDL_Surface) void = {
	_SDL_FreeSurface(surface);
};

// NB SDL_BlitSurface is aliased to SDL_UpperBlit via a macro in the SDL header
@symbol("SDL_UpperBlit") fn _SDL_BlitSurface(src: *SDL_Surface,
	srcrect: nullable *SDL_Rect, dst: *SDL_Surface, dstrect: nullable *SDL_Rect) int;

// Perform a fast surface copy to a destination surface.
export fn SDL_BlitSurface(src: *SDL_Surface, srcrect: nullable *SDL_Rect, dst: *SDL_Surface, dstrect: nullable *SDL_Rect) (void | error) = {
	return wrapvoid(_SDL_BlitSurface(src, srcrect, dst, dstrect));
};
