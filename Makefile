NAME := ttf_bindings

all:
	odin run test -extra-linker-flags:"-Wl,-rpath /usr/local/lib64"
