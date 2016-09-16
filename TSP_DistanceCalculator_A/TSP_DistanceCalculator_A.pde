// Carla de Beer
// September 2016
// Genetic algorithm to find an optimised solution to the Travelling Salesman Problem.
// The sketch dynamically reads in city data from a file and calculates the shortest distance it can find, linking all cities.
// The actual physical distance on the route, calculated as the Haversine distance, is also shown.
// Specifiable parameters: mutation rate, popuation size, max. no. iterations, no. of cities to be read.
// Based on Daniel Shiffman's TSP GA solution from the Coding Rainbow coding challenges series:
// https://www.youtube.com/watch?v=r_SpBy9fQuo
// Haversine distance formula: 
// http://stackoverflow.com/questions/27928/calculate-distance-between-two-latitude-longitude-points-haversine-formula
// City coordinate data: https://gist.github.com/Miserlou/c5cd8364bf9b2420bb29

import java.util.Collections;

BufferedReader reader;
int NUM_CITIES = 35;
float maxLat, maxLon, minLat, minLon;
float sumHaversine;

ArrayList<Float> latList = new ArrayList();
ArrayList<Float> lonList = new ArrayList();
ArrayList<String> nameList = new ArrayList();
ArrayList<Float> tmpLat = new ArrayList();
ArrayList<Float> tmpLon = new ArrayList();

int maxPop;
float mutationRate;
Population population;
City[] path = new City[NUM_CITIES];
City[] pathTrue = new City[NUM_CITIES];

Route bestEver;

color pink = color(255, 0, 120);
color white = color(250);

void setup() {
  size(700, 800);
  maxPop = 2500;
  mutationRate = 0.15;
  reader = createReader("cities.txt");
}

void draw() {
  sumHaversine = 0.0f;
  background(0);
  textSize(20);

  if (frameCount < NUM_CITIES + 15) {
    init();
  } else if (frameCount >= NUM_CITIES + 15) {
    // Run the GA
    population.calcFitness();
    Route best = population.getBest();

    if (best.fitness > bestEver.fitness) {
      bestEver = best;
    }

    population.generate();

    beginShape();
    noFill();
    stroke(white, 150);
    strokeWeight(1);
    for (City v : best.chromosome) {
      vertex(v.lat, v.lon);
    }
    endShape();

    beginShape();
    noFill();
    stroke(pink);
    strokeWeight(2);
    for (City v : bestEver.chromosome) {
      vertex(v.lat, v.lon);
    }
    endShape();

    // display city nodes and names
    for (City v : path) {
      fill(white);
      strokeWeight(1);
      textSize(12);
      ellipse(v.lat, v.lon, 8, 8);
      if (v.name.equals("Washington") || v.name.equals("Seattle") || 
        v.name.equals("Indianapolis") || v.name.equals("Oklahoma City") || 
        v.name.equals("Portland") || v.name.equals("Milwaukee") ||
        v.name.equals("San Antonio")) {
        text(v.name, v.lat + 8, v.lon + 15);
      } else if (v.name.equals("San Francisco")) {
        text(v.name, v.lat + 8, v.lon + 17);
      } else if (v.name.equals("Dallas") || v.name.equals("Sacramento") ||
        v.name.equals("New York") || v.name.equals("Philadelphia") ||
        v.name.equals("Baltimore") ) {
        text(v.name, v.lat + 8, v.lon - 5);
      } else text(v.name, v.lat + 11, v.lon + 4);
    }

    // Calculate the Haversine distance
    City[] bestArray = bestEver.chromosome;
    City[] bestTrue = new City[NUM_CITIES];

    // Fill the bestTrue array with the true coordinate values, 
    // and in the sequence of the most optimal route
    for (int i = 0; i < bestArray.length; ++i) {
      String str = bestArray[i].name;
      for (int j = 0; j < bestArray.length; ++j) {
        if ((str).equals(pathTrue[j].name)) {
          bestTrue[i] = new City(pathTrue[j]);
        }
      }
    }

    for (int i = 0; i < NUM_CITIES - 1; ++i) {
      sumHaversine += haversine(bestTrue[i].lat, bestTrue[i + 1].lat, bestTrue[i].lon, bestTrue[i + 1].lon);
    }

    String haversineDistance = convertToCommaString(sumHaversine);
    printText(best.fitness, haversineDistance);
  }
}

void init() {
  fill(white);
  text("Parsing the city data", 250, 350);
  
  // Load the city data 
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
    float x = map(latList.get(i), minLat, maxLat, 50, width - 100);
    float y = map(lonList.get(i), minLon, maxLon, 45, height - 192);
    path[i] = new City(x, y, nameList.get(i));
    // retain an array with the true, unmapped coordinate values for distance calculations
    pathTrue[i] = new City(latList.get(i), lonList.get(i), nameList.get(i));
  }

  bestEver = new Route(path, false);
  population = new Population(path, mutationRate, maxPop);
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

float haversine(float lat1, float lat2, float lon1, float lon2) {
  float p = 0.017453292519943295;
  float a = 0.5 - cos((lat2 - lat1) * p)/2 + cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p))/2;
  return 12742 * asin(sqrt(a));
}

String convertToCommaString(double fitness) {
  String fitnessString = "";
  StringBuilder resString;
  fitnessString = String.format("%.2f", fitness);
  resString = new StringBuilder(fitnessString);
  int index1 = fitnessString.indexOf('.');
  resString.insert(index1 - 3, ',');
  return resString.toString();
}

void printText(float fitness, String haversineDistance) {
  fill(white, 200);
  text("Travelling to the " + NUM_CITIES + " largest cities in the US ", 45, height - 135);
  text("Iterations: " + population.generations, 45, height - 115);
  text("Population size: " + maxPop, 45, height - 95);
  text("MutationRate: " + floor(mutationRate * 100) + "%", 45, height - 75);
  text("Current best fitness: " + fitness, 45, height - 55);
  text("Total distance travelled: " + haversineDistance + " km (Haversine distance)", 45, height - 35);
}