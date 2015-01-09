class Particle
{
  PVector pos;
  PVector acc;
  PVector vel;

  Particle(PVector _pos)
  {
    pos = _pos;
    acc = new PVector(0, 0, 0);
    vel = new PVector(0, 0, 0);
  }

  void run()
  { 
    // Update velocity
    vel.add(acc);
    // Limit speed
    vel.limit(MAX_SPEED);
    pos.add(vel);
    // Reset accelertion to 0 each cycle
    acc.mult(0);
  }

  void drawParticle(int i, int j, boolean colorOff)
  {
    noStroke();
    if (colorOff)
    {
      noFill();
    }
    else fill(100,100);//(#78C43B);//, 150);
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    box(10);
    popMatrix();
  }

  void seek(PVector target) 
  {
    acc.add(steer(target, false));
  }

  void arrive(PVector target)
  {
    acc.add(steer(target, true));
  }

  // A method that calculates a steering vector towards a target
  // Takes a second argument, if true, it slows down as it approaches the target
  PVector steer(PVector target, boolean slowdown) 
  {
    PVector steer;  // The steering vector

      PVector desired = PVector.sub(target, pos);  // A vector pointing from the location to the target

    float d = desired.mag(); // Distance from the target is the magnitude of the vector
    // println("d = " + d);
    // If the distance is greater than 0, calc steering (otherwise return zero vector)
    if (d > 0) 
    {
      // Normalize desired
      desired.normalize();
      // Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
      if ((slowdown) && (d < 100.0f)) desired.mult(MAX_SPEED*(d/100.0f)); // This damping is somewhat arbitrary
      else desired.mult(MAX_SPEED);
      // Steering = Desired minus Velocity
      steer = PVector.sub(desired, vel);
      steer.limit(MAX_FORCE);  // Limit to maximum steering force
    } 
    else 
    {
      steer = new PVector(0, 0, 0);
    }
    //println("steer = " + steer);
    return steer;
  }
}

