// Carla de Beer
// September 2016
// Genetic algorithm to find an optimised solution to the Travelling Salesman Problem.
// The sketch dynamically reads in city data from a file and calculates the shortest distance it can find, linking all cities.
// The actual physical distance on the route, calculated as the Haversine distance, is also shown.
// Specifiable parameters: crossover rate, mutation rate, popuation size, max. no. iterations, elitism generation gap.
// City data obtained from: https://gist.github.com/Miserlou/c5cd8364bf9b2420bb29
// The crossover strategy makes use of Modified Order Crossover (MOX), as described in:
// http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.91.9167&rep=rep1&type=pdf
// Haversine distance formula: 
// http://stackoverflow.com/questions/27928/calculate-distance-between-two-latitude-longitude-points-haversine-formula

BufferedReader reader;
float maxLat, maxLon, minLat, minLon;
ArrayList<Float> latList = new ArrayList();
ArrayList<Float> lonList = new ArrayList();
ArrayList<String> nameList = new ArrayList();
ArrayList<Float> tmpLat = new ArrayList();
ArrayList<Float> tmpLon = new ArrayList();

int NUM_CITIES = 35;
int generation = 0;
int maxGeneration = 250;
int numPop = 2000;
double crossoverRate = 85.0;
double mutationRate = 25.0;
double generationGap = 20.0;
double sumHaversine = 0.0;

RandomStrategy randomStrategy;

ArrayList<City> path = new ArrayList();
ArrayList<City> pathTrue = new ArrayList();
ArrayList<Route> populationList = new ArrayList<Route>();

color pink = color(255, 0, 120);
color white = color(250);

double record = 0.0;
int converge = 0;

void setup() {
  size(700, 800);
  pixelDensity(displayDensity());
  frameRate(60);
  reader = createReader("cities.txt");
}

void draw() {

  background(0);
  if (generation >= maxGeneration - 1) {
    noLoop();
  }

  if (frameCount < NUM_CITIES + 10) {
    textSize(20);
    path.clear();
    pathTrue.clear();
    init();
  } else if (frameCount >= NUM_CITIES + 10) {
    textSize(12);

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
    stroke(pink, 200);
    strokeWeight(2);
    for (City c : randomStrategy.getBestSolution()) {
      stroke(255, 0, 120, 200);
      vertex((float)c.lat, (float)c.lon);
    }
    endShape();

    strokeWeight(1);
    fill(white);

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
    //System.out.println(sumHaversine);
    sumHaversine = 0.0;
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
  fill(white, 200);
  text("Travelling to the " + NUM_CITIES + " largest cities in the US ", 45, height - 135);
  text("Generations: " + convertToCommaString(generation), 45, height - 115);
  text("Population size: " + convertToCommaString(numPop) + " individuals", 45, height - 95);
  text("Crossover rate: " +crossoverRate + "%", 45, height - 75);
  text("|  Mutation rate: " + mutationRate + "%", 179, height - 75);
  text("Elitism generation gap: " + randomStrategy.numElite + " individuals", 45, height - 55);
  text("Total distance travelled: " + haversineDistance + " km (Haversine distance)", 45, height - 35);
  text("|  Convergence at generation: " + converge, 400, height - 35);
}