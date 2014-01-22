// Carla de Beer
// Created November 2010
// Updated January 2014
// Mouse circles

Circle [][] grid;
final int COLS = 15;
final int ROWS = 9;
final float SPACING = 80;
final int SIZE = 33;

void setup()
{
  size(1300, 800);
  noStroke();
  smooth();
  ellipseMode(CENTER);
  grid = new Circle[COLS][ROWS];

  for (int i = 0; i < COLS ; i++)
  {
    for (int j = 0; j < ROWS; j++)
    {
      grid[i][j] = new Circle(0, 0);
    }
  }
}

void draw()
{ 
  background(10);
  pushMatrix();
  translate((width - (SPACING*(COLS-1)))/2, (height - (SPACING*(ROWS-1)))/2);
  for (int i = 0; i < COLS ; ++i)
  {
    for (int j = 0; j < ROWS; ++j)
    {
      grid[i][j].display(i, j);
    }
  }
  popMatrix();
}

void keyPressed()
{
  saveFrame();
}

