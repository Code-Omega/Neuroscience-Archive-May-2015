/* 
  Feb 3 Homework
  Modify the Bot update() routine so that the bots use an
  orthokinesis strategy to stay in the cold parts of the 
  environment (temperature < temperature.tmin + 0.2);
  
  Bots can access the local temperature using
  float mytemp = temperature.getVal(x, y);
  
  The minimum temperature in the environment is
  temperature.tmin
  
  The minimum temperature in the environment is
  temperature.tmax
  
  
*/

Temperature temperature;
PImage temperature_img;
ArrayList<Bot> bots;

int NBOTS = 50;

void setup() {
  size(600,400);
  bots = new ArrayList<Bot>(NBOTS);
  temperature = new Temperature(0, 0, .02, .005);
  temperature_img = temperature.getImage(0, 0, width, height);
  println(temperature.tmin, temperature.tmax);
  for (int i = 0; i < NBOTS; i++){
    bots.add(new Bot());
  }
}

void draw() {
  image(temperature_img, 0, 0); 
  for (Bot b : bots) {
    b.display();
    b.update();
    wrap_edges(b);
  }
}

void wrap_edges(Bot b) {
  if(b.x < -b.major) b.x = width + b.major;
  if(b.x > width + b.major) b.x = -b.major;
  if(b.y < -b.major) b.y = height + b.major;
  if(b.y > height + b.major) b.y = -b.major;
}
