TARGET  = riscv64-unknown-elf
CC      = $(TARGET)-gcc
CFLAGS  = -march=rv32imc -mabi=ilp32 -Wall -Wextra -pedantic -O2 -Iuip
UIPOPT  = uip/uip/uipopt.h
SOURCES = slipdev_picosoc.c
OBJECTS = $(addsuffix .o,$(basename $(SOURCES)))

.PHONY: all clean

all: $(OBJECTS)

clean:
	$(RM) $(OBJECTS)

$(OBJECTS): $(UIPOPT)

$(UIPOPT):
	ln -rs uipopt.h $@
