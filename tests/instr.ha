use cmd::chip8;

@test fn ld_v0_byte() void = {
	let bus = chip8::bus { ... };
	let cpu = cpu::cpu(&bus);

	bus::write(cpu.bus, 0x00, 0x60);
	bus::write(cpu.bus, 0x01, 0x10);

	cpu::execute(cpu);

	assert(cpu.v0 == 0x10);
};

@test fn ld_v1_byte() void = {
	let bus = chip8::bus { ... };
	let cpu = cpu::cpu(&bus);

	bus::write(cpu.bus, 0x00, 0x61);
	bus::write(cpu.bus, 0x01, 0xff);

	cpu::execute(cpu);

	assert(cpu.v1 == 0xff);
};

@test fn ld_v2_byte() void = {
	let bus = chip8::bus { ... };
	let cpu = cpu::cpu(&bus);

	bus::write(cpu.bus, 0x00, 0x62);
	bus::write(cpu.bus, 0x01, 0xca);

	cpu::execute(cpu);

	assert(cpu.v2 == 0xca);
};

@test fn ld_vf_byte() void = {
	let bus = chip8::bus { ... };
	let cpu = cpu::cpu(&bus);

	bus::write(cpu.bus, 0x00, 0x6f);
	bus::write(cpu.bus, 0x01, 0xbe);

	cpu::execute(cpu);

	assert(cpu.vf == 0xbe);
};
