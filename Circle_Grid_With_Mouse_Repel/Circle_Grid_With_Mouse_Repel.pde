// Carla de Beer
// November 2010

final int RADIUS = 20;

Circle [][] grid;

void setup() {
  size(800, 550);
  pixelDensity(displayDensity());
  ellipseMode(CENTER);
  smooth();
  fill(255);
  noStroke();
  grid = new Circle[15][10];

  for (int i = 0; i < 15; i++) {
    for (int j = 0; j < 10; j++) {
      grid[i][j] = new Circle(i*50, j*50, RADIUS);
    }
  }
  background(#645F5F);
}

void draw() {
  noStroke();
  background(#645F5F); 
  fill(255);
  pushMatrix();
  translate(50, 50);

  for (int i = 0; i < 15; i++) {
    for (int j = 0; j < 10; j++) {
      if (grid[i][j] != grid[0][0] && frameCount > 2)
        grid[i][j].move();
      grid[i][j].drawCircle();
    }
  }
  popMatrix();
}