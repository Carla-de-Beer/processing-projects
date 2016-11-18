// Command line entry:
// processing-java --sketch=`pwd`/numbers --run text

import java.util.*;
import java.text.*;

Date dNow;
SimpleDateFormat ft;

float r = 0.0;
float g = 0.0;
float b = 0.0;
float textR = 0.0;
float textG = 0.0;
float textB = 0.0;

void setup() {
  size(600, 400);

  r = random(255);
  g = random(255);
  b = random(255);

  textR = random(255);
  textG = random(255);
  textB = random(255);
}

void draw() {
  background(r, g, b);
  textSize(95);
  fill(textR, textG, textB);
  text(args[0], width/2 - 30, height/2 + 25);
  if (frameCount == 20) {
    dNow = new Date();
    ft = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
    textSize(15);
    text(ft.format(dNow), 50, height - 50);
    saveFrame("images/" + ft.format(dNow) + ".png");
    exit();
  }
}