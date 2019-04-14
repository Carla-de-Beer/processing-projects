// Carla de Beer //<>//
// Created: April 2019
// Discrete Fourier Tranformation with epicycles using a heart curve as input.
// Switch the `record` boolean to `true` in order to generate as set of PNG files, that my be converted to a GIF.

// Based on Daniel Shiffman's Fourier Transform Drawing with Complex Number Input Coding Train coding challenge:
// https://www.youtube.com/watch?v=7_vKzcgpfvU&t=1336s
// https://www.youtube.com/watch?v=MY4luNgGfms

import java.util.*;
import java.util.Comparator;

ArrayList<Complex> x;
ArrayList<XObject> fourierX;
ArrayList<PVector> path;
ArrayList<PVector> heartList;

float time = 0;
float theta = 0.0;

color heartCol = color(255, 50, 100);
color lineCol = color(120, 225, 150);
color circleCol = color(255, 90);

boolean record = false;

void setup() {
  size(500, 500);
  pixelDensity(displayDensity());

  x = new ArrayList<Complex>();
  path = new ArrayList<PVector>();
  heartList = new ArrayList<PVector>();
  fourierX = new ArrayList<XObject>();

  for (int i = 0; i < 20 * TWO_PI; ++i) {
    float x = 125 * pow(sin(theta), 3);
    float y = 30 * (4 * cos(theta) - 1.3 * cos(2 * theta) - 0.6 * cos(3 * theta) - 0.2 * cos(4 * theta));

    heartList.add(new PVector(1.5 * x, 1.5 * y));
    theta += 0.05;
  }

  for (int i = 0; i < heartList.size(); ++i) {
    Complex c = new Complex(heartList.get(i).x, heartList.get(i).y);
    x.add(c);
  }

  fourierX = dft(x); 

  // Sort by amplitude in reverse
  Collections.sort(fourierX, new AmpComparator());
}

void draw() {
  background(40);
  translate(0, -20);
  PVector v = epicycles(width / 2, height / 2, 0, fourierX);
  path.add(v);

  stroke(heartCol);
  strokeWeight(3);
  beginShape();
  noFill();

  for (int i = 0; i < path.size(); ++i) {
    vertex(width - path.get(i).x, height - path.get(i).y);
  }
  endShape();
  strokeWeight(1);

  float dt = TWO_PI / fourierX.size();
  time += dt;

  if (record) {
    saveFrame("output/gif-" + nf(frameCount, 3) + ".png");
  }

  if (time > TWO_PI + 0.01) {
    time = 0;
    path.clear();
    if (record) {
      noLoop();
    }
  }
}

PVector epicycles(float x, float y, float rotation, ArrayList<XObject> fourier) {
  for (int i = 0; i < fourier.size(); ++i) {
    float prevx = x;
    float prevy = y;
    float freq = fourier.get(i).freq;
    float radius = fourier.get(i).amp;
    float phase = fourier.get(i).phase;
    x += radius * cos(freq * time + phase + rotation);
    y += radius * sin(freq * time + phase + rotation);

    noFill();
    stroke(circleCol);
    strokeWeight(5);
    point(width - prevx, height - prevy);
    strokeWeight(1);
    ellipse(width - prevx, height - prevy, radius * 2, radius * 2);
    stroke(255);
    stroke(lineCol);
    line(width - prevx, height - prevy, width - x, height - y);
  }
  return new PVector(x, y);
}

// Discrete Fourier Transform
ArrayList<XObject> dft(ArrayList<Complex> x) {
  ArrayList<XObject> X = new ArrayList<XObject>();
  int N = x.size();
  for (int k = 0; k < N; ++k) {
    Complex sum = new Complex(0, 0);
    for (int n = 0; n < N; ++n) {
      float phi = (TWO_PI * k * n) / N;
      Complex c = new Complex(cos(phi), -sin(phi));
      sum.add(x.get(n).mult(c));
    }
    sum.re = sum.re / N;
    sum.im = sum.im / N;

    float freq = k;
    float amp = sqrt(sum.re * sum.re + sum.im * sum.im);
    float phase = atan2(sum.im, sum.re);
    X.add(k, new XObject(sum.re, sum.im, freq, amp, phase));
  }
  return X;
}

// Simple sort without lamba expression
class AmpComparator implements Comparator<XObject> {
  public int compare(XObject a, XObject b) {
    return Float.compare(b.amp, a.amp);
  }
}
