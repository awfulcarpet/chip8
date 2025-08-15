use sdl2;
use sdl2::{ SDL_GameControllerAxis, SDL_EventType, SDL_RendererFlags, SDL_WindowFlags };

def SCREEN_WIDTH = 64;
def SCREEN_HEIGHT = 32;
def SCALE = 25;

type graphics = struct {
	bus: *bus,
	win: *sdl2::SDL_Window,
	render: *sdl2::SDL_Renderer,
};

fn graphics::init(bus: *bus) (*graphics | sdl2::error) = {
	sdl2::SDL_Init(sdl2::SDL_INIT_VIDEO
		| sdl2::SDL_INIT_AUDIO
		| sdl2::SDL_INIT_GAMECONTROLLER)!;
	const win = sdl2::SDL_CreateWindow("Hare SDL2 demo",
		sdl2::SDL_WINDOWPOS_CENTERED, sdl2::SDL_WINDOWPOS_CENTERED,
		SCREEN_WIDTH * SCALE, SCREEN_HEIGHT * SCALE, SDL_WindowFlags::NONE)?;
	const render = sdl2::SDL_CreateRenderer(win, -1, SDL_RendererFlags::NONE)?;
	sdl2::SDL_RenderSetScale(render, SCALE: f32, SCALE: f32)?;

	let g = alloc(graphics {
		bus = bus,
		win = win,
		render = render,
	})!;

	return g;
};

fn graphics::update(graphics: *graphics) void = {
	for (let i = 0; i < SCREEN_HEIGHT; i += 1) {
		for (let j = 0; j < SCREEN_WIDTH; j += 1) {
			let p = bus::read(graphics.bus, FB + i: u16 * SCREEN_WIDTH + j: u16);
			if (p != 0) {
				sdl2::SDL_SetRenderDrawColor(graphics.render, 255, 255, 255, 0)!;
			} else {
				sdl2::SDL_SetRenderDrawColor(graphics.render, 0, 0, 0, 0)!;
			};
			sdl2::SDL_RenderDrawPoint(graphics.render, j, i)!;
		};
	};
	sdl2::SDL_RenderPresent(graphics.render);
};

fn graphics::finish(graphics: *graphics) void = {
	sdl2::SDL_DestroyRenderer(graphics.render);
	sdl2::SDL_DestroyWindow(graphics.win);
	sdl2::SDL_Quit();
};
