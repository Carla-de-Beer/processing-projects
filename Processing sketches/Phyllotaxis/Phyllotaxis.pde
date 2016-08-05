// Carla de Beer
// August 2016
// Sunflower-like construction based on phyllotaxis design.
// Based on Daniel Shiffman's Coding Rainbow example.

Lozenge lozenge;
int n = 0;
int c = 7;

void setup() {
  size(650, 650);
  background(51);
  //colorMode(HSB);
  colorMode(RGB);
}

void draw() {

  float phi = n * 137.3;
  float r = c * sqrt(n);
  float x = r * cos(phi) + width/2;
  float y = r * sin(phi) + height/2;
  //fill(phi % 256, 255, 255);
  fill(n/2 - (n % 256), 255 - n/50, 80);
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