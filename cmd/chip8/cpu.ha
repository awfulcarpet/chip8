use fmt;
use strings;

type opcodes = enum u16 {
	CLS = 0x00e0,
	LD = 0x6000,
	LDI = 0xa000,
	DRW = 0xd000,
};

type invalid_opcode = !void;

export type cpu = struct {
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

	dtimer: u8, // delay timer
	stimer: u8, // sound timer

	bus: *bus,
};

export fn cpu::cpu(bus: *bus) *cpu = {
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

	fmt::printfln("d: {:.2x} s: {:.2x}", cpu.dtimer, cpu.stimer)!;

	let opcode = read_opcode(cpu);
	fmt::printf("{:.4x}:\t{:.4x}\t", cpu.pc, opcode)!;

	let stropcode = match (stropcode(opcode)) {
	case invalid_opcode =>
		fmt::fatalf("invalid opcode: {:.4x}", opcode);
	case let s: str =>
		yield s;
	};
	defer free(stropcode);

	fmt::printfln("{}", stropcode)!;

	fmt::println("")!;
};

fn read_opcode(cpu: *cpu) u16 = {
	return bus::read(cpu.bus, cpu.pc): u16 << 8
		| bus::read(cpu.bus, cpu.pc + 1);
};

// string representation of opcodes. The caller must free the result.
fn stropcode(opcode: u16) (str | invalid_opcode) = {
	switch (opcode & 0xf000) {
	case opcodes::CLS & 0xf000 =>
		switch (opcode) {
		case opcodes::CLS =>
			return strings::dup("CLS")!;
		case =>
			return invalid_opcode;
		};
	case opcodes::LD & 0xf000 =>
		return fmt::asprintf("LD V{}, {:.4x}", (opcode & 0xf00) >> 8,
			opcode & 0xff)!;
	case opcodes::LDI & 0xf000 =>
		return fmt::asprintf("LD I, {:.4x}", opcode & 0xfff)!;
	case opcodes::DRW & 0xf000 =>
		return fmt::asprintf("DRW V{}, V{}, {:.1x}",
			(opcode & 0xf00) >> 8, (opcode & 0xf0) >> 4,
			opcode & 0x0f)!;
	case =>
		return invalid_opcode;
	};
};

export fn cpu::execute(cpu: *cpu) void = {
	let opcode = read_opcode(cpu);
	cpu.pc += 2;
};
