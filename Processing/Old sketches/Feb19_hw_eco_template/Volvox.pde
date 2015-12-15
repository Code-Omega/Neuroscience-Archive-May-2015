class Volvox {

  PVector location, velocity, accel;
  float max_speed = 1.0;
  float max_accel = 0.1;
  float r;
  float energy;

  Volvox() {
    location = new PVector(random(width), random(height));
    velocity = new PVector(0.0, 0.0);
    accel = new PVector(0.0, 0.0);
    r = 2.0;
    energy = 2.0;
  }

  void update() {
    //accel.add(new PVector(randomGaussian(), randomGaussian()));
    accel.add(ff.getFlow(location));
    accel.limit(max_accel);
    velocity.sub(accel);
    velocity.limit(max_speed);
    for (int i = volvoxArray.size()-1; i>=0; i--) {
      Volvox p = volvoxArray.get(i);
      float d = location.dist(p.location);
      if (d < 4*p.r) {
        seperate(p.location);
      }
    }
    accel.limit(max_accel);
    velocity.sub(accel);
    velocity.limit(max_speed);
    for (int i = fishArray.size()-1; i>=0; i--) {
      Fish p = fishArray.get(i);
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
    //velocity = PVector.sub(_target,location);
    //velocity.normalize();
    accel = PVector.sub(_target,location);
  }
  
  void seperate(PVector _target) {
    accel = PVector.sub(_target,location);
  }

  void display() {
    pushStyle();
    stroke(0);
    fill(120, 230, 80);
    ellipse(location.x, location.y, 2*r, 2*r);
    // energy text
    textAlign(CENTER, CENTER);
    float xoff = location.x > width/2 ? -1.2*r : 1.2*r;
    float yoff = location.y > height/2 ? -1.2*r : 1.2*r;
    text(nf(energy, 0, 1), location.x+xoff, location.y+yoff);
    popStyle();
  }
}

