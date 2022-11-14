void io_hlt();
void io_cli();
void io_sti();
void io_out8(int port, int data);
int io_load_eflags();
void io_store_eflags(int eflags);

void init_palette(unsigned char *rgb_table, int col_num);
void box_fill8(unsigned char *vram, int xsize, unsigned char c,
        int x0, int y0, int x1, int y1);

enum COL8 {
    COL8_BLACK,
    COL8_RED,
    COL8_GREEN,
    COL8_YELLOW,
    COL8_BLUE,
    COL8_PURPLE,
    COL8_CYAN,
    COL8_WHITE,
    COL8_GRAY,
    COL8_DIM_RED,
    COL8_DIM_GREEN,
    COL8_DIM_YELLOW,
    COL8_DIM_BLUE,
    COL8_DIM_PURPLE,
    COL8_LIGHT_DIM_BLUE,
    COL8_DIM_GRAY,
};
static unsigned char rgb_table[] = {
    0x00, 0x00, 0x00, // black
    0xff, 0x00, 0x00, // red
    0x00, 0xff, 0x00, // green
    0xff, 0xff, 0x00, // yellow
    0x00, 0x00, 0xff, // blue
    0xff, 0x00, 0xff, // purple
    0x00, 0xff, 0xff, // cyan
    0xff, 0xff, 0xff, // white
    0xc6, 0xc6, 0xc6, // gray
    0x84, 0x00, 0x00, // dim red
    0x00, 0x84, 0x00, // dim green
    0x84, 0x84, 0x00, // dim yellow
    0x00, 0x00, 0x84, // dim blue
    0x84, 0x00, 0x84, // dim purple
    0x00, 0x84, 0x84, // light dim blue
    0x84, 0x84, 0x84, // dim gray
};

int main() {
    unsigned char *vram = (unsigned char *) 0xa0000;
    int xsize = 320, ysize = 200;

    init_palette(rgb_table, 16);

    box_fill8(vram, xsize, COL8_DIM_BLUE, 0, 0, xsize - 1, ysize - 1);
    box_fill8(vram, xsize, COL8_WHITE, 0, ysize - 28, xsize - 1, ysize - 28);
    box_fill8(vram, xsize, COL8_DIM_GRAY, 0, ysize - 27, xsize - 1, ysize - 1);

    while(1) {
        io_hlt();
    }
}

void init_palette(unsigned char *rgb_table, int col_num) {
    int eflags = io_load_eflags();
    io_cli();

    io_out8(0x03c8, 0);
    for (int i = 0; i < col_num; i++) {
        io_out8(0x03c9, rgb_table[0] / 4);
        io_out8(0x03c9, rgb_table[1] / 4);
        io_out8(0x03c9, rgb_table[2] / 4);
        rgb_table += 3;
    }

    io_store_eflags(eflags);
}

void box_fill8(unsigned char *vram, int xsize, unsigned char c,
        int x0, int y0, int x1, int y1) {
    for (int y = y0; y <= y1; y++) {
        for (int x = x0; x <= x1; x++) {
            vram[y * xsize + x] = c;
        }
    }
}