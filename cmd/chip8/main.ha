use fmt;
use getopt;
use sdl;
use sdl = sdl::audio;
use strconv;
use time;
use os;

def SEC_FRAME: f32 = 1.0/60.0;
def CYC_PER_SEC = 700.0;

export fn main() void = {
	const help: []getopt::help = [
		"chip8 emulator",
		('s', "scale", "set graphics scale"),
		"rom",
	];

	const cmd = getopt::parse(os::args, help...);
	defer getopt::finish(&cmd);

	const scale = DEFAULT_SCALE;

	for (const (opt, param) .. cmd.opts) {
		switch (opt) {
		case 's' =>
			scale = match (strconv::stof32(param)) {
			case strconv::invalid =>
				fmt::fatalf("err: scale is not a float");
			case strconv::overflow =>
				fmt::fatalf("err: scale is not a float");
			case let f: f32 =>
				if (f <= 0.0) {
					fmt::fatalf("err: scale must be positive");
				};
				yield f;
			};
		case =>
			abort();
		};
	};

	if (len(cmd.args) != 1) {
		getopt::printhelp(os::stderr, "chip8", help)!;
		os::exit(1);
	};

	const rom = cmd.args[0];

	let bus = bus { ... };
	let cpu = cpu::cpu(&bus);
	defer free(cpu);

	let graphics = match (graphics::init(&bus, scale)) {
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
