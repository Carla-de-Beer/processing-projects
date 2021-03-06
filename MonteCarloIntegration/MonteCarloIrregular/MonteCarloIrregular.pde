// Carla de Beer
// Simple Monte Carlo Integration using the background colour value 
// to determine whether a random point is inside or outside the given shape.
// This example uses an irregularly-shaped polygon.
// January 2019

PGraphics canvas;
int count;

void setup() {
  size(500, 600);
  pixelDensity(1);
  background(255);
  canvas = createGraphics(width, height);
  canvas.beginDraw();
  canvas.background(255);
  canvas.endDraw();
}

void draw() {
  int x = (int)random(width);
  int y = (int)random(height-100);

  boolean in = false;
  boolean out = false;

  color c = get(x, y); 
  //println((int)green(c) + " : " + (int)red(c));
  if ((int)green(c) == 255 && (int)red(c) < 255 && (int)blue(c) < 255) {
    ++count;
    in = true;
  } else {
    out = true;
  }

  // Draw the canvas
  image(canvas, 0, 0);
  canvas.beginDraw();
  canvas.strokeWeight(4);


  if (out && !in) {
    canvas.stroke(100, 120);
    canvas.point(x, y);
  } else if (in && !out) {
    canvas.stroke(0, 255, 0, 200);
    canvas.point(x, y);
  }

  canvas.endDraw();

  // Draw text
  stroke(120);
  strokeWeight(0.5);
  fill(120);
  text("Ratio: " + (float)count/(float)frameCount, 30, height-47.5);
  text("Estimated shape area (square pixels): " + (float)count/(float)frameCount*1000000/4, 30, height-25);

  fill(0, 255, 0, 100);
  stroke(120);
  strokeWeight(0.5);
  line(0, height - 100, width, height - 100);

  beginShape();
  vertex(50, 60);
  vertex(350, 60);
  vertex(250, 150);
  vertex(420, 280);
  vertex(460, 420);
  vertex(100, 480);
  endShape(CLOSE);

  println("Estimated shape area (square pixels): " + (float)count/(float)frameCount*1000000/4);
}
