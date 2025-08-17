use fmt;
use strings;

type opcodes = enum u16 {
	CLS = 0x00e0,
	RET = 0x00ee,
	JP_ADR = 0x1000,
	CALL_ADR = 0x2000,
	SE_VX_ADR = 0x3000,
	SNE_VX_BYTE = 0x4000,
	SE_VX_VY = 0x5000,
	LD_VX_BYTE = 0x6000,
	ADD_VX_BYTE = 0x7000,
	LD_VX_VY = 0x8000,
	OR_VX_VY = 0x8001,
	AND_VX_VY = 0x8002,
	XOR_VX_VY = 0x8003,
	ADD_VX_VY = 0x8004,
	SUB_VX_VY = 0x8005,
	SHR_VX_VY = 0x8006,
	SUBN_VX_VY = 0x8007,
	SHL_VX_VY = 0x800e,
	SNE_VX_VY = 0x9000,
	LD_I_BYTE = 0xa000,
	DRW = 0xd000,
	LD_VX_DT = 0xf007,
	LD_DT_VX = 0xf015,
	LD_ST_VX = 0xf018,
	ADD_I_VX = 0xf01e,
	LD_I_VX = 0xf055,
	LD_VX_I = 0xf065,
	LD_B_VX = 0xf033,
};

type invalid_opcode = !void;

type cpu = struct {
	v0: u8,
	v1: u8,
	v2: u8,
	v3: u8,
	v4: u8,
	v5: u8,
	v6: u8,
	v7: u8,
	v8: u8,
	v9: u8,
	va: u8,
	vb: u8,
	vc: u8,
	vd: u8,
	ve: u8,
	vf: u8,

	i: u16, // index register for pointing at memory
	sp: u8,
	pc: u16,

	dt: u8, // delay timer
	st: u8, // sound timer

	bus: *bus,
};

// returns a heap allocated cpu struct.
fn cpu::cpu(bus: *bus) *cpu = {
	let cpu: *cpu = alloc(cpu { bus = bus, ... })!;

	return cpu;
};

fn cpu::log(cpu: *cpu) void = {
	fmt::printfln("V0: {:.2x} V1: {:.2x}", cpu.v0, cpu.v1)!;
	fmt::printfln("V2: {:.2x} V3: {:.2x}", cpu.v2, cpu.v3)!;
	fmt::printfln("V4: {:.2x} V5: {:.2x}", cpu.v4, cpu.v5)!;
	fmt::printfln("V6: {:.2x} V7: {:.2x}", cpu.v6, cpu.v7)!;
	fmt::printfln("V8: {:.2x} V9: {:.2x}", cpu.v8, cpu.v9)!;
	fmt::printfln("VA: {:.2x} VB: {:.2x}", cpu.va, cpu.vb)!;
	fmt::printfln("VC: {:.2x} VD: {:.2x}", cpu.vc, cpu.vd)!;
	fmt::printfln("VE: {:.2x} VF: {:.2x}", cpu.ve, cpu.vf)!;

	fmt::printfln("PC: {:.4x}", cpu.pc)!;
	fmt::printfln("SP: {:.2x}", cpu.sp)!;
	fmt::printfln("I: {:.4x}", cpu.i)!;

	fmt::printfln("d: {:.2x} s: {:.2x}", cpu.dt, cpu.st)!;

	let opcode = read_opcode(cpu);
	fmt::printf("{:.4x}:\t{:.4x}\t", cpu.pc, opcode)!;

	// let s = match (stropcode(opcode)) {
	// case invalid_opcode =>
	// 	void;
	// 	fmt::fatalf("invalid opcode: {:.4x}", opcode);
	// case let s: str =>
	// 	yield s;
	// };
	//
	// fmt::printfln("{}", s)!;

	fmt::println("")!;
	fmt::println("")!;
};

fn cpu::getreg(cpu: *cpu, num: u8) *u8 = {
	switch (num) {
	case 0x0 =>
		return &cpu.v0;
	case 0x1 =>
		return &cpu.v1;
	case 0x2 =>
		return &cpu.v2;
	case 0x3 =>
		return &cpu.v3;
	case 0x4 =>
		return &cpu.v4;
	case 0x5 =>
		return &cpu.v5;
	case 0x6 =>
		return &cpu.v6;
	case 0x7 =>
		return &cpu.v7;
	case 0x8 =>
		return &cpu.v8;
	case 0x9 =>
		return &cpu.v9;
	case 0xa =>
		return &cpu.va;
	case 0xb =>
		return &cpu.vb;
	case 0xc =>
		return &cpu.vc;
	case 0xd =>
		return &cpu.vd;
	case 0xe =>
		return &cpu.ve;
	case 0xf =>
		return &cpu.vf;
	case =>
		fmt::fatalf("reg num is out of range");
	};
};

