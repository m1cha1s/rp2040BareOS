
ARMGNU ?= arm-none-eabi

XCPU = -mcpu=cortex-m0

AOPS = --warn --fatal-warnings $(XCPU)
LOPS = -nostdlib

all : bareos.uf2

clean:
	rm -f *.bin
	rm -f *.o
	rm -f *.elf
	rm -f *.list
	rm -f *.uf2
	rm -f makeuf2
	
makeuf2 : makeuf2.c crcpico.h
	gcc -O2 makeuf2.c -o makeuf2
	
bareos.uf2 : bareos.bin makeuf2
	./makeuf2 bareos.bin bareos.uf2

start.o : start.s
	$(ARMGNU)-as $(AOPS) start.s -o start.o

bareos.bin :               memmap.ld start.o
	$(ARMGNU)-ld $(LOPS) -T memmap.ld start.o -o bareos.elf
	$(ARMGNU)-objdump -D bareos.elf > bareos.list
	$(ARMGNU)-objcopy -O binary bareos.elf bareos.bin