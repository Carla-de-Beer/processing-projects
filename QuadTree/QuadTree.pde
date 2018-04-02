// Carla de Beer
// Created: March 2018.
// Processing version of a basic Quad Tree implementation that reduces the number of particle checks required.
// Based on Daniel Shiffman's Coding Train videos:
// https://www.youtube.com/watch?v=OJxEcs0w_kE and https://www.youtube.com/watch?v=QQx_NmCIuCY

QTree qtree;

void setup() {
  size(501, 501);
  Rectangle boundary = new Rectangle(width*0.5, height*0.5, 250, 250);
  qtree = new QTree(boundary, 4);
  for (int i = 0; i < 300; ++i) {
    float x = random(50, width - 50);
    float y = random(50, height - 50);
    Particle p = new Particle(x, y);
    qtree.insert(p);
  }
}

void draw() {
  background(0);
  qtree.show();
  stroke(0, 255, 0);
  rectMode(CENTER);
  Rectangle range = new Rectangle(mouseX, mouseY, 25, 25);
  rect(range.x, range.y, range.w * 2, range.h * 2);
  ArrayList<Particle> particles = new ArrayList<Particle>();
  particles = qtree.query(range, particles);

  strokeWeight(4);
  for (Particle p : particles) {
    point(p.x, p.y);
  }
}
