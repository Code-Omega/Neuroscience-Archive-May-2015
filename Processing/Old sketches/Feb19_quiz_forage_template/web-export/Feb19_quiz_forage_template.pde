/* 
 Feb 19 Quiz
 
 The template provides:
 - a population of 50 green, circular food pellets (class Pellet)
   uniformly distributed throughout the environment; non-moving, radius = 5.
 - a single, circular orange bot, radius = 15 (class Bot)
 - uses a PVector representation for the bot's position, velocity and acceleration
 - the bot has an 'energy' variable with an initial value of 0.0
 - implements CONFINED boundary conditions so the bot never strays beyond the edges
 - when the bot collides with a pellet, increments energy by 1 and removes the pellet
 - displays the bot's energy next to the bot
 
 Main Goals
 - implement Reynold's SEEK behavior and implement a foraging simulation
   in which the bot always seeks PELLET 0 (the first pellet in the ArrayList)
 - enforce a max_speed of 1.0 and a max_accel of 0.1 in your update routine
 
 Advanced Goals
 - modify the behavior so that the bot always SEEKS the NEAREST PELLET
 - add 3 bots instead of 1
 
 */
 
int NBOTS = 3;
int NPELLETS = 50;

ArrayList<Bot> bots;
ArrayList<Pellet> pellets;

boolean paused;

void setup() {
  size(600, 400);
  bots = new ArrayList<Bot>();
  pellets = new ArrayList<Pellet>();
  for (int i=0; i<NBOTS; i++) bots.add(new Bot());
  for (int i=0; i<NPELLETS; i++) pellets.add(new Pellet());
}

void draw() {
  // display
  background(30);

  for (Pellet p : pellets) {
    p.display();
  }
  
  // outline pellet 0
  if (pellets.size() > 0) {
  pushStyle();
  stroke(255);
  noFill();
  Pellet p0 = pellets.get(0);
  ellipse(p0.location.x, p0.location.y, 14, 14);
  popStyle();
  }

  for (Bot b : bots) {
    // display
    b.display();

    // update
    b.update();
    confine(b);
    
    // pellet consumption
    for (int i = pellets.size()-1; i>=0; i--) {
      Pellet p = pellets.get(i);
      // check for collision
      float d = b.location.dist(p.location);
      if (d < b.r + p.r) {
        b.energy += 1.0;
        pellets.remove(i);
      }
    }
  }
  
  if (paused) {
    pushStyle();
    fill(200);
    textAlign(CENTER);
    textSize(26);
    text("PAUSED", width/2, height/2);
    noLoop();
    popStyle();
  }
  
  // pause if no more pellets
  if (pellets.size() == 0) {
    paused = true;
  }
}

void confine(Bot b) {
  float r = b.r;
  if (b.location.x < r) b.location.x = r;
  if (b.location.x > width - r) b.location.x = width - r;
  if (b.location.y < r) b.location.y = r;
  if (b.location.y > height - r) b.location.y = height - r;
}

void keyPressed() {
  if (key == 'p' || key == ' ') {
    paused = !paused;
    if(!paused) loop();
  }
}

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

class Pellet {
  
  PVector location;
  float r;
  
  Pellet() {
    location = new PVector(random(width), random(height));
    r = 5;
  }
   
  void display() {
    noStroke();
    fill(50, 250, 50);
    ellipse(location.x, location.y, 2*r, 2*r);
  }
}

