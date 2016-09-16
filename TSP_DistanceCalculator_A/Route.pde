public class Route {

  City[] chromosome;
  float fitness;
  float normFitness;
  MyRandom myRandom = new MyRandom();

  // Constructor (makes a random Route)
  public Route(City[] path, boolean shuffle) {
    chromosome = new City[path.length];
    System.arraycopy(path, 0, chromosome, 0, path.length);
    if (shuffle) {
      for (int i = 0; i < 15; i++) {
        shuffle(chromosome);
      }
    }
  }

  public void fitness() {
    float sum = sumDistance(chromosome);
    fitness = (float) 1.0 / sum;
    fitness = (float) Math.pow(fitness, 4);
  }

  public float sumDistance(City[] path) {
    float sum = 0;
    for (int i = 0; i < path.length - 1; i++) {
      City a = path[i];
      City b = path[i + 1];
      float d = distSq(a.lat, a.lon, b.lat, b.lon);
      sum += d;
    }
    return sum;
  }

  public float distSq(float x1, float y1, float x2, float y2) {
    return ((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
  }

  public Route crossover(Route partner) {
    City[] dna = new City[chromosome.length];
    int start = myRandom.randomInt(chromosome.length);
    int end = myRandom.randomInt(start, chromosome.length);

    for (int i = start; i < end; i++) {
      dna[i] = chromosome[i];
    }

    int index = 0;
    if (start == 0) {
      index = end;
    }
    for (int i = 0; i < partner.chromosome.length; i++) {
      City v = partner.chromosome[i];
      boolean ok = true;
      for (int j = start; j < end; j++) {
        if (chromosome[j] == v) {
          ok = false;
        }
      }
      if (ok) {
        dna[index] = v;
        index++;
        if (index == start) {
          index = end;
        }
      }
    }
    return new Route(dna, false);
  }

  // Based on a mutation probability, picks a new random element
  public void mutate(float mutationRate) {
    if (Math.random() < mutationRate) {
      if (Math.random() < 0.5) {
        shuffle(chromosome);
      } else {
        int r1 = myRandom.randomInt(chromosome.length);
        City removed = chromosome[r1];
        City[] truncated = new City[chromosome.length - 1];
        for (int i = 0; i < truncated.length; i++) {
          if (i < r1) {
            truncated[i] = chromosome[i];
          } else {
            truncated[i] = chromosome[i + 1];
          }
        }
        int r2 = myRandom.randomInt(truncated.length);
        for (int i = 0; i < chromosome.length; i++) {
          if (i < r2) {
            chromosome[i] = truncated[i];
          } else if (i == r2) {
            chromosome[i] = removed;
          } else {
            chromosome[i] = truncated[i - 1];
          }
        }
      }
    }
  }

  private void shuffle(City[] list) {
    int a = myRandom.randomInt(list.length);
    int b = myRandom.randomInt(list.length);
    City temp = list[a];
    list[a] = list[b];
    list[b] = temp;
  }
}