/* 
 Feb 19 Homework Assignment (due Feb 24 midnight)
 
 Create a small ecosystem with 3 species: 
 volvox - small, green algae
 fish   - medium, eat algae, avoid sharks
 shark  - large, eats fish, ignores algae
 
 Include lots of algae, several fish and just one shark.
 
 Use several of Reynold's steering behaviors to control the 
 behavior of your agents (seek, flee, pursue, evade, wander,
 flow field following, flocking, path following, etc.)
 
 Consider using different values of max speed and 
 max acceleration (max force) for the different species.
 
 Example ideas:
 algea could move slowly in a flow field, fish could school
 and seek algae unless a shark is nearby in which case they 
 should evade the predator, the shark could follow a fixed path
 through the environment until it got close to some fish, in 
 which case it could switch to pursuit.
 
 Adjust the level of complexity to match your programming skills.
 This is an open-ended assignment. Be creative and have fun.
 
 Start simple!!
 
 WHEN YOU SUBMIT YOUR HOMEWORK, PLEASE PROVIDE A SHORT TEXT
 DESCRIPTION IN THE EMAIL THAT SUMMARIZES THE BEHAVIORS THAT
 YOU IMPLEMENTED FOR EACH SPECIES.
 
 */
 
int NVOLVOX = 50;
int NFISH = 20;
int NSHARK = 2;

ArrayList<Volvox> volvoxArray;
ArrayList<Fish> fishArray;
ArrayList<Shark> sharkArray;

void setup() {
  size(600, 400);
  volvoxArray = new ArrayList<Volvox>();
  fishArray = new ArrayList<Fish>();
  sharkArray = new ArrayList<Shark>();
  for (int i=0; i<NVOLVOX; i++) volvoxArray.add(new Volvox());
  for (int i=0; i<NFISH; i++) fishArray.add(new Fish());
  for (int i=0; i<NSHARK; i++) sharkArray.add(new Shark());
}

void draw() {
  // display
  background(30);
  
  int newV = 0;
  int newF = 0;
  int newS = 0;

  for (int j = fishArray.size()-1; j>=0; j--) {
    Fish f = fishArray.get(j);
    if (f.energy <= 0) {
        fishArray.remove(j);
    }
  }
  
  for (int k = volvoxArray.size()-1; k>=0; k--) {
    Volvox v = volvoxArray.get(k);
    if (v.energy <= 0.1) {
      volvoxArray.remove(k);
    }
  }

  
  for (int i = sharkArray.size()-1; i>=0; i--) {
    Shark s = sharkArray.get(i);
    if (s.energy <= 0) {
      sharkArray.remove(i);
    }
    for (int j = fishArray.size()-1; j>=0; j--) {
      Fish f = fishArray.get(j);
      float dj = f.location.dist(s.location);
      if (dj < f.r + s.r) {
        s.energy += f.energy*0.1;
        fishArray.remove(j);
      }
      for (int k = volvoxArray.size()-1; k>=0; k--) {
        Volvox v = volvoxArray.get(k);
        float dk = f.location.dist(v.location);
        if (dk < f.r + v.r) {
          f.energy += v.energy*0.1;
          volvoxArray.remove(k);
        }
      }
    }
  }
  
  for (Volvox v : volvoxArray) {
    v.display();
    v.update();
    confine(v);
    if (frameCount%100 < 1) {
      v.energy -= 1000.0*(volvoxArray.size()+1)/(width*height);
    if (v.energy > 0.7) newV++;}
  }
  for (Fish f : fishArray) {
    f.display();
    f.update();
    confine(f);
    if (frameCount%100 < 1) {f.energy -= 0.1;
    if (f.energy > 5.5) newF++;}
  }
  for (Shark s : sharkArray) {
    s.display();
    s.update();
    confine(s);
    if (frameCount%100 < 1) {s.energy--;
    if (s.energy > 10) newS++;}
  }
  
  for (int i = 0; i < newV; i++) volvoxArray.add(new Volvox());
  for (int j = 0; j < newF; j++) fishArray.add(new Fish());
  for (int k = 0; k < newS; k++) sharkArray.add(new Shark());
}

void confine(Fish b) {
  float r = b.r;
  if (b.location.x < r) b.location.x = r;
  if (b.location.x > width - r) b.location.x = width - r;
  if (b.location.y < r) b.location.y = r;
  if (b.location.y > height - r) b.location.y = height - r;
}

void confine(Shark b) {
  float r = b.r;
  if (b.location.x < r) b.location.x = r;
  if (b.location.x > width - r) b.location.x = width - r;
  if (b.location.y < r) b.location.y = r;
  if (b.location.y > height - r) b.location.y = height - r;
}

void confine(Volvox b) {
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

class Fish {

  PVector location, velocity, accel;
  float max_speed = 1.0;
  float max_accel = 0.1;
  float r;
  float energy;

  Fish() {
    location = new PVector(random(width), random(height));
    velocity = new PVector(0.0, 0.0);
    accel = new PVector(0.0, 0.0);
    r = 8.0;
    energy = 5.0;
  }

  void update() {
    if (energy > 7) return;
    int min_idx = 0;
    float min_dist = width+height;
    for (int i = volvoxArray.size()-1; i>=0; i--) {
      Volvox p = volvoxArray.get(i);
      float d = location.dist(p.location);
      if (d < min_dist) {
        min_idx = i;
        min_dist = d;
      }
    }
    if (volvoxArray.size() > min_idx)
      seek(volvoxArray.get(min_idx).location);
    accel.limit(max_accel);
    velocity.add(accel);
    velocity.limit(max_speed);
    //location.add(velocity);
    
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
class Shark {

  PVector location, velocity, accel;
  float max_speed = 1.0;
  float max_accel = 0.1;
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
    if (energy > 13) return;
    int min_idx = 0;
    float min_dist = width+height;
    for (int i = fishArray.size()-1; i>=0; i--) {
      Fish f = fishArray.get(i);
      float d = location.dist(f.location);
      if (d < min_dist) {
        min_idx = i;
        min_dist = d;
      }
    }
    if (fishArray.size() > min_idx)
      seek(fishArray.get(min_idx).location);
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
    energy = 1.0;
  }

  void update() {
    accel.add(new PVector(randomGaussian(), randomGaussian()));
    accel.limit(max_accel);
    velocity.sub(accel);
    velocity.limit(max_speed);
    for (int i = volvoxArray.size()-1; i>=0; i--) {
      Volvox p = volvoxArray.get(i);
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
    text(nf(energy, 0, 0), location.x+xoff, location.y+yoff);
    popStyle();
  }
}


