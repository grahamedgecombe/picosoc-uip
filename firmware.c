#include "slipdev.h"
#include "slipdev_picosoc.h"
#include "uip.h"
#include "uip_arp.h"

#include <stdint.h>

#define LEDS (*(volatile uint32_t *) 0x03000000)

int main(void) {
    LEDS = 0xAA;

    slipdev_picosoc_init();
    uip_init();

    for (;;) {
        uip_len = slipdev_poll();
        if (uip_len > 0) {
            uip_input();
            if (uip_len > 0) {
                slipdev_send();
            }
        }
    }
}

void discard_app(void) {
    /* empty */
}
