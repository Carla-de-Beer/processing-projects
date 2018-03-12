class Landscape {
  int scl;           // size of each cell
  int w, h;          // width and height of thingie
  int rows, cols;    // number of rows and columns
  float[][] z;       // using an array to store all the height values 
  float max;
  float min, ave;

  Landscape(int scl, int w, int h) {
    this.scl = scl;
    this.w = w;
    this.h = h;
    cols = w/scl;
    rows = h/scl;
    z = new float[cols][rows];
  }

  // Calculate height values
  void calculate() {

    float [][] array2d = new float[cols][rows];
    float [] array1d = new float[cols*rows];
    fft.forward(player.mix);

    // Convert from ArrayList to 1D array
    for (int i = 0; i < fft.specSize(); i++) {
      array1d[i] = fft.getBand(i);
    } 

    max = max(array1d);
    min = min(array1d);

    for (int i = 0; i < array1d.length; ++i) {
      ave += array1d[i];
    }
    ave /= (float)(array1d.length); 

    // Convert 1D array to 2Darray
    for (int i = 0; i < cols; i++) { 
      for (int j = 0; j < rows; j++) {
        array2d[i][j] = array1d[(i*rows/2) + j];
      }
    }
    // Map the values
    for (int i = 0; i < cols; i++) { 
      for (int j = 0; j < rows; j++) {
        z[i][j] = map(array2d[i][j], 0, 0.02, 0.15, 0.215);
      }
    }
  }

  // Render landscape as grid of quad_strips
  void render() {
    for (int x = 0; x < z.length-1; x++) {
      for (int y = 0; y < z[x].length-1; y++) {
        stroke(50);
        strokeWeight(0.5); 

        // Blue-red
        float r = 255 - z[x][y]*100;
        float g = z[x][y]*10 ;
        float b = z[x][y]*50;

        // Standard
        //float r = z[x][y]*200;
        //float g = 255 - (z[x][y]*30);
        //float b = z[x][y];

        fill(r, g, b, 200);

        pushMatrix();
        beginShape(QUAD_STRIP);
        translate(x*scl-w/2, y*scl-h/2, 0);
        vertex(0, scl, z[x][y+1]);
        vertex(0, 0, z[x][y]);
        vertex(scl, scl, z[x+1][y+1]);
        vertex(scl, 0, z[x+1][y]);
        endShape();
        popMatrix();
      }
    }
  }
}