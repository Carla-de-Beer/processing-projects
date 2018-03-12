// Carla de Beer
// Created: August 2016.
// Sunflower-like construction based on phyllotaxis design principles.
// Based on Daniel Shiffman's Coding Train coding challenge:
// https://www.youtube.com/watch?v=MQMJ0xWSMWE

Lozenge lozenge;
int n = 0;
int c = 7;

void setup() {
  size(650, 650);
  pixelDensity(displayDensity());
  background(51);
  //colorMode(HSB);
  colorMode(RGB);
}

void draw() {

  float phi = n * 137.5;
  float r = c * sqrt(n);
  float x = r * cos(phi) + width/2;
  float y = r * sin(phi) + height/2;
  fill(phi % 256, 60, 80);
  //fill(n/3 - (n*2 % 256), 255 - n/20, 90);
  //fill((255- r*2) % 256, 255, 200);
  //fill((phi-r) % 256, 255, 255);
  //ellipse(x, y, 3, 3);
  noStroke();
  lozenge = new Lozenge(x, y, 4 * n/350, n);
  c += 0.9;
  lozenge.display();

  n++;

  if (frameCount % 1500 == 0) {
    //background(51);
    //n = 0;
    noLoop();
  }
}