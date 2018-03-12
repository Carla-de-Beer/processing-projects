// Carla de Beer
// Created: November 2016; updated October 2017.
// Minimum Spanning Tree (Prim's Algorithm) connecting the 50 largest cities in the US.

// Based on Daniel Shiffman's Minimum Spanning Tree solution from the Coding Train coding challenges series:
// https://www.youtube.com/watch?v=BxabnKrOjT0
// Also based on Daniel Shiffman's Web Mercator projection example:
// https://www.youtube.com/watch?v=ZiYdOwOrGyc&t=1705s
// Haversine distance formula: 
// http://stackoverflow.com/questions/27928/calculate-distance-between-two-latitude-longitude-points-haversine-formula

import java.util.*;

BufferedReader reader;

ArrayList<Float> lonList = new ArrayList<Float>();
ArrayList<Float> latList = new ArrayList<Float>();
ArrayList<String> nameList = new ArrayList<String>();
ArrayList<Float> tmpLon = new ArrayList<Float>();
ArrayList<Float> tmpLat = new ArrayList<Float>();
ArrayList<City> path = new ArrayList<City>();
ArrayList<City> pathTrue = new ArrayList<City>();

float minLon, maxLon, minLat, maxLat;
int NUM_CITIES = 50;
float sumHaversine = 0.0;
String haversineDistance = "";

PImage img;
int imageWidth = 1024;
int imageHeight= 512;

float clat = 36.2672;
float clon = -97.7431;
float lat = 32.715738;
float lon = -117.1610838;
int zoom = 3;

PFont fontHeaderBold;
PFont fontBody, fontBodyBold;
PFont mapBody;

color coloured = color(255, 64, 64);
color pink = color(245, 0, 145);
color white = color(250);
color lightWhite = color(250, 220);
color darkGray = color(80, 200);
color mapGray = color(184);
color dots = color(250, 200);

void settings() {
  size(1024, 512);
  pixelDensity(displayDensity());
}

void setup() {
  img = loadImage("data/map.jpg");
  imageMode(CENTER);
  reader = createReader("data/cities.txt");
  fontHeaderBold = createFont("Arial-BoldMT", 20);
  fontBody = createFont("ArialMT", 12);
  fontBodyBold = createFont("Arial-BoldMT", 12);
  mapBody = createFont("Helvetica-Bold", 11);
}

void draw() {
  if (frameCount < NUM_CITIES + 1) {
    background(255);
    textSize(20);
    path.clear();
    pathTrue.clear();
    init();
  } else if (frameCount >= NUM_CITIES + 1 && frameCount <= NUM_CITIES + 2) {
    translate(width * 0.5, height * 0.5);
    background(255);
    image(img, 0, 0, width, height);

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

      // Draw the line 
      strokeWeight(2);
      line(reached.get(rIndex).lon, reached.get(rIndex).lat, unreached.get(uIndex).lon, unreached.get(uIndex).lat);

      reached.add(unreached.get(uIndex));
      unreached.remove(uIndex);

      reachedTrue.add(unreachedTrue.get(uIndex));
      unreachedTrue.remove(uIndex);
    }

    // Calculate Haversine distance
    sumHaversine = 0.0;
    for (int i = 0; i < NUM_CITIES - 1; ++i) {
      sumHaversine += haversine(reachedTrue.get(i).lon, reachedTrue.get(i + 1).lon, reachedTrue.get(i).lat, reachedTrue.get(i + 1).lat);
    }

    //println(sumHaversine);
    haversineDistance = convertToCommaString((float)sumHaversine);

    fill(lightWhite);
    noStroke();
    for (int i = 0; i < path.size(); ++i) {
      ellipse(path.get(i).lon, path.get(i).lat, 8, 8);
    }

    stroke(coloured);
    strokeWeight(1);

    for (City c : path) {
      fill(lightWhite, 170);
      ellipse((float)c.lon, (float)c.lat, 8, 8);

      textFont(mapBody);
      if (c.name.equals("Boston") || c.name.equals("New York") || 
        c.name.equals("Washington") || c.name.equals("Virginia Beach") ||
        c.name.equals("Charlotte") || c.name.equals("Jacksonville") ||
        c.name.equals("Milwaukee") || c.name.equals("Kansas City") ||
        c.name.equals("Detroit") || c.name.equals("Wichita") ||
        c.name.equals("Tulsa") || c.name.equals("Memphis") ||
        c.name.equals("Dallas") || c.name.equals("El Paso") || 
        c.name.equals("Albuquerque") || c.name.equals("Las Vegas") || 
        c.name.equals("Phoenix") || c.name.equals("Fresno") || 
        c.name.equals("Omaha") || c.name.equals("Portland") || 
        c.name.equals("Seattle")) { 
        fill(lightWhite, 200);
        text(c.name, (float)c.lon + 9.5, (float)c.lat + 4.5);
        text(c.name, (float)c.lon + 8.5, (float)c.lat + 3.5);
        fill(mapGray);
        text(c.name, (float)c.lon + 9, (float)c.lat + 4);
      } else if ( c.name.equals("Minneapolis") || c.name.equals("San Antonio")) {
        fill(lightWhite, 200);
        text(c.name, (float)c.lon - 73.5, (float)c.lat - 0.5);
        text(c.name, (float)c.lon -72.5, (float)c.lat - 1.5);
        fill(mapGray);
        text(c.name, (float)c.lon - 73, (float)c.lat - 1);
      } else if (c.name.equals("Denver")) {
        fill(lightWhite, 200);
        text(c.name, (float)c.lon - 46.5, (float)c.lat + 2.5);
        text(c.name, (float)c.lon - 45.5, (float)c.lat + 1.5);
        fill(mapGray);
        text(c.name, (float)c.lon - 46, (float)c.lat + 2);
      }
    }

    printText(haversineDistance);
  } else if (frameCount == NUM_CITIES + 2) {
    println("DONE");
    noLoop();
  }
}

