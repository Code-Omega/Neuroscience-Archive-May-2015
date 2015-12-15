class Bot {

  PVector location, velocity, accel;
  float max_speed = 1.0;
  float max_accel = 0.1;
  float r;
  float energy;

  Bot() {
    location = new PVector(random(width), random(height));
    velocity = new PVector(0.0, 0.0);
    accel = new PVector(0.0, 0.0);
    r = 15.0;
    energy = 0.0;
  }

  void update() {
    /*if (pellets.size() > 0)
      seek(pellets.get(0).location);
    location.add(velocity);*/
    int min_idx = 0;
    float min_dist = width+height;
    for (int i = pellets.size()-1; i>=0; i--) {
      Pellet p = pellets.get(i);
      float d = location.dist(p.location);
      if (d < min_dist) {
        min_idx = i;
        min_dist = d;
      }
    }
    if (pellets.size() > min_idx)
      seek(pellets.get(min_idx).location);
    accel.limit(max_accel);
    velocity.add(accel);
    velocity.limit(max_speed);
    //location.add(velocity);
    
    for (int i = bots.size()-1; i>=0; i--) {
      Bot p = bots.get(i);
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
    fill(250, 200, 50);
    ellipse(location.x, location.y, 2*r, 2*r);
    // energy text
    textAlign(CENTER, CENTER);
    float xoff = location.x > width/2 ? -1.2*r : 1.2*r;
    float yoff = location.y > height/2 ? -1.2*r : 1.2*r;
    text(nf(energy, 0, 0), location.x+xoff, location.y+yoff);
    popStyle();
  }
}

