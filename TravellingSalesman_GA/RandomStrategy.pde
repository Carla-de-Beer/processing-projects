import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;

class RandomStrategy {
  
  int NUM_CITIES = 10;
  int numPop;
  int maxIter;
  float crossoverRate;
  float mutationRate;
  float percentageGap;
  int generationGap;
  CityRoute optimalRoute;
  float optimalValue;
  float average = 0.0;
  MyRandom myRandom = new MyRandom();

  ArrayList<City> path = new ArrayList();
  ArrayList<CityRoute> newPopulationList = new ArrayList();
  ArrayList<CityRoute> currentPopulationList = new ArrayList();
  ArrayList<Float> currentListFitness = new ArrayList();
  ArrayList<Float> newListFitness = new ArrayList();

  RandomStrategy(ArrayList<City> path, int numPop, int maxIter, float crossoverRate, float mutationRate, 
    float percentageGap) {
    this.numPop = numPop;
    this.maxIter = maxIter;
    this.crossoverRate = crossoverRate;
    this.mutationRate = mutationRate;
    this.percentageGap = percentageGap;
    this.generationGap = (int) (this.numPop * this.percentageGap / 100.0);

    for (City c : path) {
      this.path.add(c);
    }

    this.optimalRoute = null;
    this.optimalValue = Float.POSITIVE_INFINITY;
  }

  // The crossover strategy makes use of Modified Order Crossover (MOX),
  // as described in:
  // http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.91.9167&rep=rep1&type=pdf
  void crossover(ArrayList<City> parentA, ArrayList<City> parentB, ArrayList<City> childA, 
    ArrayList<City> childB) {

    ArrayList<City> endA = new ArrayList();
    ArrayList<City> endB = new ArrayList();

    int rand = myRandom.randomInt(NUM_CITIES);

    // Copy over first part of the chromosome
    for (int i = 0; i < rand; ++i) {
      childA.add(parentA.get(i));
      childB.add(parentB.get(i));
    }

    // Copy over second part of the chromosome
    for (int i = rand; i < parentA.size(); ++i) {
      endA.add(parentA.get(i));
      endB.add(parentB.get(i));
    }

    int[] numsA = new int[endA.size()];
    int[] numsB = new int[endB.size()];

    // get index values
    for (int i = 0; i < endA.size(); ++i) {
      City x = endA.get(i);
      City y = endB.get(i);

      for (int j = 0; j < parentB.size(); ++j) {
        if (x == parentB.get(j)) {
          numsA[i] = j;
        }
        if (y == parentA.get(j)) {
          numsB[i] = j;
        }
      }
    }

    City[] strA = new City[endA.size()];
    endA.toArray(strA);
    City[] strB = new City[endB.size()];
    endB.toArray(strB);

    selectionSort(numsA, strA);
    selectionSort(numsB, strB);

    endA.clear();
    endB.clear();

    for (int i = 0; i < strA.length; ++i) {
      endA.add(strA[i]);
      endB.add(strB[i]);
    }

    // concatenate the two parts
    childA.addAll(endA);
    childB.addAll(endB);
  }

  void mutate(ArrayList<City> path) {
    int rand1 = myRandom.randomInt(NUM_CITIES);
    int rand2 = myRandom.randomInt(NUM_CITIES);
    Collections.swap(path, rand1, rand2);
  }

  void getOptimal() {
    float fitnessValue = 0.0;
    for (int i = 0; i < newPopulationList.size(); ++i) {
      fitnessValue = newPopulationList.get(i).calculateFitness();
      if (optimalValue > fitnessValue) {
        optimalRoute = newPopulationList.get(i);
        optimalValue = fitnessValue;
      }
    }
  }

  CityRoute getOptimalRoute() {
    return optimalRoute;
  }

  ArrayList<City> getBestSolution() {
    return optimalRoute.getChromosome();
  }

  float getBestFitness() {
    return optimalValue;
  }

  float getAverage() {
    return average;
  }

  ArrayList<Float> createCurrentFitnessList(ArrayList<CityRoute> listCurrent) {
    currentListFitness.clear();
    for (int i = 0; i < numPop; ++i) {
      currentListFitness.add(listCurrent.get(i).calculateFitness());
    }
    return currentListFitness;
  }

  ArrayList<Float> createNextFitnessList(ArrayList<CityRoute> listNew) {
    newListFitness.clear();
    for (int i = 0; i < numPop; ++i) {
      newListFitness.add(listNew.get(i).calculateFitness());
    }
    return newListFitness;
  }

  void selectionSort(int[] arr1, City[] arr2) {
    int i, j, minIndex;
    int tmp1;
    City tmp2;
    int n = arr1.length;

    for (i = 0; i < n - 1; i++) {
      minIndex = i;
      for (j = i + 1; j < n; j++) {
        if (arr1[j] < arr1[minIndex]) {
          minIndex = j;
        }
      }

      if (minIndex != i) {
        tmp1 = arr1[i];
        tmp2 = arr2[i];

        arr1[i] = arr1[minIndex];
        arr2[i] = arr2[minIndex];

        arr1[minIndex] = tmp1;
        arr2[minIndex] = tmp2;
      }
    }
  }

  void selectionSort(float[] arr1, CityRoute[] arr2) {
    int i, j, minIndex;
    float tmp1;
    CityRoute tmp2;
    int n = arr1.length;

    for (i = 0; i < n - 1; i++) {
      minIndex = i;
      for (j = i + 1; j < n; j++) {

        if (arr1[j] < arr1[minIndex]) {
          minIndex = j;
        }
      }

      if (minIndex != i) {
        tmp1 = arr1[i];
        tmp2 = arr2[i];

        arr1[i] = arr1[minIndex];
        arr2[i] = arr2[minIndex];

        arr1[minIndex] = tmp1;
        arr2[minIndex] = tmp2;
      }
    }
  }

  void printEndInfo() {
    println("\nProcessing complete.\n");
    println("\n****************************************************");
  }
}