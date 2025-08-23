# chip8
A simple chip8 emulator written in [Hare] using [SDL2]

[Hare]: https://harelang.org
[SDL2]: https://libsdl.org

## Building
* Install `libsdl2` and the `hare` programming language
* Run `make` to create the main binary.
* Example roms are in the roms directory

## Usage
```sh
$ chip8 roms/RPS.ch8
$ chip8 -h # print help and flags
```

## Controls
controls will vary by game but the following keys map to the following keypad
| Key |     |     |     |
| :-: | :-: | :-: | :-: |
| 1  | 2  | 3  | 4  |
| Q  | W  | E  | R  |
| A  | S  | D  | F  |
| Z  | X  | C  | V  |

| Mapping | |     |     |
| :-: | :-: | :-: | :-: |
| 1  | 2  | 3  | C  |
| 4  | 5  | 6  | D  |
| 7  | 8  | 9  | E  |
| A  | 0  | B  | F  |

