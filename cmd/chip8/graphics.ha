use sdl2;
use sdl2::{ SDL_GameControllerAxis, SDL_EventType, SDL_RendererFlags, SDL_WindowFlags };

fn graphics::init() void = {
	sdl2::SDL_Init(sdl2::SDL_INIT_VIDEO
		| sdl2::SDL_INIT_AUDIO
		| sdl2::SDL_INIT_GAMECONTROLLER)!;
	const win = sdl2::SDL_CreateWindow("Hare SDL2 demo",
		sdl2::SDL_WINDOWPOS_UNDEFINED, sdl2::SDL_WINDOWPOS_UNDEFINED,
		640, 480, SDL_WindowFlags::NONE)!;
};

fn graphics::finish() void = {
	sdl2::SDL_Quit();
};
