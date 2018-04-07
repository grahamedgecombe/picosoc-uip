#include "httpd.h"
#include "slipdev.h"
#include "slipdev_picosoc.h"
#include "uip.h"

#include <stdint.h>

#define LEDS (*(volatile uint32_t *) 0x03000000)

static inline uint32_t rdcycle(void) {
    uint32_t cycle;
    asm volatile ("rdcycle %0" : "=r"(cycle));
    return cycle;
}

int main(void) {
    LEDS = 0xAA;

    slipdev_picosoc_init();
    uip_init();
    httpd_init();

    uint32_t last_periodic = rdcycle();

    for (;;) {
        uip_len = slipdev_poll();
        if (uip_len > 0) {
            uip_input();
            if (uip_len > 0) {
                slipdev_send();
            }
        }

        uint32_t now = rdcycle();
        if ((now - last_periodic) >= 12000000) {
            last_periodic = now;

            for (uint8_t i = 0; i < UIP_CONNS; i++) {
                uip_periodic(i);
                if (uip_len > 0) {
                    slipdev_send();
                }
            }
        }
    }
}
