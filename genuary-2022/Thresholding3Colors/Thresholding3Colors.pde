// Carla de Beer
// Created: January 2022.
// Image thresholding with 3 colors.

PImage img;

static int THRESHOLD_1 = 170;
static  int THRESHOLD_2 = 85;

//color[] colors = {#2191FB, #BA274A, #841C26};

// cream, olive, aubergine
// color[] colors = {#FBF5F3, #8DAA9D, #522B47};

// yellow, purple, red
color[] colors = {#FFF689, #58355E, #E03616};


void setup() {
  size(1512, 1008);
  pixelDensity(displayDensity());

  img = loadImage("img-05.png");
}

void draw() {
  background(128);
  image(img, 0, 0);

  img.loadPixels();
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      int index = x + y * img.width;
      color c = img.get(x, y);
      float bright = brightness(c);

      if (bright >= THRESHOLD_1) {
        img.pixels[index] = colors[0];
      } else if (bright < THRESHOLD_1 && bright >= THRESHOLD_2) {
        img.pixels[index] = colors[2];
      } else {
        img.pixels[index] = colors[1];
      }
    }
  }

  img.updatePixels();

  image(img, 756, 0);
  noLoop();
}

int getIndex(int x, int y) {
  return x + y * img.width;
}

void keyPressed() {
  if (key == 'P' || key == 'p') {
    saveFrame("images/threshold-###.png");
  }
}
