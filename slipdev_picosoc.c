#include "slipdev_picosoc.h"
#include "slipdev.h"

#include <stdint.h>

#define UART_CLKDIV (*(volatile uint32_t *) 0x02000004)
#define UART_DATA   (*(volatile  int32_t *) 0x02000008)

void slipdev_picosoc_init(void) {
    UART_CLKDIV = 416; /* 57600 baud at 24 MHz */
    slipdev_init();
}

void slipdev_char_put(uint8_t c) {
    UART_DATA = c;
}

uint8_t slipdev_char_poll(uint8_t *c) {
    int32_t data = UART_DATA;
    if (data != -1) {
        *c = data;
        return 1;
    } else {
        return 0;
    }
}
