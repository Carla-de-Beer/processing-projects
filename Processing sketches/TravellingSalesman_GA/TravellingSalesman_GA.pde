import java.util.Collections;

ArrayList<City> path = new ArrayList();
ArrayList<City> randPath = new ArrayList();

String[] names = { "New York", "Philadelphia", "Chicago", "Dallas", "Houston", "Phoenix", "San Diego", "San Antonio", "Los Angeles", "San Jose" };
float[] lat = { 40.7127837, 39.9525839, 41.8781136, 32.7766642, 29.7604267, 29.4241219, 33.4483771, 32.715738, 34.0522342, 37.3382082 };
float[] lon = { -74.0059413, -75.1652215, -87.6297982, -96.79698789999999, -95.3698028, -98.49362819999999, -112.0740373, -117.1610838, -118.2436849, -121.8863286 };

int NUM_CITIES = 10;
CityRoute route;
RandomStrategy randomStrategy;

int maxIter = 1000;
int numPop = 100;
float crossoverRate = 80.0;
float mutationRate = 5.0;
float percentageGap = 5.0;

void setup() {
  size(700, 700);
  for (int i = 0; i < names.length; ++i) {
    float x = map(lat[i], 29.4241219, 41.8781136, 70, width-70);
    float y = map(lon[i], -121.8863286, -74.0059413, 70, height-70);
    path.add(new City(x, y, names[i]));
  }

  for (int i = 0; i < path.size(); ++i) {
    randPath.add(path.get(i));
  }
  Collections.shuffle(randPath);
}

void draw() {

  background(0);

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

    // Inner while loop that fills the newPopulationList ArrayList
    // before elitism is applied
    while (randomStrategy.newPopulationList.size() < randomStrategy.numPop) {

      ArrayList<City> parentA = new ArrayList();
      ArrayList<City> parentB = new ArrayList();
      ArrayList<City> childA = new ArrayList();
      ArrayList<City> childB = new ArrayList();

      // Randomly select two parents from the population of
      // Routes
      int rand1 = randomStrategy.myRandom.randomInt(randomStrategy.numPop);
      int rand2 = randomStrategy.myRandom.randomInt(randomStrategy.numPop);

      parentA = (randomStrategy.currentPopulationList.get(rand1).getChromosome());
      parentB = (randomStrategy.currentPopulationList.get(rand2).getChromosome());

      float crossRand = (float) Math.random();
      float muteRand = (float) Math.random();

      // System.out.println();

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

      // Populate the ArrayList newPopulation
      // with the offspring
      CityRoute new1 = new CityRoute(path);
      CityRoute new2 = new CityRoute(path);

      new1.setChromosome(childA);
      new2.setChromosome(childB);

      randomStrategy.newPopulationList.add(new2);
      randomStrategy.newPopulationList.add(new1);
    }

    counter++;

    randomStrategy.getOptimal();

    // -------------------------------------------------
    StringBuilder sb = new StringBuilder(NUM_CITIES);
    for (int i = 0; i < NUM_CITIES; ++i) {
      sb.append(randomStrategy.optimalRoute.getChromosome().get(i).getName());
      if (i < NUM_CITIES - 1) {
        sb.append("->");
      }
    }

    beginShape();
    noFill();
    stroke(100, 200);
    strokeWeight(1);
    for (City c : randomStrategy.getBestSolution()) {
      vertex(c.lat, c.lon);
    }
    endShape();

    // -------------------------------------------------

    // System.out.println(getBestFitness() + ": " + sb.toString());
    System.out.println(randomStrategy.getBestFitness());
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

      // Create a new ArrayList handOver that forms the hand over
      // from one generation to the next,
      // consisting of the best part of the current generation
      // replacing the worst part of the next generation
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
    else
      randomStrategy.currentPopulationList = new ArrayList(randomStrategy.newPopulationList);

    randomStrategy.newPopulationList.clear();
  }

  // output average fitness value after each generation
  randomStrategy.average = sum / (randomStrategy.maxIter);
  System.out.println();
  randomStrategy.printEndInfo();
  // return randomStrategy.optimalRoute;

  ///////////////////////////////////////

  beginShape();
  noFill();
  stroke(255, 0, 120, 200);
  strokeWeight(3);
  for (City c : randomStrategy.getBestSolution()) {
    vertex(c.lat, c.lon);
  }
  endShape();

  /// highlight ellipse
  for (City v : path) {
    fill(255, 220);
    ellipse(v.lat, v.lon, 8, 8);
    text(v.name, v.lat + 8, v.lon + 8);
  }

  text("Shortest route: " + randomStrategy.getBestFitness(), 45, height - 45);
}