use fmt;
use fs;
use io;
use os;

// 4k of addressable memory
export def ADR_MEM = 4096;

export type bus = struct {
	ram: [ADR_MEM]u8,
};

export fn bus::write(bus: *bus, adr: u16, data: u8) void = {
	assert(adr < ADR_MEM);

	bus.ram[adr] = data;
};

export fn bus::read(bus: *bus, adr: u16) u8 = {
	assert(adr < ADR_MEM);

	return bus.ram[adr];
};


export fn open(bus: *bus, path: str) void = {
	const rom = match (os::open(path)) {
	case let err: fs::error =>
		fmt::fatalf("err in opening {}: {}", path, fs::strerror(err));
	case let file: io:: file =>
		yield file;
	};
	defer io::close(rom)!;

	io::read(rom, bus.ram[0x200..ADR_MEM])!;
};
