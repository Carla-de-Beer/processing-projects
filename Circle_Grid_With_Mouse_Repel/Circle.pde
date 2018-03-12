class Circle {
  int xpos;
  int ypos;
  int rad;
  int sp;
  int originalxpos;
  int originalypos;

  Circle (int xpos, int ypos, int rad) { 
    this.xpos = xpos;
    this.ypos = ypos;
    this.rad = rad;
    originalxpos = xpos;
    originalypos = ypos;
    sp = 1;
  }

  void move() {
    float distance = dist(mouseX, mouseY, xpos, ypos);
    if (distance <= 100) {
      if (mouseX >= xpos) xpos -= sp;
      if (mouseX < xpos)  xpos += sp;
      if (mouseY >= ypos) ypos -= sp;
      if (mouseY < ypos)  ypos += sp;
    } else {
      if (originalxpos >= xpos)  xpos += sp;
      if (originalxpos < xpos)   xpos -= sp;
      if (originalypos >= ypos)  ypos += sp;
      if (originalypos < ypos)   ypos -= sp;
    }
  }  

  void drawCircle() {
    ellipse (xpos, ypos, rad, rad);
  }
}