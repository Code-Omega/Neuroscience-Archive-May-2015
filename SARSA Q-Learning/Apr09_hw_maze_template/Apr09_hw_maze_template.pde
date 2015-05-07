/*
Apr 09 Homework - Reinforcement Learning

This template provide a maze environment for exploring reinforcement learning algorithms.
The bot starts in the lower left corner and needs to learn the path to the goal in the upper right corner.

You will solve this problem using the SARSA algorithm and an epsilon-greedy action policy.

Main Goals:
- correctly implement the SARSA update rule by changing the last line of the Bot.step() method
- implement an epsilon-greedy action-selection policy by modifying the code in Bot.pickAction() method
- pick reasonable starting values for alpha (learning rate), gamma (discount factor), and epsilon (greedy policy)
- what values did you select and why? (RESPOND IN EMAIL)
- with these values, how many trials are required on average to reach a trial reward value of 50? (EMAIL)
- retune your alpha, gamma and epsilon values to see if you can improve performance (EMAIL)

Advanced Goals:
Once your model is working properly, you are encouraged to explore extensions to the model.
This part is open-ended... you can pick ideas from the list below, or design your own extensions.
Summarize the results of any such studies in the EMAIL section.

- develop a strategy to decrease epsilon over time to encourage more exploration in the
  early part of the learning process and more exploitation in the late part of the process;
  develop a metric to quantify the improvement in performance
- implement a 'softmax' action-selection policy and compare it with epsilon-greedy. Again you
  might want to have the softmax temperature parameter change with time (high temperature in the
  beginning to encourage exploration, low temperature at the end to encourage exploitation);
  do softmax and epsilon-greedy have similar performance characteristics in this scenario?
- early in the learning process the bot often 'wastes time' by revisiting empty cells multiple
  times during the same trial; devise a strategy to discourage the bot from revisiting cells that
  it has visited recently
- an epsilon-greedy algorithm will sometimes 're-try' to walk through a previously-encountered wall; 
  assuming that the walls are fixed, a better policy would be to never retry an action that is known 
  to lead to a wall; modify your action-selection policy to implement this feature and compare performance
- what happens if you move the reward to a new location in the maze after the bot has learned the
  expected location? How long does it take to find the new location?  Could performance improve if
  the bot wiped out its old Q values based on some measure of 'surprise' when it repeatedly fails to
  find the reward at the expected location? Try to implement this.
- similarly what happens if some of the walls are moved after learning so that the old path to 
  the reward is blocked, but a new path has become available?  Is it better to wipe out old Q values
  or keep the existing ones?

*/

Maze maze;
Bot bot;

// a trial is completed when the bot reaches the reward
int ntrials;
float last_trial_reward;

int run;
int[] nt;

boolean paused = true, showQ = false, showV = false;
int EAST = 0, SOUTH = 1, WEST = 2, NORTH = 3;

void setup() {
  maze = new Maze();
  size(maze.nx*maze.w, maze.ny*maze.w + 180);
  bot = new Bot();
  
  run = 0;
  nt = new int[10];
  //nt[run] = 10;
}

void draw() {
  if(!paused)bot.step();
  background(0);
  maze.display();
  bot.display();
  text_display();
  
  
}

void reset() {
  /*run = 0;
  nt = new int[10];*/
  
  ntrials = 0;
  last_trial_reward = 0.0;
  bot.reset();
}

void nextTrial() {
  ntrials++;
  last_trial_reward = bot.summed_reward;
  bot.home();
  
  bot.epsilon *= 0.8;
  
  if (last_trial_reward >= 50.0) {
    println("run="+run+" ntrials="+ntrials);
    nt[run] = ntrials;
    reset();
    run++;
    
    bot.epsilon = 0.15;
    
    if (run == 10) paused = true;
  }
}

void text_display() {
  textAlign(LEFT, CENTER);
  textSize(14);
  // Controls
  fill(255, 255, 0);
  int xoff = 15;
  int yoff = 500;
  int dy = 18;
  text("r - RESET", xoff, yoff += dy);
  text("p - PAUSE/RUN", xoff, yoff += dy);
  text("s - SINGLE STEP", xoff, yoff += dy);
  text("q - QVALS (show/hide)", xoff, yoff += dy);
  text("v - VALUES (show/hide)", xoff, yoff += dy);

  // Status info
  fill(255);
  xoff = width/2;
  yoff = 500;
  String[] actions = {"EAST", "SOUTH", "WEST", "NORTH", "NONE"};
  fill(255);
  text("action = " + actions[bot.last_action],     xoff, yoff+=dy);
  text("reward = " + bot.reward,                   xoff, yoff+=dy);
  text("summed_reward = " + bot.summed_reward,     xoff, yoff+=dy);
  text("------------------------",                 xoff, yoff+=dy);
  text("ntrials = " + ntrials,                     xoff, yoff+=dy);
  text("last_trial_reward = " + last_trial_reward, xoff, yoff+=dy);
  
  xoff = -55;
  yoff+=dy;
  int dx = 70;
  float sum = 0;
  for (int i = 0; i < 5 && i < run; i++) {
    text("nt"+(i+1)+" = " + nt[i],             xoff+=dx, yoff);
    sum += nt[i];
  }
  xoff = -55;
  for (int i = 5; i < run; i++) {
    text("nt"+(i+1)+" = " + nt[i],             xoff+=dx, yoff+dy);
    sum += nt[i];
  }
  float average = (run>0)?sum/run:0;
  text("average = "+average,               15, yoff+2*dy);
}

void keyPressed() {
  if (key == 'p' || key == ' ') {
    paused = !paused;
  } else if (key == 'q') {
    showQ = !showQ;
  } else if (key == 'r') {
    reset();
  } else if (key == 's') {
    bot.step();
  } else if (key == 'v') {
    showV = !showV;
  } 
}
