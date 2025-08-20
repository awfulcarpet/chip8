use types::c;
// Audio format flags.
//
// Current representation (unspecified bits are always zero):
//
// 	++-----------------------sample is signed if set
// 	||
// 	||       ++-----------sample is bigendian if set
// 	||       ||
// 	||       ||          ++---sample is float if set
// 	||       ||          ||
// 	||       ||          || +---sample bit size---+
// 	||       ||          || |                     |
// 	15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
export type SDL_AudioFormat = u16;

// Unsigned 8-bit samples
export def AUDIO_U8: SDL_AudioFormat = 0x0008;
// Signed 8-bit samples
export def AUDIO_S8: SDL_AudioFormat = 0x8008;
// Unsigned 16-bit samples, little-endian
export def AUDIO_U16LSB: SDL_AudioFormat = 0x0010;
// Signed 16-bit samples, little-endian
export def AUDIO_S16LSB: SDL_AudioFormat = 0x8010;
// Unsigned 16-bit samples, big-endian
export def AUDIO_U16MSB: SDL_AudioFormat = 0x1010;
// Signed 16-bit samples, big-endian
export def AUDIO_S16MSB: SDL_AudioFormat = 0x9010;
// Unsigned 16-bit samples
export def AUDIO_U16: SDL_AudioFormat = AUDIO_U16LSB;
// Signed 16-bit samples
export def AUDIO_S16: SDL_AudioFormat = AUDIO_S16LSB;

export type SDL_AudioDeviceID = u32;
export type SDL_AudioCallback = fn(userdata: *opaque, stream: *u8, len_: int) void;

export type SDL_AudioSpec = struct {
	freq: int,                   //*< DSP frequency -- samples per second */
	format: SDL_AudioFormat,     //< Audio data format */
	channels: u8,             //< Number of channels: 1 mono, 2 stereo */
	silence: u8,              //< Audio buffer silence value (calculated) */
	samples: u16,             //< Audio buffer size in sample FRAMES (total samples divided by channel count) */
	padding: u16,             //< Necessary for some compile environments */
	size_: u32,                //< Audio buffer size in bytes (calculated) */
	callback: *SDL_AudioCallback, //< Callback that feeds the audio device (NULL to use SDL_QueueAudio()). */
	userdata: *opaque,             //< Userdata passed to callback (ignored for NULL callbacks). */
};

export @symbol("SDL_OpenAudioDevice") fn SDL_OpenAudioDevice(device: const *c::char,
	iscapture: int, desired: const *SDL_AudioSpec, obtained: *SDL_AudioSpec,
	allowed_changes: int) SDL_AudioDeviceID;

export @symbol("SDL_PauseAudioDevice") fn SDL_PauseAudioDevice(id: SDL_AudioDeviceID,
	pause_on: int) void;
