class Curve {

  float theta;
  PVector vecPos;

  Curve(PVector vecPos) {
    this.vecPos = vecPos;
    theta = 0.0;
  }

  void render(int i, int j) {
    pushMatrix();
    translate(i*175, j*175);

    if (i % 2 ==  j % 2 ) {
      vecPos.x = r*sin(theta) + r*cos(5*theta) + r*0.5*sin(15*theta);
      vecPos.y = r*cos(theta) + r*sin(5*theta) + r*0.5*cos(15*theta);
      stroke(50, 180);
    }
    else {
      vecPos.x = r*sin(theta) + r*cos(10*theta) + r*0.5*sin(15*theta);
      vecPos.y = r*cos(theta) + r*sin(10*theta) + r*0.5*cos(15*theta);
      stroke(150, 180);
    }

    ellipse((vecPos.x + width/2), (vecPos.y + height/2), 0.3, 0.3);
    popMatrix();
    theta += 0.002;
  }
}