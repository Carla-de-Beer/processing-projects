// Carla de Beer
// November 2016
// Minimum Spanning Tree (Prim's Algorithm) connecting the 35 larget cities in the US.
// Based on Daniel Shiffman's Minimum Spanning Tree solution from the Coding Rainbow coding challenges series:
// https://www.youtube.com/watch?v=BxabnKrOjT0
// Haversine distance formula: 
// http://stackoverflow.com/questions/27928/calculate-distance-between-two-latitude-longitude-points-haversine-formula

import java.util.*;

BufferedReader reader;
float maxLat, maxLon, minLat, minLon;
ArrayList<Float> latList = new ArrayList<Float>();
ArrayList<Float> lonList = new ArrayList<Float>();
ArrayList<String> nameList = new ArrayList<String>();
ArrayList<Float> tmpLat = new ArrayList<Float>();
ArrayList<Float> tmpLon = new ArrayList<Float>();

ArrayList<City> path = new ArrayList<City>();
ArrayList<City> pathTrue = new ArrayList<City>();
int NUM_CITIES = 36;
float haversineDistance = 0.0;

color pink = color(255, 0, 120);
color white = color(250);

void setup() {
  size(700, 800);
  reader = createReader("cities.txt");
}

void draw() {
  if (frameCount < NUM_CITIES ) {
    background(0);
    textSize(20);
    path.clear();
    pathTrue.clear();
    init(); // The BufferedReader has to be executed within the draw() loop
  } else if (frameCount >= NUM_CITIES && frameCount <= NUM_CITIES + 1) {
    textSize(12);
    background(0);

    ArrayList<City> reached = new ArrayList<City>();
    ArrayList<City> unreached = new ArrayList<City>(path);
    ArrayList<City> reachedTrue = new ArrayList<City>();
    ArrayList<City> unreachedTrue = new ArrayList<City>(pathTrue);

    reached.add(unreached.get(0));
    unreached.remove(0);

    reachedTrue.add(unreachedTrue.get(0));
    unreachedTrue.remove(0);

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
      if (frameCount < NUM_CITIES + 1) {
        haversineDistance += haversine(reachedTrue.get(rIndex).lat, unreachedTrue.get(uIndex).lat, reachedTrue.get(rIndex).lon, unreachedTrue.get(uIndex).lon);
        println(haversineDistance);
      }

      reached.add(unreached.get(uIndex));
      unreached.remove(uIndex);

      reachedTrue.add(unreachedTrue.get(uIndex));
      unreachedTrue.remove(uIndex);
    }

    fill(white);
    noStroke();
    for (int i = 0; i < path.size(); ++i) {
      ellipse(path.get(i).lat, path.get(i).lon, 8, 8);
    }

    strokeWeight(2);
    stroke(pink);

    for (City c : path) {
      ellipse(c.lat, c.lon, 8, 8);
      if (c.name.equals("Washington") || c.name.equals("Seattle") || 
        c.name.equals("Indianapolis") || c.name.equals("Oklahoma City") || 
        c.name.equals("Portland") || c.name.equals("Milwaukee") ||
        c.name.equals("San Antonio")) {
        text(c.name, c.lat + 8, c.lon + 15);
      } else if (c.name.equals("San Francisco")) {
        text(c.name, c.lat + 8, c.lon + 17);
      } else if (c.name.equals("Dallas") || c.name.equals("Sacramento") ||
        c.name.equals("New York") || c.name.equals("Philadelphia") ||
        c.name.equals("Baltimore") ) {
        text(c.name, c.lat + 8, c.lon - 5);
      } else text(c.name, c.lat + 11, c.lon + 4);
    }

    printText(haversineDistance);
  } else if (frameCount == NUM_CITIES + 2) {
    println("DONE");
    noLoop();
  }
}

double haversine(double lat1, double lat2, double lon1, double lon2) {
  double p = 0.017453292519943295;
  double a = 0.5 - Math.cos((lat2 - lat1) * p) / 2
    + Math.cos(lat1 * p) * Math.cos(lat2 * p) * (1 - Math.cos((lon2 - lon1) * p)) / 2;
  return 12742 * Math.asin(Math.sqrt(a));
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
    pathTrue.add(new City(latList.get(i), lonList.get(i), nameList.get(i)));
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

void printText(float haversineDistance) {
  fill(white, 200);
  text("Connecting the " + Integer.toString(NUM_CITIES - 1) + " largest cities in the US ", 45, height - 55);
  text("The total distance of the conection: " + haversineDistance + " km (Haversine distance)", 45, height - 35);
}