// Carla de Beer
// Created: January 2022.
// Superellipse grid (part of Genuary 2022).

int cols = 10;
int rows = 10;

float a = 30;
float b = 30;

int offset = 65;

Ellipse[][] grid;

color[] colors = {#2E294E, #541388, #F1E9DA, #FFD400, #D90368};

void setup() {
  size(700, 700);
  pixelDensity(displayDensity());
  smooth();

  grid = new Ellipse[cols][rows];

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float n = random(0.1, 1);
      float theta = random(0, 10);
      int colValue = (int) random(5);
      grid[i][j] = new Ellipse(n, theta, colValue);
    }
  }
}

void draw() {
  background(81);
  translate(57, 57);

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      pushMatrix();
      translate(i * offset, j * offset);
      grid[i][j].drawFigure();
      grid[i][j].update();
      popMatrix();
    }
  }
}
