class Pendulum {
  float r1, r2;
  float m1, m2;
  float a1, a2;
  float a1_v, a2_v;
  float px1, py1;
  float px2, py2;
  float g;

  float x1, y1;
  float x2, y2;

  Pendulum(float r1, float r2, float m1, float m2, float a1, float a2, float g) {
    this.r1 = r1;
    this.r2 = r2;
    this.m1 = m1;
    this.m2 = m2;
    this.a1 = a1;
    this.a2 = a2;
    this.g = g;
  }

  void draw() {
    float a1_nominator = (-g * (2 * m1 + m2) * sin(a1)) - (m2 * g * sin(a1 - 2 * a2)) - (2 * sin(a1 - a2) * m2) * ((a2_v * a2_v * r2 + a1_v * a1_v * r1 * cos(a1 - a2)));
    float a1_demoninator = r1 * (2 * m1 + m2 - m2 * cos(2 * a1 - 2 * a2));

    float a1_a = a1_nominator / a1_demoninator;

    float a2_nominator = (2 * sin(a1 - a2)) * (((a1_v * a1_v * r1 * (m1 + m2))) + (g * (m1 + m2) * cos(a1)) + (a2_v * a2_v * r2 * m2 * cos(a1 - a2)));
    float a2_demoninator = r2 * (2 * m1 + m2 - m2 * cos(2 * a1 - 2 * a2));

    float a2_a = a2_nominator / a2_demoninator;

    x1 = r1 * sin(a1);
    y1 = r1 * cos(a1);

    x2 = x1 + r2 * sin(a2);
    y2 = y1 + r2 * cos(a2);

    stroke(50, 220);
    fill(50, 150);
    line(0, 0, x1, y1);
    ellipse(x1, y1, m1 * 0.35, m1 * 0.35);

    line(x1, y1, x2, y2);
    ellipse(x2, y2, m2 * 0.35, m2 * 0.35);

    a1_v += a1_a;
    a2_v += a2_a;
    a1 += a1_v;
    a2 += a2_v;

    //a1_v *= 0.999;
    //a2_v *= 0.999;
  }

  void updateCoordinates() {
    px1 = x1;
    py1 = y1;

    px2 = x2;
    py2 = y2;
  }
}