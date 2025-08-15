use fmt;

export fn main() void = {
	let bus = bus { ... };
	let cpu = cpu::cpu(&bus);

	open(&bus, "tests/1-chip8-logo.ch8");

	cpu.pc = 0x200;
	cpu::log(&cpu);
	cpu::execute(&cpu);
};
