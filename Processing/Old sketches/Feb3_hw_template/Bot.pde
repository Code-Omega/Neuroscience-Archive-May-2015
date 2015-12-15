class Bot {
  // do not change the data fields
  float x, y;
  float speed, heading;
  float major, minor; // bot length and width
  color cfill;
  
  Bot() {
    // do not change the constructor
    x = random(width);
    y = random(height);
    heading = random(TWO_PI);
    speed = 1.0;
    major = 20;
    minor = 10;
    cfill = color(200, 150, 50);
  }
  
  void display() {
    // do not change the display routine
    pushMatrix();
    translate(x, y);
    rotate(heading);
    fill(cfill);
    ellipse(0, 0, major, minor);
    popMatrix();
  }
  
  void update() {
    // ADD YOUR UPDATE CODE HERE
    float thresh = temperature.tmin + 0.2;
    //speed = temperature.getVal(x,y) < thresh ? 0.0 : 1.0;
    speed = temperature.getVal(x,y);
    speed = speed < 0.2 ? 0.0:5*pow(speed,3.2);
    //speed = speed < 0.1 ? 0.0:2*log(1+speed);
    heading += 0.1*randomGaussian();
    x += speed * cos(heading);
    y += speed * sin(heading);
  }
}
