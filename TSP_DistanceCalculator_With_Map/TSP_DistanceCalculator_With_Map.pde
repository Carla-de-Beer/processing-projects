// Carla de Beer //<>//
// September 2016; updted March 2017
// Genetic algorithm to find an optimised solution to the Travelling Salesman Problem.
// The sketch dynamically reads in city data from a file and calculates the shortest distance it can find, linking all cities.
// The actual physical distance on the route, calculated as the Haversine distance, is also shown.
// Specifiable parameters: crossover rate, mutation rate, popuation size, max. no. iterations, elitism generation gap.
// City data obtained from: https://gist.github.com/Miserlou/c5cd8364bf9b2420bb29
// The crossover strategy makes use of Modified Order Crossover (MOX), as described in:
// http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.91.9167&rep=rep1&type=pdf
// Haversine distance formula: 
// http://stackoverflow.com/questions/27928/calculate-distance-between-two-latitude-longitude-points-haversine-formula

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.util.*;
import java.text.*;
import processing.pdf.*;

BufferedReader reader;
float maxLat, maxLon, minLat, minLon;
ArrayList<Float> latList = new ArrayList();
ArrayList<Float> lonList = new ArrayList();
ArrayList<String> nameList = new ArrayList();
ArrayList<Float> tmpLat = new ArrayList();
ArrayList<Float> tmpLon = new ArrayList();

int NUM_CITIES = 50;
int generation = 0;
int maxGeneration = 350;
int numPop = 5000;
double crossoverRate = 85.0;
double mutationRate = 25.0;
double generationGap = 25.0;
double sumHaversine = 0.0;

RandomStrategy randomStrategy;

ArrayList<City> path = new ArrayList();
ArrayList<City> pathTrue = new ArrayList();
ArrayList<Route> populationList = new ArrayList<Route>();

color red = color(242, 35, 50);
color white = color(250);
color lightWhite = color(250, 200);
color darkGray = color(80, 200);

PFont fontHeaderBold;
PFont fontBody, fontBodyBold;

double record = 0.0;
int converge = 0;
boolean isRecord = false;
String result;

Date dNow;
SimpleDateFormat ft;

PImage img;
int imageWidth = 1024;
int imageHeight= 512;

float clat = 36.2672;
float clon = -97.7431;
float lat = 32.715738;
float lon = -117.1610838;
int zoom = 3;

void setup() {
  size(1024, 512);
  img = loadImage("map.jpg");
  imageMode(CENTER);
  pixelDensity(displayDensity());
  frameRate(60);
  reader = createReader("cities.txt");
  background(255);
  fontHeaderBold = createFont("Arial-BoldMT.vlw", 22);
  fontBody = createFont("ArialMT", 12);
  fontBodyBold = createFont("Arial-BoldMT", 12);
}

void draw() {
  if (isRecord) {
    dNow = new Date();
    ft = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
    beginRecord(PDF, "./PDF/" + ft.format(dNow) + ".pdf");
    //beginRecord(PDF, "./PDF/" + args[0] + ".pdf");
  }

  if (generation >= maxGeneration - 1) {
    noLoop();
  }

  if (frameCount < NUM_CITIES + 10) {
    textFont(fontHeaderBold);
    path.clear();
    pathTrue.clear();
    init();
  } else if (frameCount >= NUM_CITIES + 10) {
    //background(img);
    translate(width/2, height/2);
    image(img, 0, 0, width, height);

    randomStrategy.calculateOptimal();
    randomStrategy.calculateBestEver();
    randomStrategy.generatePopulation();
    generation++;

    if (Math.abs(record - randomStrategy.getBestFitness()) > 0.00001) {
      converge = generation;
    }

    record = randomStrategy.getBestFitness();

    beginShape();
    noFill();
    stroke(red, 200);
    strokeWeight(2);
    for (City c : randomStrategy.getBestSolution()) {
      stroke(red, 200);
      vertex((float)c.lat, (float)c.lon);
    }
    endShape();

    strokeWeight(1);

    for (City c : path) {
      fill(lightWhite);
      ellipse((float)c.lat, (float)c.lon, 8, 8);
    }

    // Calculate the Haversine distance
    ArrayList<City> bestArray = randomStrategy.getOptimalRoute().getChromosome();
    ArrayList<City> bestTrue = new ArrayList<City>();

    // Fill the bestTrue array with the true coordinate values, 
    // and in the sequence of the most optimal route
    for (int i = 0; i < bestArray.size(); ++i) {
      String str = bestArray.get(i).name;
      for (int j = 0; j < bestArray.size(); ++j) {
        if ((str).equals(pathTrue.get(j).name)) {
          bestTrue.add(new City(pathTrue.get(j)));
        }
      }
    }

    for (int i = 0; i < NUM_CITIES - 1; ++i) {
      sumHaversine += haversine(bestTrue.get(i).lon, bestTrue.get(i + 1).lon, bestTrue.get(i).lat, bestTrue.get(i + 1).lat);
    }

    String haversineDistance = convertToCommaString((float)sumHaversine);
    result = Double.toString(sumHaversine);
    printText(haversineDistance);
    //System.out.println(sumHaversine);
    sumHaversine = 0.0;
  }

  if (generation == maxGeneration - 2) {
    //isRecord = true;
  } else if (generation == maxGeneration - 1) {
    BufferedWriter writer = null;
    try {
      writer = new BufferedWriter(new FileWriter("/Users/cadebe/Documents/Processing/TSP_DistanceCalculator_B/results.csv", true)); 
      writer.write(result + ", " + converge);
      writer.write("\n");
      println("RESULT: " + result);
    }
    catch (IOException e) {
      println("Error: " + e.getMessage());
      e.printStackTrace();
    }
    finally {
      if (writer != null) {
        try {
          writer.close();
        } 
        catch (IOException e) {
          println("Error: " + e.getMessage());
        }
      }
    }
    //endRecord();
    //exit();
  }

  if (isRecord) {
    isRecord = false;
    endRecord();
  }
}

