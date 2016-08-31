import java.util.Collections;

int NUM_CITIES = 20;
int iter = 0;
int maxIter = 2000;
int numPop = 200;
float crossoverRate = 55.0;
float mutationRate = 15.0;
float percentageGap = 5.0;

CityRoute route;
RandomStrategy randomStrategy;

ArrayList<City> path = new ArrayList();
ArrayList<City> randPath = new ArrayList();

float bestEverFitness = Float.POSITIVE_INFINITY;
ArrayList<City> bestEverRoute = new ArrayList();

String[] names = { "New York", "Los Angeles", "Chicago", "Houston", "Philadelphia", "Phoenix", "San Antonio", "San Diego", "Dallas", "San Jose", 
  "Austin", "Indianapolis", "Jacksonville", "San Francisco", "Columbus", "Charlotte", "Fort Worth", "Detroit", "El Paso", "Memphis" };

float[] lat = { 40.7127837, 34.0522342, 41.8781136, 29.7604267, 39.9525839, 33.4483771, 29.4241219, 32.715738, 32.7766642, 37.3382082, 
  30.267153, 39.768403, 30.3321838, 37.7749295, 39.9611755, 35.2270869, 32.7554883, 42.331427, 31.7775757, 35.1495343 };

float[] lon = { -74.0059413, -118.2436849, -87.6297982, -95.3698028, -75.1652215, -112.0740373, -98.49362819999999, -117.1610838, -96.79698789999999, -121.8863286, 
  -97.7430608, -86.158068, -81.65565099999999, -122.4194155, -82.99879419999999, -80.8431267, -97.3307658, -83.0457538, -106.4424559, -90.0489801 };

void setup() {
  size(700, 800);
  for (int i = 0; i < names.length; ++i) {
    float x = map(lat[i], 29.4241219, 42.331427, 70, width - 70);
    float y = map(lon[i], -122.4194155, -74.0059413, 70, height - 150);
    path.add(new City(x, y, names[i]));
  }

  randPath = new ArrayList<City>(path); 
  Collections.shuffle(randPath);
}

