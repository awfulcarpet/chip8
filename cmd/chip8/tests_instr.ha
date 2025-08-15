@test fn getreg() void = {
	let bus = bus { ... };
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
		let bus = bus { ... };
		let cpu = cpu::cpu(&bus);
		defer free(cpu);

		bus::write(cpu.bus, 0x00, 0x60 | i: u8);
		bus::write(cpu.bus, 0x01, (i + 5): u8);

		cpu::execute(cpu);

		assert(*cpu::getreg(cpu, i: u8) == i + 5);
	};
};

@test fn ld_i_byte() void = {
	for (let i = 0z; i <= 0xfff; i += 1) {
		let bus = bus { ... };
		let cpu = cpu::cpu(&bus);
		defer free(cpu);

		cpu.i = (i - 3): u8;
		bus::write(cpu.bus, 0x00, 0xa0 | (i & 0xf00): u8);
		bus::write(cpu.bus, 0x01, (i & 0xff): u8);

		cpu::execute(cpu);

		assert(cpu.i == i: u8);
	};
};

@test fn drw_v1_v3_2n() void = {
	let bus = bus { ... };
	let cpu = cpu::cpu(&bus);
	defer free(cpu);

	cpu.v1 = 30;
	cpu.v3 = 10;
	cpu.i = 0x20;

	bus::write(cpu.bus, 0x20, 0xff);
	bus::write(cpu.bus, 0x21, 0x0f);

	bus::write(cpu.bus, 0x00, 0xd1);
	bus::write(cpu.bus, 0x01, 0x32);

	cpu::execute(cpu);

	let row = bus::read(cpu.bus, FB + SCREEN_WIDTH * cpu.v3: u16 + cpu.v1);
	assert(row == 0xff);

	let row = bus::read(cpu.bus, FB + SCREEN_WIDTH * (cpu.v3: u16 + 1) + cpu.v1);
	assert(row == 0x0f);
};

@test fn drw_vf() void = {
	let bus = bus { ... };
	let cpu = cpu::cpu(&bus);
	defer free(cpu);

	cpu.v0 = 0;
	cpu.v1 = 0;
	cpu.i = 0x20;

	bus::write(cpu.bus, 0x20, 0xff);
	bus::write(cpu.bus, FB, 0x0f);

	bus::write(cpu.bus, 0x00, 0xd0);
	bus::write(cpu.bus, 0x01, 0x01);

	cpu::execute(cpu);
	let row = bus::read(cpu.bus, FB);
	assert(row == 0xf0);

	assert(cpu.vf == 1);
};

@test fn drw_3n() void = {
	let bus = bus { ... };
	let cpu = cpu::cpu(&bus);
	defer free(cpu);

	cpu.v0 = 0;
	cpu.v1 = 0;
	cpu.i = 0x20;

	bus::write(cpu.bus, 0x20, 0xff);
	bus::write(cpu.bus, 0x21, 0x0f);
	bus::write(cpu.bus, 0x22, 0x0a);

	bus::write(cpu.bus, 0x00, 0xd0);
	bus::write(cpu.bus, 0x01, 0x03);

	bus::write(cpu.bus, FB, 0x00);
	bus::write(cpu.bus, FB + SCREEN_WIDTH, 0x00);

	cpu::execute(cpu);

	let row = bus::read(cpu.bus, FB);
	assert(row == 0xff);

	let row = bus::read(cpu.bus, FB + SCREEN_WIDTH);
	assert(row == 0x0f);

	let row = bus::read(cpu.bus, FB + SCREEN_WIDTH * 2);
	assert(row == 0x0a);
};

@test fn drw_1n() void = {
	let bus = bus { ... };
	let cpu = cpu::cpu(&bus);
	defer free(cpu);

	cpu.v0 = 0;
	cpu.v1 = 0;
	cpu.i = 0x20;

	bus::write(cpu.bus, 0x20, 0xff);

	bus::write(cpu.bus, 0x00, 0xd0);
	bus::write(cpu.bus, 0x01, 0x01);

	bus::write(cpu.bus, FB, 0x00);

	cpu::execute(cpu);

	let row = bus::read(cpu.bus, FB);

	assert(row == 0xff);
};
