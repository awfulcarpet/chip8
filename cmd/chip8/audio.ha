use sdl = sdl::audio;
use math;
use types;

def SAMPLE_RATE = 48000;
def SAMPLES = 4096;

def A4 = 440.00;
def VOLUME = 0.5;

let frequency: f32 = A4;
let volume: f32 = VOLUME;

// returns next step for a sin wave of freq
fn tone(freq: f32, vol: f32) f32 = {
	static let cur: f32 = 0.0;
	cur += (2.0 * math::PI): f32 / SAMPLE_RATE: f32 * freq;
	return math::sinf64(cur): f32 * vol;
};


// caller must call close_audio_device
fn audio::init(freq: f32, vol: f32) sdl::audio_device_id = {
	let spec = sdl::audio_spec {
		freq = SAMPLE_RATE,
		format = sdl::audio_format::F32,
		channels = 1,
		samples = SAMPLES,
		callback = &play,
		...
	};
	let dev = sdl::open_audio_device(void, 0, &spec, null, 0)!;

	sdl::pause_audio_device(dev, false);

	frequency = freq;
	volume = vol;

	return dev;
};

fn audio::close(id: sdl::audio_device_id) void = {
	sdl::close_audio_device(id);
};

fn play(userdata: nullable *opaque, stream: *u8, len_: int) void = {
	let fs = stream: *[*]f32;
	for (let i = 0z; i: int < SAMPLES; i += 1) {
		fs[i] = tone(frequency, volume);
	};
};
