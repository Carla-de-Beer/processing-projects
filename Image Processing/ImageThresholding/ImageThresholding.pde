// Image thresholding.
// Algorithm adapted from: https://en.wikipedia.org/wiki/Thresholding_(image_processing)
// Created: January 2018

PImage img;

static int THRESHOLD = 128;

void setup() {
  size(2000, 675);
  pixelDensity(displayDensity());
  img = loadImage("Pavlovsk.jpg");
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

      if (bright >= THRESHOLD) {
        img.pixels[index] = color(255);
      } else {
        img.pixels[index] = color(0);
      }
    }
  }
  img.updatePixels();

  image(img, 1000, 0);
  noLoop();
}

int getIndex(int x, int y) {
  return x + y * img.width;
}