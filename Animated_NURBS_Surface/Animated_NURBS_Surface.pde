// Carla de Beer
// Created: January 2014.
// An animated NURBS surface imbued with movement through the addition of a particle spring system. 
// NURBS algorithm based on that of Alasdair Turner's: http://www.openprocessing.org/sketch/8101

import processing.opengl.*;

// 12 nos. u_knots for degree 2 curve if there are 9 u_ctrl_pts
float [] u_knots = { 
  //0.0, 0.083, 0.167, 0.333, 0.417, 0.5, 0.583, 0.667, 0.75, 0.833, 0.917, 1.0 // URBS
  0.0, 0.083, 0.167, 0.313, 0.467, 0.55, 0.583, 0.667, 0.71, 0.833, 0.97, 1.0 // NURBS
};
// 10 nos. v_knots for degree 2 curve if there are 7 v_ctrl_pts
float [] v_knots = { 
  //0.0, 0.111, 0.222, 0.333, 0.444, 0.555, 0.666, 0.777, 0.888, 0.999 // URBS
  0.0, 0.171, 0.222, 0.333, 0.444, 0.585, 0.636, 0.707, 0.888, 0.939 // NURBS
};

PVector [][] ctrl_pts;
Particle [][] chain;

int u_ctrl_pts = 9;
int v_ctrl_pts = 7;

float u_spacing; 
float v_spacing;
PVector loc;
PVector eye;
PVector centre;
PVector up;
float  solution;

void setup() {
  size(750, 750, P3D);
  pixelDensity(displayDensity());
  smooth();
  eye = new PVector(width/2.0-100, height/2.0 + 600, (height/2.0) / tan(PI*30.0 / 180.0) - 50);
  centre = new PVector(width/2.0, height/2.0 + 100, 0);
  up = new PVector( 0, 1, 1);

  ctrl_pts = new PVector[u_ctrl_pts][v_ctrl_pts];
  chain = new Particle [u_ctrl_pts][v_ctrl_pts];

  // set up control points in a regular grid on the xz plane with a random height:
  u_spacing = ((width)*2.5 / u_ctrl_pts);
  v_spacing = ((height)*2.5 / v_ctrl_pts);

  for (int i = 0; i < u_ctrl_pts; i++) {
    for (int j = 0; j < v_ctrl_pts; j++) {
      ctrl_pts[i][j] = new PVector( u_spacing * i, random(50, height/2.5), -v_spacing * j);
      chain[i][j] = new Particle(ctrl_pts[i][j]);
    }
  }
}

void draw() {
  background(0);
  lights();
  camera(eye.x, eye.y, eye.z, centre.x, centre.y, centre.z, up.x, up.y, up.z);
  translate(-300, -width/5, -200);

  int u_deg = u_knots.length - u_ctrl_pts - 1;
  int v_deg = v_knots.length - v_ctrl_pts - 1;

  for (int i = 0; i < u_ctrl_pts; i++) {
    for (int j = 0; j < v_ctrl_pts; j++) {
      chain[i][j].move(chain, u_ctrl_pts, v_ctrl_pts);
    }
  }

  // draw surface
  for (float u = u_knots[u_deg]; u <= u_knots[u_knots.length-u_deg-1] - 0.01; u += 0.01) { 
    beginShape(QUAD_STRIP);
    for (float v = v_knots[v_deg]; v <= v_knots[v_knots.length-v_deg-1]; v += 0.01) {
      PVector pt_uv = new PVector();
      PVector pt_u1v = new PVector(); 

      for (int i = 0; i < u_ctrl_pts; i++) {
        for (int j = 0; j < v_ctrl_pts; j++) {
          float basisv = basisn(v, j, v_deg, v_knots);
          float basisu = basisn(u, i, u_deg, u_knots);
          float basisu1 = basisn(u+0.01, i, u_deg, u_knots);
          PVector pk = PVector.mult( ctrl_pts[i][j], basisu * basisv);
          PVector pk1 = PVector.mult( ctrl_pts[i][j], basisu1 * basisv);
          pt_uv.add( pk );
          pt_u1v.add( pk1 );
          solution = (pt_u1v.y - 100);
          fill(80, 0, solution);
        }
      }

      noStroke();
      pushMatrix();
      translate(pt_u1v.x, pt_u1v.y, pt_u1v.z);

      for (int i = 0; i < u_ctrl_pts; i++) {
        for (int j = 0; j < v_ctrl_pts; j++) { 
          chain[i][j].draw_particle();
        }
      }

      popMatrix();
      stroke(100, 10, solution);
      noFill();
      vertex( pt_uv.x, pt_uv.y, pt_uv.z );
      vertex( pt_u1v.x, pt_u1v.y, pt_u1v.z );
    }
    endShape();
  }
}

float basisn(float u, int k, int d, float [] knots) {
  if (d == 0) {
    return basis0(u, k, knots);
  } else {
    float b1 = basisn(u, k, d-1, knots) * (u - knots[k]) / (knots[k+d] - knots[k]);
    float b2 = basisn(u, k+1, d-1, knots) * (knots[k+d+1] - u) / (knots[k+d+1] - knots[k+1]);
    return b1 + b2;
  }
}

float basis0(float u, int k, float [] knots) {
  if (u >= knots[k] && u < knots[k+1]) {
    return 1;
  } else {
    return 0;
  }
}

void mouseClicked() {
  setup();
  draw();
}

void keyReleased() {
  if (key == 'S' || key == 's')  saveFrame();
}