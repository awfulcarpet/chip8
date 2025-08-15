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
	v10: u8,
	v11: u8,
	v12: u8,
	v13: u8,
	v14: u8,
	v15: u8,

	i: u16, // index register for pointing at memory
	sp: u16,
	pc: u16,

	dtimer: u8, // delay timer
	stimer: u8, // sound timer

	bus: *bus,
};

fn cpu::cpu(bus: *bus) cpu = {
	return cpu {
		bus = bus,
		...
	};
};
