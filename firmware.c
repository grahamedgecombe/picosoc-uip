#include <stdint.h>

#define UART_CLKDIV (*(volatile uint32_t *) 0x02000004)
#define UART_DATA   (*(volatile  int32_t *) 0x02000008)
#define LEDS        (*(volatile uint32_t *) 0x03000000)

int main(void) {
    LEDS = 0xff;
    UART_CLKDIV = 104;

    for (;;) {
        int32_t c = UART_DATA;
        if (c != -1) {
            UART_DATA = c;
        }
    }
}
