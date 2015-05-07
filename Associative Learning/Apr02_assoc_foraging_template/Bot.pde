class Bot {

  PVector location, velocity, accel;
  float max_speed = 1.0;
  float max_accel = 0.1;
  float r, energy;
  color cfill;
  int pelletType;
  float expected_red, expected_green, expected_blue;
  float prob_red, prob_green, prob_blue;
  float reward;
  int chosen_type;
  
  float temp, temp2;

  Bot() {
    location = new PVector(random(world_width), random(world_height));
    velocity = new PVector(0.0, 0.0);
    accel = new PVector(0.0, 0.0);
    r = 15.0;
    energy = 0.0;
    cfill = color(180, 160, 120);
    pelletType = -1;
    expected_red = expected_green = expected_blue = 0.0;
    prob_red = prob_green = prob_blue = 1.0/3.0;
    float selector = random(1.0);
    chosen_type = (selector < prob_red) ? 0 : ((selector-prob_red < prob_green) ? 1 : 2);
  }

  void update() {
    
    //float orig_mag = 0;
    
    if (pellets.size() > 0) {
      //float selector = random(1.0);
      //chosen_type = (selector < prob_red) ? 0 : ((selector-prob_red < prob_green) ? 1 : 2);
      Pellet ptarget = closest_pellet(chosen_type);
      if (ptarget.type != chosen_type) {
        int old_chosen_type = chosen_type;
        while (chosen_type == old_chosen_type) {
          float selector = random(1.0);
          chosen_type = (selector < prob_red) ? 0 : ((selector-prob_red < prob_green) ? 1 : 2);
          ptarget = closest_pellet(chosen_type);
        }
      }
      seek(ptarget.location);
      
      //orig_mag = accel.mag();
      if (avoid){
        Pellet pavoid = closest_pellet();
        float tempx = (abs((PVector.sub(pavoid.location, location).heading()-PVector.sub(ptarget.location, location).heading())%TWO_PI));
        temp = PVector.sub(pavoid.location, location).mag();
        if ((pavoid != ptarget)&&
            ((expected_red < -0.5 && pavoid.type == 0)||
            (expected_green < -0.5 && pavoid.type == 1)||
            (expected_blue < -0.5 && pavoid.type == 2))&&
            (temp > abs(r+pavoid.r))&&
            (tempx < PI/2)
            ){
            avoid(pavoid);
        }
      }
      // draw line to target
      stroke(cfill, 100);
      line(location.x, location.y, ptarget.location.x, ptarget.location.y);
    }
    
    //accel.setMag(orig_mag);
    
    accel.limit(max_accel);
    velocity.add(accel);
    velocity.limit(max_speed);
    location.add(velocity);
    accel.mult(0.0);
  }

  Pellet closest_pellet(int _type) {
    float dmin = width+height;
    int imin = 0;
    for (int i = 0; i < pellets.size (); i++) {
      Pellet p = pellets.get(i);
      if (p.type == _type){
        float d = location.dist(p.location);
        if (d < dmin) {
          dmin = d;
          imin = i;
        }
      }
    }
    return pellets.get(imin);
  }
  
  Pellet closest_pellet() {
    float dmin = width+height;
    int imin = 0;
    for (int i = 0; i < pellets.size (); i++) {
      Pellet p = pellets.get(i);
      float d = location.dist(p.location);
      if (d < dmin) {
        dmin = d;
        imin = i;
      }
    }
    return pellets.get(imin);
  }

  void seek(PVector _target) {
    PVector desired_vel = PVector.sub(_target, location);
    desired_vel.setMag(max_speed);
    PVector desired_accel = PVector.sub(desired_vel, velocity);
    desired_accel.limit(max_accel);
    accel.add(desired_accel);
  }
  
  void avoid(Pellet _target) {
    PVector desired_vel = PVector.sub(_target.location, location);
    float x = temp2 = asin(1.0*(r+_target.r+2)*sin(PI/2)/desired_vel.mag());
    if (x != x) x = temp2 = PI;
    //if ((desired_vel.heading()%PI-velocity.heading()%PI) < 0 ) x = -1.0*abs(x);
    if (abs(desired_vel.heading()-velocity.heading())%TWO_PI < 0 ) x = -1.0*abs(x);
    else x = 1.0*abs(x);
    //float x = PI/2;
    //x = constrain(x, -TWO_PI, TWO_PI);
    desired_vel.rotate(x);
    desired_vel.setMag(max_speed);
    PVector desired_accel = PVector.sub(desired_vel, velocity);
    desired_accel.limit(max_accel);
    accel.add(desired_accel);
  }


  void display() {
    stroke(0);
    fill(cfill);
    pushMatrix();
    translate(location.x, location.y);
    // energy text
    pushStyle();
    textAlign(CENTER, CENTER);
    float xoff = location.x > width/2 ? -1.4*r : 1.4*r;
    float yoff = location.y > height/2 ? -1.4*r : 1.4*r;
    text(nf(energy, 0, 0), xoff, yoff);
    //text(temp2, xoff, yoff+10);
    print(temp2);
    //text(pelletType, xoff+30, yoff);
    popStyle();
    // draw bot
    if (velocity.mag() > 0) rotate(velocity.heading());
    ellipse(0, 0, 2*r, r);
    // eyes
    fill(0);
    ellipse(0.7*r,  0.3*r, 4, 4);
    ellipse(0.7*r, -0.3*r, 4, 4);
    popMatrix();
  }

  void updateExpect() {
    if (pelletType == 0) {
      expected_red += epsilon * (reward - expected_red);
    } else if (pelletType == 1){
      expected_green += epsilon * (reward - expected_green);
    } else if (pelletType == 2){
      expected_blue += epsilon * (reward - expected_blue);
    }
    /*prob_red = 1.0 / (2.0 + exp(beta * ((expected_green + expected_blue)/2 - expected_red)));
    prob_green = 1.0 / (2.0 + exp(beta * ((expected_red + expected_blue)/2 - expected_green)));
    prob_blue = 1.0 / (2.0 + exp(beta * ((expected_red + expected_green)/2 - expected_blue)));*/
    prob_red = 1.0 / (1.0 + 2.0 * exp(beta * ((expected_green + expected_blue)/2 - expected_red)));
    prob_green = ((1.0 - prob_red) / (1.0 + exp(beta * (expected_blue - expected_green))));
    prob_blue = 1.0 - prob_red - prob_green;
  }
}
