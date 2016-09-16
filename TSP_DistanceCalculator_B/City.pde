class City {

  private double lat, lon;
  private String name;

  public City(double lat, double lon, String name) {
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

  public double getLon() {
    return lon;
  }

  public double getLat() {
    return lat;
  }
  
}