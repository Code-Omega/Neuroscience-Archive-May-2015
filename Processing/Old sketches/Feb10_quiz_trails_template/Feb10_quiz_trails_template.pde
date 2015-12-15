/* 
  Feb 10 Quiz
  
  Main Goal
  Create two populations of bots: 
  
    6 red bots that circle counter-clockwise in perfect circular
    trajectories with a speed of 1.0 pixels/frame and a 
    trajectory radius of approx 25 pixels.
    
    4 green bots that circle clockwise in noisy circular 
    trajectoreis with a speed of 1.0 pixels/frame, a mean 
    trajectory radius of approx. 50 pixels and with additive
    Gaussian random variation in heading with a per-tick
    standard of deviation of 0.01; 
  
  Advanced goal
    Add more populations with other interesting trajectories
    (squares, triangles, figure-eights, spirals, etc.)
  
*/

boolean paused = false;

PGraphics trails;

ArrayList<Bot> bots;
//int[] numBots = {6, 4, 5, 3, 4};
int[] numBots = {5};

void setup() {
  size(600,400);
  trails = createGraphics(width, height);
  clear_trails();
  bots = new ArrayList<Bot>();
  int numTypes = numBots.length;
  for (int itype = 0 ; itype < numTypes; itype++) {
      for (int i=0; i < numBots[itype];  i++) {
        bots.add(new Bot(itype));
      }
  }
}

void draw() {
  image(trails, 0, 0);
  fill(0);
  text("e: erase trails", 5, 15);
  text("p: pause (toggle)", 5, 30); 
  
  for (Bot b : bots) {
    // display
    b.display();
    leave_trail(b);
    
    //update
    b.update();
    wrap_edges(b);
  }
  
  if (paused) {
    pushStyle();
    fill(0);
    textSize(26);
    textAlign(CENTER);
    text("PAUSED", width/2, height/2);
    popStyle();
    noLoop();
  }
}

void clear_trails() {
  trails.beginDraw();
  trails.background(230);
  trails.endDraw();
}

void leave_trail(Bot b) {
  trails.beginDraw();
  trails.stroke(b.cfill);
  trails.point(b.x, b.y);
  trails.endDraw();
}

void wrap_edges(Bot b) {
  if(b.x < -b.major) b.x = width + b.major;
  if(b.x > width + b.major) b.x = -b.major;
  if(b.y < -b.major) b.y = height + b.major;
  if(b.y > height + b.major) b.y = -b.major;
}

void keyPressed() {
  if (key == 'e'){
    clear_trails();
  }
  if (key == 'p') {
    paused = !paused;
    if(!paused) loop();
  }
}
