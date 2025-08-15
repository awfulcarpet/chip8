use fmt;

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

export fn cpu::cpu(bus: *bus) cpu = {
	return cpu {
		bus = bus,
		...
	};
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

	fmt::printfln("{:.4x}: {:.2x}", cpu.pc, bus::read(cpu.bus, cpu.pc))!;
};

export fn cpu::execute(cpu: *cpu) void = {
	let opcode = bus::read(cpu.bus, cpu.pc);
	cpu.pc += 1;
};
