use sdl2;
use sdl2::{ SDL_GameControllerAxis, SDL_EventType, SDL_RendererFlags, SDL_WindowFlags };

def SCREEN_WIDTH = 64;
def SCREEN_HEIGHT = 32;
def SCALE = 25;

type graphics = struct {
	bus: *bus,
	win: *sdl2::SDL_Window,
	render: *sdl2::SDL_Renderer,
	running: bool,
};

def FONT = [
	0xF0, 0x90, 0x90, 0x90, 0xF0, // 0
	0x20, 0x60, 0x20, 0x20, 0x70, // 1
	0xF0, 0x10, 0xF0, 0x80, 0xF0, // 2
	0xF0, 0x10, 0xF0, 0x10, 0xF0, // 3
	0x90, 0x90, 0xF0, 0x10, 0x10, // 4
	0xF0, 0x80, 0xF0, 0x10, 0xF0, // 5
	0xF0, 0x80, 0xF0, 0x90, 0xF0, // 6
	0xF0, 0x10, 0x20, 0x40, 0x40, // 7
	0xF0, 0x90, 0xF0, 0x90, 0xF0, // 8
	0xF0, 0x90, 0xF0, 0x10, 0xF0, // 9
	0xF0, 0x90, 0xF0, 0x90, 0x90, // A
	0xE0, 0x90, 0xE0, 0x90, 0xE0, // B
	0xF0, 0x80, 0x80, 0x80, 0xF0, // C
	0xE0, 0x90, 0x90, 0x90, 0xE0, // D
	0xF0, 0x80, 0xF0, 0x80, 0xF0, // E
	0xF0, 0x80, 0xF0, 0x80, 0x80  // F
];

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
		running = true,
	})!;
	for (let i = 0; i < SCREEN_HEIGHT; i += 1) {
		for (let j = 0; j < SCREEN_WIDTH; j += 1) {
				sdl2::SDL_SetRenderDrawColor(g.render, 255, 255, 255, 0)!;
			sdl2::SDL_RenderDrawPoint(g.render, j, i)!;
		};
	};

	for (let i = 0x050; i <= 0x09f; i += 1) {
		bus::write(bus, i: u16, FONT[i - 0x050]: u8);
	};

	return g;
};

fn graphics::draw(graphics: *graphics) void = {
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

fn graphics::update(graphics: *graphics) void = {
	let ev = sdl2::event { ... };
	for (sdl2::SDL_PollEvent(&ev)! == 1) switch (ev.event_type) {
	case SDL_EventType::QUIT =>
		graphics.running = false;
		return;
	case SDL_EventType::KEYUP, SDL_EventType::KEYDOWN =>
		input::handle(graphics.bus, ev.key);
	case => void;
	};
};

fn graphics::freeres(graphics: *graphics) void = {
	sdl2::SDL_DestroyRenderer(graphics.render);
	sdl2::SDL_DestroyWindow(graphics.win);
	sdl2::SDL_Quit();

	free(graphics);
};
