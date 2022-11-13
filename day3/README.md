# Day3's Notes

## 汇编

### 汇编指令

最常用的汇编指令有: `mov`, `and`, `or`, `xor`, `add`, `sub`, `inc`, `dec`, `syscall` 等等.

注意在 nasm 中, 第一个参数是目的地, 第二个参数是源地址. 也就是说, `mov x, y` 的意思是 `x = y`.

nasm 中还有一个非常常用的伪指令 `db`, 用来定义一个或多个字节. 例如 `db 0x90` 就是定义了一个字节, 值为 `0x90`.

以下例子来自 nasm 官方文档.

```asm
db    0x55                ; just the byte 0x55
db    0x55,0x56,0x57      ; three bytes in succession
db    'a',0x55            ; character constants are OK
db    'hello',13,10,'$'   ; so are string constants
dw    0x1234              ; 0x34 0x12
dw    'a'                 ; 0x61 0x00 (it's just a number)
dw    'ab'                ; 0x61 0x62 (character constant)
dw    'abc'               ; 0x61 0x62 0x63 0x00 (string)
dd    0x12345678          ; 0x78 0x56 0x34 0x12
dd    1.234567e20         ; floating-point constant
dq    0x123456789abcdef0  ; eight byte constant
dq    1.234567e20         ; double-precision float
dt    1.234567e20         ; extended-precision float
```

伪指令 `resb` 用来预留一段空间 (不初始化), 例如 `resb 0x100` 就是预留了 256 个字节的空间.

TODO
