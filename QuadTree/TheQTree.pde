class QTree {
  Rectangle boundary;
  ArrayList<Particle> particles;
  int capacity;
  Boolean isDivided;

  QTree northEast, northWest, southEast, southWest;

  QTree(Rectangle boundary, int n) {
    this.boundary = new Rectangle(boundary);
    this.capacity = n;
    this.particles = new ArrayList<Particle>();
    this.isDivided = false;
  }

  void subdivide() {
    float x = this.boundary.x;
    float y = this.boundary.y;
    float w = this.boundary.w * 0.5;
    float h = this.boundary.h * 0.5;

    Rectangle ne = new Rectangle(x + w, y - h, w, h);
    northEast = new QTree(ne, this.capacity);
    Rectangle nw = new Rectangle(x - w, y - h, w, h);
    northWest = new QTree(nw, this.capacity);
    Rectangle se = new Rectangle(x + w, y + h, w, h);
    southEast = new QTree(se, this.capacity);
    Rectangle sw = new Rectangle(x - w, y + h, w, h);
    southWest = new QTree(sw, this.capacity);
    isDivided = true;
  }

  Boolean insert(Particle point) {
    if (!this.boundary.contains(point)) {
      return false;
    }

    if (particles.size() < this.capacity) {
      particles.add(point);
      return true;
    } else {
      if (!isDivided) {
        subdivide();
      }
      if (northEast.insert(point)) {
        return true;
      } else if (this.northWest.insert(point)) {
        return true;
      } else if (this.southEast.insert(point)) {
        return true;
      } else if (this.southWest.insert(point)) {
        return true;
      }
    }
    return false;
  }

  ArrayList<Particle> query(Rectangle range, ArrayList<Particle> found) {
    if (found == null) {
      found = new ArrayList<Particle>();
    }
    if (this.boundary.intersects(range)) {

      for (Particle p : particles) {
        if (range.contains(p)) {
          found.add(p);
        }
      }
      if (isDivided) {
        northWest.query(range, found);
        northEast.query(range, found);
        southWest.query(range, found);
        southEast.query(range, found);
      }
    }
    return found;
  }

  void show() {
    stroke(255);
    strokeWeight(0.5);
    noFill();
    rectMode(CENTER);
    rect(boundary.x, boundary.y, boundary.w * 2, boundary.h * 2);
    if (isDivided) {
      this.northEast.show();
      this.northWest.show();
      this.southEast.show();
      this.southWest.show();
    }
    stroke(255, 0, 100);
    strokeWeight(2);
    for (Particle p : particles) {
      point(p.x, p.y);
    }
  }
}
