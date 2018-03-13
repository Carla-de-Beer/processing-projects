class Pendulum {
  float r1, r2;
  float m1, m2;
  float a1, a2;
  float a1_v, a2_v;
  float g;

  PVector pos1;
  PVector pos2;
  PVector prev1;
  PVector prev2;

  Pendulum(float r1, float r2, float m1, float m2, float a1, float a2, float g) {
    this.r1 = r1;
    this.r2 = r2;
    this.m1 = m1;
    this.m2 = m2;
    this.a1 = a1;
    this.a2 = a2;
    this.g = g;
    pos1 = new PVector();
    pos2 = new PVector();
    prev1 = new PVector();
    prev2 = new PVector();
  }

  void draw() {
    float a1_nominator = (-g * (2 * m1 + m2) * sin(a1)) - (m2 * g * sin(a1 - 2 * a2)) - (2 * sin(a1 - a2) * m2) * ((a2_v * a2_v * r2 + a1_v * a1_v * r1 * cos(a1 - a2)));
    float a1_demoninator = r1 * (2 * m1 + m2 - m2 * cos(2 * a1 - 2 * a2));

    float a1_a = a1_nominator / a1_demoninator;

    float a2_nominator = (2 * sin(a1 - a2)) * (((a1_v * a1_v * r1 * (m1 + m2))) + (g * (m1 + m2) * cos(a1)) + (a2_v * a2_v * r2 * m2 * cos(a1 - a2)));
    float a2_demoninator = r2 * (2 * m1 + m2 - m2 * cos(2 * a1 - 2 * a2));

    float a2_a = a2_nominator / a2_demoninator;

    pos1.x = r1 * sin(a1);
    pos1.y = r1 * cos(a1);

    pos2.x = pos1.x + r2 * sin(a2);
    pos2.y = pos1.y + r2 * cos(a2);

    stroke(50, 220);
    fill(50, 150);
    line(0, 0, pos1.x, pos1.y);
    ellipse(pos1.x, pos1.y, m1 * 0.35, m1 * 0.35);

    line(pos1.x, pos1.y, pos2.x, pos2.y);
    ellipse(pos2.x, pos2.y, m2 * 0.35, m2 * 0.35);

    a1_v += a1_a;
    a2_v += a2_a;
    a1 += a1_v;
    a2 += a2_v;

    //a1_v *= 0.999;
    //a2_v *= 0.999;
  }

  void updateCoordinates() {
    prev1.x = pos1.x;
    prev1.y = pos1.y;

    prev2.x = pos2.x;
    prev2.y = pos2.y;
  }
}