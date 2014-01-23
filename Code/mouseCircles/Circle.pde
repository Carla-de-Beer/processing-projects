class Circle
{
  float xpos;
  float ypos;
  float maxDistance = dist(0, 0, width, height);
  Particle dot;

  Circle(float _xpos, float _ypos)
  {
    xpos = _xpos;
    ypos = _ypos;
    dot = new Particle();
  }

  void display(int i, int j)
  {  
    pushMatrix();
    translate(-(width - (SPACING*(COLS-1)))/2, -(height - (SPACING*(ROWS-1)))/2);
    dot.run();
    popMatrix();
    float mouseDist = dist(dot.pos.x, dot.pos.y, i*SPACING, j*SPACING);
    //float mouseDist = dist(mouseX, mouseY, i*SPACING, j*SPACING);

    float rad = (mouseDist / maxDistance) * 200.0;
    fill(255, 50);
    for (int k = 0; k < 4; ++k)
    { 
      fill(mouseDist*50, mouseDist, mouseDist/2, 150);  
      ellipse(i*SPACING, j*SPACING, min(0, rad - SIZE*k), min(0, rad - SIZE*k));
    }
  }
}

