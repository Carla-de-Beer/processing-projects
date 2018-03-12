// Carla de Beer
// Created: January 2014.
// Self-organising net structure: 3D.
// Wrapping a 2D mesh onto a 3D point cloud.
// Press 'R' to restart, and 'U' to reverse the direction of steer.

// Steer and arrive alogorithms based on those by Daniel Shiffman ("Nature of Code").

import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;
import processing.opengl.*;
import processing.dxf.*;

PeasyCam camera;

ArrayList pointList; 
String[] values;
PVector[] pointListToArray;
int num = 5;
int iter;
float mult = 25.0;
final float MAX_SPEED = 2.0;
final float MAX_FORCE = 0.008;
Particle [][] particles;
PVector[][] vecMesh = new PVector[num][num];
PVector loc;
PVector eye;
PVector centre;
PVector up;
boolean showParticles;
boolean reverse = false;
boolean colorOff = false;
boolean introText = true;
boolean record = false;

PFont font;
PFont myFont1;

float accAve = 0;
float velAve = 0;

void setup() {
  randomSeed(11);
  size(900, 900, OPENGL);
  pixelDensity(displayDensity());
  smooth();

  showParticles = true;
  particles = new Particle[num][num];
  camera = new PeasyCam(this, 2700);
  camera.setMinimumDistance(1000);
  camera.setMaximumDistance(2700);

  eye = new PVector(1300, 1300, 1300);
  centre = new PVector(0, 0, 0);
  up = new PVector(0, 0, 1);

  pointList = new ArrayList();  
  iter = 0; 

  importTextData();

  for (int i=0; i<num; ++i) {
    for (int j=0; j<num; ++j) {
      vecMesh[i][j] = new PVector(random(-1*width/3, width/3)*3, random(-1*height/3, height/3)*3, random(-1*width/3, width/3)*3);
    }
  }

  for (int i = 0; i < num; i++) {
    for (int j = 0; j < num; j++) {
      PVector loc = new PVector (random(width-(width - (num-1)*mult*2)), random(height-(height - (num-1)*mult*2)), random(width-(width - (num-1)*mult*2)));
      if (!reverse) {
        particles[i][j] = new Particle(loc);
      } else {
        PVector loc1 = new PVector(vecMesh[i][j].x, vecMesh[i][j].y, vecMesh[i][j].z);
        particles[i][j] = new Particle(loc1);
        vecMesh[i][j] = new PVector(random(width-(width - (num-1)*mult)), random(height-(height - (num-1)*mult)));
      }
      //println("finalPos = " + finalPos[i][j]);
    }
  }

  myFont1 = createFont("Consolas", 14, true);
}

void draw() {      
  if (record == true) {
    beginRaw(DXF, "output.dxf"); // Start recording to the file
  }

  background(255);

  pushMatrix();
  lights();
  directionalLight(128, 128, 128, 0, 0, -1);
  translate(5, -100, 0);

  //println("vecMesh[0][0].x = " + vecMesh[0][0].x);
  println("particles[0][0].pos.x = " + particles[0][0].pos.x);

  for (int i = 0; i < num; i++) {
    for (int j = 0; j < num; j++) { 
      particles[i][j].arrive(vecMesh[i][j]);
      particles[i][j].run();
    }
  }

  noStroke();
  for (int i = 0; i < num; ++i) {
    for (int j = 0; j < num; ++j) {
      if ((int)particles[i][j].pos.x == (int)vecMesh[i][j].x && 
        (int)particles[i][j].pos.y == (int)vecMesh[i][j].y && (int)particles[i][j].pos.z==(int)vecMesh[i][j].z) {
        fill(#F52411, 150);
        pushMatrix();
        translate(vecMesh[i][j].x, vecMesh[i][j].y, vecMesh[i][j].z);
        box(12);
        popMatrix();
      } else {
        fill(50, 150);
        pushMatrix();
        translate(vecMesh[i][j].x, vecMesh[i][j].y, vecMesh[i][j].z);
        box(10);
        popMatrix();
        iter++;
        velAve = (velAve + (particles[i][j].vel.x + particles[i][j].vel.y + particles[i][j].vel.z)/3)/25;
      }
    }
  }

  stroke(255);
  strokeWeight(1);

  for (int i = 0; i < num; i++) {
    for (int j = 0; j < num; j++) {        
      if (showParticles) {
        if ((int)particles[i][j].pos.x == (int)vecMesh[i][j].x 
          && (int)particles[i][j].pos.y == (int)vecMesh[i][j].y && (int)particles[i][j].pos.z==(int)vecMesh[i][j].z) {
          colorOff = true;
        } else colorOff = false;
        particles[i][j].drawParticle(i, j, colorOff);
      }
    }
  }

  for (int i = 0; i < num-1; ++i) {
    for (int j = 0; j < num-1; ++j) {
      fill(150, 100);
      stroke(100, 100);
      beginShape(TRIANGLE_STRIP);
      vertex (particles[i][j].pos.x, particles[i][j].pos.y, particles[i][j].pos.z);
      vertex (particles[i+1][j].pos.x, particles[i+1][j].pos.y, particles[i+1][j].pos.z);
      vertex (particles[i][j+1].pos.x, particles[i][j+1].pos.y, particles[i][j+1].pos.z);
      vertex (particles[i+1][j+1].pos.x, particles[i+1][j+1].pos.y, particles[i+1][j+1].pos.z);    
      endShape();
    }
  }

  camera.beginHUD(); 
  textFont(myFont1);
  fill(80);
  textAlign(LEFT, TOP);
  text("Point cloud nodes" + ": " + pointList.size(), 40, 740);
  text("Mesh size" + ": " + num + " x " + num + " = " + (int)sq(num), 40, 760);
  text("Iterations" + ": " + iter, 40, 780);
  text("Average velocity" + ": " + velAve, 40, 800);
  text("(measured in pixels/iteration)", 40, 820);
  camera.endHUD();
  popMatrix();

  if (record == true) {
    endRaw();
    record = false; // Stop recording to the file
  }
  
  //saveFrame("image-#####.tif");
  
}

void importTextData() {   
  String[] data = loadStrings("pointCloud.txt"); 
  String everything = join(data, " ");
  String delimeters = "{,,} ";
  //float minVal = min(everything);

  for (int i = 0; i < data.length*3; i +=3) {
    values = splitTokens(everything, delimeters);
    // println( values);
    float xx = float(values[i]);                     // cast string value to a float values
    float yy = float(values[i+1]);                   // cast string value to a float values
    float zz = float(values[i+2]);                   // cast string value to a float values

    // println(i + " " + (i + 1) + " " + (i + 2)) ;    
    // println(values[i] + " " + (values[i+1]) + " " + (values[i+2])) ;                   
    pointList.add( new PVector(xx, yy, zz) ); // add values to a new array slot

    Object[] temp = pointList.toArray();
    /* create an empty Array of PVectors */
    pointListToArray = new PVector[pointList.size()];
    for (int k = 0; k < temp.length; ++k) 
    {  
      pointListToArray[k] = (PVector) temp[k];
      //println(pointListToArray);
    }
  }
}

void keyReleased() {
  if (key == 'R' || key =='r') {
    setup();
    draw();
  }
  if (key == 'U' || key =='u') {
    reverse = true;
    setup();
    draw();
    reverse = false;
  }
  if (key == 'S' || key =='s') saveFrame("image-###.tiff"); // save image
  if (key == 'D' || key =='d') showParticles = !showParticles; // toggle dots
  if (key == 'X' || key == 'x') record = true;
}