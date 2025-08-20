use sdl;
use sdl = sdl::scancode;
use sdl = sdl::events;

type keypad = enum u8 {
	ONE = 0x1,
	TWO = 0x2,
	THREE = 0x3,
	FOUR = 0xc,

	Q = 0x4,
	W = 0x5,
	E = 0x6,
	R = 0xd,

	A = 0x7,
	S = 0x8,
	D = 0x9,
	F = 0xe,

	Z = 0xa,
	X = 0x0,
	C = 0xb,
	V = 0xf,
};

fn input::handle(bus: *bus, ev: (sdl::key_pressed | sdl::key_released)) void = {
	let scancode = sdl::scancode::UNKNOWN;
	let state = 0u8;

	if (ev is sdl::key_released) {
		state = 0;
		scancode = (ev as sdl::key_released).keysym.scancode;
	};

	if (ev is sdl::key_pressed) {
		state = 1;
		scancode = (ev as sdl::key_pressed).keysym.scancode;
		if ((ev as sdl::key_pressed).repeat == true)
		return;
	};

	switch (scancode) {
	case sdl::scancode::_1=>
		bus::write(bus, KEY + keypad::ONE, state);
	case sdl::scancode::_2 =>
		bus::write(bus, KEY + keypad::TWO, state);
	case sdl::scancode::_3 =>
		bus::write(bus, KEY + keypad::THREE, state);
	case sdl::scancode::_4 =>
		bus::write(bus, KEY + keypad::FOUR, state);
	case sdl::scancode::Q =>
		bus::write(bus, KEY + keypad::Q, state);
	case sdl::scancode::W =>
		bus::write(bus, KEY + keypad::W, state);
	case sdl::scancode::E =>
		bus::write(bus, KEY + keypad::E, state);
	case sdl::scancode::R =>
		bus::write(bus, KEY + keypad::R, state);
	case sdl::scancode::A =>
		bus::write(bus, KEY + keypad::A, state);
	case sdl::scancode::S =>
		bus::write(bus, KEY + keypad::S, state);
	case sdl::scancode::D =>
		bus::write(bus, KEY + keypad::D, state);
	case sdl::scancode::F =>
		bus::write(bus, KEY + keypad::F, state);
	case sdl::scancode::Z =>
		bus::write(bus, KEY + keypad::Z, state);
	case sdl::scancode::X =>
		bus::write(bus, KEY + keypad::X, state);
	case sdl::scancode::C =>
		bus::write(bus, KEY + keypad::C, state);
	case sdl::scancode::V =>
		bus::write(bus, KEY + keypad::V, state);
	case =>
		void;
	};
};
