class Particle
{
  PVector pos;
  PVector vel;
  float val = 10;

  Particle(PVector _pos)
  {
    pos = _pos;
    vel = new PVector(0, random(-val, val), 0);
  }

  void move(Particle [][] chain, int i_len, int j_len)
  { 
    pos.add(vel);
    for (int i = 0; i < i_len; i++) 
    {
      for (int j = 0; j < j_len; j++) 
      {
        float dd = PVector.dist( pos, chain[i][j].pos );
        if (dd >= 800) vel.mult(-1);
      }
    }
  }

  void draw_particle()
  {
    noStroke();
    pushMatrix();
    popMatrix();
  }
}

