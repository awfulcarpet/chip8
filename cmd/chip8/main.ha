use fmt;

export fn main() void = {
	let bus = bus { ... };
	let cpu = cpu::cpu(&bus);
	defer free(cpu);
	//
	// open(&bus, "roms/1-chip8-logo.ch8");
	//
	// cpu.pc = 0x202;
	// for (let i = 0z; i < 6; i += 1) {
	// 	cpu::log(cpu);
	// 	cpu::execute(cpu);
	// };
	// cpu::log(cpu);

	graphics::init();

	for (true) {
		void;
	};
};
