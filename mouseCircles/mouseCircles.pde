// Carla de Beer
// Created November 2010
// Updated January 2014
// Circles grid

Circle [][] grid;
final int COLS = 18;
final int ROWS = 12;
final float SPACING = 45;
final int SIZE = 22;

void setup() {
  size(900, 600);
  noStroke();
  smooth();
  ellipseMode(CENTER);
  grid = new Circle[COLS][ROWS];

  for (int i = 0; i < COLS; i++) {
    for (int j = 0; j < ROWS; j++) {
      grid[i][j] = new Circle(0, 0);
    }
  }
}

void draw() { 
  background(55);
  pushMatrix();
  translate((width - (SPACING*(COLS-1)))/2, (height - (SPACING*(ROWS-1)))/2);
  for (int i = 0; i < COLS; ++i) {
    for (int j = 0; j < ROWS; ++j) {
      grid[i][j].display(i, j);
    }
  }
  popMatrix();
}

void keyPressed() {
  saveFrame();
}