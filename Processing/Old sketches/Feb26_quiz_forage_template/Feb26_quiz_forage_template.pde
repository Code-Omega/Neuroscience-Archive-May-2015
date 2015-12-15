/* 
  Feb 26 quiz
  foraging for pellets with fisica
 
  Main goal:
     modify the Bot "approach_target()" method
     so that the bot will approach the target_location,
     which has been set to the location of the nearest pellet
     
   Advanced goal:
     - modify the simulation to pause after 25 pellets have been collected (=25 remaining)
     - run 5 trials and record how long it takes the bot to collect 25 pellets on each trial
     - report the mean and standard deviation of collection time
     - try to optimize your "approach_target" code to improve performace
       (but do not exceed max_torque or max_thrust)
     - were you able to improve performance over your initial implementation? 
       if so, how and by how much?
 
 */

import fisica.*;

int NBOTS = 1;
int NPELLETS = 50;

FWorld world;
ArrayList<Bot> bots = new ArrayList<Bot>(NBOTS);
boolean paused = false;

void setup () {
  setup_world();
  setup_bots();
  setup_pellets();
}

void setup_world() {
  size(600, 400);
  Fisica.init(this);
  world = new FWorld();
  world.setEdges();
  world.setEdgesFriction(0.0);
  world.setEdgesRestitution(0.3);
  world.setGravity(0.0, 0.0);
}

void setup_bots() {
  for (int i=0; i<NBOTS; i++) {
    Bot b = new Bot();
    bots.add(b);
  }
}

void setup_pellets() {
  for (int i=0; i<NPELLETS; i++) {
    FCircle p = new FCircle(5);
    p.setFill(50, 250, 50);
    p.setNoStroke();
    p.setPosition(random(20, width-20), random(20, height-20));
    p.setName("pellet");
    world.add(p);
  }
}

void draw() {
  background(100);
  for (Bot b : bots) b.update();
  world.step();
  world.draw();
  show_info();
}

void show_info() {
  // show simulation time - upper left
  fill(200);
  float time = frameCount/60.0;
  textAlign(LEFT);
  text("TIME: " + nf(time, 0, 1), 10, 20);

  // show frames per second - upper right
  textAlign(RIGHT);
  text("FPS: " + nf(frameRate, 0, 1), width-10, 20);

  // show bot info
  for (Bot b : bots) b.display();

  // count remaining pellets
  ArrayList<FBody> bodies = world.getBodies();
  int npellets = 0;
  for (int i=0; i<bodies.size (); i++) {
    FBody b = bodies.get(i);
    String name = b.getName();
    if (name != null && name.equals("pellet")) npellets++;
  }
  fill(200);
  textAlign(CENTER);
  text("REMAINING PELLETS: " + npellets, width/2, 20);

  // pause if all the pellets are gone
  if (npellets == 0) {
    paused = true;
  }

  // paused status
  if (paused) {
    fill(200);
    pushStyle();
    textSize(26);
    textAlign(CENTER, CENTER);
    text("PAUSED", width/2, height/2);
    popStyle();
    noLoop();
  }
}

void keyPressed() {
  switch (key) {
  case 'p':
  case ' ':
    paused = !paused;
    if (!paused) loop();
    break;
  }
}
