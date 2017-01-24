// Pointillated image creation with circle packing algorithm.
// Based on Daniel Shiffman's Coding Train video series on animated circle packing:
// https://www.youtube.com/watch?v=QHEQuoIKgNE
// Image: Scheveningen Museum Beelden aan Zee
// https://freewallpaperspictures.com/tag/images-photos/
// Created: January 2017

import java.util.*;
import java.text.*;
import processing.pdf.*;

ArrayList<Circle> circles;
PImage img;
boolean isRecord = false;

Date dNow;
SimpleDateFormat ft;

void setup() {
  size(816, 544);
  pixelDensity(1);
  circles = new ArrayList<Circle>();
  img = loadImage("face.jpg");
}

void draw() {
  if (isRecord) {
    dNow = new Date();
    ft = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
    beginRecord(PDF, "./PDF/" + ft.format(dNow) + ".pdf");
  }

  background(51);

  int total = 10;
  int count = 0;
  int attempts = 0;

  while (count < total) {
    Circle newC = newCircle(); 
    if (newC != null) {
      circles.add(newC);
      count++;
    }

    attempts++;
    if (attempts > 1000) {
      // Can't fit any more circles
      noLoop();
      println("FINISHED");
      break;
    }
  }

  for (Circle c : circles) {
    if (c.growing) {
      if (c.edges()) {
        c.growing = false;
      } else {
        for (Circle other : circles) {
          if (c != other) {
            float d = dist(c.x, c.y, other.x, other.y);
            if (d - 2 < c.r + other.r) {
              c.growing = false;
              break;
            }
          }
        }
      }
    }
    c.show();
    c.grow();
  }

  endRecord();
  isRecord = false;
}

Circle newCircle() {
  float x = random(width);
  float y = random(height);
  boolean valid = true;

  float red = 0.0;
  float green = 0.0;
  float blue = 0.0;
  float alpha = 0.0;

  for (Circle c : circles) {
    float d = dist(x, y, c.x, c.y);
    if (d < c.r) {
      valid = false;
      break;
    }
  }

  color c = img.get((int) x, (int) y);
  red = red(c);
  green = green(c);
  blue = blue(c);
  alpha = alpha(c);

  color col = color((int) red, (int) green, (int) blue, (int) alpha);

  if (valid) {
    return new Circle(x, y, col);
  } else {
    return null;
  }
}

void keyReleased() {
  if (key == 'P' || key == 'p') {
    isRecord = true;
  }
}