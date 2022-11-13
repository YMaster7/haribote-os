void io_hlt(); // 调用汇编语言的函数

int main() {
fin:
    io_hlt();
    goto fin;
}