fn read_opcode(cpu: *cpu) u16 = {
	return bus::read(cpu.bus, cpu.pc): u16 << 8
		| bus::read(cpu.bus, cpu.pc + 1);
};

// returns string representation of opcodes. The caller must free the result.
fn stropcode(opcode: u16) (str | !invalid_opcode) = {
	static let buf: [13]u8 = [0...];
	switch (opcode & 0xf000) {
	case opcodes::CLS & 0xf000 =>
		switch (opcode) {
		case opcodes::CLS =>
			return "CLS";
		case opcodes::RET =>
			return "RET";
		case =>
			return invalid_opcode;
		};
	case opcodes::JP_ADR & 0xf000 =>
		return fmt::bsprintf(buf, "JP {:.4x}", opcode & 0xfff)!;
	case opcodes::CALL_ADR & 0xf000 =>
		return fmt::bsprintf(buf, "CALL {:.4x}", opcode & 0xfff)!;
	case opcodes::SE_VX_ADR & 0xf000 =>
		return fmt::bsprintf(buf, "SE V{}, {:.2x}",
			(opcode & 0xf00) >> 8, opcode & 0xff)!;
	case opcodes::SNE_VX_BYTE & 0xf000 =>
		return fmt::bsprintf(buf, "SNE V{}, {:.2x}",
			(opcode & 0xf00) >> 8, opcode & 0xff)!;
	case opcodes::SE_VX_VY & 0xf000 =>
		return fmt::bsprintf(buf, "SE V{}, V{}",
			(opcode & 0xf00) >> 8, (opcode & 0xf0) >> 4)!;
	case opcodes::LD_VX_BYTE & 0xf000 =>
		return fmt::bsprintf(buf, "LD V{}, {:.2x}",
			(opcode & 0xf00) >> 8, opcode & 0xff)!;
	case opcodes::ADD_VX_BYTE & 0xf000 =>
		return fmt::bsprintf(buf, "ADD V{}, {:.2x}",
			(opcode & 0xf00) >> 8, opcode & 0xff)!;
	case 0x8000 =>
		switch (opcode & 0xf00f) {
		case opcodes::LD_VX_VY =>
			return fmt::bsprintf(buf, "LD V{}, V{}",
				(opcode & 0xf00) >> 8, (opcode & 0xf0) >> 4)!;
		case opcodes::OR_VX_VY =>
			return fmt::bsprintf(buf, "OR V{}, V{}",
				(opcode & 0xf00) >> 8, (opcode & 0xf0) >> 4)!;
		case opcodes::AND_VX_VY =>
			return fmt::bsprintf(buf, "AND V{}, V{}",
				(opcode & 0xf00) >> 8, (opcode & 0xf0) >> 4)!;
		case opcodes::XOR_VX_VY =>
			return fmt::bsprintf(buf, "XOR V{}, V{}",
				(opcode & 0xf00) >> 8, (opcode & 0xf0) >> 4)!;
		case opcodes::ADD_VX_VY =>
			return fmt::bsprintf(buf, "ADD V{}, V{}",
				(opcode & 0xf00) >> 8, (opcode & 0xf0) >> 4)!;
		case opcodes::SUB_VX_VY =>
			return fmt::bsprintf(buf, "SUB V{}, V{}",
				(opcode & 0xf00) >> 8, (opcode & 0xf0) >> 4)!;
		case opcodes::SHR_VX_VY =>
			return fmt::bsprintf(buf, "SHR V{}, V{}",
				(opcode & 0xf00) >> 8, (opcode & 0xf0) >> 4)!;
		case opcodes::SUBN_VX_VY =>
			return fmt::bsprintf(buf, "SUBN V{}, V{}",
				(opcode & 0xf00) >> 8, (opcode & 0xf0) >> 4)!;
		case opcodes::SHL_VX_VY =>
			return fmt::bsprintf(buf, "SHL V{}, V{}",
				(opcode & 0xf00) >> 8, (opcode & 0xf0) >> 4)!;
		case =>
			return invalid_opcode;
		};
	case opcodes::SNE_VX_VY & 0xf000 =>
		return fmt::bsprintf(buf, "SNE V{}, V{}",
			(opcode & 0xf00) >> 8, (opcode & 0xf0) >> 4)!;
	case opcodes::LD_I_BYTE & 0xf000 =>
		return fmt::bsprintf(buf, "LD I, {:.4x}", opcode & 0xfff)!;
	case opcodes::DRW & 0xf000 =>
		return fmt::bsprintf(buf, "DRW V{}, V{}, {:.1x}",
			(opcode & 0xf00) >> 8, (opcode & 0xf0) >> 4,
			opcode & 0x0f)!;
	case 0xf000 =>
		switch (opcode & 0xf0ff) {
		case opcodes::LD_VX_DT =>
			return fmt::bsprintf(buf, "LD V{} DT",
				(opcode & 0xf00) >> 8)!;
		case opcodes::LD_DT_VX =>
			return fmt::bsprintf(buf, "LD DT V{}",
				(opcode & 0xf00) >> 8)!;
		case opcodes::LD_ST_VX =>
			return fmt::bsprintf(buf, "LD ST V{}",
				(opcode & 0xf00) >> 8)!;
		case opcodes::ADD_I_VX =>
			return fmt::bsprintf(buf, "ADD I, V{}",
				(opcode & 0xf00) >> 8)!;
		case opcodes::LD_VX_I =>
			return fmt::bsprintf(buf, "LD V{}, [I]",
				(opcode & 0xf00) >> 8)!;
		case opcodes::LD_I_VX =>
			return fmt::bsprintf(buf, "LD [I], V{}",
				(opcode & 0xf00) >> 8)!;
		case opcodes::LD_B_VX =>
			return fmt::bsprintf(buf, "LD B, V{}",
				(opcode & 0xf00) >> 8)!;
		case =>
			return invalid_opcode;
		};
	case =>
		return invalid_opcode;
	};
};

