// Carla de Beer
// Created: April 2018.
// De Jong Attractor.
// Inspiration taken from:
// http://www.algosome.com/articles/strange-attractors-de-jong.html
// http://paulbourke.net/fractals/peterdejong/
// Uncomment any of the variable sets inside setup.

int stop = 1000000;
PVector curr, next;
float x, y;
float a, b, c, d;
int offX, offY;
float scale;

void setup() {
  size(650, 650);
  pixelDensity(displayDensity());
  background(255);

  curr = new PVector();
  next = new PVector();

  // 1. Example
  //a = -2.24;
  //b = 0.43;
  //c = -0.65;
  //d = -2.43;
  //offX = 150;
  //offY = -80;
  //scale = 175;

  // 2. Example
  //a = -2.7;
  //b = -0.09;
  //c = -0.86;
  //d = -2.2;
  //offX = 150;
  //offY = -80;
  //scale = 175;

  // 3. Example
  //a = -0.709;
  //b = 1.638;
  //c = 0.452;
  //d = 1.740;
  //offX = 35;
  //offY = -50;
  //scale = 155;

  // 4. Example
  a = -2.0;
  b = -2.0;
  c = -1.2;
  d = 2.0;
  offX = 0;
  offY = 0;
  scale = 125;

  // 5. Example
  //a = 1.4;
  //b = -2.3;
  //c = 2.4;
  //d = -2.1;
  //offX = 0;
  //offY = 0;
  //scale = 125;
}

void draw() {
  noFill();
  strokeWeight(1);
  translate(width*0.5 + offX, height*0.5 + offY);

  for (int i = 0; i < stop; ++i) {
    next.x = sin(a*curr.y) - cos(b*curr.x);
    next.y = sin(c*curr.x) + cos(d*curr.y);
    float col = abs(sin(i))*255;
    stroke(255 - col, 50, col);
    point(next.x*scale, next.y*scale);
    curr = next.copy();
  }

  noLoop();
}
