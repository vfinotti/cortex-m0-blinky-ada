# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Set paths
# TOOLCHAIN_PATH = ~/gcc-arm-none-eabi-7-2018-q2-update/bin
#JLINK_PATH = 

# CC = $(TOOLCHAIN_PATH)/arm-none-eabi-gcc
# OBJCPY = $(TOOLCHAIN_PATH)/arm-none-eabi-objcopy
# OBJDUMP = $(TOOLCHAIN_PATH)/arm-none-eabi-objdump
# GDB = $(TOOLCHAIN_PATH)/arm-none-eabi-gdb

TOOLCHAIN_PATH = ~/GNAT/2018-arm-elf/bin

CC = $(TOOLCHAIN_PATH)/arm-eabi-gcc
LD = $(TOOLCHAIN_PATH)/arm-eabi-ld
OBJCPY = $(TOOLCHAIN_PATH)/arm-eabi-objcopy
OBJDUMP = $(TOOLCHAIN_PATH)/arm-eabi-objdump
GDB = $(TOOLCHAIN_PATH)/arm-eabi-gdb

C_CPU_FLAGS = -mtune=cortex-m0 -mthumb -march=armv6-m
C_DEBUG_FLAGS = -g0
C_OTHER_FLAGS =
C_OPTIMIZATION_FLAGS = -O0
C_LANGUAGE_FLAGS = -std=c11
C_INCLUDES = -Icmsis/Include/ -Icmsis

CFLAGS = $(C_CPU_FLAGS) $(C_DEBUG_FLAGS) $(C_OTHER_FLAGS) $(C_OPTIMIZATION_FLAGS) $(C_INCLUDES)
# LD_FLAGS = -T gcc_arm.ld -Wl,-Map=project.map -Wl,--gc-sections -Icmsis/Include/ -Icmsis -nostartfiles
LD_FLAGS = -T gcc_arm.ld -Icmsis/Include/ -Icmsis

C_SOURCES = startup_ARMCM0.c system_ARMCM0.c
C_OBJECTS = $(C_SOURCES:.c=.o)

ADA_SOURCES = main.adb
ADA_OBJECTS = $(ADA_SOURCES:.adb=.o)

all: project.hex project.bin memory.mem

%.o : %.c
	@echo "\n----------------------------"
	@echo "-- Compiling and linking  --"
	@echo "----------------------------\n"
	$(CC) $(CFLAGS) -c -o $@ $<

main.o : main.adb
	$(CC) $(CFLAGS) -c -o $@ $<

project.elf: $(C_OBJECTS) $(ADA_OBJECTS)
	$(LD) -o $@ $(LD_FLAGS) $^

project.bin: project.elf
	$(OBJCPY) -O binary $^ $@

project.hex: project.elf
	$(OBJCPY) -O ihex $^ $@

project.S: project.elf
	$(OBJDUMP) -D $^ > $@

memory.mem: project.bin
	@echo "\n----------------------------"
	@echo "-- Generating memory file --"
	@echo "----------------------------\n"
	./extract_ram.py $^ 0 400000 bin

clean:
	rm -rf *.o *.elf *.bin *.hex *.map project.S *.ali memory.mem main.s
