/* 
 Apr 02 Associative Learning 
 
 This template is a slightly modified version of the Feb 19th quiz
 that used Reynold's SEEK strategy for foraging.
 
 This is only a suggested starting point... 
 you will need to make major modifications to the code, including
 the Bot class, the Pellet class, and the graphical user interface. 
 
 In this assignment, you will create an associative learning task in which
 a single bot forages for RED, GREEN and BLUE pellets. The different colors 
 will have different reward values.  Your bot needs to learn the expected
 value of the different colors, and implement an efficient foraging strategy
 using that information.
 
 When consumed, pellets should return a randomly generated reward value as follows:
 - the BEST color should return values ranging uniformly between -1 and 7 (expected value 3).
 - the MEDIUM color should return values ranging between -3 and 5 (expected value 1).
 - the WORST color should return values ranging between -8 and 0 (expected value -4).
 
 Initially you should assign (RED/GREEN/BLUE) to (BEST/MEDIUM/WORST) respectively, 
 but do not make use of this fact in designing your controller code.
 
 The simulation should start with zero pellets. 
 
 On each tick (frame update), the probability for creating a new pellet should be 0.020, 
 unless the number of existing pellets has already reached MAX_PELLETS (20). 
 
 When a new pellet is created, it should be randomly assigned to one of the 3 categories 
 (BEST/MEDIUM/WORST) and given the appropriate color.
 
 On each tick, the probability for an existing pellet to 'disappear' should be 0.002.
 
 Main Goals
 - using the delta rule, COMPUTE and DISPLAY expected reward values based on experience
 - what value of the learning rate did you find most useful (RESPOND IN EMAIL MESSAGE)
 - run for 5000 ticks; how did the estimated values compare to the true means? (EMAIL)
 - based on expected values, devise a foraging strategy to maximize energy gain
 - describe how your foraging strategy uses expected reward values (EMAIL)
 - run for 5000 ticks; how much energy did your bot collect; run multiple trials (EMAIL)
 
 Advanced Goals
 - reassign categories after 2500 ticks: change (BEST/MEDIUM/WORST) to (B/R/G), instead of (R/G/B)
 - if necessary, readjust your foraging strategy to optimize performance (DO NOT USE THE SWITCHING TIME IN YOUR BOT CODE)
 - describe how your strategy balances the exploration/exploitation tradeoff (EMAIL)
 - run for 5000 ticks (2500 with the first color assignment, and 2500 with the color second assignment) and
   report how much energy your bot collected; run multiple trials (EMAIL)
 - how does the performance compare to the original case where the categories stayed fixed? (EMAIL)
 - OPTIONAL: implement a more complete GUI, similar to the bee_choice example shown in class
 
 GENERAL:
 Only use information that would be available to the bot; do not use 
 observer-level or programmer-level knowledge to solve the task.
 Your bot should have a max_speed of 1.0 and a max_accel of 0.1.

 */
 
Bot bot;
ArrayList<Pellet> pellets;

int world_width = 400;
int world_height = 400;

int MAX_PELLETS = 20;
float prob_create = 0.020;
float prob_delete = 0.002;

int ticks = 0;
int max_ticks = 5000;

float epsilon;
float beta;

int tx, ry, gy, by, ey;

boolean pause, reassign_after_2500, avoid;

void setup() {
  size(world_width + 200, world_height+300);  // add extra width and height for GUI
  bot = new Bot();
  pellets = new ArrayList<Pellet>();
  for (int i=0; i<MAX_PELLETS; i++) pellets.add(new Pellet());
  add_gui();
  
  cp5.getController("epsilon").setValue(0.5); 
  cp5.getController("beta").setValue(0.1); 
  
  // GUI panel
  background(50, 70, 90);
  fill(128, 128);
  noStroke();
  rect(world_width, 0, width - world_width, height);
  rect(0, world_height, world_width, height- world_height);
  
  stroke(0);
  fill(0);
  rect(25, 425, 550, 250);
  stroke(150);
  line(50, 530, 550, 530);
  line(50, 450, 50, 650);
  fill(150,200,200);
  text("expected reward (r,g,b) / ticks", 35, 442);
  text("energy (white) / ticks", 445, 442);
  text("0", 37, 535);
  text("80", 555, 535);
  text("0", 46, 665);
  text("R>G>B", 150, 665);
  text("B>R>G (if reassign)", 371, 665);
  
  line(50, 650, 550, 650);
  line(300, 645, 300, 650);
  text("2500", 285, 665);
  line(550, 450, 550, 650);
  text("5000", 535, 665);
  
  stroke(100);
  line(50, 470, 550, 470); // 3
  text("3", 37, 475);
  line(50, 510, 550, 510); // 1
  text("1", 37, 515);
  line(50, 610, 550, 610); // -4
  text("-4", 30, 615);
  text("0", 555, 615);
  
  tx = 50;
  ry = gy = by = 530;
  ey = 610;
  reassign_after_2500 = avoid = false;
}

