/* 
  Feb 26 homework
  action selection while foraging for pellets
  
  This is a TWO-WEEK assignment:
  Part 1 due Tue Mar 3 (midnight) -  implement (at least) wall collision detection and avoid getting stuck
  Part 2 due Tue Mar 10 (midnight) - full foraging simulation as described below, with effective action
                                     selection, area-restricted search for invisible pellets, etc.
  
  Main goal: 
  Collect all the pellets (green and invisible) as quickly as possible.
  After optimizing your controller, run 5 foraging trials and report the average time
  required to collect all pellets (mean and standard deviation)
   
 - GREEN PELLETS can be detected from a distance; 
   Green pellets are worth 1 point each
   code to find the location of the nearest green pellet is already provided
   
 - INVISIBLE PELLETS can only be detected by running into them; 
   Invisible pellets are worth 5 points each
   the only way to detect an invisible pellet is for the bot to monitor its own energy
   when the energy jumps by 5 that means it found an invisible pellet
   Invisible pellets are clustered in groups of 4, so an area-restricted search strategy
   might be useful; keeping track of energy gained should allow the bot to determine when
   it has found all 4 pellets in the cluster
  
 - WALLS 
   You should create your own method for sensing wall collisions and 
   implment appropriate behavioral responses to avoid getting stuck.
   The following fisica methods might be useful
   FBody.getContacts(), 
   FContact.getX(), FContact.getY(), FContact.getNormalX(), FContact.getNormalY()
   
 - RESTRICTIONS
   You can only use information that would be available to the bot through its sensors
   (location of nearest green pellet, bot energy, wall collisions)
   You cannot use observer-level knowledge regarding the locations of pellets, walls, etc.
   You cannot exceed max_torque and max_thrust values in your bot update routine
  
*/

import fisica.*;

int NBOTS = 1;
int NPELLETS = 30;
int NINVISIBLE = 20;

FWorld world;
ArrayList<Bot> bots = new ArrayList<Bot>(NBOTS);
boolean paused = false;

void setup () {
  setup_world();
  setup_walls();
  setup_bots();
  setup_pellets();
  setup_invisible();
}

void setup_world() {
  size(600, 400);
  Fisica.init(this);
  world = new FWorld();
  world.setEdges();
  world.setEdgesFriction(0.0);
  world.setEdgesRestitution(0.3);
  world.setGravity(0.0, 0.0);
  world.left.setName("wall");
  world.right.setName("wall");
  world.top.setName("wall");
  world.bottom.setName("wall");
}

void setup_bots() {
  for (int i=0; i<NBOTS; i++) {
    Bot b = new Bot();
    bots.add(b);
  }
}

void setup_walls() {
  float[][] dat = { 
    {200., 20., 0.25*width, 0.6*height, 1.0},
    {250., 20., 0.6*width, 0.4*height, -1.0},
    {150., 20., 0.8*width, 0.7*height, 0.0}
    };
  for (int i=0; i<3; i++) {
    FBox w = new FBox(dat[i][0], dat[i][1]);
    w.setPosition (dat[i][2], dat[i][3]);
    w.setRotation(dat[i][4]);
    w.setFriction(1.0);
    w.setRestitution(0.1);
    w.setFill(50, 50, 50);
    //w.setDensity(1000.);
    w.setStatic(true);
    w.setName("wall");
    world.add(w);
  }
}

void setup_pellets() {
  float[][] dat = { 
    {250., 100., 60.},
    {450., 200., 50.},
    {100., 300., 40.}
    };
    for (int i=0; i<3; i++) {
    for (int j=0; j<10; j++) {
      FCircle p = new FCircle(5);
      p.setFill(50,250,50);
      p.setNoStroke();
      float phi = random(TWO_PI);
      float r = dat[i][2] * sqrt(random(1.0));
      float x = dat[i][0] + r * cos(phi);
      float y = dat[i][1] + r * sin(phi);
      p.setPosition(x, y);
      p.setName("pellet");
      p.setStatic(true);
      world.add(p);
    }
  }
}

void setup_invisible() {
  float[][] dat = { 
    {70., 70., 20.},
    {520., 350., 20.},
    {500., 100., 20.}
    };
    for (int i=0; i<3; i++) {
      float phi_off = random(TWO_PI);
    for (int j=0; j<4; j++) {
      FCircle p = new FCircle(5);
      p.setNoFill();
      p.setStroke(50,50,50);
      float phi = phi_off + TWO_PI * (j/4.0);
      float r = dat[i][2];
      float x = dat[i][0] + r * cos(phi);
      float y = dat[i][1] + r * sin(phi);
      p.setPosition(x, y);
      p.setName("invisible");
      p.setStatic(true);
      world.add(p);
    }
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
  int ninvisible = 0;
  for (int i=0; i<bodies.size (); i++) {
    FBody b = bodies.get(i);
    String name = b.getName();
    if (name != null && name.equals("pellet")) npellets++;
    if (name != null && name.equals("invisible")) ninvisible++;
  }
  fill(200);
  textAlign(LEFT);
  text("REMAINING PELLETS: " + npellets, 200, 20);
  text("REMAINING INVISIBLE: " + ninvisible, 200, 35);

  // pause if all the pellets are gone
  if (npellets+ninvisible == 0) {
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

