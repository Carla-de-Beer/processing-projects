// Carla de Beer
// Genetic algorithm to solve the Travelling Salesperson Problem
// Created: September 2016
// City data obtained from: https://gist.github.com/Miserlou/c5cd8364bf9b2420bb29
// The crossover strategy makes use of Modified Order Crossover (MOX), as described in:
// http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.91.9167&rep=rep1&type=pdf
// Haversine formula: 
// http://stackoverflow.com/questions/27928/calculate-distance-between-two-latitude-longitude-points-haversine-formula

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

int NUM_CITIES = 20;
int iter = 0;
int maxIter = 250;
int numPop = 1000;
double crossoverRate = 85.0;
double mutationRate = 20.0;
double generationGap = 15.0;
double sumHaversine = 0.0;

RandomStrategy randomStrategy;

ArrayList<City> path = new ArrayList();
ArrayList<City> pathTrue = new ArrayList();
ArrayList<Route> populationList = new ArrayList<Route>();

String[] names = {"New York", "Los Angeles", "Chicago", "Houston", "Philadelphia", "Phoenix", "San Antonio", "San Diego", "Dallas", "San Jose", 
  "Austin", "Indianapolis", "Jacksonville", "San Francisco", "Columbus", "Charlotte", "Fort Worth", "Detroit", "El Paso", "Memphis"};

float[] lat = {40.7127837, 34.0522342, 41.8781136, 29.7604267, 39.9525839, 33.4483771, 29.4241219, 32.715738, 32.7766642, 37.3382082, 
  30.267153, 39.768403, 30.3321838, 37.7749295, 39.9611755, 35.2270869, 32.7554883, 42.331427, 31.7775757, 35.1495343};

float[] lon = {-74.0059413, -118.2436849, -87.6297982, -95.3698028, -75.1652215, -112.0740373, -98.49362819999999, -117.1610838, -96.79698789999999, -121.8863286, 
  -97.7430608, -86.158068, -81.65565099999999, -122.4194155, -82.99879419999999, -80.8431267, -97.3307658, -83.0457538, -106.4424559, -90.0489801};

void setup() {
  size(700, 800);
  frameRate(60);

  for (int i = 0; i < names.length; ++i) {
    float x = map(lat[i], 29.4241219, 42.331427, 70, width - 70);
    float y = map(lon[i], -122.4194155, -74.0059413, 70, height - 150);
    path.add(new City(x, y, names[i]));
    pathTrue.add(new City(lat[i], lon[i], names[i]));
  }

  populationList = new ArrayList<Route>();
  for (int i = 0; i < numPop; ++i) {
    populationList.add(new Route(path, true));
  }
  randomStrategy = new RandomStrategy(populationList, numPop, maxIter, crossoverRate, mutationRate, generationGap, NUM_CITIES);
}

void draw() {

  if (iter >= maxIter - 1) {
    noLoop();
  }

  background(0);

  randomStrategy.calculateOptimal();
  randomStrategy.calculateBestEver();
  randomStrategy.generatePopulation();
  iter++;

  beginShape();
  noFill();
  stroke(255, 200);
  strokeWeight(2);
  for (City c : randomStrategy.getBestSolution()) {
    stroke(255, 0, 120, 200);
    vertex((float)c.lat, (float)c.lon);
  }
  endShape();

  strokeWeight(1);
  stroke(255, 0, 120, 200);
  fill(255);

  for (City c : path) {
    ellipse((float)c.lat, (float)c.lon, 5, 5);
    text(c.name, (float)c.lat + 8, (float)c.lon + 8);
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
    sumHaversine += haversine(bestTrue.get(i).lat, bestTrue.get(i + 1).lat, bestTrue.get(i).lon, bestTrue.get(i + 1).lon);
  }

  String haversineDistance = convertToCommaString((float)sumHaversine);
  printText(haversineDistance);
  System.out.println(sumHaversine);
  sumHaversine = 0.0;
}

double haversine(double lat1, double lat2, double lon1, double lon2) {
  double p = 0.017453292519943295;
  double a = 0.5 - Math.cos((lat2 - lat1) * p) / 2
    + Math.cos(lat1 * p) * Math.cos(lat2 * p) * (1 - Math.cos((lon2 - lon1) * p)) / 2;
  return 12742 * Math.asin(Math.sqrt(a));
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
  fill(255, 200);
  text("Travelling to the " + NUM_CITIES + " largest cities in the US ", 45, height - 155);
  text("Iterations: " + iter, 45, height - 135);
  text("Population size: " + numPop, 45, height - 115);
  text("MutationRate: " + crossoverRate + "%", 45, height - 95);
  text("MutationRate: " + mutationRate + "%", 45, height - 75);
  text("Elitism generation gap: " + randomStrategy.numElite + " individuals", 45, height - 55);
  text("Total distance travelled: " + haversineDistance + " km (Haversine distance)", 45, height - 35);
}