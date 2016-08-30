import java.util.ArrayList;
import java.util.Collections;

class CityRoute {

  ArrayList<City> chromosome;
  float fitness;
  float normFitness;

  CityRoute(ArrayList<City> path) {
    this.chromosome = new ArrayList();
    for (City c : path) {
      this.chromosome.add(c);
    }
    // Shuffle the ArrayList to obtain different permutations
    Collections.shuffle(chromosome);
  }

  float calculateFitness() {
    float sum = sumDistance(chromosome);
    fitness = sum;
    return fitness;
  }

  float sumDistance(ArrayList<City> path) {
    float sum = 0;
    for (int i = 0; i < path.size() - 1; ++i) {
      City a = path.get(i);
      City b = path.get(i + 1);
      float d = distSq(a.getLon(), a.getLat(), b.getLon(), b.getLat());
      sum += d;
    }
    return sum;
  }

  float distSq(float x1, float y1, float x2, float y2) {
    return ((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
  }

  final float getFitness() {
    return fitness;
  }

  public final ArrayList<City> getChromosome() {
    return chromosome;
  }

  public void setChromosome(ArrayList<City> chromosome) {
    this.chromosome = chromosome;
  }
}