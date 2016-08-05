class Lozenge {

  float x, y, w;
  int n;
  float xoff, yoff;

  Lozenge(float x_, float y_, float w_, int n_) {
    x = x_;
    y = y_;
    w = w_;
    n = n_;

    xoff = cos(radians(60)) * w;
    yoff = sin(radians(60)) * w;
  }

  void display() {
    if (n > 150) {
      stroke(180, (int) n/7);
    } else {
      stroke(180, 200);
    }

    pushMatrix();
    translate(x, y);
    beginShape();

    vertex(0, 0);
    vertex(xoff, yoff);
    vertex(2 * (xoff), 0);
    vertex(xoff, -yoff);
    vertex(0, 0);

    endShape();
    popMatrix();
  }
}