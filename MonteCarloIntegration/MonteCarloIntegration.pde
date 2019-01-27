// Carla de Beer
// Simple Monte Carlo Integration.
// January 2019

PGraphics canvas;
int count;

void setup() {
  size(500, 600);
  pixelDensity(displayDensity());
  background(255);
  canvas = createGraphics(width, height);
  canvas.beginDraw();
  canvas.background(255);
  canvas.endDraw();
}

void draw() {
  int x = (int)random(0, width);
  int y = (int)random(0, height-100);
  float d = dist(width*0.5, height*0.5-50, x, y);

  // Draw the canvas
  image(canvas, 0, 0);
  canvas.beginDraw();
  canvas.strokeWeight(4);

  if ((int)d < width*0.5) {
    ++count;
    canvas.stroke(255, 0, 0, 200);
  } else {
    canvas.stroke(100, 120);
  }
  canvas.point(x, y);
  canvas.endDraw();

  // Draw text
  stroke(120);
  strokeWeight(0.5);
  fill(120);
  text("Ratio: " + (float)count/(float)frameCount, 30, height-70);
  text("Estimated circle area (square pixels): " + (float)count/(float)frameCount*1000000/4, 30, height-47.5);
  text("Error percentage: " + abs(1 - ((float)count/(float)frameCount*1000000/4)/(PI*(width/2)*width/2)), 30, height-25);

  fill(150, 40);
  ellipse(width/2, height/2-50, width, width);
  stroke(120);
  strokeWeight(0.5);
  line(0, height - 100, width, height - 100);

  println("Estimated circle area (square pixels): " + (float)count/(float)frameCount*1000000/4);
}
