// Carla de Beer
// 25.01.2016
// Processing 3.0.1
// Sketch that implements Poisson Distribution to simulate the arrival of dots on a screen.
// Poisson Distribution information from: Wikipedia and www.cs.tufts.edu.

static final float LIMIT = 0.6; 
int k = 0;
int t = 1;
int s = second();
int m = minute();
int h = hour();
float theta = 0.0;

void setup() {
  size(500, 500);
  pixelDensity(displayDensity());
  background(255);
  frameRate(10);
}

void draw() {

  fill(255, 255, 255, 35);
  rect(0, 0, 500, 500);

  float r = random(0, 1);
  k += 0.0001;
  float res = exp(-r*t)*(pow((r*t), k)/factorial(k));

  // Uncomment for Perlin noise
  // theta = theta + 0.1;
  // float n = noise(theta);//println(res);
  // r = n;

  if (res > LIMIT) {
    Dot dot = new Dot();
    pushMatrix();
    noStroke();
    translate(100, 100);
    fill(r*500, 255 - r*100, 100, 200);
    dot.draw();
    popMatrix();
  }
}

public int factorial(int n) {
  int fact = 1;
  for (int i = 1; i <= n; i++) {
    fact *= i;
  }
  return fact;
}