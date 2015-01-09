// Carla de Beer
// January 2014
// Hexagonal implementation of Daniel Shiffman's 2D CA

// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// A basic implementation of John Conway's Game of Life CA

GOL gol;

void setup() {
  size(815, 841);
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

void keyReleased()
{
  if (key == 'S' || key == 's') saveFrame();
}

