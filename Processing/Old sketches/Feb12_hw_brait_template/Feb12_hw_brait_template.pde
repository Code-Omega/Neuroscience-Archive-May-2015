/* 
 Feb 12 Homework
 
 Main Goal
 Create four populations of Braitenberg vehicles that respond
 to a single light source in the center of the canvas.
 
   -- each population should have a different color
   -- each population should implement a different Braitenberg vehicle type:
      Aggresssive, Coward, Love, Explorer
   -- tune the sensory-motor gains and offsets so that the observed behavior 
      approximates Braitenberg's description for that vehicle type
   -- 4 vehicles per population
 
 Advanced Goals
   (1) add a total of 4 light sources within the central part of the canvas
      (source x/y locations should be between 0.25 and 0.75 of width/height)
      and modify the code to appropriately handle multiple sources
   (2) extinguish a light if a bot hits it (to simulate a bot breaking the light bulb);
       you will need to implement some simple form of collision detection
   (3) after implementing (2), add a RESET capability and keyboard control (r: reset) to 
       reset/reposition the light sources and bots
 */

boolean paused = false;
boolean showTrails = false;

PGraphics trails;

ArrayList<Light> bulbs;

ArrayList<Bot> bots;

// number of each type of bot
int[] numBots = {
  4, 4, 4, 4
};


void setup() {
  size(600, 400);
  trails = createGraphics(width, height);
  clear_trails();

  // create single light bulb in center
  //Light bulb = new Light(width/2, height/2, 10.0);
  bulbs = new ArrayList<Light>();
  //bulbs.add(bulb);
  for (int i=0; i < 4; i++) {
      bulbs.add(new Light(random(width/4,3*width/4),random(height/4,3*height/4),10.0));
  }

  // create bots
  bots = new ArrayList<Bot>();
  int numTypes = numBots.length;
  for (int itype = 0; itype < numTypes; itype++) {
    for (int i=0; i < numBots[itype]; i++) {
      bots.add(new Bot(itype));
    }
  }
}

void draw() {

  // trails
  if (showTrails) {
    image(trails, 0, 0);
  } else {
    background(0);
  }

  // bots
  for (Bot b : bots) {
    // display
    b.display();
    leave_trail(b);

    //update
    b.update();
    wrap_edges(b);
  }

  // light bulb
  ArrayList<Integer> bList = new ArrayList<Integer>();
  int idx = 0;
  for (Light l : bulbs) {
    l.display();
    for (Bot b : bots) {
      if (pow(b.x-l.x,2)+pow(b.y-l.y,2)<500) {
        bList.add(idx);
        break;
      }
    }
    idx++;
  }
  for (int i = bList.size()-1; i >= 0; i--){
    bulbs.remove(bList.get(i)+0);
  }

  // instructions
  show_instructions();
}

void clear_trails() {
  trails.beginDraw();
  trails.background(0);
  trails.endDraw();
}

void leave_trail(Bot b) {
  trails.beginDraw();
  trails.stroke(b.cfill);
  trails.point(b.x, b.y);
  trails.endDraw();
}

void show_instructions() {
  fill(200);
  text("e: erase trails", 5, 15);
  text("p: pause (toggle)", 5, 30); 
  text("t: trails (toggle)", 5, 45);
  text("r: reset", 5, 60);

  if (paused) {
    pushStyle();
    fill(200);
    textSize(26);
    textAlign(CENTER);
    text("PAUSED", width/2, height/2);
    popStyle();
    noLoop();
  }
}

void wrap_edges(Bot b) {
  if(b.x < -b.major) b.x = width + b.major;
  if(b.x > width + b.major) b.x = -b.major;
  if(b.y < -b.major) b.y = height + b.major;
  if(b.y > height + b.major) b.y = -b.major;
}

void keyPressed() {
  switch(key) {
  case 'e':
    clear_trails();
    break;
  case 'p':
    paused = !paused;
    if (!paused) loop();
    break;
  case 't':
    showTrails = !showTrails;
    break;
  case 'r':
    for (Bot b : bots) {
      b.x = random(width);
      b.y = random(height);;
    }
    for (int i = bulbs.size()-1; i >= 0; i--){
      bulbs.remove(i+0);
    }
    for (int i=0; i < 4; i++) {
      bulbs.add(new Light(random(width/4,3*width/4),random(height/4,3*height/4),10.0));
    }
  }
}

void mouseClicked() {
  if (mouseButton == LEFT) bulbs.add(new Light(mouseX, mouseY, 10.0));
  //else if (mouseButton == RIGHT)
}
