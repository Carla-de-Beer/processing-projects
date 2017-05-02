import java.util.ArrayList;
import java.util.Collections;

class Route {

  private ArrayList<City> chromosome;
  private double fitness;
  
  public Route(ArrayList<City> path, boolean isShuffle) {
    this.chromosome = new ArrayList<City>(path);
    if (isShuffle) {
      Collections.shuffle(chromosome);
    }
  }

  public Route(Route other) {
    this.chromosome = new ArrayList<City>(other.getChromosome());
  }

  public double calculateFitness() {
    return sumDistance(chromosome);
  }

  private double sumDistance(ArrayList<City> path) {
    double sum = 0.0;
    for (int i = 0; i < path.size() - 1; ++i) {
      City a = path.get(i);
      City b = path.get(i + 1);
      double d = distSq(a.getLon(), a.getLat(), b.getLon(), b.getLat());
      sum += d;
    }
    return sum;
  }

  private double distSq(double x1, double y1, double x2, double y2) {
    return ((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
  }

  public final double getFitness() {
    return fitness;
  }

  public final ArrayList<City> getChromosome() {
    return chromosome;
  }
  
  public void setChromosome(ArrayList<City> chromosome) {
    this.chromosome = chromosome;
  }
}