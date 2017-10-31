// Carla de Beer
// August 2016
// Parametrically controllable 3D SuperShape generator.

// Based on Daniel Shiffman's Coding Train coding challenge:
// https://www.youtube.com/watch?v=m8WhMeW8jj0&t=905s
// Refer also to http://paulbourke.net/geometry/supershape/ for parametric settings suggestions.

import peasy.*;
import controlP5.*;

PeasyCam cam;
ControlP5 cp5;

PVector[][] globe;
int total = 150;
int myColor = color(255, 0, 0);
float m_lat, n1_lat, n2_lat, n3_lat;
float m_lon, n1_lon, n2_lon, n3_lon;
float a, b;
int sliderWidth, sliderHeight;
int start1, start2;

void setup() {
  size(1000, 800, P3D);
  pixelDensity(displayDensity());
  cam = new PeasyCam(this, 700);
  //cam.lookAt((double) width/2, (double) width/2, (double) width/2);
  //cam.lookAt((double) width/2, (double) width/2, (double) width/2, 500.00);
  cp5 = new ControlP5(this);

  globe = new PVector[total+1][total+1];

  //colorMode(HSB);

  m_lat = 2.0;
  n1_lat = 0.2;
  n2_lat = 1.7;
  n3_lat = 1.7;

  m_lon = 2.0;
  n1_lon = 0.2;
  n2_lon = 1.7;
  n3_lon = 1.7;

  a = 1.00;
  b = 1.00;

  sliderWidth = 300;
  sliderHeight = 20;

  start1 = 80;
  start2 = 540;

  cp5.addSlider("m_value_lat")
    .setPosition(start1, height-170)
    .setSize(sliderWidth, sliderHeight)
    .setRange(-35, 35)
    .setValue(7.00);

  cp5.addSlider("n1_value_lat")
    .setPosition(start1, height-140)
    .setSize(sliderWidth, sliderHeight)
    .setRange(-250, 250)
    .setValue(0.2);

  cp5.addSlider("n2_value_lat")
    .setPosition(start1, height-110)
    .setSize(sliderWidth, sliderHeight)
    .setRange(-250, 250)
    .setValue(1.7);

  cp5.addSlider("n3_value_lat")
    .setPosition(start1, height-80)
    .setSize(sliderWidth, sliderHeight)
    .setRange(-250, 1000)
    .setValue(1.7);

  cp5.addSlider("a_value")
    .setPosition(start1, height-50)
    .setSize(sliderWidth, sliderHeight)
    .setRange(-2.00, 2.00)
    .setValue(1.00);

  // -----------------------------

  cp5.addSlider("m_value_lon")
    .setPosition(start2, height-170)
    .setSize(sliderWidth, sliderHeight)
    .setRange(-35.0, 35.0)
    .setValue(7.00);

  cp5.addSlider("n1_value_lon")
    .setPosition(start2, height-140)
    .setSize(sliderWidth, sliderHeight)
    .setRange(-250, 250)
    .setValue(0.2);

  cp5.addSlider("n2_value_lon")
    .setPosition(start2, height-110)
    .setSize(sliderWidth, sliderHeight)
    .setRange(-250, 250)
    .setValue(1.7);

  cp5.addSlider("n3_value_lon")
    .setPosition(start2, height-80)
    .setSize(sliderWidth, sliderHeight)
    .setRange(-250, 1000)
    .setValue(1.7);

  cp5.addSlider("b_value")
    .setPosition(start2, height-50)
    .setSize(sliderWidth, sliderHeight)
    .setRange(-2.00, 2.00)
    .setValue(1.00);

  cp5.setAutoDraw(false);
}

float superShape(float theta, float m, float n1, float n2, float n3, float a, float b) {
  float t1 = abs((1/a) * cos(m * theta/4));
  t1 = pow(t1, n2);
  float t2 = abs((1/b) * sin(m * theta/4));
  t2 = pow(t2, n3);
  float t3 = t1 + t2;
  float r = pow(t3, -1/n1);
  return r;
}

void draw() {

  background(51);
  fill(255);
  lights();
  float r = 200;

  for (int i = 0; i < total+1; ++i) {
    float lat = map(i, 0, total, -HALF_PI, HALF_PI);
    float r2 = superShape(lat, m_lat, n1_lat, n2_lat, n3_lat, a, b);
    for (int j = 0; j < total+1; ++j) {
      float lon = map(j, 0, total, -PI, PI);
      float r1 = superShape(lon, m_lon, n1_lon, n2_lon, n3_lon, a, b);
      float x = r * r1 * cos(lon) * r2 * cos(lat);
      float y = r * r1 * sin(lon) * r2 * cos(lat);
      float z = r * r2 * sin(lat);
      globe[i][j] = new PVector(x, y, z);
    }
  }

  noStroke();

  for (int i = 0; i < total; ++i) {
    if (i % 4 == 0 && i % 5 == 0) {
      //float hue = map(i, 0, total, 0, 255 * 6);
      fill(255);
    } else fill(255, 50, 100);

    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j < total+1; ++j) {
      PVector v1 = globe[i][j];
      vertex(v1.x, v1.y, v1.z);
      PVector v2 = globe[i+1][j];
      vertex(v2.x, v2.y, v2.z);
    }
    endShape();
  }
  gui();
}

void gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  cp5.draw();
  fill(255);
  text("CONTROLS", start1, height-190);
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

void keyReleased() {
  if (key == 'p' || key =='P') {
    saveFrame();
  }
}