// Carla de Beer
// Created: January 2014.
// A basic implementation of John Conway's Game of Life CA on a hexagonal grid.
// Based on Daniel Shiffman's 2D CA implementation in "The Nature of Code":
// http://natureofcode.com

GOL gol;

void setup() {
  size(815, 841);
  pixelDensity(displayDensity());
  smooth();
  gol = new GOL();
}

void draw() {
  background(255);
  gol.generate();
  gol.display();
}

// reset board when mouse is pressed
void mousePressed() {
  gol.init();
}

void keyReleased() {
  if (key == 'S' || key == 's') saveFrame();
}