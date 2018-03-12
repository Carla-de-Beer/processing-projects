class City {
  private double lon, lat;
  private String name;

  public City(double lon, double lat, String name) {
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

  public double getLon() {
    return lon;
  }

  public double getLat() {
    return lat;
  }
}