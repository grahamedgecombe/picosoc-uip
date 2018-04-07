.extern bss_start
.extern bss_end

.extern data_flash_start
.extern data_start
.extern data_end

.global start
start:
    # zero the BSS section
    la t0, bss_start
    la t1, bss_end

    beq t0, t1, clear_bss_done
clear_bss:
    sw zero, 0(t0)
    addi t0, t0, 4
    bne t0, t1, clear_bss
clear_bss_done:

    # copy the data section from flash to RAM
    la t0, data_flash_start
    la t1, data_start
    la t2, data_end

    beq t1, t2, copy_data_done
copy_data:
    lw t3, 0(t0)
    sw t3, 0(t1)
    addi t0, t0, 4
    addi t1, t1, 4
    bne t1, t2, copy_data
copy_data_done:

    # zero register file
    li x1, 0
    # x2 (sp) is initialized by reset
    li x3, 0
    li x4, 0
    li x5, 0
    li x6, 0
    li x7, 0
    li x8, 0
    li x9, 0
    li x10, 0
    li x11, 0
    li x12, 0
    li x13, 0
    li x14, 0
    li x15, 0
    li x16, 0
    li x17, 0
    li x18, 0
    li x19, 0
    li x20, 0
    li x21, 0
    li x22, 0
    li x23, 0
    li x24, 0
    li x25, 0
    li x26, 0
    li x27, 0
    li x28, 0
    li x29, 0
    li x30, 0
    li x31, 0

    call main
    j .
