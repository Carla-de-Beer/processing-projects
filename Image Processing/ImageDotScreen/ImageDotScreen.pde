// Carla de Beer
// Created: January 2018.
// Images with a dot screen.
// A simple form of resolution reduction by increasing the effective pixel size.
// The size of each dot relates to the brightness level of the corresponding image spot.

PImage img;
static int DIVISON = 6;

void setup() {
  size(1400, 465);
  pixelDensity(displayDensity());
  img = loadImage("frog.jpg");
}

void draw() {
  background(0);
  image(img, 0, 0);

  img.loadPixels();
  for (int y = 0; y < img.height - 1; y += DIVISON) {
    for (int x = 1; x < img.width - 1; x += DIVISON) {
      color c = img.get(x, y);
      fill(c);
      println(brightness(c));
      int bright = (int) map(brightness(c), 0, 255, 3, DIVISON);
      noStroke();
      pushMatrix();
      translate(700, 0);
      ellipse(x, y, bright, bright);
      popMatrix();
    }
  }
  img.updatePixels();

  noLoop();
}