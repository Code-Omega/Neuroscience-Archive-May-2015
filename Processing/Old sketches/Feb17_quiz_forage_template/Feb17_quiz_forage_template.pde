/*
Feb 17 Quiz
 
 Main Goal
 - create a population of 50 green, circular food pellets (class Pellet)
   uniformly distributed throughout the environment; non-moving, radius = 5
 - create a single, circular orange bot, radius = 15 (class Bot)
 - give the bot an 'energy' variable with an initial value of 0.0
 - implement a wander behavior for the bot (speed = 1 pixel/frame)
 - implement wrapped boundary conditions
 - whenever the bot collides with a food pellet (distance between centers less
   than the sum of radii), increment the bot's energy by 1 and remove the pellet
   HINT: loop through the pellets array backwards, as follows:
   
   for (int i = pellets.size() - 1; i >= 0; i--) {
     Pellet p = pellets.get(i);
     ...
     if (there is a collision) {
       b.energy += 1.0;
       pellets.remove(i);
     }
     ...
   }
   
 - display the bot's energy in the upper left corner of the screen
 
 Advanced Goal
 - same as above, but create 3 bots instead of 1, and display each bot's energy 
   as a text value adjacent to the bot
 
 */
 
ArrayList<Pellet> pellets;
ArrayList<Bot> bots;

void setup() {
  size(400, 300);
  pellets = new ArrayList<Pellet>();
  bots = new ArrayList<Bot>();
  for (int i = 0; i < 50; i++) {
     pellets.add(new Pellet());
   }
  for (int i = 0; i < 3; i++) {
     bots.add(new Bot());
   }
}

void draw() {
  background(0);
  for (Pellet p : pellets) {
    p.display();
  }
  for (Bot b : bots) {
    b.display();
    b.update();
    wrap(b);
    for (int i = pellets.size() - 1; i >= 0; i--) {
      Pellet p = pellets.get(i);
      if (pow(b.x-p.x,2)+pow(b.y-p.y,2)<pow(20,2)) {
        b.energy += 1.0;
        pellets.remove(i);
      }
    }
  }
}


class Pellet {
  float x, y, d;
  Pellet() {
    x = random(width);
    y = random(height);
    d = 10;
  }
  void display() {
    pushStyle();
    noStroke();
      fill(50, 250, 50);
      ellipse(x, y, d, d);
    popStyle();
  }
  
}

void wrap(Bot b) {
  if(b.x < -15) b.x = width + 15;
  if(b.x > width + 15) b.x = -15;
  if(b.y < -15) b.y = height + 15;
  if(b.y > height + 15) b.y = -15;
}

class Bot {
  float x, y, d;
  float speed;
  float heading;
  int energy;
  Bot() {
    x = random(width);
    y = random(height);
    d = 30;
    speed = 1;
    heading = random(TWO_PI);
    energy = 0;
  }
  void display() {
    pushStyle();
    pushMatrix();
    noStroke();
      fill(250, 250, 50);
      ellipse(x, y, d, d);
    popStyle();
    popMatrix();
    text(energy,x+15,y-15);
  }
  void update() {
    heading += 0.1*randomGaussian();
    x += speed * cos(heading);
    y += speed * sin(heading);
  }
}

