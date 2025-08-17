use fmt;
use fs;
use io;
use os;

// 4k of addressable memory
def ADR_MEM = 4096;
def FB = 4096;
def FB_LEN = SCREEN_WIDTH * SCREEN_HEIGHT;
def KEY: u16 = ADR_MEM + FB_LEN;
def KEY_LEN = 16;

type bus = struct {
	ram: [ADR_MEM]u8,
	fb: [FB_LEN]u8,
	key: [KEY_LEN]u8,
};

fn bus::write(bus: *bus, adr: u16, data: u8) void = {
	assert (adr < ADR_MEM + FB_LEN + KEY_LEN);

	if (adr < ADR_MEM) {
		bus.ram[adr] = data;
		return;
	};

	if (adr < ADR_MEM + FB_LEN) {
		bus.fb[adr - FB] = data;
		return;
	};

	if (adr < ADR_MEM + FB_LEN + KEY_LEN) {
		bus.key[adr - KEY] = data;
	};
};

fn bus::read(bus: *bus, adr: u16) u8 = {
	assert (adr < ADR_MEM + FB_LEN + KEY_LEN);

	if (adr < ADR_MEM) {
		return bus.ram[adr];
	};

	if (adr < ADR_MEM + FB_LEN) {
		return bus.fb[adr - FB];
	};

	if (adr < ADR_MEM + FB_LEN + KEY_LEN) {
		return bus.key[adr - KEY];
	};

	assert(false, "bus read adr is out of bounds");
	return 0xff;
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
