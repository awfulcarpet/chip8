use fmt;
use sdl2;
use sdl2::{ SDL_Scancode };

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

fn input::handle(bus: *bus, ev: sdl2::SDL_KeyboardEvent) void = {
	if (ev.repeat == 1)
		return;

	switch (ev.keysym.scancode) {
	case SDL_Scancode::ONE =>
		bus::write(bus, KEY + keypad::ONE, ev.state);
	case SDL_Scancode::TWO =>
		bus::write(bus, KEY + keypad::TWO, ev.state);
	case SDL_Scancode::THREE =>
		bus::write(bus, KEY + keypad::THREE, ev.state);
	case SDL_Scancode::FOUR =>
		bus::write(bus, KEY + keypad::FOUR, ev.state);
	case SDL_Scancode::Q =>
		bus::write(bus, KEY + keypad::Q, ev.state);
	case SDL_Scancode::W =>
		bus::write(bus, KEY + keypad::W, ev.state);
	case SDL_Scancode::E =>
		bus::write(bus, KEY + keypad::E, ev.state);
	case SDL_Scancode::R =>
		bus::write(bus, KEY + keypad::R, ev.state);
	case SDL_Scancode::A =>
		bus::write(bus, KEY + keypad::A, ev.state);
	case SDL_Scancode::S =>
		bus::write(bus, KEY + keypad::S, ev.state);
	case SDL_Scancode::D =>
		bus::write(bus, KEY + keypad::D, ev.state);
	case SDL_Scancode::F =>
		bus::write(bus, KEY + keypad::F, ev.state);
	case SDL_Scancode::Z =>
		bus::write(bus, KEY + keypad::Z, ev.state);
	case SDL_Scancode::X =>
		bus::write(bus, KEY + keypad::X, ev.state);
	case SDL_Scancode::C =>
		bus::write(bus, KEY + keypad::C, ev.state);
	case SDL_Scancode::V =>
		bus::write(bus, KEY + keypad::V, ev.state);
	case =>
		void;
	};
};
