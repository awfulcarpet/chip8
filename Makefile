.POSIX:
.SUFFIXES:

HARE = hare
HARELIBS = -lSDL2
HAREFLAGS =

DESTDIR =
PREFIX = /usr/local
BINDIR = $(PREFIX)/bin

HARE_SOURCES != find . -name '*.ha'

all: chip8

run: chip8
	./chip8 roms/7-beep.ch8

chip8: $(HARE_SOURCES)
	$(HARE) build $(HAREFLAGS) $(HARELIBS) -o $@ cmd/$@/

check:
	$(HARE) test $(HAREFLAGS) $(HARELIBS) cmd/chip8

clean:
	rm -f chip8

install:
	install -Dm755 chip8 $(DESTDIR)$(BINDIR)/chip8

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/chip8

.PHONY: all check clean install uninstall
