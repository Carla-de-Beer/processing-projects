// Carla de Beer
// Created: January 2022.
// 80 colours spread over 800 lines (part of Genuary 2022: 80x800).

// Custom palette (permulation of hex yellow values)
int colors[] = {
  #aaa111, #aaa222, #aaa333, #aaa444, #aaa555, #aaa666, #aaa777, #aaa888, #aaa999, #bbb111,
  #bbb222, #bbb333, #bbb444, #bbb555, #bbb666, #bbb777, #bbb888, #bbb999, #ccc111, #ccc222,
  #ccc333, #ccc444, #ccc555, #ccc666, #ccc777, #ccc888, #ccc999, #ddd111, #ddd222, #ddd333,
  #ddd444, #ddd555, #ddd666, #ddd777, #ddd888, #ddd999, #eee111, #eee222, #eee333, #eee444,
  #eee555, #eee666, #eee777, #eee888, #eee999, #fff111, #fff222, #fff333, #fff444, #fff555,
  #fff666, #fff777, #fff888, #fff999, #bcffed, #f156fa, #cadebe, #C7DCC7, #BADA55, #FF6666,
  #3399FF, #cccfff, #FF7373, #dddfff, #fffddd, #eeefff, #fffeee, #a1a1a1, #b2b2b2, #c3c3c3,
  #d4d4d4, #e5e5e5, #f6f6f6, #bab112, #fbc223, #ccd334, #bbcfed, #bbcddd, #bbcaab, #bbc789
};

// Rainbow colors
//int colors[] = {
//  #ffd6d6, #ffc2c2, #ffadad, #ff9999, #ff8585, #ff7070, #ff5c5c, #ff4747, #ff3333, #ff1f1f, // red
//  #fff1d6, #ffeac2, #ffe2ad, #ffdb99, #ffd485, #ffcd70, #ffc65c, #ffbf47, #ffb833, #ffb01f, // orange
//  #ffffd6, #ffffc2, #ffffad, #ffff99, #ffff85, #ffff70, #ffff5c, #ffff47, #ffff33, #ffff1f, // yellow
//  #d6ffd6, #c2ffc2, #adffad, #99ff99, #85ff85, #70ff70, #5cff5c, #47ff47, #33ff33, #1fff1f, // green
//  #d6ffff, #c2ffff, #adffff, #99ffff, #85ffff, #70ffff, #5cffff, #47ffff, #33ffff, #1fffff, // cyan
//  #0000ff, #0000f5, #0000e0, #0000cc, #0000b8, #0000a3, #00008f, #00007a, #000066, #000052, // blue
//  #cb8df6, #c27af5, #b967f4, #b054f2, #a841f1, #9f2eff, #961bee, #8c11e4, #8010d1, #750ebe, // purple
//  #ffebee, #ffd6dd, #ffc0cb, #ffadbb, #ff99aa, #ff8599, #ff7088, #ff5c77, #ff4766, #ff3355// pink
//};

void setup() {
  size(800, 800);
  pixelDensity(displayDensity());
  background(255);
  strokeWeight(4);
  strokeCap(SQUARE);

  translate(2, 0);

  drawLine(0, height * 0.25 - 4);
  drawLine(height * 0.25, height * 0.5 - 4);
  drawLine(height * 0.5, height * 0.75 - 4);
  drawLine(height * 0.75, height);
}

void drawLine(float start, float end) {
  for (int i = 0, j = 0; i < width; i+=4, j++) {
    int r = (int) random(0, colors.length);
    stroke(colors[r]);
    //stroke(colors[j % 80]);
    line(i, (int)start, i, (int)end);
  }
}

void draw() {
}

void keyPressed() {
  if (key == 'P' || key == 'p') {
    saveFrame("images/80x800-###.png");
  }
}
