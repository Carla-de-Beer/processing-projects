// k-Nearest Neighbour clustering algorithm
// Clusters the iris data set based on sepal length and width.
// Use the up and down arrows to increment or decrement the size of k.
//
// Ported to Eclipse from the original Processign code.
//
// Based on Daniel Shiffman's Coding Rainbow series: 
// http://codingrainbow.com/
// Data is the classic "Iris Data Set"
// https://archive.ics.uci.edu/ml/datasets/Iris

import processing.core.PApplet;
import processing.core.PFont;
import processing.data.FloatList;
import processing.data.IntDict;
import processing.data.Table;
import processing.data.TableRow;

import java.util.*;

public class Main extends PApplet {

	int k = 5;
	Table data;

	PFont boldLarge;
	PFont regular, bold, italic;

	String column1 = "slength";
	String column2 = "swidth";
	int setosa = color(255, 255, 0); // yellow
	int versicolor = color(0, 255, 255); // cyan
	int virginica = color(255, 0, 255); // pink

	public static void main(String[] args) {
		PApplet.main("Main");
	}

	public void settings() {
		size(600, 600);
		pixelDensity(displayDensity());
	}

	public void setup() {
		data = loadTable("iris.csv", "header");

		boldLarge = loadFont("Arial-BoldMT-14.vlw");
		bold = loadFont("Arial-BoldMT-12.vlw");
		regular = loadFont("ArialMT-12.vlw");
		italic = loadFont("Arial-ItalicMT-12.vlw");
	}

	public void draw() {
		background(0);

		// Normalise all the data between 0 and 1
		// Not really necessary for Iris dataset, but good practice
		for (int i = 0; i < 4; ++i) {
			FloatList all = data.getFloatList(i);
			float mn = all.min();
			float mx = all.max();
			for (TableRow row : data.rows()) {
				float val = row.getFloat(i);
				row.setFloat(i, map(val, mn, mx, 0, 1));
			}
		}

		// Classify every possible spot in 2D space
		for (float x = 0; x < width; x += 4) {
			for (float y = 0; y < height; y += 4) {
				float xval = x / width;
				float yval = y / height;

				// List of all neighbors by distance
				ArrayList<Neighbour> neighbors = new ArrayList<Neighbour>();
				for (TableRow row : data.rows()) {
					float sx = row.getFloat(column1);
					float sy = row.getFloat(column2);
					// For demo purposes I'm only using 2 properties of the
					// dataset
					float d = dist(xval, yval, sx, sy);
					neighbors.add(new Neighbour(d, row.getString("class")));
				}

				// Sort ArrayList by d-value
				Collections.sort(neighbors, new Comparator<Neighbour>() {
					public int compare(Neighbour nb1, Neighbour nb2) {
						float diff = nb2.d - nb1.d;
						if (diff < 0) {
							return 1;
						} else if (diff > 0) {
							return -1;
						} else {
							return 0;
						}
					}
				});

				// In the top k spots, how many neighbors per category
				IntDict knn = new IntDict();
				for (int i = 0; i < k; ++i) {
					// Count how many of each type in the top k-spots
					Neighbour nb = neighbors.get(i);
					if (knn.hasKey(nb.cat)) {
						knn.increment(nb.cat);
					} else {
						knn.set(nb.cat, 1);
					}
				}

				// Sort by number and get top values
				knn.sortValuesReverse();
				String cat = knn.key(0);

				// Draw rectangle for this spot
				if (cat.equals("Iris-setosa")) {
					fill(setosa, 200);
				} else if (cat.equals("Iris-versicolor")) {
					fill(versicolor, 200);
				} else {
					fill(virginica, 200);
				}
				noStroke();
				strokeWeight(1);
				// stroke(255, 180);
				rect(x, y, 4, 4);
			}
		}

		// Show the original data
		for (TableRow row : data.rows()) {
			float x = row.getFloat(column1);
			float y = row.getFloat(column2);
			String cat = row.getString("class");
			if (cat.equals("Iris-setosa")) {
				fill(setosa);
			} else if (cat.equals("Iris-versicolor")) {
				fill(versicolor);
			} else {
				fill(virginica);
			}
			noStroke();
			ellipse(x * width, y * height, 8, 8);
		}

		printToScreen();
	}

	public void keyPressed() {
		if (key == CODED) {
			if (keyCode == UP) {
				++k;
			} else if (keyCode == DOWN) {
				--k;
				if (k == 0) {
					k = 1;
				}
			}
		}
	}

	public void printToScreen() {
		textFont(boldLarge);
		textAlign(LEFT);
		fill(255);
		text("k: " + k, 20, height - 65);
		textFont(regular);
		text("UP ARROW: increase k", 20, height - 40);
		text("DOWN ARROW: decrease k", 20, height - 20);

		textFont(italic);
		text("Iris-setosa", 40, height - 120);
		text("Iris-versicolor", width / 2 - 50, 40);
		textAlign(RIGHT);
		text("Iris-virginica", width - 40, height - 120);
	}
}