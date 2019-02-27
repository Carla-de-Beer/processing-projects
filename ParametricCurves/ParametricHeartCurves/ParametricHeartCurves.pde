// Carla de Beer
// Created: March 2018; updated: February 2019.
// A cardioid curve circumscribing a heart curve. Both are based on parametric equations.

final float INCREMENT = 0.025;
ArrayList<PVector> heartList;
ArrayList<PVector> cardidoidList;
float r = 165.0;
float theta = 0.0;

void setup() {
  size(650, 650);
  pixelDensity(displayDensity());
  heartList = new ArrayList<PVector>();
  cardidoidList = new ArrayList<PVector>();
}

void draw() {
  // Heart curve parametric equations
  float hx = 125*pow(sin(theta), 3);
  float hy = 30*(4*cos(theta) - 1.3*cos(2*theta) - 0.6*cos(3*theta) - 0.2*cos(4*theta));
  heartList.add(new PVector(hx, hy));

  // Cardidoid parametric equations
  float cx = 140 * (cos(theta) * (1 - cos(theta)));
  float cy = 140 * (sin(theta) * (1 - cos(theta)));
  cardidoidList.add(new PVector(cx, cy));

  background(255);

  // 1. ---------------------------------- Axes
  pushMatrix();
  stroke(125);
  strokeWeight(0.5);
  noFill();
  line(width/2 + 0.06, 50, width/2 + 0.06, height - 50);
  line(50, height*0.5 - 146, width - 50, height*0.5 - 146);
  popMatrix();

  // 2. ---------------------------------- Heart curve

  pushMatrix();
  translate(width*0.5, height*0.5);
  strokeWeight(3);
  stroke(255, 10, 80, 200);
  noFill();

  beginShape();
  for (PVector v : heartList) {
    vertex(v.x, v.y);
  }
  endShape();

  theta += INCREMENT;
  popMatrix();

  // 3. ---------------------------------- Cardioid curve
  pushMatrix();
  strokeWeight(2.0);
  translate(width*0.5, height*0.5 - 146);
  rotate(-PI/2);
  stroke(120, 120);
  noFill();

  beginShape();
  for (PVector v : cardidoidList) {
    vertex(v.x, v.y);
  }
  endShape();
  popMatrix();


  // Stop
  if (theta > TWO_PI) {
    println("Full circle: DONE");
    noLoop();
  }
}
