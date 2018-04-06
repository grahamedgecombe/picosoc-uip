TARGET  = riscv64-unknown-elf
CC      = $(TARGET)-gcc
CFLAGS  = -march=rv32imc -mabi=ilp32 -Wall -Wextra -pedantic -O2
SOURCES = slipdev_picosoc.c
OBJECTS = $(addsuffix .o,$(basename $(SOURCES)))
VERILOG = picorv32/picosoc/hx8kdemo.v \
          picorv32/picosoc/spimemio.v \
          picorv32/picosoc/simpleuart.v \
          picorv32/picosoc/picosoc.v \
          picorv32/picorv32.v
BLIF    = picosoc.blif
PCF     = picorv32/picosoc/hx8kdemo.pcf
ASC     = picosoc.asc
BIN     = picosoc.bin

.PHONY: all clean

all: $(BIN) $(OBJECTS)

clean:
	$(RM) $(BLIF) $(ASC) $(BIN) $(OBJECTS)

$(BLIF): $(VERILOG)
	yosys -q -p 'synth_ice40 -top hx8kdemo -blif $(BLIF)' $^

$(ASC): $(BLIF) $(PCF)
	arachne-pnr -q -d 8k -o $@ -p $(PCF) $<

$(BIN): $(ASC)
	icepack $< $@