fn ld_vx_byte(cpu: *cpu, opcode: u16) void = {
	let reg = cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);
	*reg = (opcode & 0xff): u8;
};

fn ld_i_byte(cpu: *cpu, opcode: u16) void = {
	cpu.i = opcode & 0xfff;
};

fn drw_vx_vy_nib(cpu: *cpu, opcode: u16) void = {
	let n = (opcode & 0xf): u8;
	let x = *cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8) % SCREEN_WIDTH;
	let y = *cpu::getreg(cpu, ((opcode & 0xf0) >> 4): u8) % SCREEN_HEIGHT;

	cpu.vf = 0;

	for (let i = 0z; i < n; i += 1) {
		let sprite = bus::read(cpu.bus, cpu.i + i: u16);
		for (let j = 0z; j < 8; j += 1) {
			let coord = FB + (i + y) * SCREEN_WIDTH + x + j;
			if (x + j >= SCREEN_WIDTH || y + i >= SCREEN_HEIGHT)
				continue;

			let fb = bus::read(cpu.bus, coord: u16);
			let s: u8 = if ((sprite & (1 << (7 - j))) > 0) 1 else 0;
			let p = s ^ fb;

			if (fb == 1 && p == 0)
				cpu.vf = 1;

			bus::write(cpu.bus, coord: u16, p);
		};
	};
};

fn cls(cpu: *cpu) void = {
	for (let i = 0z; i < SCREEN_HEIGHT; i += 1) {
		for (let j = 0z; j < SCREEN_WIDTH; j += 1) {
			bus::write(cpu.bus, FB + i: u16 * SCREEN_HEIGHT + j: u16, 0x00);
		};
	};
};

fn jp(cpu: *cpu, opcode: u16) void = {
	cpu.pc = opcode & 0xfff;
};

fn add_vx_byte(cpu: *cpu, opcode: u16) void = {
	let reg: *u8 = cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);

	*reg += (opcode & 0xff): u8;
};

fn se_vx_adr(cpu: *cpu, opcode: u16) void = {
	let reg: *u8 = cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);
	if (*reg == opcode & 0xff)
		cpu.pc += 2;
};

fn sne_vx_byte(cpu: *cpu, opcode: u16) void = {
	let reg: *u8 = cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);

	if (*reg != opcode & 0xff) {
		cpu.pc += 2;
	};
};

