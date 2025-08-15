use fmt;
use fs;
use io;
use os;

// 4k of addressable memory
def ADR_MEM = 4096;
def FB = 4096;
def FB_LEN = SCREEN_WIDTH * SCREEN_HEIGHT;

type bus = struct {
	ram: [ADR_MEM]u8,
	fb: [FB_LEN]u8,
};

fn bus::write(bus: *bus, adr: u16, data: u8) void = {
	assert (adr < FB + FB_LEN);

	if (adr < ADR_MEM) {
		bus.ram[adr] = data;
		return;
	};

	bus.fb[adr - FB] = data;
};

fn bus::read(bus: *bus, adr: u16) u8 = {
	assert(adr < FB + FB_LEN);

	if (adr < ADR_MEM) {
		return bus.ram[adr];
	};

	return bus.fb[adr - FB];
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
