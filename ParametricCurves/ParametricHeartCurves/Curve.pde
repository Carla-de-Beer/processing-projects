class Curve {

  float theta;
  PVector coords;

  Curve(PVector coords) {
    this.coords = coords;
    theta = 0.0;
  }

  void render() {
    pushMatrix();
    ellipse((coords.x + width/2), (coords.y + height/2), 0.3, 0.3);
    popMatrix();
    theta += 0.005;
  }
}