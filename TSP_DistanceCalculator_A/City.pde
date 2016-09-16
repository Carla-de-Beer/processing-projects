// Class that acts similarly to the of the Processing PVector class (for this example),
// but stores the city name value as well.

public class City {

  public float lat, lon;
  public String name;

  public City(float lat, float lon, String name) {
    this.lat = lat;
    this.lon = lon;
    this.name = name;
  }

  // Copy constructor
  public City(City other) {
    this.lat = other.lat;
    this.lon = other.lon;
    this.name = other.name;
  }

  public String getName() {
    return name;
  }

  public float getLon() {
    return lat;
  }

  public float getLat() {
    return lon;
  }
}