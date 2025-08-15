use cmd::chip8;

@test fn getreg() void = {
	let bus = chip8::bus { ... };
	let cpu = cpu::cpu(&bus);
	defer free(cpu);

	assert(cpu::getreg(cpu, 0x0) == &cpu.v0);
	assert(cpu::getreg(cpu, 0x1) == &cpu.v1);
	assert(cpu::getreg(cpu, 0x2) == &cpu.v2);
	assert(cpu::getreg(cpu, 0x3) == &cpu.v3);
	assert(cpu::getreg(cpu, 0x4) == &cpu.v4);
	assert(cpu::getreg(cpu, 0x5) == &cpu.v5);
	assert(cpu::getreg(cpu, 0x6) == &cpu.v6);
	assert(cpu::getreg(cpu, 0x7) == &cpu.v7);
	assert(cpu::getreg(cpu, 0x8) == &cpu.v8);
	assert(cpu::getreg(cpu, 0x9) == &cpu.v9);
	assert(cpu::getreg(cpu, 0xa) == &cpu.va);
	assert(cpu::getreg(cpu, 0xb) == &cpu.vb);
	assert(cpu::getreg(cpu, 0xc) == &cpu.vc);
	assert(cpu::getreg(cpu, 0xd) == &cpu.vd);
	assert(cpu::getreg(cpu, 0xe) == &cpu.ve);
	assert(cpu::getreg(cpu, 0xf) == &cpu.vf);
};

@test fn ld_vx_byte() void = {
	for (let i = 0z; i <= 0xf; i += 1) {
		let bus = chip8::bus { ... };
		let cpu = cpu::cpu(&bus);
		defer free(cpu);

		bus::write(cpu.bus, 0x00, 0x60 | i: u8);
		bus::write(cpu.bus, 0x01, (i + 5): u8);

		cpu::execute(cpu);

		assert(*cpu::getreg(cpu, i: u8) == i + 5);
	};
};