fn se_vx_vy(cpu: *cpu, opcode: u16) void = {
	let vx: *u8 = cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);
	let vy: *u8 = cpu::getreg(cpu, ((opcode & 0xf0) >> 4): u8);

	if (*vx == *vy) {
		cpu.pc += 2;
	};
};

fn sne_vx_vy(cpu: *cpu, opcode: u16) void = {
	let vx: *u8 = cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);
	let vy: *u8 = cpu::getreg(cpu, ((opcode & 0xf0) >> 4): u8);

	if (*vx != *vy) {
		cpu.pc += 2;
	};
};

fn call(cpu: *cpu, opcode: u16) void = {
	cpu.sp += 1;
	bus::write(cpu.bus, cpu.sp, (cpu.pc & 0xff): u8);
	cpu.sp += 1;
	bus::write(cpu.bus, cpu.sp, (cpu.pc >> 8): u8);
	cpu.pc = opcode & 0xfff;
};

fn ret(cpu: *cpu, opcode: u16) void = {
	let h: u16 = bus::read(cpu.bus, cpu.sp);
	cpu.sp -= 1;
	let l = bus::read(cpu.bus, cpu.sp);
	cpu.sp -= 1;

	cpu.pc = h << 8 | l;
};

fn ld_vx_vy(cpu: *cpu, opcode: u16) void = {
	let vx: *u8 = cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);
	let vy: *u8 = cpu::getreg(cpu, ((opcode & 0xf0) >> 4): u8);

	*vx = *vy;
};

fn or_vx_vy(cpu: *cpu, opcode: u16) void = {
	let vx: *u8 = cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);
	let vy: *u8 = cpu::getreg(cpu, ((opcode & 0xf0) >> 4): u8);

	*vx |= *vy;
};

fn and_vx_vy(cpu: *cpu, opcode: u16) void = {
	let vx: *u8 = cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);
	let vy: *u8 = cpu::getreg(cpu, ((opcode & 0xf0) >> 4): u8);

	*vx &= *vy;
};

fn xor_vx_vy(cpu: *cpu, opcode: u16) void = {
	let vx: *u8 = cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);
	let vy: *u8 = cpu::getreg(cpu, ((opcode & 0xf0) >> 4): u8);

	*vx ^= *vy;
};

fn add_vx_vy(cpu: *cpu, opcode: u16) void = {
	let vx: *u8 = cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);
	let vy: *u8 = cpu::getreg(cpu, ((opcode & 0xf0) >> 4): u8);
	let add: u16 = *vx: u16 + *vy: u16;

	*vx += *vy;

	if (add > 0xff) {
		cpu.vf = 1;
	} else {
		cpu.vf = 0;
	};

};

fn sub_vx_vy(cpu: *cpu, opcode: u16) void = {
	let vx: *u8 = cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);
	let vy: *u8 = cpu::getreg(cpu, ((opcode & 0xf0) >> 4): u8);

	*vx -= *vy;

	if (*vx + *vy > *vx) {
		cpu.vf = 1;
	} else {
		cpu.vf = 0;
	};
};


fn shr_vx_vy(cpu: *cpu, opcode: u16) void = {
	let vx: *u8 = cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);
	let tmp = *vx & 1;
	*vx >>= 1;
	cpu.vf = tmp;
};

fn shl_vx_vy(cpu: *cpu, opcode: u16) void = {
	let vx: *u8 = cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);
	let tmp = *vx >> 7;
	*vx <<= 1;

	cpu.vf = tmp;
};

fn subn_vx_vy(cpu: *cpu, opcode: u16) void = {
	let vx: *u8 = cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);
	let vy: *u8 = cpu::getreg(cpu, ((opcode & 0xf0) >> 4): u8);
	let sub = *vy: i16 - *vx: i16;

	*vx = *vy - *vx;

	if (sub >= 0) {
		cpu.vf = 1;
	} else {
		cpu.vf = 0;
	};
};

fn ld_vx_i(cpu: *cpu, opcode: u16) void = {
	for (let i = 0z; i <= (opcode & 0xf00) >> 8; i += 1) {
		let vx: *u8 = cpu::getreg(cpu, i: u8);
		*vx = bus::read(cpu.bus, cpu.i);
		cpu.i += 1;
	};
};

fn ld_i_vx(cpu: *cpu, opcode: u16) void = {
	for (let i = 0z; i <= (opcode & 0xf00) >> 8; i += 1) {
		let vx: *u8 = cpu::getreg(cpu, i: u8);
		bus::write(cpu.bus, cpu.i, *vx);
		cpu.i += 1;
	};
};

