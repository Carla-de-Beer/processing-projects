// Carla de Beer
// Created: January 2022.
// A grid with squares that gradually rotate out of position (part of Genuary 2022: Destroy a square).
// Design inspired by Ryan Strulh's Genuary 2022 creation.

int cols = 10;
int rows = 10;
int scale = 50;

//int colors[] = {
//  #fff666, #fff777, #fff888, #fff999, #bcffed, #f156fa, #cadebe, #C7DCC7, #BADA55, #FF6666,
//  #3399FF, #cccfff, #FF7373, #dddfff, #fffddd, #eeefff, #fffeee, #a1a1a1, #b2b2b2, #FAD3B3,
//  #d4d4d4, #e5e5e5, #f6f6f6, #bab112, #fbc223, #ccd334, #bbcfed, #bbcddd, #bbcaab, #bbc789
//};

int colors[] = {
  #003049, #d62828, #f77f00, #fcbf49, #eae2b7
};

//int colors[] = {
//  #1c3144, #d00000, #ffba08, #a2aebb, #3f88c5
//};

//int colors[] = {
//  #1c77c3, #39a9db, #40bcd8, #f39237, #d63230
//};

//int colors[] = {
//  #edf5ff, #bac0c7, #6a88ff, #b1d8fd, #dbe3ec, #d03f4a, #a7c0ea
//};


void setup() {
  size(700, 700);
  pixelDensity(displayDensity());
  background(255);
  smooth();

  translate(85, 85);

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {

      //float r = random(255);
      //float g = random(255);
      //float b = random(255);
      //fill(r, g, b, 180);

      fill(colors[(int) random(colors.length)], 185);
      noStroke();

      pushMatrix();
      translate(i*scale, j*scale);
      translate(i*3, j*3);
      rotate(radians(j/1.5) * random(-7, 7));
      rect(0, 0, scale, scale);
      popMatrix();
    }
  }
}

void draw() {
}

void keyPressed() {
  if (key == 'P' || key == 'p') {
    saveFrame("images/square-###.png");
  }
}
