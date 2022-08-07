# - RUN THE FOLLOWING TARGETS TO KNOW
# HOW TO CROSS-COMPILE WITH GO:
#
# 	make help-os
# 	make help-arch
#
#	make <target>
#

# lua tcc.lua <source> -o <output>


TCC=lua tcc.lua
all: current
current:
	lua tcc.lua main -o main


linux:
	lua tcc.lua main -o main -i linux amd64
linux-i386:
	lua tcc.lua main -o main -i linux 386


windows:
	lua tcc.lua main -o main.exe -i windows amd64
windows-386:
	lua tcc.lua main -o main.exe -i windows 386


macos-x64:
	lua tcc.lua main -o main -i darwin amd64
macos-arm64:
	lua tcc.lua main -o main -i darwin arm64

	
debugger:
	lua tcc.lua main -op main
run:
	lua tcc.lua main --run main



help-os:
	@echo "\n$(TCC) <source> -o <binary> -i <os>\n"
	@echo "<os> = aix android darwin dragonfly freebsd hurd\nillumos ios js linux nacl netbsd openbsd plan9 solaris windows zos\n"
help-arch:
	@echo "\n$(TCC) <source> -o <binary> -i <os> <arch>\n"
	@echo "<arch> = 386 amd64 amd64p32 arm arm64 arm64be\narmbe loong64 mips mips64 mips64le mips64p32le\nmipsle ppc ppc64 ppc64le riscv riscv64\ns390 s390x sparc sparc64 wasm\n"
