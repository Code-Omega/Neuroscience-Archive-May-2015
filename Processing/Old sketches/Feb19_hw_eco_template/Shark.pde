class Shark {

  PVector location, velocity, accel;
  float max_speed = 3.0;
  float max_accel = 1.0;
  float r;
  float energy;

  Shark() {
    location = new PVector(random(width), random(height));
    velocity = new PVector(0.0, 0.0);
    accel = new PVector(0.0, 0.0);
    r = 15.0;
    energy = 10.0;
  }

  void update() {
    //if (energy > 13) return;
    int min_idx = -1;
    float min_dist = width+height;
    for (int i = fishArray.size()-1; i>=0; i--) {
      Fish f = fishArray.get(i);
      float d = location.dist(f.location);
      if (d < min_dist && d < r*6) {
        min_idx = i;
        min_dist = d;
      }
    }
    if (fishArray.size() > min_idx && min_idx != -1)
      seek(fishArray.get(min_idx).location);
    else accel.add(new PVector(3*randomGaussian(), 3*randomGaussian()));
    accel.limit(max_accel);
    velocity.add(accel);
    velocity.limit(max_speed);
    //location.add(velocity);
    
    for (int i = sharkArray.size()-1; i>=0; i--) {
      Shark p = sharkArray.get(i);
      float d = location.dist(p.location);
      if (d < 2*r) {
        seperate(p.location);
      }
    }
    accel.limit(max_accel);
    velocity.sub(accel);
    velocity.limit(max_speed);
    location.add(velocity);
  }
  
  void seek(PVector _target) {
    //velocity = PVector.sub(_target,locatio
    accel = PVector.sub(_target,location);
  }
  
  void seperate(PVector _target) {
    accel = PVector.sub(_target,location);
  }

  void display() {
    pushStyle();
    stroke(0);
    fill(120, 70, 240);
    ellipse(location.x, location.y, 2*r, 2*r);
    // energy text
    textAlign(CENTER, CENTER);
    float xoff = location.x > width/2 ? -1.2*r : 1.2*r;
    float yoff = location.y > height/2 ? -1.2*r : 1.2*r;
    text(nf(energy, 0, 0), location.x+xoff, location.y+yoff);
    popStyle();
  }
}
