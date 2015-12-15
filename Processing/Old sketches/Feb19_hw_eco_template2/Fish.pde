class Fish {

  PVector location, velocity, accel;
  float max_speed = 2.5;
  float max_accel = 0.7;
  float r;
  float energy;
  boolean sharkPresent;

  Fish() {
    location = new PVector(random(width), random(height));
    velocity = new PVector(0.0, 0.0);
    accel = new PVector(0.0, 0.0);
    r = 8.0;
    energy = 3.0;
  }

  void update() {
    //if (energy > 6) return;
    
    sharkPresent = false;
    for (int i = sharkArray.size()-1; i>=0; i--) {
      Shark p = sharkArray.get(i);
      float d = location.dist(p.location);
      if (d < 10*p.r) {
        seperate(p.location);
        sharkPresent = true;
      }
    }
    accel.limit(max_accel);
    velocity.sub(accel);
    velocity.limit(max_speed);
    
    if (!sharkPresent) {
      /*for (int i = fishArray.size()-1; i>=0; i--) {
        Fish p = fishArray.get(i);
        float d = location.dist(p.location);
        if (d < 10.2*r) {
          flocking(p.location);
        }
      }
      accel.limit(max_accel);
      velocity.add(accel);*/
      //velocity.limit(max_speed);
      
     /*for (int i = fishArray.size()-1; i>=0; i--) {
        Fish p = fishArray.get(i);
        float d = location.dist(p.location);
        if (d < 1.2*r) {
          seperate(p.location);
        }
      }
      accel.limit(max_accel);
      velocity.sub(accel);*/
      //velocity.limit(max_speed);
      
      int min_idx = -1;
      float min_dist = width+height;
      for (int i = volvoxArray.size()-1; i>=0; i--) {
        Volvox p = volvoxArray.get(i);
        float d = location.dist(p.location);
        if (d < min_dist && d < 15*r) {
          min_idx = i;
          min_dist = d;
        }
      }
      if (volvoxArray.size() > min_idx && min_idx != -1)
        seek(volvoxArray.get(min_idx).location);
      else accel = (new PVector(randomGaussian(), randomGaussian()));
      accel.mult(5);
      accel.limit(max_accel);
      velocity.add(accel);
      velocity.limit(max_speed);
    }
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
  
  void flocking(PVector _target) {
    accel = PVector.sub(_target,location);
  }

  void display() {
    pushStyle();
    stroke(0);
    fill(250, 150, 50);
    ellipse(location.x, location.y, 2*r, 2*r);
    // energy text
    textAlign(CENTER, CENTER);
    float xoff = location.x > width/2 ? -1.2*r : 1.2*r;
    float yoff = location.y > height/2 ? -1.2*r : 1.2*r;
    text(nf(energy, 0, 0), location.x+xoff, location.y+yoff);
    popStyle();
  }
}
