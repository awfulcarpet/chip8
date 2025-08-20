use sdl;
use sdl = sdl::video;
use sdl = sdl::render;
use sdl = sdl::events;

def SCREEN_WIDTH = 64;
def SCREEN_HEIGHT = 32;
def SCALE = 25;

type graphics = struct {
	bus: *bus,
	win: *sdl::window,
	render: *sdl::renderer,
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

fn graphics::init(bus: *bus) (*graphics | sdl::error) = {
	sdl::init(sdl::init_flags::VIDEO | sdl::init_flags::AUDIO)!;
	const win = sdl::create_window("Hare SDL2 demo",
		sdl::WINDOWPOS_CENTERED, sdl::WINDOWPOS_CENTERED,
		SCREEN_WIDTH * SCALE, SCREEN_HEIGHT * SCALE, 0)?;
	const render = sdl::create_renderer(win, -1, 0)?;
	sdl::render_set_scale(render, SCALE: f32, SCALE: f32)?;

	let g = alloc(graphics {
		bus = bus,
		win = win,
		render = render,
		running = true,
	})!;
	// for (let i = 0; i < SCREEN_HEIGHT; i += 1) {
	// 	for (let j = 0; j < SCREEN_WIDTH; j += 1) {
	// 			sdl::SDL_SetRenderDrawColor(g.render, 255, 255, 255, 0)!;
	// 		sdl::SDL_RenderDrawPoint(g.render, j, i)!;
	// 	};
	// };

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
				sdl::set_render_draw_color(graphics.render, 255, 255, 255, 0)!;
			} else {
				sdl::set_render_draw_color(graphics.render, 0, 0, 0, 0)!;
			};
			sdl::render_draw_point(graphics.render, j, i)!;
		};
	};
	sdl::render_present(graphics.render);
};

fn graphics::update(graphics: *graphics) void = {
	for (true) match (sdl::poll_event()) {
	case sdl::quit_requested =>
		graphics.running = false;
		break;
	case let ev: sdl::key_pressed =>
		input::handle(graphics.bus, ev);
	case let ev: sdl::key_released =>
		input::handle(graphics.bus, ev);
	case =>
		break;
	};
};

fn graphics::freeres(graphics: *graphics) void = {
	sdl::destroy_renderer(graphics.render);
	sdl::destroy_window(graphics.win);
	sdl::quit();

	free(graphics);
};
