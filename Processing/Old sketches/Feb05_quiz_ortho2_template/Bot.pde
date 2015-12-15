class Bot {
  float x, y;
  float speed, heading;
  float major, minor;
  color cfill;
  int type;

  Bot(int itype) {
    x = random(width);
    y = random(height);
    heading = random(TWO_PI);
    speed = 1.0;
    major = 20;
    minor = 10;
    cfill = itype == 1? color(50, 50, 250):color(250, 50, 50);
    type = itype;
  }

  void display() {
    pushMatrix();
    translate(x, y);
    rotate(heading);
    fill(cfill);
    ellipse(0, 0, major, minor);
    popMatrix();
  }

  void update(boolean mode) {
    heading += 0.1*randomGaussian();
      if (mode == true){
        if (type == 1){
            speed = temperature.getVal(x,y);
            speed = speed < temperature.tmin+0.15 ? 0.0:2*log(1+speed);
          //speed = temperature.getVal(x,y) < 0.2 ? 0.0:1.0;
        }
        else{  //type == 0
            speed = temperature.getVal(x,y);
            speed = speed > temperature.tmax-0.15 ? 0.0:2*log(1+speed);
          //speed = temperature.getVal(x,y) > 0.6 ? 0.0:1.0;
        }
      }
      else {
        speed = 2*noise(dt);
      }
    x += speed * cos(heading);
    y += speed * sin(heading);
  }
}

