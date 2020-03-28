// Carla de Beer
// Created: February 2019
// Code to generate a set of images of a cardioid curve circumscribing a heart curve. 
// These images can be used to make a gif.
// Based on Daniel Shiffman's Coding Train coding challenges:
// https://www.youtube.com/watch?v=nBKwCCtWlUg
// https://www.youtube.com/watch?v=l5I3Q1JFISE

ArrayList<PVector> heartList;
ArrayList<PVector> cardidoidList;
float theta = 0.0f;

int totalFrames = 120;
int counter = 0;
boolean record = false;

void setup() {
  size(650, 650);
  heartList = new ArrayList<PVector>();
  cardidoidList = new ArrayList<PVector>();
}

void draw() {
  float percent = 0.0f;
  if (record) {
    percent = float (counter) / totalFrames;
  } else {
    percent = float (counter % totalFrames) / totalFrames;
  }
  render(percent);
  if (record) {
    saveFrame("output/gif-" + nf(counter, 3) + ".png");
    if (counter == totalFrames-1) {
      exit();
    }
  }
  counter++;
}

void render(float percent) {
  background(255);

  // 1. ---------------------------------- Axes
  pushMatrix();
  strokeWeight(0.5);
  stroke(125);
  line(width/2 + 0.06, 50, width/2 + 0.06, height - 50);
  line(50, height*0.5 - 146, width - 50, height*0.5 - 146);
  popMatrix();

  // 2. ---------------------------------- Heart curve
  pushMatrix();
  translate(width*0.5, height*0.5);
  strokeWeight(3);
  stroke(255, 10, 80);
  noFill();

  beginShape();
  for (PVector v : heartList) {
    vertex(v.x, v.y);
  }
  endShape();
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

  if (percent < 0.5) {
    theta = map(percent, 0, 0.5, 0, TWO_PI);
    // Heart curve parametric equations
    float hx = 125*pow(sin(theta), 3);
    float hy = 30*(4*cos(theta) - 1.3*cos(2*theta) - 0.6*cos(3*theta) - 0.2*cos(4*theta));
    heartList.add(new PVector(hx, hy));

    // Cardidoid parametric equations
    float cx = 140 * (cos(theta) * (1 - cos(theta)));
    float cy = 140 * (sin(theta) * (1 - cos(theta)));
    cardidoidList.add(new PVector(cx, cy));
  } else {
    heartList.remove(0);
    cardidoidList.remove(0);
  }
}
