// Carla de Beer
// January 2014
// Lissajous and parametric curve equations that generate geometric patterns 
// similar to that created by a traditional spirograph
// Change the parameters to the equations to generate different patterns

float r = 165.0;
float theta = 0.0;
public static final int STOP = 90;


void setup() {
  size(650, 650);
  background(255);
  smooth();
}

void draw() {
  if (theta <= STOP)
  {
    //float x = r*cos(theta); //circle
    //float y = r*sin(theta); //circle

    float x = r*sin(theta) + r*0.5*cos(5*theta) + r*0.25*sin(13*theta); // parametric curve equation 1
    float y = r*cos(theta) + r*0.5*sin(5*theta) + r*0.25*cos(13*theta); // parametric curve equation 1

    //float x = r*sin(theta) + r*0.5*sin(5*theta) + r*0.25*cos(2.3*theta); // parametric curve equation 2
    //float y = r*cos(theta) + r*0.5*cos(5*theta) + r*0.25*sin(2.3*theta); // parametric curve equation 2

    //float x = r*cos(theta) -r*pow(cos(7*theta), 7); // parametric curve equation 3
    //float y = r*sin(theta) -r*pow(sin(7*theta), 7); // parametric curve equation 3

    /*
    float a = pow(exp(1.0), cos(theta));
     float b = 2*cos(4*theta);
     float c = pow(sin(theta/12), 5);
     float x = r*sin(theta)*(a - b - c);// butterfly
     float y = r*cos(theta)*(a - b - c);// butterfly
     */

    //float x = r*3*sin(11*theta + PI/2); // lissajous
    //float y = r*3*sin(10*theta); // lissajous

    noStroke();
    fill(0);
    fill(y*10, 10, 100);
    ellipse(x + width/2, y + height/2, 1, 1);

    theta += 0.005;
    println(theta);
    if ((int)theta == STOP) {
      println("DONE");
      saveFrame("curve-###.tiff");
    }
  }
}

void keyReleased()
{
  if (key == 'R' || key == 'r') setup();
  if (key == 'S' || key == 's') saveFrame();
}

