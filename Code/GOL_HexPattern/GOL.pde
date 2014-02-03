// Hexagonal implementation of Daniel Shiffman's 2D CA

// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// A basic implementation of John Conway's Game of Life CA

class GOL {

  float w = 10;
  float h = sin(radians(60))*w;
  int columns, rows;
  // Game of life board
  Cell[][] board;

  GOL() {
    // Initialize rows, columns and set-up arrays
    columns = width/int(w*3);
    rows = height/int(h);
    println("columns = " + columns);
    println("rows = " + rows);
    board = new Cell[columns][rows];
    init();
  }

  void init() {
    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        if (j % 2 == 0) board[i][j] = new Cell(i*w*3, j*h, w);
        else board[i][j] = new Cell(i*w*3 + w + w/2, j*h, w);
      }
    }
  }


  // The process of creating the new generation
  void generate() {
    for ( int i = 0; i < columns;i++) {
      for ( int j = 0; j < rows;j++) {
        board[i][j].savePrevious();
      }
    }

    // Loop through every spot in our 2D array and check spots neighbors
    for (int x = 0; x < columns; x++) {
      for (int y = 0; y < rows; y++) {

        // Add up all the states in a 3x3 surrounding grid
        int neighbors = 0;
        for (int i = -1; i <= 1; i++) {
          for (int j = -1; j <= 1; j++) {
            neighbors += board[(x+i+columns)%columns][(y+j+rows)%rows].previous;
          }
        }

        // A little trick to subtract the current cell's state since
        // we added it in the above loop
        neighbors -= board[x][y].previous;

        // Rules of Life
        if ((board[x][y].state == 1) && (neighbors < 2)) board[x][y].newState(0); // Loneliness
        else if ((board[x][y].state == 1) && (neighbors > 3)) board[x][y].newState(0); // Overpopulation
        else if ((board[x][y].state == 0) && (neighbors == 3)) board[x][y].newState(1); // Reproduction
        // else do nothing!
      }
    }
  }

  // This is the easy part, just draw the cells, fill 255 for '1', fill 0 for '0'
  void display() {
    for ( int i = 0; i < columns;i++) {
      for ( int j = 0; j < rows;j++) {
        fill(255);
        if ( (i % 2 == j % 2)) fill(230);
        if (board[i][j].previous == 0 && board[i][j].state == 1) fill(0, 255, 0);
        else if (board[i][j].state == 1) fill(0, 0, 255);
        else if (board[i][j].previous == 1 && board[i][j].state == 0) fill(255, 0, 0);
        //else fill(255);
        board[i][j].display();
      }
    }
  }
}

