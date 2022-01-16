# Requires: petcat (included in Vice)
# Requires: cc65

all: vic_bas.prg plus4_bas.prg c64_bas.prg c64_c.prg c64_asm.prg

# xvic -memory 3k --cartA vic-20-super-expander-rom.prg vic_bas.prg

vic_bas.prg: vic_bas.txt
	petcat -wsuperexp -o vic_bas.prg vic_bas.txt

# xplus4 plus4_bas.prg

plus4_bas.prg: plus4_bas.txt
	petcat -w3 -o plus4_bas.prg plus4_bas.txt

# x64 --cartcrt SIMON.CRT c64_bas.prg

c64_bas.prg: c64_bas.txt
	petcat -wsimon -o c64_bas.prg c64_bas.txt

# x64 c64_c.prg

c64_c.prg: c64_c.c
	cl65 -t c64 -o c64_c.prg c64_c.c

# x64 c64_asm.prg

c64_asm.prg: c64_asm.s
	cl65 -t none -o c64_asm.prg c64_asm.s

clean:
	rm *_bas.prg *_c.prg *_asm.prg *.o

