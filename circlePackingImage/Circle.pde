class Circle {
  float x;
  float y;
  float r;
  color col;

  boolean growing = true;

  Circle(float x, float y, color col) {
    this.x = x;
    this.y = y;
    this.r = 1;
    this.col = col;
  }

  void grow() {
    if (growing) {
      // vary value of the increment to tweak the size of the circles
      r = r + 0.1;
    }
  }

  boolean edges() {
    return(x + r > width || x - r < 0 || y + r > height || y + r < 0);
  }

  void show() {
    noStroke();
    fill(col);
    ellipse(x, y, r*2, r*2);
  }
}