    global io_hlt, io_cli, io_sti, iostihlt
    global io_in8, io_in16, io_in32
    global io_out8, io_out16, io_out32
    global io_load_eflags, io_store_eflags

    section .text
io_hlt:             ; void io_hlt(); 停机
    hlt
    ret

io_cli:             ; void io_cli(); 关中断 (clear interrupt flag)
    cli
    ret

io_sti:             ; void io_sti(); 开中断 (set interrupt flag)
    sti
    ret

io_stihlt:          ; void io_stihlt(); 开中断并停机
    sti
    hlt
    ret

io_in8:             ; int io_in8(int port); 从端口 port 读取一个字节
    mov edx, [esp+4]
    mov eax, 0
    in ax, dx
    ret

io_in16:            ; int io_in16(int port); 从端口 port 读取一个字
    mov edx, [esp+4]
    mov eax, 0
    in ax, dx
    ret

io_in32:            ; int io_in32(int port); 从端口 port 读取一个双字
    mov edx, [esp+4]
    in eax, dx
    ret

io_out8:            ; void io_out8(int port, int data); 向端口 port 写入一个字节
    mov edx, [esp+4]
    mov al, [esp+8]
    out dx, al
    ret

io_out16:           ; void io_out16(int port, int data); 向端口 port 写入一个字
    mov edx, [esp+4]
    mov ax, [esp+8]
    out dx, ax
    ret

io_out32:           ; void io_out32(int port, int data); 向端口 port 写入一个双字
    mov edx, [esp+4]
    mov eax, [esp+8]
    out dx, eax
    ret

io_load_eflags:     ; int io_load_eflags(); 读取 EFLAGS 寄存器
    pushfd
    pop eax
    ret

io_store_eflags:    ; void io_store_eflags(int eflags); 写入 EFLAGS 寄存器
    mov eax, [esp+4]
    push eax
    popfd
    ret
