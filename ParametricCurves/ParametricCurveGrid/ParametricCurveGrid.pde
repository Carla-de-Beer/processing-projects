// Carla de Beer
// Created: January 2015.
// Parametric curve sketches on a 4 x 4 grid.

Curve [][] curves;
int rows = 4; 
int cols = 4;
PVector pos;
float r = 50.0;

void setup() {
  size(780, 780);
  pixelDensity(displayDensity());
  background(255);
  smooth();
  pos = new PVector(50, 50, 0);
  curves = new Curve[rows][cols];

  for (int i = 0; i < rows; ++i) {  
    for (int j = 0; j < cols; ++j) {      
      curves[i][j] = new Curve(pos);
    }
  }
}

void draw() {
  pushMatrix();
  translate(-260, -260);
  for (int i = 0; i < rows; ++i) {
    for (int j = 0; j < cols; ++j) {
      curves[i][j].render(i, j);
    }
  }
  popMatrix();
}

void keyReleased() {
  if (key == 'R' || key == 'r') setup();
  if (key == 'S' || key == 's') saveFrame();
}