double haversine(double lon1, double lon2, double lat1, double lat2) {
  double p = 0.017453292519943295;
  double a = 0.5 - Math.cos((lat2 - lat1) * p) / 2
    + Math.cos(lat1 * p) * Math.cos(lat2 * p) * (1 - Math.cos((lon2 - lon1) * p)) / 2;
  return 12742 * Math.asin(Math.sqrt(a));
}

void init() {
  fill(red);
  textFont(fontHeaderBold);
  text("Parsing the city data", width/2 - 120, height/2 - 20);
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
    double cx = webMercatorX(clon);
    double cy = webMercatorY(clat);

    double xx = webMercatorX(latList.get(i)) - cx;
    double yy = webMercatorY(lonList.get(i)) - cy;

    path.add(new City(xx, yy, nameList.get(i)));
    pathTrue.add(new City(lonList.get(i), latList.get(i), nameList.get(i)));
  }

  populationList = new ArrayList<Route>();
  for (int i = 0; i < numPop; ++i) {
    populationList.add(new Route(path, true));
  }
  randomStrategy = new RandomStrategy(populationList, numPop, maxGeneration, crossoverRate, mutationRate, generationGap, NUM_CITIES);
}

void parse(BufferedReader reader, ArrayList<Float> list1, ArrayList<Float> list2, ArrayList<String> list3) {
  try {
    String line = reader.readLine(); 
    if (line != null) {
      String [] bits = line.split(", "); 
      float lon = float(bits[0]); 
      float lat = float(bits[1]); 
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

double webMercatorX(float lon) {
  lon = radians(lon);
  double a = (256 / Math.PI) * Math.pow(2, zoom);
  double b = lon + Math.PI;
  return a * b;
}

double webMercatorY(float lat) {
  lat = radians(lat);
  double a = (256 / Math.PI) * Math.pow(2, zoom);
  double b = Math.tan(Math.PI / 4 + lat / 2);
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

String convertToCommaString(int value) {
  if (value >= 1000) {
    StringBuilder resString;
    resString = new StringBuilder(Integer.toString(value));
    if (value >= 1000 && value < 10000) {
      resString.insert(1, ',');
    } else if (value >= 10000) {
      resString.insert(2, ',');
    }
    return resString.toString();
  }
  return Integer.toString(value);
}

void printText(String haversineDistance) {
  fill(darkGray);
  textFont(fontBody);
  text("Travelling to the " + NUM_CITIES + " largest cities in the US ", -480, 160);
  text("Generations: " + convertToCommaString(generation), -480, 180);
  text("Convergence at generation: " + converge, -480, 200);
  text("Total distance travelled: " + haversineDistance + " km (Haversine distance)", -480, 220);
}

void keyReleased() {
  if (key == 'P' || key == 'p') {
    isRecord = !isRecord;
  }
}