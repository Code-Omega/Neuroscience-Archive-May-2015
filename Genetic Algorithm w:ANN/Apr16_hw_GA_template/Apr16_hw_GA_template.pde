/* 
  Apr 16 Homework
  Genetic Algorithms, Evolving a Foraging Controller
  
  Main goal:
  Modify the controller algorithm in the Bot class to compute speed and turnAngle 
  using a combination of gene parameter values and sensor values. 
  
  Try to code it in a general way and let the GA find the best solution to optimize performance. 
  You may need to adjust the number of genes, population size, mutation rate, etc.
  
  The basic version has two types of pellets:
  green pellets = good, value = +1
  red pellets = bad, value = -1
  Your bot should collect the green pellets and avoid the bad
  
  Genes are floating point values between 0.0 and 1.0
  
  There are 4 sensor values:
    bearingNG  = relative bearing (angle) to nearest GREEN pellet (NG = Nearest Green)
    strengthNG = signal strength from nearest green (roughly inversely proportional to distance)
    bearingNR  = relative bearing (angle) to nearest RED pellet (NR = Nearest Red)
    strengthNR = signal strength from nearest red (roughly inversely proportional to distance)
  
  The bot has a SNS_RANGE of 100 pixels, if the nearest red or green pellet is further away the
  corresponding sensor values list eabove will return 0.0.
    
  Advanced goals:
    make the scenario and the controller more complicated and re-evolve a solution using the GA
    possible ideas: add a third pellet color, choose pellet values from a probability distribution, 
    allow pellets to move, use a neural network controller and evolve the connection weights, etc.   
*/

int world_width = 600;
int world_height = 400;
int popSize = 500;
int numPellets = 30;
float mutationRate = 0.10;
float crossoverProb = 0.80;
int TMAX = 1000; 

Bot[] bots = new Bot[popSize]; 
Bot[] children = new Bot[popSize];
Pellet[][] pellets = new Pellet[popSize][numPellets];

int generation;
float averageFit, bestFit;
int ibest;
int startTime, elapsedTime;

int tsim;

boolean evolveMode = true, terminated = false;

void setup() {

  size(world_width, world_height);
  PFont f = createFont("Courier", 12, true);
  textFont(f);

  startTime = millis();

  // create bots (one per world)
  for (int i = 0; i < popSize; i++) {
    bots[i] = new Bot(i);
  }

  // create pellets (numPellets per world)
  for (int j = 0; j < numPellets; j++) {
    float x = random(width);
    float y = random(height);
    float val = (j%2 == 0) ? -1.0 : 1.0;
    for (int i = 0; i < popSize; i++) {
      pellets[i][j] = new Pellet(x, y, val);
    }
  }

  simulate(); // simulate the performance for one epoch (TMAX ticks)
  calc_stats();
  
}

void draw() {

  background(255);

  if (evolveMode) {
    // TERMINATION CONDITION - YOU MAY WANT TO MODIFY THIS
    if (averageFit > (0.4*numPellets) && !terminated) {
      evolveMode = false;
      terminated = true;
      sim_reset();
    } else {
      create_next_generation();
      simulate();
      calc_stats();
      show_info();
      show_instructions();
    }
  } else {
    // DISPLAY MODE - SHOW BEST BOT BEHAVIOR
    background(200);
    bots[ibest].update();
    for (int j=0; j < numPellets; j++)pellets[ibest][j].display();
    bots[ibest].display();
    show_info();
    show_instructions();
    tsim++;
  }
}


void simulate() {
  sim_reset();
  while (tsim < TMAX) {
    for (int i = 0; i < popSize; i++) bots[i].update();
    tsim++;
  }
}

void sim_reset() {
  tsim = 0;
  for (int i = 0; i < popSize; i++) {
    bots[i].reset();
    for (int j = 0; j < numPellets; j++) pellets[i][j].visible = true;
  }
}



void calc_stats() {
  elapsedTime = millis() - startTime;  // elapsed time in milliseconds
  averageFit = 0.0;
  bestFit = 0.0;
  for (int i = 0; i < popSize; i++) {
    float fit = bots[i].energy;
    bots[i].fitness = fit;
    averageFit += fit;
    if (fit > bestFit) {
      bestFit = fit;
      ibest = i;
    }
  }
  averageFit /= popSize;
}

void show_info() { 
  fill(0, 128);
  float xoff = 20;
  float yoff = 0;
  float dy = 20;
  textSize(12);
  text("tsim:                " + tsim, xoff, yoff+=dy);
  text("bots size:           " + popSize, xoff, yoff+=dy);
  text("mutation rate:       " + nf(mutationRate, 0, 4), xoff, yoff+=dy);
  text("total generations:   " + generation, xoff, yoff+=dy);
  text("total evaluations:   " + generation*popSize, xoff, yoff+=dy);
  text("average fitness:     " + nf(averageFit, 0, 2), xoff, yoff+=dy);
  text("best fitness:        " + nf(bestFit, 0, 2), xoff, yoff+=dy);
  text("elapsed time:        " + nf((float)elapsedTime/1000.0, 0, 2) + "sec", xoff, yoff+=dy);
  textSize(20);
  String s = "";
  for (int i = 0; i < bots[ibest].numGenes; i++) {
    s += nf(bots[ibest].genes[i], 0, 4) + " ";
  }
  text(s, xoff, yoff+=2*dy, 0.9*width, 0.4*height);
}

void show_instructions() {
  fill(0, 128);
  float xoff = 0.6*width;
  float yoff = 0;
  float dy = 20;
  textSize(12);
  text("KEYBOARD CONTROLS", xoff, yoff+=dy);
  text("e:  evolve Mode toggle", xoff, yoff+=dy);
  text("r:  reset sim (display Mode only)", xoff, yoff+=dy);
  text("s:  screendump to file", xoff, yoff+=dy);
}

void keyPressed() {
  if (!evolveMode && key == 'r') {
    sim_reset();
  } else if (key == 'e') {
    evolveMode = !evolveMode;
    if (!evolveMode) {
      sim_reset();
      calc_stats();
    }
  } else if (key == 's') {  // s - save image 
    String fname = "Apr16_hw_" + month() + day() + hour() + minute() + ".png";
    println("Saving screendump to " + fname);
    save(fname);
  }
}

