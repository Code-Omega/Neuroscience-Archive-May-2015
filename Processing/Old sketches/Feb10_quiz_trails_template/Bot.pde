class Bot {
  int itype;  // type of bot (color, behavior)
  float x, y;
  float speed, heading;
  float major, minor;
  color cfill;

  Bot(int _itype) {
    itype = _itype;
    x = random(width);
    y = random(height);
    heading = random(TWO_PI);
    speed = 1.0;
    major = 20;
    minor = 10;
    cfill = color(random(255), random(255), random(255));
  }

  void display() {
    pushMatrix();
    translate(x, y);
    rotate(heading);
    fill(cfill);
    ellipse(0, 0, major, minor);
    popMatrix();
  }

  void update() {
    speed = 1.0;
    heading += random(-0.1, 0.1); //wander
    x += speed * cos(heading);
    y += speed * sin(heading);
  }
}

