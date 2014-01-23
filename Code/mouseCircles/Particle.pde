class Particle
{
  PVector pos;
  PVector acc;
  PVector vel;
  float val = 10.0;

  Particle()
  {
    pos = new PVector(random(height), random(width));
    acc = new PVector(0, 0);
    vel = new PVector( random(-val, val), random(-val, val));
  }

  void run()
  { 
    pos.add(vel);
    bounce();
    fill(255, 0, 0);
    //ellipse(pos.x, pos.y, 15, 15);
  }

  void bounce()
  { 
    if (pos.x <= 0) vel.x = -vel.x;
    if (pos.x >= width) vel.x = -vel.x;
    if (pos.y <= 0) vel.y = -vel.y;
    if (pos.y >= height) vel.y = -vel.y;
  }
}