void draw() {

  route = new CityRoute(path);
  randomStrategy = new RandomStrategy(path, numPop, maxIter, crossoverRate, mutationRate, percentageGap);

  ///////////////////////////////////////

  // Start with a clean slate
  randomStrategy.newPopulationList.clear();

  // Initialise ArrayList of routes
  for (int i = 0; i < randomStrategy.numPop; ++i) {
    randomStrategy.currentPopulationList.add(new CityRoute(path));
  }

  int counter = 0;
  float sum = 0.0;

  // Outer while loop that runs for the number of generations required
  while (counter < randomStrategy.maxIter) {

    // Inner while loop that fills the newPopulationList ArrayList before elitism is applied
    while (randomStrategy.newPopulationList.size() < randomStrategy.numPop) {

      ArrayList<City> parentA = new ArrayList();
      ArrayList<City> parentB = new ArrayList();
      ArrayList<City> childA = new ArrayList();
      ArrayList<City> childB = new ArrayList();

      // Randomly select two parents from the population of CityRoutes
      int rand1 = (int) random((randomStrategy.numPop));
      int rand2 = (int) random((randomStrategy.numPop));

      parentA = (randomStrategy.currentPopulationList.get(rand1).getChromosome());
      parentB = (randomStrategy.currentPopulationList.get(rand2).getChromosome());

      float crossRand = (float) Math.random();
      float muteRand = (float) Math.random();

      // Crossover, if applicable
      if (randomStrategy.crossoverRate > crossRand) {

        randomStrategy.crossover(parentA, parentB, childA, childB);
      } else {
        for (int i = 0; i < parentA.size(); ++i) {
          childA.add(parentA.get(i));
          childB.add(parentB.get(i));
        }
      }

      // Mutate, if applicable
      if (randomStrategy.mutationRate > muteRand) {
        randomStrategy.mutate(childA);
        randomStrategy.mutate(childB);
      }

      // Populate the ArrayList newPopulation with the offspring
      CityRoute new1 = new CityRoute(path);
      CityRoute new2 = new CityRoute(path);

      new1.setChromosome(childA);
      new2.setChromosome(childB);

      randomStrategy.newPopulationList.add(new2);
      randomStrategy.newPopulationList.add(new1);
    } // end inner while

    counter++;
    randomStrategy.getOptimal();

    // -------------------------------------------------

    background(0);
    beginShape();
    noFill();
    stroke(255, 200);
    strokeWeight(1);
    for (City c : randomStrategy.getBestSolution()) {
      vertex(c.lat, c.lon);
    }
    endShape();

    // -------------------------------------------------

    sum += randomStrategy.getBestFitness();

    // Apply elitism, only if the generation gap > 0
    if (randomStrategy.generationGap > 0) {
      randomStrategy.createCurrentFitnessList(randomStrategy.currentPopulationList);
      randomStrategy.createNextFitnessList(randomStrategy.newPopulationList);

      float[] listArray = new float[randomStrategy.currentListFitness.size()];
      CityRoute[] listRouterArray = new CityRoute[randomStrategy.currentPopulationList.size()];

      float[] newListArray = new float[randomStrategy.newListFitness.size()];
      CityRoute[] newlistRouteArray = new CityRoute[randomStrategy.newPopulationList.size()];

      for (int i = 0; i < randomStrategy.numPop; ++i) {
        listArray[i] = randomStrategy.currentListFitness.get(i);
        listRouterArray[i] = randomStrategy.currentPopulationList.get(i);
        newListArray[i] = randomStrategy.newListFitness.get(i);
        newlistRouteArray[i] = randomStrategy.newPopulationList.get(i);
      }

      randomStrategy.selectionSort(listArray, listRouterArray);
      randomStrategy.selectionSort(newListArray, newlistRouteArray);

      randomStrategy.currentPopulationList = new ArrayList(Arrays.asList(listRouterArray));
      randomStrategy.newPopulationList = new ArrayList(Arrays.asList(newlistRouteArray));

      // Create a new ArrayList handOver that forms the hand over from one generation to the next, 
      // consisting of the best part of the current generation replacing the worst part of the next generation.
      ArrayList<CityRoute> handOver = new ArrayList();
      for (int i = randomStrategy.numPop
        - randomStrategy.generationGap; i < randomStrategy.currentPopulationList.size(); ++i)
        handOver.add(randomStrategy.currentPopulationList.get(i));

      for (int i = randomStrategy.generationGap; i < randomStrategy.numPop; ++i)
        handOver.add(randomStrategy.newPopulationList.get(i));

      randomStrategy.currentPopulationList = new ArrayList(handOver);
    }
    // Else if the generation gap value is zero,
    // replace entire current generation with the new generation
    else {
      randomStrategy.currentPopulationList = new ArrayList<CityRoute>(randomStrategy.newPopulationList);
    }

    randomStrategy.newPopulationList.clear();
  } // end outer while

  iter++;

  ///////////////////////////////////////

  CityRoute currentBestRoute = new CityRoute(randomStrategy.getOptimalRoute());
  currentBestRoute.calculateFitness();

  ArrayList<City> currentBestSolution = new ArrayList();
  for (int i = 0; i < NUM_CITIES; ++i) {
    currentBestSolution.add(randomStrategy.getBestSolution().get(i));
  }

  if (currentBestRoute.getFitness() < bestEverFitness) {
    bestEverRoute.clear();
    bestEverFitness = currentBestRoute.getFitness();
    for (int i = 0; i < NUM_CITIES; ++i) {
      bestEverRoute.add(currentBestSolution.get(i));
    }
  }

  // output average fitness value after each generation
  randomStrategy.average = sum / (randomStrategy.maxIter);

  beginShape();
  noFill();
  stroke(255, 0, 120, 200);
  strokeWeight(3);
  for (City c : bestEverRoute) {
    vertex(c.lat, c.lon);
  }
  endShape();
  strokeWeight(1);

  // display city nodes
  for (City v : path) {
    fill(250);
    ellipse(v.lat, v.lon, 8, 8);
    if (v.name == "Fort Worth") {
      text(v.name, v.lat - 8, v.lon - 8);
    } else  if (v.name == "San Jose" ) {
      text(v.name, v.lat + 10, v.lon + 14);
    } else  if (v.name == "San Antonio") {
      text(v.name, v.lat + 8, v.lon);
    } else text(v.name, v.lat + 11, v.lon + 4);
  }

  String resString1 = convertToCommaString(randomStrategy.getBestFitness());
  String resString2 = convertToCommaString(bestEverFitness);

  printText(resString1, resString2);
}

void printText(String resString1, String resString2) {
  fill(255, 200);
  text("Iterations: " + iter, 45, height - 175);
  text("Max. no. generations/iteration: " + maxIter, 45, height - 155);
  text("Population size: " + numPop, 45, height - 135);
  text("Crossover rate: " + crossoverRate + "%", 45, height - 115);
  text("MutationRate: " + mutationRate + "%", 45, height - 95);
  text("Elitism gap: " + percentageGap + "%", 45, height - 75);
  text("Current shortest route: " + resString1.toString(), 45, height - 55);
  text("Shortest route over " + iter + " iterations:", 45, height - 35);

  fill(255);
  strokeWeight(1);

  if (iter < 10) {
    text(resString2.toString(), 236, height - 35);
    fill(255, 200);
    fill(255, 0, 120, 200);
    line(237, height - 30, 304, height - 30);
  } else if (iter >= 10 && iter < 100) {
    text(resString2.toString(), 244, height - 35);
    fill(255, 200);
    fill(255, 0, 120, 200);
    line(245, height - 30, 312, height - 30);
  } else {
    text(resString2.toString(), 252, height - 35);
    fill(255, 200);
    fill(255, 0, 120, 200);
    line(253, height - 30, 320, height - 30);
  }
  //saveFrame();
}

String convertToCommaString(Float fitness) {
  String fitnessString = "";
  StringBuilder resString;
  fitnessString = String.format("%.2f", fitness);
  resString = new StringBuilder(fitnessString);
  int index1 = fitnessString.indexOf('.');
  resString.insert(index1 - 3, ',');
  return resString.toString();
}