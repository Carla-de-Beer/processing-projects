class City {

  private float lat, lon;
  private String name;

  public City(float lat, float lon, String name) {
    this.lat = lat;
    this.lon = lon;
    this.name = name;
  }

  public City(City other) {
    this.lat = other.lat;
    this.lon = other.lon;
    this.name = other.name;
  }

  public String getName() {
    return name;
  }

  public float dist(City other) {
    return sqrt((other.lat - lat) * (other.lat - lat) + (other.lon - lon) * (other.lon - lon));
  }

  public float getLon() {
    return lon;
  }

  public float getLat() {
    return lat;
  }
}