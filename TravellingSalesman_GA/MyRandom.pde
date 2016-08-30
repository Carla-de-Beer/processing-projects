import java.util.Random;

class MyRandom {

  MyRandom() {
  }

  int randomInt(int min, int max) {
    Random rand = new Random();
    int randomNum = rand.nextInt((max - min)) + min;
    return randomNum;
  }

  int randomInt(int max) {
    Random rand = new Random();
    int randomNum = rand.nextInt((max));
    return randomNum;
  }

  float randomDouble() {
    Random rand = new Random();
    float randomNum = 1 * rand.nextFloat();
    return randomNum;
  }
}