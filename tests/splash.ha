use cmd::chip8;
use fmt;

@test fn test_splash() void = {
	let bus = chip8::bus { ... };
	let cpu = cpu::cpu(&bus);

	chip8::open(&bus, "tests/1-chip8-logo.ch8");

	for (let i = 0z; i < 39; i += 1) {
		cpu::log(cpu);
		cpu::execute(cpu);
	};
};
