// Carla de Beer
// November 2016
// Minimum Spanning Tree (Prim's Algorithm) connecting the 35 larget cities in the US.
// Based on Daniel Shiffman's Minimum Spanning Tree solution from the Coding Rainbow coding challenges series:
// https://www.youtube.com/watch?v=BxabnKrOjT0

import java.util.*;

BufferedReader reader;
float maxLat, maxLon, minLat, minLon;
ArrayList<Float> latList = new ArrayList<Float>();
ArrayList<Float> lonList = new ArrayList<Float>();
ArrayList<String> nameList = new ArrayList<String>();
ArrayList<Float> tmpLat = new ArrayList<Float>();
ArrayList<Float> tmpLon = new ArrayList<Float>();

ArrayList<City> path = new ArrayList<City>();
int NUM_CITIES = 35;

color pink = color(255, 0, 120);
color white = color(250);

void setup() {
  size(700, 800);
  reader = createReader("cities.txt");
}

void draw() {
  background(0);

  if (frameCount < NUM_CITIES + 10) {
    textSize(20);
    path.clear();
    init();
  } else if (frameCount >= NUM_CITIES + 10) {
    textSize(12);

    ArrayList<City> reached = new ArrayList<City>();
    ArrayList<City> unreached= new ArrayList<City>(path);

    reached.add(unreached.get(0));
    unreached.remove(0);

    while (unreached.size() > 0) {
      double record = Double.POSITIVE_INFINITY;
      int rIndex = 0;
      int uIndex = 0;
      for (int i = 0; i < reached.size(); ++i) {
        for (int j = 0; j < unreached.size(); ++j) {
          double d = reached.get(i).dist(unreached.get(j));
          if (d < record) {
            record = d;
            rIndex = i;
            uIndex = j;
          }
        }
      }

      line(reached.get(rIndex).lat, reached.get(rIndex).lon, unreached.get(uIndex).lat, unreached.get(uIndex).lon);
      reached.add(unreached.get(uIndex));
      unreached.remove(uIndex);
    }

    fill(white);
    for (int i = 0; i < path.size(); ++i) {
      ellipse(path.get(i).lat, path.get(i).lon, 8, 8);
    }

    stroke(255);
    strokeWeight(2);
    stroke(pink);

    for (City c : path) {
      ellipse((float)c.lat, (float)c.lon, 8, 8);
      if (c.name.equals("Washington") || c.name.equals("Seattle") || 
        c.name.equals("Indianapolis") || c.name.equals("Oklahoma City") || 
        c.name.equals("Portland") || c.name.equals("Milwaukee") ||
        c.name.equals("San Antonio")) {
        text(c.name, (float)c.lat + 8, (float)c.lon + 15);
      } else if (c.name.equals("San Francisco")) {
        text(c.name, (float)c.lat + 8, (float)c.lon + 17);
      } else if (c.name.equals("Dallas") || c.name.equals("Sacramento") ||
        c.name.equals("New York") || c.name.equals("Philadelphia") ||
        c.name.equals("Baltimore") ) {
        text(c.name, (float)c.lat + 8, (float)c.lon - 5);
      } else text(c.name, (float)c.lat + 11, (float)c.lon + 4);
    }

    printText();
  }
}

void init() {
  fill(white);
  text("Parsing the city data", 250, 350);
  parse(reader, latList, lonList, nameList);

  for (int i = 0; i < latList.size(); ++i) {
    tmpLat.add(latList.get(i));
    tmpLon.add(lonList.get(i));
  }

  Collections.sort(tmpLat);
  Collections.sort(tmpLon);

  maxLat = tmpLat.get(0);
  minLat = tmpLat.get(tmpLat.size() - 1);
  maxLon = tmpLon.get(0);
  minLon = tmpLon.get(tmpLon.size() - 1);

  for (int i = 0; i < latList.size(); ++i) {
    float xx = map(latList.get(i), minLat, maxLat, 50, width - 100);
    float yy = map(lonList.get(i), minLon, maxLon, 45, height - 192);
    path.add(new City(xx, yy, nameList.get(i)));
  }
}

void parse(BufferedReader reader, ArrayList<Float> list1, ArrayList<Float> list2, ArrayList<String> list3) {
  try {
    String line = reader.readLine(); 
    if (line != null) {
      String [] bits = line.split(", "); 
      float lat = float(bits[0]); 
      float lon = float(bits[1]); 
      String name = bits[2]; 
      list1.add(lat);
      list2.add(lon);
      list3.add(name);
    }
  }
  catch(IOException e) {
    println(e);
  }
} 

void printText() {
  fill(white, 200);
  text("Connecting the " + NUM_CITIES + " largest cities in the US ", 45, height - 35);
}