TARGET  = riscv64-unknown-elf
CC      = $(TARGET)-gcc
CFLAGS  = -march=rv32imc -mabi=ilp32 -Wall -Wextra -pedantic -O2
AS      = $(TARGET)-as
ASFLAGS = -march=rv32imc -mabi=ilp32
LD      = $(CC)
LDS     = firmware.lds
LDFLAGS = -march=rv32imc -mabi=ilp32 -Wl,-T,$(LDS) -ffreestanding -nostartfiles
OBJCOPY = $(TARGET)-objcopy
SOURCES = $(wildcard *.c *.s)
OBJECTS = $(addsuffix .o,$(basename $(SOURCES)))
ELF     = firmware.elf
FWBIN   = firmware.bin
VERILOG = picorv32/picosoc/hx8kdemo.v \
          picorv32/picosoc/spimemio.v \
          picorv32/picosoc/simpleuart.v \
          picorv32/picosoc/picosoc.v \
          picorv32/picorv32.v
BLIF    = picosoc.blif
PCF     = picorv32/picosoc/hx8kdemo.pcf
ASC     = picosoc.asc
BIN     = picosoc.bin

.PHONY: all clean flash flashfw

all: $(BIN) $(FWBIN)

flash: $(BIN) flashfw
	iceprog $(BIN)

flashfw: $(FWBIN)
	iceprog -o 1M $(FWBIN)

clean:
	$(RM) $(BLIF) $(ASC) $(BIN) $(OBJECTS)

$(ELF): $(OBJECTS) $(LDS)
	$(CC) $(LDFLAGS) -o $@ $(OBJECTS)

$(FWBIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

$(BLIF): $(VERILOG)
	yosys -q -p 'synth_ice40 -top hx8kdemo -blif $(BLIF)' $^

$(ASC): $(BLIF) $(PCF)
	arachne-pnr -q -d 8k -o $@ -p $(PCF) $<

$(BIN): $(ASC)
	icepack $< $@
