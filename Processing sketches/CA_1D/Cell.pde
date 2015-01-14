class Cell {

  float x, y;
  float w;
  float xoff;
  float yoff;
  boolean value;

  Cell(float x_, float y_, float w_) {
    x = x_;
    y = y_;
    w = w_;

    xoff = cos(radians(60))*w;
    yoff = sin(radians(60))*w;
    value = false;
  }

  void display() {
    
    stroke(170);
    pushMatrix();
    translate(x, y);
    beginShape();

    vertex(0, 0);
    vertex(xoff, yoff);
    vertex(2*(xoff), 0);
    vertex(xoff, -yoff);
    vertex(0, 0);

    endShape();
    popMatrix();
  }
}

