use fmt;

export fn main() void = {
	let bus = bus { ... };
	let cpu = cpu::cpu(&bus);

	fmt::println("hello, world")!;
};
