/* 
  Feb 5 Quiz
  
  Main Goal: 
  Create two populations of bots: 
    20 red bots that use orthokinesis and prefer warmer areas
    15 blue bots that use orthokinesis and prefer colder areas
  
  Advanced goal:
  Calculate and display in real-time:
   - the average temperature of the red bots and
   - the average temperature of the blue bots
  Display the values in the upper left corner of the screen
  in a way that makes the numbers easy to read.
  
  Advanced goal:
  Change the behavior so that the bots alternate between
  random wandering for 10 seconds, and then doing orthokinesis
  to hot or cold for 10 seconds.
  
*/

Temperature temperature;
PImage temperature_img;
ArrayList<Bot> bots;
float avgHigh, avgLow;
int dt;
boolean m;


void setup() {
  size(600,400);
  temperature = new Temperature(0, 0, .02, .005);
  temperature_img = temperature.getImage(0, 0, width, height);
  bots = new ArrayList<Bot>(20);
  for (int i = 0; i < 10; i++){
    bots.add(new Bot(0));
    bots.add(new Bot(1));
  }
  dt = 0;
  m = true;
}

void draw() {
  image(temperature_img, 0, 0); 
  avgHigh = avgLow = 0;
      if (dt-1000 > 0){
        dt-=1000;
        m = !m;
      }
      else {
        dt++;
      }
  for (Bot b : bots){
    b.display();
    b.update(m);
    wrap_edges(b);
    if (b.type == 1)
      avgHigh += temperature.getVal(b.x,b.y);
    else // b.type = 0
      avgLow += temperature.getVal(b.x,b.y);
  }
  avgHigh /= 10;
  avgLow /= 10;
  info();
}


void wrap_edges(Bot b) {
  if(b.x < -b.major) b.x = width + b.major;
  if(b.x > width + b.major) b.x = -b.major;
  if(b.y < -b.major) b.y = height + b.major;
  if(b.y > height + b.major) b.y = -b.major;
}

void info(){
  fill(200,200,200);
  rect(0, 0, 90, 70);
  String s = "ABG TEMP\n";
  fill(250,50,50);
  String r1 = "RED: ";
  String r2 = nf(avgHigh,1,2);
  String r3 = "\n";
  fill(50,50,250);
  String b1 = "BLUE: ";
  String b2 = nf(avgLow,1,2);
  fill(65,55,55);
  text(s+r1+r2+r3+b1+b2, 5, 5, 200, 60);
}
