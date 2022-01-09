// Carla de Beer
// Created: January 2022.
// Processing version of a simple Fidenza-like implementation (part of Genuary 2022).

// Based on
// The original Fidenza algorithm by Tyler Hobbs: https://tylerxhobbs.com/fidenza.
// Daniel Shiffman's Coding Train interpretation of a flowfield:
//   http://youtube.com/thecodingtrain
//   http://codingtra.in
//   Coding Challenge #24: Perlin Noise Flow  Field
//   https://youtu.be/BjoM9oKOAKY

FlowField flowfield;
OpenSimplexNoise noise = new OpenSimplexNoise();
ArrayList<Particle> particles;

int colors[] = {#A83E36, #F54E42, #35F5F1, #A87214, #F5AA2A};
boolean debug = false;

void setup() {
  size(1280, 720);
  pixelDensity(displayDensity());
  int res = 25;

  flowfield = new FlowField(res);
  flowfield.update();

  particles = new ArrayList<>();
}

void draw() {
  background(71);
  flowfield.update();

  PVector start = new PVector(random(width), random(height));
  //int r = (int) random(255);
  //int g = (int) random(255);
  //int b = (int) random(255);
  //color col = color(r,g,b);

  int rand = (int) random(6);
  color col =  colors[4];

  switch (rand) {
  case 0:
    col = colors[0];
    break;
  case 1:
    col = colors[1];
    break;
  case 2:
    col =  colors[2];
    break;
  case 3:
    col =  colors[3];
    break;
  }

  int widthParticle = (int) random(10, 35);

  particles.add(new Particle(start, 5, col, widthParticle));

  for (Particle p : particles) {
    p.edges();
    p.check(particles);
    if (!p.finished) {
      p.follow(flowfield);
      p.update();
    }

    p.show();
  }

  if (debug) {
    flowfield.display();
  }
}

void mousePressed() {
  debug = !debug;
}

void keyPressed() {
  if (key == 'P' || key == 'p') {
    saveFrame("images/fidenza-###.png");
  }
}