fn ld_b_vx(cpu: *cpu, opcode: u16) void = {
	let vx: u8 = *cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);
	for (let i = 0; i < 3; i += 1) {
		bus::write(cpu.bus, cpu.i + (2 - i): u16, vx % 10);
		vx /= 10;
	};
};

fn add_i_vx(cpu: *cpu, opcode: u16) void = {
	let vx: *u8 = cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);

	cpu.i += *vx;
};

fn ld_dt_vx(cpu: *cpu, opcode: u16) void = {
	let vx: *u8 = cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);
	cpu.dt = *vx;
};

fn ld_vx_dt(cpu: *cpu, opcode: u16) void = {
	let vx: *u8 = cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);
	*vx = cpu.dt;
};

fn ld_st_vx(cpu: *cpu, opcode: u16) void = {
	let vx: *u8 = cpu::getreg(cpu, ((opcode & 0xf00) >> 8): u8);
	cpu.st = *vx;
};


fn cpu::execute(cpu: *cpu) void = {
	let opcode = read_opcode(cpu);
	cpu.pc += 2;
	switch (opcode & 0xf000) {
	case 0x0000 =>
		switch (opcode) {
		case opcodes::CLS =>
			cls(cpu);
		case opcodes::RET =>
			ret(cpu, opcode);
		case =>
			fmt::fatalf("unimplemented opcode {:.4x}", opcode);
		};
	case opcodes::JP_ADR & 0xf000 =>
		jp(cpu, opcode);
	case opcodes::CALL_ADR & 0xf000 =>
		call(cpu, opcode);
	case opcodes::SE_VX_ADR & 0xf000 =>
		se_vx_adr(cpu, opcode);
	case opcodes::SNE_VX_BYTE & 0xf000 =>
		sne_vx_byte(cpu, opcode);
	case opcodes::SE_VX_VY & 0xf000 =>
		se_vx_vy(cpu, opcode);
	case opcodes::LD_VX_BYTE & 0xf000 =>
		ld_vx_byte(cpu, opcode);
	case opcodes::ADD_VX_BYTE & 0xf000 =>
		add_vx_byte(cpu, opcode);
	case 0x8000 =>
		switch (opcode & 0xf00f) {
		case opcodes::LD_VX_VY =>
			ld_vx_vy(cpu, opcode);
		case opcodes::OR_VX_VY =>
			or_vx_vy(cpu, opcode);
		case opcodes::AND_VX_VY =>
			and_vx_vy(cpu, opcode);
		case opcodes::XOR_VX_VY =>
			xor_vx_vy(cpu, opcode);
		case opcodes::ADD_VX_VY =>
			add_vx_vy(cpu, opcode);
		case opcodes::SUB_VX_VY =>
			sub_vx_vy(cpu, opcode);
		case opcodes::SHR_VX_VY =>
			shr_vx_vy(cpu, opcode);
		case opcodes::SUBN_VX_VY =>
			subn_vx_vy(cpu, opcode);
		case opcodes::SHL_VX_VY =>
			shl_vx_vy(cpu, opcode);
		case =>
			fmt::fatalf("unimplemented opcode {:.4x}", opcode);
		};
	case opcodes::SNE_VX_VY & 0xf000 =>
		sne_vx_vy(cpu, opcode);
	case opcodes::LD_I_BYTE & 0xf000 =>
		ld_i_byte(cpu, opcode);
	case opcodes::DRW =>
		drw_vx_vy_nib(cpu, opcode);
	case 0xf000 =>
		switch (opcode & 0xf0ff) {
		case opcodes::LD_VX_DT =>
			ld_vx_dt(cpu, opcode);
		case opcodes::LD_DT_VX =>
			ld_dt_vx(cpu, opcode);
		case opcodes::LD_ST_VX =>
			ld_st_vx(cpu, opcode);
		case opcodes::ADD_I_VX =>
			add_i_vx(cpu, opcode);
		case opcodes::LD_VX_I =>
			ld_vx_i(cpu, opcode);
		case opcodes::LD_I_VX =>
			ld_i_vx(cpu, opcode);
		case opcodes::LD_B_VX =>
			ld_b_vx(cpu, opcode);
		case =>
			fmt::fatalf("unimplemented opcode {:.4x}", opcode);
		};
	case =>
		fmt::fatalf("unimplemented opcode {:.4x}", opcode);
	};
};
