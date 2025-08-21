use fmt;
use sdl;
use sdl = sdl::audio;
use time;
use os;

def SEC_FRAME: f32 = 1.0/60.0;
def CYC_PER_SEC = 700.0;

export fn main() void = {
	const rom = if (len(os::args) <= 1) {
		fmt::fatalf("no rom specified");
	} else {
		yield os::args[1];
	};

	let bus = bus { ... };
	let cpu = cpu::cpu(&bus);
	defer free(cpu);

	let graphics = match(graphics::init(&bus)) {
	case let err: sdl::error =>
		fmt::fatalf("sdl err: {}", sdl::strerror(err));
	case let g: *graphics =>
		yield g;
	};

	defer graphics::freeres(graphics);

	open(&bus, rom);

	cpu.pc = 0x200;
	let t = time::now(time::clock::PROCESS_CPU);
	let d = t;

	let dev = audio::init();
	defer sdl::close_audio_device(dev);

	for (graphics.running) {
		d = time::now(time::clock::PROCESS_CPU);
		let dt = time::diff(t, d): f32 / time::SECOND: f32;


		if (dt: f32 < SEC_FRAME)
			continue;

		graphics::update(graphics);
		for (let i = 0z; i < (CYC_PER_SEC * dt): uint; i += 1) {
			cpu::log(cpu);
			cpu::execute(cpu);
		};

		if (cpu.dt > 0) cpu.dt -= 1;
		if (cpu.st > 0) cpu.st -= 1;

		sdl::pause_audio_device(dev, cpu.st == 0);

		graphics::draw(graphics);

		t = time::now(time::clock::PROCESS_CPU);
	};
};

@test fn test_suite() void = {
	let roms = [
		"roms/1-chip8-logo.ch8",
		"roms/2-ibm-logo.ch8",
		"roms/3-corax+.ch8",
		"roms/4-flags.ch8",
		"roms/5-quirks.ch8",
		"roms/6-keypad.ch8",
		"roms/7-beep.ch8",
		"roms/8-scrolling.ch8",
	];

	for (let i = 0z; i < len(roms); i += 1) {
		let bus = bus { ... };
		let cpu = cpu::cpu(&bus);
		defer free(cpu);

		let graphics = match(graphics::init(&bus)) {
		case let err: sdl::error =>
			fmt::fatalf("sdl err: {}", sdl::strerror(err));
		case let g: *graphics =>
			yield g;
		};
		defer graphics::freeres(graphics);

		open(&bus, roms[i]);

		cpu.pc = 0x200;
		for (graphics.running) {
			cpu::log(cpu);
			cpu::execute(cpu);

			graphics::update(graphics);
			graphics::draw(graphics);
		};
	};
	assert(true);
};
