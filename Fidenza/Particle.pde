// Daniel Shiffman
// http://youtube.com/thecodingtrain
// http://codingtra.in
//
// Coding Challenge #24: Perlin Noise Flow  Field
// https://youtu.be/BjoM9oKOAKY

public class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  PVector previousPos;
  float maxSpeed;
  boolean finished = false;
  color col;
  int widthParticle;

  int rand = (int) random(colors.length);
  int randCol1 = (int) random(colors.length);
  int randCol2 = (int) random(colors.length);

  ArrayList<PVector> history = new ArrayList<>();

  Particle(PVector start, float maxspeed, color col, int widthParticle) {
    this.maxSpeed = maxspeed;
    this.pos = start;
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.previousPos = pos.copy();
    this.col = col;
    this.widthParticle = widthParticle;
  }

  void update() {
    history.add(pos.copy());
    int rand = (int) random(10);

    pos.add(vel);

    //sizeList.add(widthParticle);
    //widthParticle += 1;
  }

  void applyForce(PVector force) {
    acc.add(force);
  }

  void check(ArrayList<Particle> others) {
    if (!finished) {
      for (Particle other : others) {
        if (other != this) {
          for (PVector v : other.history) {
            float d = PVector.dist(pos, v);
            if (d < widthParticle + 13) {
              this.finished = true;
              return;
            }
          }
        }
      }
    }
  }

  void follow(FlowField flowfield) {
    int x = floor(pos.x / flowfield.scl);
    int y = floor(pos.y / flowfield.scl);
    int index = x + y * flowfield.cols;
    this.vel = flowfield.vectors[index];
  }

  void edges() {
    if (pos.x < 0 || pos.x > width-1 || pos.y < 0 || pos.y > height-1) {
      this.finished = true;
    }
  }

  void show() {
    stroke(col);
    noFill();
    strokeCap(SQUARE);
    beginShape();
    strokeWeight(widthParticle);

    for (int i = 0; i < history.size()-1; ++i) {
      PVector v = history.get(i+1);
      PVector pv = history.get(i);
      //noStroke();
      //fill(col);
      //strokeWeight(sizeList.get(i));
      //ellipse(v.x, v.y, sizeList.get(i), sizeList.get(i));
      vertex(v.x, v.y);

      stroke(col);
    }
    endShape();

    // Draw start tips in different color
    showStartTip();
    showSecondTip();
  }

  void showStartTip() {
    beginShape();
    strokeWeight(widthParticle);
    if (history.size() > 4) {
      for (int i = 0; i < colors.length; ++i) {
        PVector v1 = history.get(i);
        if (rand < 4) {
          stroke(colors[randCol1]);
          vertex(v1.x, v1.y);
        }
      }
    }
    endShape();
  }

  void showSecondTip() {
    beginShape();
    strokeWeight(widthParticle);
    if (history.size() > 4) {
      for (int i = 2; i < 4; ++i) {
        PVector v1 = history.get(i);
        if (rand < 4) {
          stroke(colors[randCol2]);
          vertex(v1.x, v1.y);
        }
      }
    }
    endShape();
  }
}
