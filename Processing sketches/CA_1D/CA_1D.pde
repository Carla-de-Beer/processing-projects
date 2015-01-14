// Carla de Beer
// January 2015
// 1D Cellular Automata played out on a 2D lozenge-shaped grid

// Rule set
// Modify the input values here:
int [] response = {
  0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0
}; // rules

Cell [][] cell;
int num = 90;
int n = num;
int jVal = (int)(num*2-(num)+3);

void setup()
{
  background(255);
  size(910, 825);

  cell = new Cell[width][height];
  for (int i = 0; i < num; ++i) {
    for (int j = 0; j < num*2-10; ++j) {
      if (j % 2 == 0) cell[i][j] = new Cell(width/n*i, sin(radians(60))*j*width/n, width/n);
      else cell[i][j] = new Cell( width/n*i + cos(radians(60))*width/(n/2) - width/(n*2), sin(radians(60))*j*width/n, width/n);
    }
  }
}

void draw()
{
  strokeWeight(0.5);
  pushMatrix();
  translate(0, width/n *sin(radians(60)));


  // Modify the input values here:
  for (int i = 0; i < num; ++i) {
    for (int j = 0; j < jVal; ++j) {
      if ( (i == 0 && j == 0) || (i == 21 && j == 0) || (i == 25 && j == 0) || (i == 27 && j == 0)
        || (i == 28 && j == 0) || (i == 5 && j == 0) || (i == 42 && j == 0)
        || (i == 44 && j == 0) || (i == 50 && j == 0) || (i == 46 && j == 0)  
        || (i == 55 && j == 0) || (i == 56 && j == 0) || (i == 65 && j == 0) 
        || (i == 72 && j == 0) || (i == 79 && j == 0) || (i == 88 && j == 0) 
        ) 
        cell[i][j].value = true;

      else if (cell[i][j].value == true) fill(100);
      else fill(255);

      cell[i][j].display();

      int val = 0;
      //println("i = " + i);
      //println("j = " + j);
      
      if (cell[(i-1 + num) % num][(j-1 + jVal) % jVal].value == true) {
        val+=16; // 2 to power of 4 = 16
      }
      if (cell[i][(j-1 + jVal) % jVal].value == true) {
        val+=4; // 2 to power of 2 = 4
      }
      if (cell[i][(j-1 + jVal) % jVal].value == true) {
        val+=1; // 2 to power of 0 = 1
      }

      if (response[val] == 1) {
        cell[i][j].value = true;
        fill(100, 128);
      }
    }
  }
  popMatrix();
}

void keyReleased()
{
  saveFrame();
}

