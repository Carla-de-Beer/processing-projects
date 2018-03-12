import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

class RandomStrategy {
  private ArrayList<Route> populationList;
  private int numPop;
  private double crossoverRate;
  private double mutationRate;
  private int numCities;
  private int numElite;
  private Route optimalRoute;
  private double optimalValue;
  private double overallBestFitness;

  public RandomStrategy(ArrayList<Route> populationList, int numPop, double crossoverRate, 
    double mutationRate, double generationGap, int numCities) {
    this.populationList = new ArrayList<Route>(populationList);
    this.numPop = numPop;
    this.crossoverRate = crossoverRate * 0.01;
    this.mutationRate = mutationRate * 0.01;
    this.numCities = numCities;
    this.numElite = (int) (this.numPop * generationGap * 0.01);
    this.optimalRoute = null;
    this.optimalValue = Double.POSITIVE_INFINITY;
    this.overallBestFitness = Double.POSITIVE_INFINITY;
  }

  public void runGA() {
    calculateOptimal();
    calculateBestEver();
    generatePopulation();
  }

  public void calculateOptimal() {
    double fitnessValue = 0.0;
    for (int i = 0; i < populationList.size(); ++i) {
      fitnessValue = populationList.get(i).calculateFitness();
      if (fitnessValue < optimalValue) {
        optimalRoute = new Route(populationList.get(i));
        optimalValue = fitnessValue;
      }
    }
  }

  public void calculateBestEver() {
    double currentBestFitness = optimalValue;
    if (currentBestFitness < overallBestFitness) {
      overallBestFitness = currentBestFitness;
    }
  }

  public void generatePopulation() {
    ArrayList<Route> newPopulationList = new ArrayList<Route>();
    ArrayList<Route> nextPopulationList = new ArrayList<Route>();

    while (newPopulationList.size() < numPop) {
      ArrayList<City> parentA = new ArrayList<City>();
      ArrayList<City> parentB = new ArrayList<City>();
      ArrayList<City> child = new ArrayList<City>();

      // Randomly select two parents from the population
      int randA = floor(random(numPop));
      int randB = floor(random(numPop));
      parentA = (populationList.get(randA).getChromosome());
      parentB = (populationList.get(randB).getChromosome());

      double cProb = Math.random();
      double mRand = Math.random();

      // Crossover, if applicable
      if (crossoverRate > cProb) {
        crossover(parentA, parentB, child);
        // if you are crossing over, mutate
        // Mutate, if applicable
        if (mutationRate > mRand) {
          mutate(child);
        }
        // Populate the ArrayList newPopulation
        // with the offspring
        Route newRoute = new Route(child, false);
        newPopulationList.add(newRoute);
      }
    }

    nextPopulationList = new ArrayList<Route>(newPopulationList);

    // Apply elitism if required; sort hashmaps by value
    if (numElite > 0) {
      populationList = new ArrayList<Route>(createEliteList(nextPopulationList));
    } else {
      // else, if no elitism applied, carry new population over as is
      populationList = new ArrayList<Route>(newPopulationList);
    }
    //newPopulationList.clear();
  }

  public void crossover(ArrayList<City> parentA, ArrayList<City> parentB, ArrayList<City> child) {
    ArrayList<City> end = new ArrayList<City>();
    int rand = floor(random(numCities));

    // Copy over first part of the chromosome
    for (int i = 0; i < rand; ++i) {
      child.add(parentA.get(i));
    }

    // Copy over second part of the chromosome
    for (int i = rand; i < parentA.size(); ++i) {
      end.add(parentA.get(i));
    }

    int[] nums = new int[end.size()];

    // get index values
    for (int i = 0; i < end.size(); ++i) {
      City x = end.get(i);
      for (int j = 0; j < parentB.size(); ++j) {
        if (x.getName().equals(parentB.get(j).getName())) {
          nums[i] = j;
        }
      }
    }

    Arrays.sort(nums);
    ArrayList<City> res = new ArrayList<City>();

    for (int i = 0; i < nums.length; ++i) {
      res.add(parentB.get(nums[i]));
    }

    // concatenate the two parts
    child.addAll(res);
  }

  public void mutate(ArrayList<City> path) {
    int rand1 = floor(random(numCities));
    int rand2 = floor(random(numCities));
    Collections.swap(path, rand1, rand2);
  }

  public ArrayList<Route> createEliteList(ArrayList<Route> nextPopulationList) {
    HashMap<Route, Double> mapNext = new HashMap<Route, Double>();
    for (int i = 0; i < nextPopulationList.size(); ++i) {
      mapNext.put(nextPopulationList.get(i), nextPopulationList.get(i).calculateFitness());
    }

    HashMap<Route, Double> mapCurrent = new HashMap<Route, Double>();
    for (int i = 0; i < populationList.size(); ++i) {
      mapCurrent.put(populationList.get(i), populationList.get(i).calculateFitness());
    }

    Set<Entry<Route, Double>> setCurrent = mapCurrent.entrySet();
    List<Entry<Route, Double>> ascendingList = new ArrayList<Entry<Route, Double>>(setCurrent);

    Set<Entry<Route, Double>> setNext = mapNext.entrySet();
    List<Entry<Route, Double>> descendingList = new ArrayList<Entry<Route, Double>>(setNext);

    // Sort ascending
    Collections.sort(ascendingList, new Comparator<Map.Entry<Route, Double>>() {
      public int compare(Map.Entry<Route, Double> value1, Map.Entry<Route, Double> value2) {
        return (value1.getValue()).compareTo(value2.getValue());
      }
    }
    );

    // Sort descending
    Collections.sort(descendingList, new Comparator<Map.Entry<Route, Double>>() {
      public int compare(Map.Entry<Route, Double> value1, Map.Entry<Route, Double> value2) {
        return (value2.getValue()).compareTo(value1.getValue());
      }
    }
    );

    ArrayList<Route> eliteList = new ArrayList<Route>();
    for (int i = 0; i < numElite; ++i) {
      descendingList.set(i, ascendingList.get(i));
    }

    for (Map.Entry<Route, Double> entry : descendingList) {
      eliteList.add(entry.getKey());
    }

    return eliteList;
  }

  public final Route getOptimalRoute() {
    return optimalRoute;
  }

  public final ArrayList<City> getBestSolution() {
    return optimalRoute.getChromosome();
  }

  public final double getBestFitness() {
    return optimalValue;
  }
}