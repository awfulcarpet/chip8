use fmt;
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

@test fn drw_vf() void = {
	let bus = bus { ... };
	let cpu = cpu::cpu(&bus);
	defer free(cpu);

	cpu.v0 = 0;
	cpu.v1 = 0;
	cpu.i = 0x20;

	bus::write(cpu.bus, 0x20, 0xff);
	for (let i = 0; i < 4; i += 1) {
		bus::write(cpu.bus, FB + i: u16, 0x01);
	};

	bus::write(cpu.bus, 0x00, 0xd0);
	bus::write(cpu.bus, 0x01, 0x01);

	cpu::execute(cpu);

	for (let i = 0; i < 8; i += 1) {
		let row = bus::read(cpu.bus, FB + i: u16);
		if (i < 4) {
			assert(row == 0x00);
		} else {
			assert(row == 0x01);
		};
	};
	assert(cpu.vf == 1);
};

@test fn drw_vx_vy_1n_wrap() void = {
	let bus = bus { ... };
	let cpu = cpu::cpu(&bus);
	defer free(cpu);

	cpu.v3 = SCREEN_WIDTH + 4;
	cpu.v0 = SCREEN_HEIGHT + 1;
	cpu.i = 0x20;

	bus::write(cpu.bus, 0x20, 0xff);

	bus::write(cpu.bus, 0x00, 0xd3);
	bus::write(cpu.bus, 0x01, 0x01);

	cpu::execute(cpu);

	for (let i = 0z; i < 8; i += 1) {
		let row = bus::read(cpu.bus, FB + 1 * SCREEN_WIDTH + 4 + i: u16);
		assert(row == 0x01);
	};

	assert(cpu.vf == 0);
};

@test fn drw_vx_vy_2n_clip() void = {
	let bus = bus { ... };
	let cpu = cpu::cpu(&bus);
	defer free(cpu);

	cpu.va = SCREEN_WIDTH - 4;
	cpu.vd = SCREEN_HEIGHT - 1;
	cpu.i = 0x20;

	bus::write(cpu.bus, 0x20, 0xff);
	bus::write(cpu.bus, 0x21, 0xff);

	bus::write(cpu.bus, 0x00, 0xda);
	bus::write(cpu.bus, 0x01, 0xd2);

	cpu::execute(cpu);

	for (let i = 0; i < 8; i += 1) {
		let coord: u16 = FB + cpu.vd: u16 * SCREEN_WIDTH + cpu.va + i: u16;
		if (coord >= FB + FB_LEN)
			continue;
		let row = bus::read(cpu.bus, coord);
		if (cpu.va + i: u8 < SCREEN_WIDTH) {
			assert(row == 0x01);
		} else {
			assert(row == 0x00);
		};
	};

	for (let i = 0; i < 8; i += 1) {
		let coord: u16 = FB + (cpu.vd: u16 + 1) * SCREEN_WIDTH + cpu.va + i: u16;
		if (coord >= FB + FB_LEN)
			continue;
		let row = bus::read(cpu.bus, coord);
		if (cpu.va + i: u8 < SCREEN_WIDTH) {
			assert(row == 0x01);
		} else {
			assert(row == 0x00);
		};
	};

	assert(cpu.vf == 0);
};

@test fn drw_vx_vy_3n() void = {
	let bus = bus { ... };
	let cpu = cpu::cpu(&bus);
	defer free(cpu);

	cpu.v6 = 4;
	cpu.v4 = 20;
	cpu.i = 0x20;

	bus::write(cpu.bus, 0x20, 0xf3);
	bus::write(cpu.bus, 0x21, 0xf4);
	bus::write(cpu.bus, 0x22, 0x4f);

	bus::write(cpu.bus, 0x00, 0xd6);
	bus::write(cpu.bus, 0x01, 0x43);

	cpu::execute(cpu);

	for (let i = 0; i < 8; i += 1) {
		let row = bus::read(cpu.bus, FB + cpu.v4: u16 * SCREEN_WIDTH + cpu.v6 + i: u16);
		if (i < 4 || i > 5) {
			assert(row == 0x01);
		} else {
			assert(row == 0x00);
		};
	};

	for (let i = 0; i < 8; i += 1) {
		let row = bus::read(cpu.bus, FB + (cpu.v4: u16 + 1) * SCREEN_WIDTH + cpu.v6 + i: u16);
		if (i < 4 || i == 5) {
			assert(row == 0x01);
		} else {
			assert(row == 0x00);
		};
	};

	for (let i = 0; i < 8; i += 1) {
		let row = bus::read(cpu.bus, FB + (cpu.v4: u16 + 2) * SCREEN_WIDTH + cpu.v6 + i: u16);
		if (i == 1 || i >= 4) {
			assert(row == 0x01);
		} else {
			assert(row == 0x00);
		};
	};

	assert(cpu.vf == 0);
};

@test fn drw_3n() void = {
	let bus = bus { ... };
	let cpu = cpu::cpu(&bus);
	defer free(cpu);

	cpu.v0 = 0;
	cpu.v1 = 0;
	cpu.i = 0x20;

	bus::write(cpu.bus, 0x20, 0xff);
	bus::write(cpu.bus, 0x21, 0xf0);
	bus::write(cpu.bus, 0x22, 0x0f);

	bus::write(cpu.bus, 0x00, 0xd0);
	bus::write(cpu.bus, 0x01, 0x03);

	cpu::execute(cpu);

	for (let i = 0; i < 8; i += 1) {
		let row = bus::read(cpu.bus, FB + i: u16);
		assert(row == 0x01);
	};

	for (let i = 0; i < 8; i += 1) {
		let row = bus::read(cpu.bus, FB + SCREEN_WIDTH + i: u16);
		if (i < 4) {
			assert(row == 0x01);
		} else {
			assert(row == 0x00);
		};
	};

	for (let i = 0; i < 8; i += 1) {
		let row = bus::read(cpu.bus, FB + SCREEN_WIDTH * 2 + i: u16);
		if (i < 4) {
			assert(row == 0x00);
		} else {
			assert(row == 0x01);
		};
	};

	assert(cpu.vf == 0);
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

	cpu::execute(cpu);

	for (let i = 0; i < 8; i += 1) {
		let row = bus::read(cpu.bus, FB + i: u16);
		assert(row == 0x01);
	};
	assert(cpu.vf == 0);
};

@test fn jp_adr() void = {
	let bus = bus { ... };
	let cpu = cpu::cpu(&bus);
	defer free(cpu);

	bus::write(cpu.bus, 0x00, 0x13);
	bus::write(cpu.bus, 0x01, 0x45);

	cpu::execute(cpu);

	assert(cpu.pc == 0x345);
};