float haversine(float lon1, float lon2, float lat1, float lat2) {
  double p = 0.017453292519943295;
  double a = 0.5 - Math.cos((lat2 - lat1) * p) * 0.5
    + Math.cos(lat1 * p) * Math.cos(lat2 * p) * (1 - Math.cos((lon2 - lon1) * p)) * 0.5;
  return (float)(12742 * Math.asin(Math.sqrt(a)));
}

void init() {
  fill(coloured);
  textFont(fontHeaderBold);
  text("Parsing the city data", width/2 - 100, height/2 - 15);
  parse(reader, lonList, latList, nameList);

  for (int i = 0; i < latList.size(); ++i) {
    tmpLon.add(lonList.get(i));
    tmpLat.add(latList.get(i));
  }

  Collections.sort(tmpLon);
  Collections.sort(tmpLat);

  maxLon = tmpLon.get(0);
  minLon = tmpLon.get(tmpLon.size() - 1);
  maxLat = tmpLat.get(0);
  minLat = tmpLat.get(tmpLat.size() - 1);

  for (int i = 0; i < latList.size(); ++i) {
    double cx = webMercatorX(clon);
    double cy = webMercatorY(clat);
    double x = webMercatorX(lonList.get(i)) - cx;
    double y = webMercatorY(latList.get(i)) - cy;

    path.add(new City((float)x, (float)y, nameList.get(i)));
    pathTrue.add(new City(lonList.get(i), latList.get(i), nameList.get(i)));
  }
}

void parse(BufferedReader reader, ArrayList<Float> list1, ArrayList<Float> list2, ArrayList<String> list3) {
  try {
    String line = reader.readLine(); 
    if (line != null) {
      String [] bits = line.split(", "); 
      float lon = float(bits[1]); 
      float lat = float(bits[0]); 
      String name = bits[2]; 
      list1.add(lon);
      list2.add(lat);
      list3.add(name);
    }
  }
  catch(IOException e) {
    println(e);
  }
} 

double webMercatorX(float lon) {
  lon = radians(lon);
  double a = (256 / Math.PI) * Math.pow(2, zoom);
  double b = lon + Math.PI;
  return a * b;
}

double webMercatorY(float lat) {
  lat = radians(lat);
  double a = (256 / Math.PI) * Math.pow(2, zoom);
  double b = Math.tan(Math.PI * 0.25 + lat * 0.5);
  double c = Math.PI - Math.log(b);
  return a * c;
}

String convertToCommaString(float fitness) {
  String fitnessString = "";
  StringBuilder resString;
  fitnessString = String.format("%.2f", fitness);
  resString = new StringBuilder(fitnessString);
  int index1 = fitnessString.indexOf('.');
  resString.insert(index1 - 3, ',');
  return resString.toString();
}

void printText(String haversineDistance) {
  int offset = -485;
  fill(darkGray);
  text("Connecting the " + Integer.toString(NUM_CITIES) + " largest cities in the US ", offset, 210);
  text("The total distance of the conection: " + haversineDistance + " km (Haversine distance)", offset, 230);
}