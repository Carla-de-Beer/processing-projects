// Carla de Beer
// Created: February 2018.
// Four double pendula with various settings.
// Based on Daniel Shiffman's Coding Train coding challenge:
// https://www.youtube.com/watch?v=uWzPe_S-RVE

PGraphics canvas;
Pendulum pendulum1, pendulum2, pendulum3, pendulum4;

void setup () {
  size(1000, 750);
  pixelDensity(displayDensity());
  canvas = createGraphics(width, height);
  canvas.beginDraw();
  canvas.background(255);
  canvas.endDraw();
  pendulum1 = new Pendulum(80.0, 80.0, 40, 40, PI/2, PI/2, 0.3);
  pendulum2 = new Pendulum(80.0, 100.0, 20, 5, PI, PI/4, 0.7);
  pendulum3 = new Pendulum(110.0, 60.0, 20, 10, PI/1.5, PI, 0.1);
  pendulum4 = new Pendulum(50.0, 100.0, 80, 40, PI/2, PI, 0.1);
}

void draw() {
  image(canvas, 0, 0);
  stroke(0);
  strokeWeight(2);

  float yOff1 = -125;
  float yOff2 = -105;
  float yOff3 = -85;

  pushMatrix();
  translate(250, 175);
  pendulum1.draw();
  noStroke();
  fill(50, 200);
  text("P1", 0, yOff1);
  text("m1: " + pendulum1.m1 + " m2: " + pendulum1.m2, 0, yOff2);
  text("r1: " + pendulum1.r1 + " r2: " + pendulum1.r2, 0, yOff3);
  popMatrix();

  pushMatrix();
  translate(750, 175);
  pendulum2.draw();
  noStroke();
  fill(50, 200);
  text("P2", 0, yOff1);
  text("m1: " + pendulum2.m1 + " m2: " + pendulum2.m2, 0, yOff2);
  text("r1: " + pendulum2.r1 + " r2: " + pendulum2.r2, 0, yOff3);
  popMatrix();

  pushMatrix();
  translate(250, 525);
  pendulum3.draw();
  noStroke();
  fill(50, 200);
  text("P3", 0, yOff1);
  text("m1: " + pendulum3.m1 + " m2: " + pendulum3.m2, 0, yOff2);
  text("r1: " + pendulum3.r1 + " r2: " + pendulum3.r2, 0, yOff3);
  popMatrix();

  pushMatrix();
  translate(750, 525);
  pendulum4.draw();
  noStroke();
  fill(50, 200);
  text("P4", 0, yOff1);
  text("m1: " + pendulum4.m1 + " m2: " + pendulum4.m2, 0, yOff2);
  text("r1: " + pendulum4.r1 + " r2: " + pendulum4.r2, 0, yOff3);
  popMatrix();

  canvas.beginDraw();
  canvas.strokeWeight(1);

  pushMatrix();
  canvas.translate(250, 175);
  canvas.stroke(pendulum1.pos2.y, 10, 255 - pendulum1.pos2.y, 200);
  if (frameCount > 1) {
    canvas.line(pendulum1.prev2.x, pendulum1.prev2.y, pendulum1.pos2.x, pendulum1.pos2.y);
    canvas.stroke(255, 0, 50, 100);
    canvas.point(pendulum1.pos1.x, pendulum1.pos1.y);
  }
  popMatrix();

  pushMatrix();
  canvas.translate(500, 0);
  canvas.stroke(pendulum2.pos2.y, 10, 255 - pendulum2.pos2.y, 200);
  if (frameCount > 1) {
    canvas.line(pendulum2.prev2.x, pendulum2.prev2.y, pendulum2.pos2.x, pendulum2.pos2.y);
    canvas.stroke(255, 0, 50, 100);
    canvas.point(pendulum2.pos1.x, pendulum2.pos1.y);
  }
  popMatrix();

  pushMatrix();
  canvas.translate(-500, 350);
  canvas.stroke(50, 255 - pendulum3.pos2.y, pendulum3.pos2.y, 200);
  if (frameCount > 1) {
    canvas.line(pendulum3.prev2.x, pendulum3.prev2.y, pendulum3.pos2.x, pendulum3.pos2.y);
    canvas.stroke(255, 0, 50, 100);
    canvas.point(pendulum3.pos1.x, pendulum3.pos1.y);
  }
  popMatrix();

  pushMatrix();
  canvas.translate(500, 0);
  canvas.stroke(50, 255 - pendulum4.pos2.y, pendulum4.pos2.y, 200);
  if (frameCount > 1) {
    canvas.line(pendulum4.prev2.x, pendulum4.prev2.y, pendulum4.pos2.x, pendulum4.pos2.y);
    canvas.stroke(255, 0, 50, 100);
    canvas.point(pendulum4.pos1.x, pendulum4.pos1.y);
  }
  popMatrix();

  canvas.endDraw();

  pendulum1.updateCoordinates();
  pendulum2.updateCoordinates();
  pendulum3.updateCoordinates();
  pendulum4.updateCoordinates();
}