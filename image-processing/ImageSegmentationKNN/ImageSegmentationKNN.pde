// Carla de Beer //<>//
// Created: December 2017.
// Image segmentation using the k-nearest neighbour algorithm.
// Algorithm adapted from: https://en.wikipedia.org/wiki/Image_segmentation.
// Press 'R' or 'r' to restart the sketch. A single mouse press halts the centroid recalculation.

import processing.core.PFont;
import java.util.*;

PImage img;
PFont regular, bold;
int offset = 15;
Boolean isRunning = true;

int K = 25;
ArrayList<PVector> centroids;
ArrayList<Pixel> imagePixels;

public void settings() {
  size(700*2, 467);

  regular = loadFont("ArialMT-12.vlw");
  bold = loadFont("Arial-BoldMT-12.vlw");

  // Randomly pick k cluster centres
  randomiseCentroids();
}

public void setup() {
  img = loadImage("frog.jpg");
}

public void draw() {
  background(255);
  image(img, 0, 0);

  if (isRunning) {
    assignPixelsToClusters();
    recomputeCentroids();
  } else {
    text("PAUSED", 25, height - 45);
  }

  showPixels();
  showCentroids();
}

void randomiseCentroids() {
  centroids = new ArrayList<PVector>();
  for (int i = 0; i < K; ++i) {
    centroids.add(new PVector(random(offset, width*0.45), random(offset, height*0.75)));
  }
}

public void assignPixelsToClusters() {
  imagePixels = new ArrayList<Pixel>();

  img.loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      color c = img.get(x, y);
      float r = c >> 16 & 0xFF; 
      float g = c >> 8 & 0xFF;
      float b = c & 0xFF;

      // Get distances to all the centroids
      ArrayList<Neighbour> neighbours = new ArrayList<Neighbour>();
      for (int k = 0; k < centroids.size(); ++k) {
        color cc = get((int)centroids.get(k).x, (int)centroids.get(k).y);
        float rr = cc >> 16 & 0xFF; 
        float gg = cc >> 8 & 0xFF;
        float bb = cc & 0xFF;
        //println(r + " : " + g + " : " + b);

        //float d = distance4D(rr, gg, bb, centroids.get(k).x*0.001, centroids.get(k).y*0.001, r, g, b, (float)x*0.001, (float)y*0.001);
        float d = distance3D(rr, gg, bb, r, g, b);
        neighbours.add(new Neighbour(d, k));
      }

      // Sort ArrayList by d-value
      Collections.sort(neighbours, new Comparator<Neighbour>() {
        public int compare(Neighbour nb1, Neighbour nb2) {
          float diff = nb2.d - nb1.d;
          if (diff < 0) {
            return 1;
          } else if (diff > 0) {
            return -1;
          } else {
            return 0;
          }
        }
      }
      );

      // Add to the image ArrayList each pixel and its correspondingly closest centoid
      imagePixels.add(new Pixel(x, y, neighbours.get(0).cat));
    }
  }

  img.updatePixels();
}

float distance3D(float x1, float y1, float z1, float x2, float y2, float z2) {
  return sqrt((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2) + (z1 - z2)*(z1 - z2));
}

float distance4D(float x1, float y1, float z1, float p1, float q1, float x2, float y2, float z2, float p2, float q2) {
  return sqrt((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2) + (z1 - z2)*(z1 - z2) + (p1 - p2)*(p1 - p2) + (q1 - q2)*(q1 - q2));
}

void recomputeCentroids() {
  ArrayList<Pixel> cluster = new ArrayList<Pixel>();
  for (int k = 0; k < 2; ++k) {

    cluster.clear();

    for (int j = 0; j < imagePixels.size(); ++j) { //<>//
      if (imagePixels.get(j).cat == k) {
        cluster.add(imagePixels.get(j));
      }
    }

    float totalX = 0.0;
    float totalY = 0.0;
    float Xpos, Ypos = 0.0;

    for (int i = 0; i < cluster.size(); ++i) {
      totalX += cluster.get(i).x;
      totalY += cluster.get(i).y;
    }

    if (cluster.size() != 0) {
      Xpos = (int) totalX/cluster.size();
      Ypos = (int) totalY/cluster.size();

      if (Xpos < 0) {
        Xpos = offset;
      } else if (Xpos > width*0.5) {
        Xpos = width*0.5 - offset;
      } else if (Ypos < 0) {
        Ypos = offset;
      } else if (Ypos > height) {
        Ypos = height - offset;
      }

      centroids.get(k).set(new PVector((int) totalX/cluster.size(), (int) totalY/cluster.size()));
    }
  }
}

void showCentroids() {
  printText();
  for (int k = 0; k < centroids.size(); ++k) {
    color cc = get((int)centroids.get(k).x, (int)centroids.get(k).y);
    float r = cc >> 16 & 0xFF; 
    float g = cc >> 8 & 0xFF;
    float b = cc & 0xFF;
    stroke(255);
    fill(r, g, b);
    ellipse(centroids.get(k).x, centroids.get(k).y, 12, 12);
    textFont(regular);
    noStroke();
    fill(255);
    text(k, centroids.get(k).x + 10, centroids.get(k).y + 5);
  }
}

void printText() {
  textFont(bold);
  noStroke();
  fill(255);
  text("K: " + K, 25, height - 25);
}

void showPixels() {
  for (int i = 0; i < imagePixels.size(); ++i) {
    PVector k = centroids.get(imagePixels.get(i).cat);
    color kc = get((int)k.x, (int)k.y);
    int kr = kc >> 16 & 0xFF; 
    int kg = kc >> 8 & 0xFF;
    int kb = kc & 0xFF;

    noStroke();
    fill(kr, kg, kb);
    // println(kr + " : " + kg + " : " + kb);
    pushMatrix();
    translate(width*0.5, 0);
    rect(imagePixels.get(i).x, imagePixels.get(i).y, 1, 1);
    popMatrix();
  }
}

void mousePressed() {
  isRunning = !isRunning;
}

void keyPressed() {
  if (key == 'R' || key == 'r') {
    size(700*2, 467);
    centroids.clear();
    randomiseCentroids();
    setup();
    isRunning = true;
  }
}