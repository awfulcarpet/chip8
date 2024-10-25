export type SDL_Cursor = opaque;

// Cursor types for [[SDL_CreateSystemCursor]]
export type SDL_SystemCursor = enum uint {
	ARROW,     // Arrow
	IBEAM,     // I-beam
	WAIT,      // Wait
	CROSSHAIR, // Crosshair
	WAITARROW, // Small wait cursor (or Wait if not available)
	SIZENWSE,  // Double arrow pointing northwest and southeast
	SIZENESW,  // Double arrow pointing northeast and southwest
	SIZEWE,    // Double arrow pointing west and east
	SIZENS,    // Double arrow pointing north and south
	SIZEALL,   // Four pointed arrow pointing north, south, east, and west
	NO,        // Slashed circle or crossbones
	HAND,      // Hand
};

// Scroll direction types for the Scroll event
export type SDL_MouseWheelDirection = enum uint {
	NORMAL,    // The scroll direction is normal
	FLIPPED    // The scroll direction is flipped / natural
};

// Get the window which currently has mouse focus.
export @symbol("SDL_GetMouseFocus") fn SDL_GetMouseFocus() nullable *SDL_Window;

// Retrieve the current state of the mouse.
export @symbol("SDL_GetMouseState") fn SDL_GetMouseState(x: *int, y: *int) u32;

// Set relative mouse mode.
export @symbol("SDL_SetRelativeMouseMode") fn SDL_SetRelativeMouseMode(enabled: bool) int;

// Capture the mouse and to track input outside an SDL window.
export @symbol("SDL_CaptureMouse") fn SDL_CaptureMouse(enabled: bool) int;

// Toggle whether or not the cursor is shown.
export @symbol("SDL_ShowCursor") fn SDL_ShowCursor(toggle: int) int;

export def SDL_BUTTON_LEFT	= 1;
export def SDL_BUTTON_MIDDLE	= 2;
export def SDL_BUTTON_RIGHT	= 3;
export def SDL_BUTTON_X1	= 4;
export def SDL_BUTTON_X2	= 5;
export def SDL_BUTTON_LMASK	= 1 << 0;
export def SDL_BUTTON_MMASK	= 1 << 1;
export def SDL_BUTTON_RMASK	= 1 << 2;
export def SDL_BUTTON_X1MASK	= 1 << 3;
export def SDL_BUTTON_X2MASK	= 1 << 4;
