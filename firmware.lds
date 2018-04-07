MEMORY {
    ram   (rwx) : ORIGIN = 0x00000000, LENGTH = 8K
    flash (rx)  : ORIGIN = 0x00100000, LENGTH = 3M
}

SECTIONS {
    .text : {
        start*(.text);
        *(.text);
    } > flash

    .rodata : {
        *(.rodata);
    } > flash

    data_flash_start = .;

    .data : AT (data_flash_start) {
        . = ALIGN(4);
        data_start = .;
        *(.data);

        . = ALIGN(4);
        data_end = .;
    } > ram

    .bss : {
        . = ALIGN(4);
        bss_start = .;
        *(.bss);

        . = ALIGN(4);
        bss_end = .;
    } > ram
}
