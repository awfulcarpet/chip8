use sdl = sdl::audio;
use math;

def SAMPLE_RATE = 48000;

// caller must call close_audio_device
fn audio::init() sdl::audio_device_id = {
	let spec = sdl::audio_spec {
		freq = SAMPLE_RATE,
		format = sdl::audio_format::S16,
		channels = 1,
		samples = 4096,
		callback = &play,
		...
	};
	let dev = sdl::open_audio_device(void, 0, &spec, null, 0)!;

	sdl::pause_audio_device(dev, false);

	return dev;
};

fn audio::close(id: sdl::audio_device_id) void = {
	sdl::close_audio_device(id);
};

fn play(userdata: nullable *opaque, stream: *u8, len_: int) void = {
	for (let i = 0z; i: int < len_; i += 1) {
		(stream: *[*]u8)[i] = (math::sinf64(i: f64) * 100000.0): u8;
	};
};
