// Carla de Beer
// January 2014
// 3D Implementation of John Conway's Game of Life CA,
// based on Daniel Shiffman's Nature of Code 2D CA example

// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

PVector eye;
PVector center;
PVector up;

import processing.opengl.*;

GOL gol;

boolean noPause = true;
import processing.dxf.*;
//boolean record = false;

void setup() {
  size(650, 650, P3D);
  pixelDensity(displayDensity());
  gol = new GOL();

  eye = new PVector(width/6, (height/6)*5, -width/1.15);
  center = new PVector(275, 250, 100);
  up = new PVector(0, 0, 1);
}

void draw() {
  /*
  if (record == true) {
   beginRaw(DXF, "output.dxf"); // Start recording to the file
   }
   */
  if (noPause) {

    background(255);

    lights();
    directionalLight(126, 126, 126, 1, 1, 1);
    ambientLight(102, 102, 102);

    camera(eye.x, eye.y, eye.z, center.x, center.y, center.z, up.x, up.y, up.z);
    gol.generate();
    gol.display();
    pushMatrix();
    noFill();
    stroke(10);
    strokeWeight(0.5);
    translate(width/2-80, height/2-80, -20);
    box(500, 500, 60);
    popMatrix();
  }

  /*
  if (record == true) {
   endRaw();
   record = false; // Stop recording to the file
   }
   */
}

void keyPressed() {
  if (key == 'U' || key == 'u') setup();
  if (key == 'S' || key == 's') saveFrame();
  //if (key == 'R' || key == 'r') record = true;
}

void mouseReleased() {
  noPause = !noPause;
}