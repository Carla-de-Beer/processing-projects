// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

class Cell {

  float x, y, z, h;
  float w;
  float check = 0.5;
  boolean colorOn;
  int state;
  int previous;
  int cap;

  Cell(float x_, float y_, float w_) {
    x = x_;
    y = y_;
    w = w_;
    z = 0;
    h = 20;
    cap = 60;
    colorOn = false;
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
    if (previous == 0 && state == 1)
    {
      if (colorOn)
        fill(0, 255, 0);
      else fill((1.8*h)%255);
      if (h < cap)
      {
        h += check;
        z -= check/2;
      }

      else if (h >= cap)     
      {
        h = cap;
        z = -20;
      }
    }
    else if (state == 1) {
      if (colorOn)
        fill( 255, 0, 0);
      else fill((1.8*h)%255);

      if (h < cap)
      {
        h += check;
        z -= check/2;
      }

      else if (h >= cap)     
      {
        h = cap;
        z = -20;
      }
    }
    else if (previous == 1 && state == 0) {

      if (colorOn)
        fill(#F5EA16);
      else fill((1.8*h)%255);

      if (h < cap)
      {
        h += check;
        z -= check/2;
      }

      else if (h >= cap)     
      {
        h = cap;
        z = -20;
      }
    }
    else fill((1.8*h)%255);
    stroke(10);
    strokeWeight(0.5);
    pushMatrix();
    translate(x, y, z);
    box(w, w, h);
    popMatrix();
  }
}

