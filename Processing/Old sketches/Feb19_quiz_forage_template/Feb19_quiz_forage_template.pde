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

