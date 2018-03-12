// Carla de Beer
// Created: March 2018
// A cardioid curve circumscribing a heart curve. Both are based on parametric equations.

PVector pos1, pos2;
PVector prev1, prev2;
float r = 165.0;
float theta = 0.0;
//float sx1, sy1;
//float sx2, sy2;

void setup() {
  size(650, 650);
  pixelDensity(displayDensity());
  background(255);
  pos1 = new PVector();
  prev1 = new PVector();
  pos2 = new PVector();
  prev2 = new PVector();
}

void draw() {
  // Heart curve parametric equations
  pos1.x = 125*pow(sin(theta), 3);
  pos1.y = 30*(4*cos(theta) - 1.3*cos(2*theta) - 0.6*cos(3*theta) - 0.2*cos(4*theta));

  // Cardidoid parametric equations
  pos2.x = 140 * (cos(theta) * (1 - cos(theta)));
  pos2.y = 140 * (sin(theta) * (1 - cos(theta)));

  // 1. ---------------------------------- Heart curve
  pushMatrix();
  noStroke();
  noFill();
  strokeWeight(0.5);
  strokeWeight(2.5);

  translate(width*0.5, height*0.5);
  if (frameCount == 1) {
    prev1.x = pos1.x;
    prev1.y = pos1.y;
    //sx1 = pos1.x;
    //sy1 = pos1.y;
    //sx2 = pos2.x;
    //sy2 = pos2.y;
    //println(sx1 + " : " + sy1); //0.0 : 56.999996
    //println(sx2 + " : " + sy2); //0.0 : 0.0
    //println(prev1.x + " : " + prev1.y); //0.0 : 56.999996
  }

  if (frameCount > 2) {
    stroke(255, 10, 80, 120);
    line(prev1.x, prev1.y, pos1.x, pos1.y);
  }

  prev1.x = pos1.x;
  prev1.y = pos1.y;
  prev2.x = pos2.x;
  prev2.y = pos2.y;

  popMatrix();

  // 2. ---------------------------------- Cardioid curve
  pushMatrix();
  noStroke();
  noFill();
  strokeWeight(1.5);

  translate(width*0.5, height*0.5 - 146);
  rotate(-PI/2);
  if (frameCount == 1) {
    prev1.x = pos1.x;
    prev1.y = pos1.y;
  }

  if (frameCount > 2) {
    stroke(120, 120, 170, 150);
    line(prev2.x, prev2.y, pos2.x, pos2.y);
  }

  prev1.x = pos1.x;
  prev1.y = pos1.y;
  prev2.x = pos2.x;
  prev2.y = pos2.y;
  popMatrix();

  // 3. ---------------------------------- Axes
  pushMatrix();
  strokeWeight(0.5);
  stroke(120);
  line(width/2 + 0.06, 50, width/2 + 0.06, height - 50);
  line(50, height*0.5 - 146, width - 50, height*0.5 - 146);
  popMatrix();

  if (theta > 6.21) { // 1. 6.2100945 // 2. 6.1700935
    println("DONE");
    noLoop();
  }

  theta += 0.005;

  //if (distance(sx2 + 0.06, sy2 - 146, pos1.x, pos1.y) < 1) {
  //  println(pos1.x + " : " + pos1.y);
  //  println("FOUND IT");
  //  noLoop();
  //}
}

float distance(float x1, float y1, float x2, float y2) {
  return sqrt((x1 - x2)*(x1 -x2) + (y1 - y2)*(y1 - y2));
}