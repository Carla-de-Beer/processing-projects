// Carla de Beer
// Created: March 2019
// Code to generate a 4D OpenSimplex Perlin noise loop. 
// These images can be used to make a gif.
// Based on Daniel Shiffman's Coding Train coding challenges:
// https://www.youtube.com/watch?v=Lv9gyZZJPE0
// https://www.youtube.com/watch?v=3_0Ax95jIrk&t=574s

int totalFrames = 120;
int counter = 0;
boolean record = false;

float increment = 0.02;
// We will increment zoff differently than xoff and yoff
float zincrement = 0.03; 

OpenSimplexNoise noise;

void setup() {
  size(450, 250);
  noise = new OpenSimplexNoise();
}

void draw() {
  float percent = 0.0f;
  if (record) {
    percent = float (counter)/totalFrames;
  } else {
    percent = float (frameCount % totalFrames) / totalFrames;
  }
  render(percent);
  if (record) {
    saveFrame("output/gif-" + nf(counter, 3) + ".png");
    if (counter == totalFrames-1) {
      exit();
    }
  }
  counter++;
}

void render(float percent) {

  float angle = map(percent, 0, 1, 0, TWO_PI);
  float uoff = map(cos(angle), -1, 1, 0, 2);
  float voff = map(sin(angle), -1, 1, 0, 2);

  loadPixels();

  float xoff = 0.0; // Start xoff at 0

  // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
  for (int x = 0; x < width; x++) {
    xoff += increment;  
    float yoff = 0.0;   // For every xoff, start yoff at 0
    for (int y = 0; y < height; y++) {
      yoff += increment;

      // Calculate noise and scale by 255
      float bright = (float) noise.eval(xoff, yoff, uoff, voff);
      bright = map(bright, -1, 0.5, 10, 255);
      //println(bright);
      //float bright =  n > 0 ? 255 : 0;

      // Try using this line instead
      //float bright = random(0,255);

      if (bright < 230) {
        pixels[x+y*width] = color(bright, 255 - bright*2, 255 - bright);
      } else {
        pixels[x+y*width] = color(255, bright/1.5, 70);
      }
    }
  }
  updatePixels();
}
