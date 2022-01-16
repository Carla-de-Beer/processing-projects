class Ellipse {

  float n;
  float theta;
  color col;

  Ellipse(float n, float theta, color col) {
    this.n = n;
    this.col = col;
    this.theta = theta;
  }

  void update() {
    n = sin(theta);
    n = map(n, -1, 1, 0.2, 1);
    theta += 0.025;
  }

  void drawFigure() {
    noStroke();
    strokeWeight(1);
    fill(colors[col]);

    beginShape();
    for (float angle = 0; angle < TWO_PI; angle += 0.1) {
      float na = 2 / n;
      float x = pow(abs(cos(angle)), na) * a * sgn(cos(angle));
      float y = pow(abs(sin(angle)), na) * b * sgn(sin(angle));
      vertex(x, y);
    }
    endShape(CLOSE);
  }

  float sgn(float val) {
    if (val == 0) {
      return 0;
    }
    return val / abs(val);
  }
}
