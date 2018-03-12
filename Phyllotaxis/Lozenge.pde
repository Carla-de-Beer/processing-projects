class Lozenge {
  float x, y, w;
  int n;
  float xoff, yoff;

  Lozenge(float x, float y, float w, int n) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.n = n;

    xoff = cos(radians(60)) * w;
    yoff = sin(radians(60)) * w;
  }

  void display() {
    if (n > 150) {
      //stroke(180, (int) n/7);
      //noStroke();
    } else {
      stroke(190, 200);
    }

    pushMatrix();
    translate(x, y);
    rotate(radians(n/7));
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