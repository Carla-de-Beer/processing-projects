// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

class Cell {

  float x, y;
  float w;
  float xoff;
  float yoff;

  int state;
  int previous;

  Cell(float x_, float y_, float w_) {
    x = x_;
    y = y_;
    w = w_;

    xoff = w/2;
    yoff = sin(radians(60))*w;
    state = int(random(2));
    previous = state;
  }

  void savePrevious() {
    previous = state;
  }

  void newState(int s) {
    state = s;
  }

  void display() {

    stroke(170);
    //noStroke();
    pushMatrix();
    translate(x, y);
    beginShape();
    vertex(0, yoff);
    vertex(xoff, 0);
    vertex(xoff+w, 0);
    vertex(2*w, yoff);
    vertex(xoff+w, 2*yoff);
    vertex(xoff, 2*yoff);
    vertex(0, yoff);
    endShape();
    popMatrix();
  }
}

