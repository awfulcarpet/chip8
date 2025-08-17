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

	defer graphics::freeres(graphics);

	open(&bus, "roms/5-quirks.ch8");

	cpu.pc = 0x200;
	for (graphics.running) {
		cpu::log(cpu);
		graphics::update(graphics);
		cpu::execute(cpu);

		graphics::draw(graphics);
	};
};

// @test fn test_suite() void = {
// 	let roms = [
// 		"roms/1-chip8-logo.ch8",
// 		"roms/2-ibm-logo.ch8",
// 		"roms/3-corax+.ch8",
// 		"roms/4-flags.ch8",
// 		"roms/5-quirks.ch8",
// 		"roms/6-keypad.ch8",
// 		"roms/7-beep.ch8",
// 		"roms/8-scrolling.ch8",
// 	];
//
// 	for (let i = 0z; i < len(roms); i += 1) {
// 		let bus = bus { ... };
// 		let cpu = cpu::cpu(&bus);
// 		defer free(cpu);
//
// 		let graphics = match(graphics::init(&bus)) {
// 		case let err: sdl2::error =>
// 			fmt::fatalf("SDL2 err: {}", sdl2::strerror(err));
// 		case let g: *graphics =>
// 			yield g;
// 		};
// 		defer graphics::freeres(graphics);
//
// 		open(&bus, roms[i]);
//
// 		cpu.pc = 0x200;
// 		for (graphics.running) {
// 			// cpu::log(cpu);
// 			cpu::execute(cpu);
//
// 			graphics::update(graphics);
// 			graphics::draw(graphics);
// 		};
// 	};
// 	assert(true);
// };
