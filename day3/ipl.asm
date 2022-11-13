CYLS   EQU   10               ; 读取的柱面数量（CYLS = cylinders）

    ORG   0x7c00            ; 指明程序的装载地址

; 用于标准FAT12格式的软盘
    JMP   entry             ; 跳转指令
    NOP                     ; NOP指令
    DB    "HARIBOTE"        ; OEM标识符（8字节）
    DW    512               ; 每个扇区（sector）的字节数（必须为512字节）
    DB    1                 ; 每个簇（cluster）的扇区数（必须为1个扇区）
    DW    1                 ; FAT的预留扇区数（包含boot扇区）
    DB    2                 ; FAT表的数量，通常为2
    DW    224               ; 根目录文件的最大值（一般设为224项）
    DW    2880              ; 磁盘的扇区总数，若为0则代表超过65535个扇区，需要使用22行记录
    DB    0xf0              ; 磁盘的种类（本项目中设为0xf0代表1.44MB的软盘）
    DW    9                 ; 每个FAT的长度（必须为9扇区）
    DW    18                ; 1个磁道（track）拥有的扇区数（必须是18）
    DW    2                 ; 磁头数（必须为2）
    DD    0                 ; 隐藏的扇区数
    DD    2880              ; 大容量扇区总数，若16行记录的值为0则使用本行记录扇区数
    DB    0                 ; 中断0x13的设备号
    DB    0                 ; Windows NT标识符
    DB    0x29              ; 扩展引导标识
    DD    0xffffffff        ; 卷序列号
    DB    "HARIBOTEOS "     ; 卷标（11字节）
    DB    "FAT12   "        ; 文件系统类型（8字节）
    TIMES 18 DB 0           ; 空白区域（18字节）

; 程序核心

entry:
    mov ax, 0           ; 初始化寄存器
    mov ss, ax
    mov sp, 0x7c00
    mov ds, ax

    ; 读取软盘, 每个软盘有 0-79 共 80 个柱面, 每个柱面有 1-18 共 18 个扇区
    mov ax, 0x0820
    mov es, ax          ; 读取的数据存放在 0x0820 处
    mov ch, 0           ; 柱面号
    mov dh, 0           ; 磁头号
    mov cl, 2           ; 扇区号

readloop:
    mov si, 0           ; 失败次数
retry:
    mov ah, 0x02        ; 读取扇区
    mov al, 1           ; 读取 1 个扇区
    mov bx, 0           ; 缓冲区偏移地址
    mov dl, 0           ; 驱动器号
    int 0x13            ; 调用 BIOS
    jnc next            ; 无错误则跳转到 next 标签处

    ; 读取失败
    inc si              ; 失败次数加 1
    cmp si, 5           
    jae error           ; 失败次数大于 5 则跳转到 error 标签处

    mov ah, 0x00
    mov dl, 0x00
    int 0x13            ; 重置驱动器
    jmp retry           ; 重新读取

next:
    ; 段寄存器 es += 0x20
    mov ax, es
    add ax, 0x20
    mov es, ax

    inc cl              ; 扇区号加 1
    cmp cl, 18
    jbe readloop        ; 扇区号小于等于 18 则跳转到 readloop 标签处

    ; 读取反面
    mov cl, 1           ; 扇区号
    inc dh              ; 磁头号加 1
    cmp dh, 2
    jb readloop         ; 磁头号小于等于 1 则跳转到 readloop 标签处

    ; 读取下个柱面
    mov dh, 0
    inc ch              ; 柱面号加 1
    cmp ch, CYLS
    jb readloop         ; 柱面号小于 CYLS 则跳转到 readloop 标签处

    ; 读取完成
    mov [0x0ff0], ch    ; 将柱面号存入 0x0ff0 处
    jmp 0xc200          ; 跳转到 0xc200 处, 执行 haribote.sys

fin:
    hlt
    jmp fin

error:
    mov si, msg

putloop:
    mov al, [si]
    inc si
    cmp al, 0
    je fin
    
    ; 输出字符
    mov ah, 0x0e
    mov bx, 15           ; 黑底白字
    int 0x10
    jmp putloop

msg:
    db `\n\nload error\n`, 0

    times 0x1fe - ($ - $$) db 0
    db 0x55, 0xaa        ; 引导扇区结束标志
