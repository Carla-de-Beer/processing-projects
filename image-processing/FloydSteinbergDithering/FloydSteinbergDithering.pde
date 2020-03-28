// Carla de Beer
// Created: January 2018.
// Floyd-Steinberg dithering.
// A dithering technique using error diffusion, meaning it pushes (adds) the residual quantisation error of a pixel onto its neighbouring pixels, to be dealt with later.
// Based on Daniel Shiffman's Coding Train video:
// https://www.youtube.com/watch?v=0L2n8Tg2FwI

PImage img;
static int FACTOR = 2;

void setup() {
  size(1400, 467);
  img = loadImage("frog.jpg");
  //img.filter(GRAY);
}

void draw() {
  image(img, 0, 0);

  img.loadPixels();
  for (int y = 0; y < img.height - 1; ++y) {
    for (int x = 1; x < img.width - 1; ++x) {

      color pix = img.pixels[getIndex(x, y)];
      float oldR = red(pix);
      float oldG = green(pix);
      float oldB = blue(pix);
      float factorInv = 1.0 / FACTOR;

      int newR = (int) (round(FACTOR * oldR / 255) * (255 * factorInv));
      int newG = (int) (round(FACTOR * oldG / 255) * (255 * factorInv));
      int newB = (int) (round(FACTOR * oldB / 255) * (255 * factorInv));

      img.pixels[getIndex(x, y)] = color(newR, newG, newB);

      float errR = oldR - newR;
      float errG = oldG - newG;
      float errB = oldB - newB;

      int index = getIndex(x + 1, y);
      color c = img.pixels[index];
      img.pixels[index] = calculateCol(c, errR, errG, errB, 7.0);

      index = getIndex(x - 1, y + 1);
      c = img.pixels[index];
      img.pixels[index] = calculateCol(c, errR, errG, errB, 5.0);

      index = getIndex(x, y + 1);
      c = img.pixels[index];
      img.pixels[index] = calculateCol(c, errR, errG, errB, 3.0);

      index = getIndex(x + 1, y + 1);
      c = img.pixels[index];
      img.pixels[index] = calculateCol(c, errR, errG, errB, 1.0);
    }
  }
  img.updatePixels();

  image(img, 700, 0);
  noLoop();
}

int getIndex(int x, int y) {
  return x + y * img.width;
}

color calculateCol(color c, float errR, float errG, float errB, float scale) {
  float r = red(c);
  float g = green(c);
  float b = blue(c);
  r = r + errR * scale / 16.0;
  g = g + errG * scale / 16.0;
  b = b + errB * scale / 16.0;
  return color(r, g, b);
}