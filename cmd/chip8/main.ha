use fmt;
use sdl2;

export fn main() void = {
	let bus = bus { ... };
	let cpu = cpu::cpu(&bus);
	defer free(cpu);

	let graphics = match(graphics::init(&bus)) {
	case let err: sdl2::error =>
		fmt::fatalf("SDL2 err: {}", sdl2::strerror(err));
	case let g: *graphics =>
		yield g;
	};
	defer free(graphics);

	open(&bus, "roms/1-chip8-logo.ch8");

	cpu.pc = 0x200;
	for (graphics.running) {
		cpu::log(cpu);
		cpu::execute(cpu);

		graphics::update(graphics);
		graphics::draw(graphics);
	};
};
