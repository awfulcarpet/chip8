// 4k of addressable memory
def ADR_MEM = 4096;

type bus = struct {
	ram: [ADR_MEM]u8,
};

fn bus::write(bus: *bus, adr: u16, data: u8) void = {
	assert(adr < ADR_MEM);

	bus.ram[adr] = data;
};

fn bus::read(bus: *bus, adr: u16) u8 = {
	assert(adr < ADR_MEM);

	return bus.ram[adr];
};
