class Circle
{
  float xpos;
  float ypos;
  float maxDistance = dist(0, 0, width, height);

  Circle(float _xpos, float _ypos)
  {
    xpos = _xpos;
    ypos = _ypos;
  }

  void display(int i, int j)
  {
    float mouseDist = dist(mouseX, mouseY, i*100, j*100);
    float rad = (mouseDist / maxDistance) * 200.0;
    fill(255, 50);
    for (int k = 0; k < 4; ++k)
    { 
      fill(mouseDist*50, mouseDist, mouseDist/2, 150);  
      ellipse(i*SPACING, j*SPACING, min(10, rad - SIZE*k), min(10, rad - SIZE*k));
    }
  }
}

