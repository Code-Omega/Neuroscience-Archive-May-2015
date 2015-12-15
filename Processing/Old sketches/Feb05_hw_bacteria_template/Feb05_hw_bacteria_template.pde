/* 
 Feb 5 Homework
 
 Main Goal:
 
 1) Create a population of 20 bacteria-like bots that use
 adaptive klinokinesis to implement a RUN-TUMBLE strategy
 to move toward the peak of a Gaussian odor gradient.
 
 (done)
 
 2) Add mouse functionality so that clicking the mouse 
 randomly redistributes the bots across the environment. 
 
 (done)
 
 Advanced goals:
 
 3) Add a display in the upper left corner that shows the average
 odor concentration of the bots in real time.
 
 (done) It can be moved to the right corner so that it doesn't cover part 
 of the visible odor gradient.
 
 
 4) Modify the Odor.getVal(x,y) method so that it adds
 a small amount of uniform random noise to the return value.
 Change the last line to "return exp(-num/denom) + random(-0.03, 0.03)"
 Now rerun the simulation and observe the behavior in the presense of
 noise.  Recode and reoptimize the run-tumble strategy to improve 
 performance in this new environment.
 
 (done) bugs in the new environment tend to converge up the odor gradient
 slower because of the noise.(Essencially, they can get trapped where the 
 gradient is not more significant than the noise.) By putting more weight 
 on the previous average they tend to diverge (tumble and move in the wrong 
 direction) less, and accelerating directional movement also give them more 
 opportunity to run into part of the gradient where the noise is not as 
 significant, thus making them converge faster, while losting some accuracy, 
 hence resulting in slightly less average after they all converge.
 
 5) Create two populations of bots, one using orthokinesis and one using 
 run-tumble behavior to reach the peak; compare performance. 
 
 (done) the ones using orthokinesis perform relatively poorly as their 
 turning rates are not affected by the stimulus, resulting in more wandering 
 and slower convergence.
 
 6) Modify the code so that you can use a keyboard command to switch between
 a Gaussian odor distribution and a 2D Perlin-noise distribution (like the
 Temperature map in the last homework).  How do orthokinesis and run-tumble
 strategies perform in the two different environments?
 
 Orthokinesis perform better in the 2D Perlin-noise distribution as the 
 gradient is much more diverse, hence providing more possibility for random 
 movements to lead the bugs to the desired odor level. Run-tumble (adaptive 
 klinokinesis) tend to lead the bugs to wander around the high odor area, or 
 even getting trapped in areas surrounded by low odor areas, preventing them
 from reaching the higher odor concentraction areas, resulting in a lower 
 average, whereas orthokinesis lets, and only lets the bugs stop at the spots 
 with the desired odor, resulting in a relatively higher average (odor).
 
*/

Odor odor;
PImage odor_image;
PImage odor_image_noise;
ArrayList<Bot> bots;
int numBots = 20;
int dt;
boolean map;
float up_thresh;
float avgOrtho, avgKlino;
float stAvgOrt, stAvgKli;

void setup() {
  size(600, 400);
  map = true;
  odor = new Odor(width/3, height/2, 70, 0.02, 0.01);  // x, y, peak, sigma
  odor_image = odor.getImage();
  odor_image_noise = odor.getNoiseImage(); 
  bots = new ArrayList<Bot>();
  for (int i=0; i < 20; i++) {
    bots.add(new Bot(0));
    bots.add(new Bot(1));
  }
  dt = millis();
  map = true;
  up_thresh = 0;
  avgOrtho = avgKlino = 0;
} 

void draw() {
  if (map){
    image(odor_image, 0, 0);
    up_thresh = odor.omax;
  }
  else{
    image(odor_image_noise, 0, 0);
    up_thresh = odor.omax_noise;
  }
  //image(odor_image, 0, 0);
  dt = millis();
  
  // update bots
  avgOrtho = avgKlino = 0;
  for (Bot b : bots) {
    b.display();
    b.update();
    wrap_edges(b);
    if (b.type == 1)
      avgOrtho += odor.getVal(b.x,b.y);
    else // b.type = 0
      avgKlino += odor.getVal(b.x,b.y);
  }

  // display text
  fill(200, 200, 50);
  textAlign(CENTER, TOP);
  text("BACTERIAL CHEMOTAXIS - RUN/TUMBLE STRATEGY", width/2, 5);
  fill(128);
  text("Click mouse to randomly redistribute bugs", width/2, 20);
  
  // display average odor
  avgOrtho /= 20;
  avgKlino /= 20;
  stAvgOrt = stAvgOrt*0.99 + 0.01*avgOrtho;
  stAvgKli = stAvgKli*0.99 + 0.01*avgKlino;
  info();
}

void wrap_edges(Bot b) {
  if (b.x < -b.major) b.x = width + b.major;
  if (b.x > width + b.major) b.x = -b.major;
  if (b.y < -b.major) b.y = height + b.major;
  if (b.y > height + b.major) b.y = -b.major;
}

void mouseClicked() {
  // randomly redistribute bugs
  //if (mouseButton == LEFT)
  //else if (mouseButton == RIGHT)
  for (Bot b : bots) {
    b.x = random(width);
    b.y = random(height);;
  }
}

void keyPressed() {
  if (key == ' ') {
    map = !map;
  }
}
 
void info(){
  int left_corner = 140;
  //int right_corner = width;
  textAlign(LEFT);
  fill(200,200,200);
  rect(140-140, 0, 140, 100);
  fill(65,55,55);
  String s = "AVG ODOR\n";
  text(s, left_corner-100, 5, 80, 30);
  String s1 = "Real Time/100 Frames\n";
  text(s1, left_corner-135, 20, 150, 30);
  
  fill(50,150,200);
  String r1 = "Orthokinesis: \n";
  String r2 = nf(avgOrtho,1,2);
  String r3 = nf(stAvgOrt,1,2);
  text(r1+r2+"     "+r3, left_corner-105, 37, 120, 30);
  
  fill(200,150,50);
  String b1 = "Klinokinesis: \n";
  String b2 = nf(avgKlino,1,2);
  String b3 = nf(stAvgKli,1,2);
  text(b1+b2+"     "+b3, left_corner-105, 67, 120, 30);
}