void draw() {
  // display
  //background(50, 70, 90);
  stroke(50, 70, 90);
  fill(50, 70, 90);
  rect(0, 0, width, world_height);

  // GUI panel
  fill(128, 128);
  noStroke();
  rect(world_width, 0, width - world_width, height-300);
  
  // time display
  fill(255);
  text("ticks = " + ticks, 420, 15);


  // draw pellets
  for (Pellet p : pellets) {
    p.display();
  }

  // draw bot
  bot.display();
  
  if (pause) {
    pushStyle();
    fill(200);
    textAlign(CENTER);
    textSize(26);
    text("paused", world_width/2, world_height/2);
    popStyle();
  } else {

    ticks++;

    // update bot
    bot.update();
    confine(bot);

    // pellet consumption
    for (int i = pellets.size ()-1; i>=0; i--) {
      Pellet p = pellets.get(i);
      // check for collision
      float d = bot.location.dist(p.location);
      if (d < bot.r + p.r) {
        bot.reward = p.get_value();
        bot.energy += bot.reward;
        bot.pelletType = p.type;
        pellets.remove(i);
        // update expectation and next pellet choice
        update_expectation();
        float selector = random(1.0);
        bot.chosen_type = (selector < bot.prob_red) ? 0 : ((selector-bot.prob_red < bot.prob_green) ? 1 : 2);
      }
      
     // update pellets
     /*if ((random(0,1) < prob_create) && (pellets.size() < MAX_PELLETS)) pellets.add(new Pellet());
     else if ((random(0,1) < prob_delete) && (pellets.size() > 0)) pellets.remove(0);*/
     
     // update graph
     /*if (ticks % 10 == 0) {
       stroke(250,50,50);
       line(tx, ry, 50+ticks/10, 530-20*bot.expected_red);
       stroke(50,250,50);
       line(tx, gy, 50+ticks/10, 530-20*bot.expected_green);
       stroke(50,50,250);
       line(tx, by, 50+ticks/10, 530-20*bot.expected_blue);
       stroke(250,250,250);
       line(tx, ey, 50+ticks/10, 610-1*bot.energy);
       tx = 50+ticks/10;
       ry = round(530-20*bot.expected_red);
       gy = round(530-20*bot.expected_green);
       by = round(530-20*bot.expected_blue);
       ey = round(610-1*bot.energy);
     }
     fill(89, 99, 109);
     stroke(89, 99, 109);
     rect(0, world_height, width, 24);
     rect(world_width, 0, 20, world_height+24);*/
    }
    
    if ((random(0,1) < prob_create) && (pellets.size() < MAX_PELLETS)) pellets.add(new Pellet());
    if ((random(0,1) < prob_delete) && (pellets.size() > 0)) pellets.remove(0);
    
    if (ticks % 10 == 0) {
      stroke(250,50,50);
      line(tx, ry, 50+ticks/10, 530-20*bot.expected_red);
      stroke(50,250,50);
      line(tx, gy, 50+ticks/10, 530-20*bot.expected_green);
      stroke(50,50,250);
      line(tx, by, 50+ticks/10, 530-20*bot.expected_blue);
      stroke(250,250,250);
      line(tx, ey, 50+ticks/10, 610-1*bot.energy);
      tx = 50+ticks/10;
      ry = round(530-20*bot.expected_red);
      gy = round(530-20*bot.expected_green);
      by = round(530-20*bot.expected_blue);
      ey = round(610-1*bot.energy);
    }
    fill(89, 99, 109);
    stroke(89, 99, 109);
    rect(0, world_height, width, 24);
    rect(world_width, 0, 20, world_height+24);
  }

  // pause when ticks = max_ticks
  if (ticks == max_ticks) {
    pause = true;
  }
}

void confine(Bot b) {
  float r = b.r;
  if (b.location.x < r) b.location.x = r;
  if (b.location.x > world_width - r) b.location.x = world_width - r;
  if (b.location.y < r) b.location.y = r;
  if (b.location.y > world_height - r) b.location.y = world_height - r;
}

void keyPressed() {
  if (key == 'p' || key == ' ') {
    pause = !pause;
    if (!pause) loop();
  }
  if (key=='r') {
    reset();
  }
}

void reset() {

  ticks = 0;

  // reset the pellets
  pellets = new ArrayList<Pellet>();
  for (int i=0; i<MAX_PELLETS; i++) pellets.add(new Pellet());

  // reset bot energy
  bot.energy = 0.0;
  bot.expected_red = bot.expected_green = bot.expected_blue = 0.0;
  bot.prob_red = bot.prob_green = bot.prob_blue = 1.0/3.0;
  
  stroke(0);
  fill(0);
  rect(25, 425, 550, 250);
  stroke(150);
  line(50, 530, 550, 530);
  line(50, 450, 50, 650);
  fill(150,200,200);
  text("expected reward (r,g,b) / ticks", 35, 442);
  text("energy (white) / ticks", 445, 442);
  text("0", 37, 535);
  text("80", 555, 535);
  text("0", 46, 665);
  text("R>G>B", 150, 665);
  text("B>R>G (if reassign)", 371, 665);
  
  line(50, 650, 550, 650);
  line(300, 645, 300, 650);
  text("2500", 285, 665);
  line(550, 450, 550, 650);
  text("5000", 535, 665);
  
  stroke(100);
  line(50, 470, 550, 470); // 3
  text("3", 37, 475);
  line(50, 510, 550, 510); // 1
  text("1", 37, 515);
  line(50, 610, 550, 610); // -4
  text("-4", 30, 615);
  text("0", 555, 615);
  
  tx = 50;
  ry = gy = by = 530;
  ey = 610;
}

void update_expectation() {
  bot.updateExpect();
  cp5.getController("expected_red").setValue(bot.expected_red); 
  cp5.getController("expected_green").setValue(bot.expected_green); 
  cp5.getController("expected_blue").setValue(bot.expected_blue); 
  cp5.getController("prob_red").setValue(bot.prob_red < 0.01 ? 0 : bot.prob_red); 
  cp5.getController("prob_green").setValue(bot.prob_green < 0.01 ? 0 : bot.prob_green); 
  cp5.getController("prob_blue").setValue(bot.prob_blue < 0.01 ? 0 : bot.prob_blue); 
  //disp_prob_blue.setText("prob_blue = " + nf(bot.prob_blue,0,4));
}
