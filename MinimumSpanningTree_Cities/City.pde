class City {

  private float lon, lat;
  private String name;

  public City(float lon, float lat, String name) {
    this.lon = lon;
    this.lat = lat;
    this.name = name;
  }

  public City(City other) {
    this.lon = other.lon;
    this.lat = other.lat;
    this.name = other.name;
  }

  public String getName() {
    return name;
  }

  public float dist(City other) {
    return sqrt((other.lon - lon) * (other.lon - lon) + (other.lat - lat) * (other.lat - lat));
  }

  public float getLon() {
    return lon;
  }

  public float getLat() {
    return lat;
  }
}