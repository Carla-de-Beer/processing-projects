// Carla de Beer
// Created: January 2014
// Updated: March 2018
// Lissajous and parametric curve equations that generate geometric patterns.
// similar to that created by a traditional spirograph.
// Change the parameters to the equations to generate different patterns.
// Inspiration taken from: "Chapter 10: Paramteric Equations and Polar Coordinates" in: 
// STEWART, J., 2012. "Calculus Early Transcendentals". 7th Edition, p636 - 641.

public static final int CHOICE = 7;
float r = 165.0;
float theta = 0.0;
PVector pos;
PVector prev;

void setup() {
  size(650, 650);
  pixelDensity(displayDensity());
  background(255);
  smooth();
  colorMode(RGB);
  prev = new PVector();
}

void draw() {

  pos = getCoordinates(CHOICE);

  if (pos.x == -999 & pos.y == -999) {
    fill(10, 200);
    text("Invalid input parameter provided", 230, 300);
    text("Enter an integer value from 1 to 15", 225, 318);
    noLoop();
  }

  pushMatrix();

  noStroke();
  noFill();
  stroke(pos.mag(), 25, 255);
  strokeWeight(1);

  translate(width*0.5, height*0.5);
  if (frameCount == 1) {
    fill(255, 0, 0, 50);
    prev.x = pos.x;
    prev.y = pos.y;
    println(theta);
  }

  if (frameCount > 2) {
    line(prev.x, prev.y, pos.x, pos.y);
  }

  prev.x = pos.x;
  prev.y = pos.y;

  theta += 0.005;
  //println(theta);

  popMatrix();
}

PVector getCoordinates(int choice) {
  float x = 0.0;
  float y = 0.0;
  switch(choice) {
  case 1:
    // 1. Circle (basic parametric equation)
    x = 1.5*r*cos(theta);
    y = 1.5*r*sin(theta);
    break;
  case 2:
    // 2. Lissajous
    x = 1.5*r*cos(theta*PI);
    y = 1.5*r*sin(2*theta*PI);
    break;
  case 3:
    // 3. Lissajous
    x = 1.5*r*cos(5*theta*PI);
    y = 1.5*r*sin(4*theta*PI);
    break;
  case 4:
    // 4. Lissajous
    x = 1.5*r*cos(8*theta + PI/4);
    y = 1.5*r*sin(5*theta);
    break;
  case 5:
    // 5. Lissajous
    x = 1.5*r*sin(11*theta + PI/2);
    y = 1.5*r*sin(10*theta);
    break;
  case 6:
    // 9. Parametric curve equation (heart)
    x = 1.5*r*pow(cos(5*theta*PI), 3);
    y = 1.5*r*pow(sin(4*theta*PI), 3);
    break;
  case 7:
    // 9. Parametric curve equation
    x = 60*5*pow(sin(theta), 3);
    y = 60*(4*cos(theta) - 1.3*cos(2*theta) - 0.6*cos(3*theta) - 0.2*cos(4*theta)) + 25;
    break;  
  case 8:
    // 8. Parametric curve equation
    float rr = 300*sin(6*theta);
    x = rr*cos(theta);
    y = rr*sin(theta);
    break;  
  case 9:
    // 9. Parametric curve equation
    x = 1.2*(r*sin(theta) + r*0.5*cos(5*theta) + r*0.25*sin(13*theta));
    y = 1.2*(r*cos(theta) + r*0.5*sin(5*theta) + r*0.25*cos(13*theta));
    break;  
  case 10:
    // 10. Parametric curve equation
    x = 0.75*(r*sin(theta) + r*cos(5*theta) + r*0.5*sin(15*theta));
    y = 0.75*(r*cos(theta) + r*sin(5*theta) + r*0.5*cos(15*theta));
    break;  
  case 11:
    // 11. Parametric curve equation
    x = 0.75*(r*sin(theta) + r*cos(10*theta + PI/2) + r*0.5*sin(15*theta));
    y = 0.75*(r*cos(theta) + r*sin(10*theta + PI/2) + r*0.5*cos(15*theta));

    break;  
  case 12:
    // 12. Parametric curve equation
    x = 0.95*r*cos(theta) - r*pow(cos(7*theta), 7);
    y = 0.95*r*sin(theta) - r*pow(sin(7*theta), 7);
    break;
  case 13:
    // 13. Parametric curve equation
    x = 150*(sin(theta) - sin(2.3 * theta));
    y = 300*cos(theta);
    break;
  case 14:
    // 14. Parametric curve equation
    x = r*sin(theta) + r*0.5*sin(5*theta) + r*0.25*cos(2.3*theta);
    y = r*cos(theta) + r*0.5*cos(5*theta) + r*0.25*sin(2.3*theta);
    break;
  case 15:
    // 15. Parametric curve equation (butterfly)
    float a = pow(exp(1.0), cos(theta));
    float b = 2*cos(4*theta);
    float c = pow(sin(theta/12), 5);
    x = 0.50*r*sin(theta)*(a - b - c);
    y = 0.50*r*cos(theta)*(a - b - c) - 55;
    break;
  default: 
    return new PVector(-999, -999);
  }
  return new PVector(x, y);
}

void keyReleased() {
  if (key == 'R' || key == 'r') setup();
  if (key == 'S' || key == 's') saveFrame();
}