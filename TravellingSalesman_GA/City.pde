class City {

  float lat, lon;
  String name;

  City(float lat, float lon, String name) {
    this.lat = lat;
    this.lon = lon;
    this.name = name;
  }

  String getName() {
    return name;
  }

  float getLon() {
    return lon;
  }

  float getLat() {
    return lat;
  }
}