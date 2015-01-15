// Carla de Beer
// January 2015
// Visualising music as a 3D landscape
// A first experiment in the use of the Processing Midim library
// Based on Daniel Shiffman's "Landscape" example from The Nature of Code

import processing.opengl.*;
import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer player;
AudioMetaData meta;
FFT fft;
Landscape land;    

PFont font;
float theta = 0.0;

void setup() {
  size(1000, 870, OPENGL);
  minim = new Minim(this);

  player = minim.loadFile("marcus_kellis_theme.mp3");

  //loop the file indefinitely
  //player.loop();

  land = new Landscape(20, 800, 400);

  fft = new FFT( player.bufferSize(), player.sampleRate() );
  player.play();
  meta = player.getMetaData();
  font = loadFont("Consolas-48.vlw");
}

void draw() {

  background(255);
  textFont(font);
  textSize(18);
  strokeWeight(0.5);

  pushMatrix();
  translate(width/2+100, height/2+200, -190);

  int ys = -750;
  int yi = 30;
  int y = ys;
  int horz = -400;

  noStroke();
  int store = (y+=yi);
  float x = map(land.max, 0, 120, 0, 48);

  fill(200, 150);
  rect(horz+310, store-10, x, 11);  

  fill(230, 80);
  rect(horz+310, store-10, 120, 11); 

  // Metadata text
  fill(50, 150);
  String maxTxt = String.format("%.2f", land.max);
  text("Max frequency band: " + maxTxt + " Hz", horz, store);
  text("Progress: ", horz + 540, store);
  text("File Name: " + meta.fileName(), horz, y+=yi);
  float minutes = meta.length() / 6000;
  minutes = minutes/10;
  String time = String.format("%.2f", minutes);
  float store2 = y+=yi;
  text("Length: " + time + " min", horz, store2);

  fill(230, 80);
  rect(horz + 660, store-10, 120, 11);

  fill(50, 150);
  text("Title: " + meta.title(), horz, y+=yi);
  text("Author: " + meta.author(), horz, y+=yi); 
  text("Date: " + meta.date(), horz, y+=yi);
  String word = "";

  if (meta.genre().equals("(8)")) word = "Jazz";
  else if (meta.genre().equals("(18)")) word = "Techno";
  text("Genre: " + word, horz, y+=yi);

  int m = millis()*100;
  int n = (int)(m/meta.length());

  // Draw progress bar
  int mult = 10;
  int size = 11;
  int cell = 12;

  fill(200, 150);

  if (n >= mult) {
    rect(horz + 660, store-10, cell, size);
  }
  if (n >= mult*2) {
    rect(horz + 660 + cell, store-10, cell, size);
  }
  if (n >= mult*3) {
    rect(horz + 660 + cell*2, store-10, cell, size);
  }
  if (n >= mult*4) {
    rect(horz+660 + cell*3, store-10, cell, size);
  }
  if (n >= mult*5) {
    rect(horz+660 + cell*4, store-10, cell, size);
  }
  if (n >= mult*6) {
    rect(horz+660 + cell*5, store-10, cell, size);
  }
  if (n >= mult*7) {
    rect(horz+660 + cell*6, store-10, cell, size);
  }
  if (n >= mult*8) {
    rect(horz+660 + cell*7, store-10, cell, size);
  }
  if (n >= mult*9) {
    rect(horz+660 + cell*8, store-10, cell, size);
  }
  if (n >= mult*10) {
    rect(horz+660 + cell*9, store-10, cell, size);
  }

  popMatrix();

  pushMatrix();
  translate(width/2+100, height/2+300, -190);
  rotateX(PI/4);

  lights();
  directionalLight(126, 126, 126, 1, 1, 1);
  ambientLight(102, 102, 102);

  land.render();
  popMatrix();

  // Draw sound waves
  pushMatrix();
  translate(-horz/2 + 50, height/2-250, 0);
  stroke(50, 150);

  for (int i = 0; i < player.bufferSize () - 1; i++) {
    float x1 = map( i, 0, player.bufferSize(), 0, width/1.55 );
    float x2 = map( i+1, 0, player.bufferSize(), 0, width/1.55 );
    line( x1, 50 + player.left.get(i)*50, x2, 50 + player.left.get(i+1)*50 );
    line( x1, 100 + player.right.get(i)*50, x2, 100 + player.right.get(i+1)*50 );
  }

  popMatrix();

  land.calculate();
  theta += 0.0025;
}

