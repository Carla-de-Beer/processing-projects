public class Population {

  float mutationRate;
  Route[] population;
  City[] path;
  int generations;
  MyRandom myRandom = new MyRandom();

  public Population(City[] path, float mutationRate, int num) {
    this.path = path;
    this.mutationRate = mutationRate;
    population = new Route[num];
    for (int i = 0; i < population.length; i++) {
      population[i] = new Route(path, true);
    }
    generations = 0;
  }

  // Fill our fitness array with a value for every member of the population
  public void calcFitness() {
    for (int i = 0; i < population.length; i++) {
      population[i].fitness();
    }
    float sum = 0;
    for (int i = 0; i < population.length; i++) {
      sum += population[i].fitness;
    }

    // Normalize all the fitness values
    for (int i = 0; i < population.length; i++) {
      population[i].normFitness = population[i].fitness / sum;
    }
  }

  public int constrain(int value, int min, int max) {
    return Math.min(Math.max(value, min), max);
  }

  public int select() {
    int select = 0;
    float selector = (float) Math.random();
    while (selector > 0) {
      select = constrain(select, 0, population.length - 1);
      selector -= population[select].normFitness;
      select += 1;
    }
    select -= 1;
    select = constrain(select, 0, population.length - 1);
    return select;
  }

  // Create a new generation
  public void generate() {
    Route[] newpop = new Route[population.length];
    for (int i = 0; i < population.length; i++) {
      int a = select();
      int b = select();
      Route partnerA = population[a];
      Route partnerB = population[b];
      Route child = partnerA.crossover(partnerB);
      child.mutate(mutationRate);
      newpop[i] = child;
    }
    generations++;
    population = newpop;
  }

  // Compute the current "most fit" member of the population
  public Route getBest() {
    float worldrecord = 0.0f;
    int index = 0;
    for (int i = 0; i < population.length; i++) {
      if (population[i].fitness > worldrecord) {
        index = i;
        worldrecord = population[i].fitness;
      }
    }
    return population[index];
  }

  int getGenerations() {
    return generations;
  }

}