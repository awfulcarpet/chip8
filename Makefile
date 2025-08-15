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
	./chip8

chip8: $(HARE_SOURCES)
	$(HARE) build $(HAREFLAGS) $(HARELIBS) -o $@ cmd/$@/

check:
	$(HARE) test $(HAREFLAGS)

clean:
	rm -f chip8

install:
	install -Dm755 chip8 $(DESTDIR)$(BINDIR)/chip8

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/chip8

.PHONY: all check clean install uninstall
