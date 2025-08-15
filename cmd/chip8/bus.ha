use fmt;
use fs;
use io;
use os;

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


fn open(bus: *bus, rom: str) void = {
	const rom = match (os::open(rom)) {
	case let err: fs::error =>
		fmt::fatalf("err in opening {}: {}", rom, fs::strerror(err));
	case let file: io:: file =>
		yield file;
	};
	defer io::close(rom)!;

	io::read(rom, bus.ram[0x200..ADR_MEM])!;
};
