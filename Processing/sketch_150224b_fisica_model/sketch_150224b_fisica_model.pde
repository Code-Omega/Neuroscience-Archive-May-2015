import fisica.*;

FWorld world;
FCircle bot;
void setup() {
  size(400,400);
  Fisica.init(this);
  world = new FWorld();
  world.setEdges();
  world.setGravity(0.0,200.0);
  bot = new FCircle(25);
  bot.setPosition(width/2,height/2);
  bot.setFill(250,50,50);
  bot.setNoStroke();
  bot.setRestitution(0.6);
  bot.setDamping(3.0);
  world.add(bot);
  
  FBox slide = new FBox(100,10);
  slide.setPosition(width/2, .75*height);
  slide.setRotation(2);
  slide.setStatic(true);
  world.add(slide);
}

void draw() {
  background(255);
  
  fill(128);
  text(frameCount/60.0,10,20);
  // apply forces
  //if(frameCount < 60)
  //  bot.addForce(100.0, 0.0);
  world.step();
  world.draw();
  
}
