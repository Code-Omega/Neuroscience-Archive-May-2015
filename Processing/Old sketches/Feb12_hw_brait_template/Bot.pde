class Bot {
  
  int itype;  // type of bot (color, behavior)
  float x, y;
  float speed, heading;
  float major, minor;
  color cfill;

  // sensor-motor values
  int LEFT = 0, RIGHT = 1;
  float[] sns;  // sensor values are sns[LEFT] and sns[RIGHT]
  float[] mtr;  // motor values are mtr[LEFT] and mtr[RIGHT]


  Bot(int _itype) {
    itype = _itype;
    x = random(width);
    y = random(height);
    heading = random(TWO_PI);
    speed = 1.0;
    major = random(20, 30);
    minor = random(10, 20);
    sns = new float[2];
    mtr = new float[2];
    cfill = color(128);
    switch (itype) {
      case 0:
        cfill = color(250,50,50);
        break;
      case 1:
        cfill = color(50,250,50);
        break;
      case 2:
        cfill = color(50,50,250);
        break;
      case 3:
        cfill = color(250,50,250);
        break;
    }
  }

  void display() {
    // Braitenberg bugs
    pushMatrix();
    translate(x, y);
    rotate(heading);

    //draw "wheels"
    stroke(150, 200);
    strokeWeight(.3*minor);
    line(-0.2*major, 0.8*minor, 0.1*major, 0.8*minor);
    line(-0.2*major, -0.8*minor, 0.1*major, -0.8*minor);

    // draw axle
    strokeWeight(1);
    line(-0.1*major, 0.8*minor, -0.1*major, -0.8*minor);

    // draw "body"
    fill(cfill);
    ellipse(0, 0, major, minor);

    // draw "sensors"
    fill(150);
    float dia = 0.2 * minor;
    ellipse(major/2, minor/2, dia, dia);
    ellipse(major/2, -minor/2, dia, dia); 
    popMatrix();
  }

  void updateSensors() {
    
    float xsns, ysns;

    float rmajor = major/2.0;
    float rminor = minor/2.0;
    float cosa = cos(heading);
    float sina = sin(heading);

    // Left sensor
    xsns = x + rmajor*cosa + rminor*sina;
    ysns = y + rmajor*sina - rminor*cosa;
    sns[LEFT] = 0;
    for (Light l : bulbs){
      sns[LEFT] += l.getVal(xsns, ysns);
    }

    // Right sensor
    xsns = x + rmajor*cosa - rminor*sina;
    ysns = y + rmajor*sina + rminor*cosa;
    sns[RIGHT] = 0;
    for (Light l : bulbs){
      sns[RIGHT] += l.getVal(xsns, ysns);
    }

  }

  void update() {

    updateSensors();

    /* 
       Implement Braitenberg vehicle wiring patterns
       - connect sensor to motors
       - sensor values are sns[LEFT] and sns[RIGHT]
       - motor values are mtr[LEFT] and mtr[RIGHT]
       - general form of relationship: mtr[L/R] = A +- B * sns[L/R]
       - L/R connections will be crossed or uncrossed, depending on vehicle type
       - for each vehicle type, adjust offsets (A) and gains (B) to get desired behavior
    */
    float mag = 50;
    switch(itype) {
    case 0:  // Aggressive 
      //mtr[LEFT] = 1.0;
      //mtr[RIGHT] = random(0.9, 1.1);
      mtr[LEFT] = 1+mag*sns[RIGHT];
      mtr[RIGHT] = 1+mag*speed*sns[LEFT];
      break;
    case 1:  // Coward
      //mtr[LEFT] = 2.0;
      //mtr[RIGHT] = 0.0;
      mtr[LEFT] = 1+mag*sns[LEFT];
      mtr[RIGHT] = 1+mag*sns[RIGHT];
      break;
    case 2:  // Love
      //mtr[LEFT] = 0.0;
      //mtr[RIGHT] = 1.0;
      mtr[LEFT] = 1-mag*sns[LEFT];
      mtr[RIGHT] = 1-mag*sns[RIGHT];
      break;
    case 3:  // Explorer
      //mtr[LEFT] = randomGaussian();
      //mtr[RIGHT] = randomGaussian();
      mtr[LEFT] = 1-mag*sns[RIGHT];
      mtr[RIGHT] = 1-mag*sns[LEFT];
      break;
    default: // spin slowly
      mtr[LEFT] = -0.1;
      mtr[RIGHT] = 0.1;
      break;
    }

    // convert motor commands to speed and heading
    // DON'T CHANGE THIS
    speed = constrain((mtr[LEFT] + mtr[RIGHT])/2.0, -5.0, 5.0);
    heading += constrain((mtr[LEFT] - mtr[RIGHT])/minor, -0.1, 0.1);
    x += speed * cos(heading);
    y += speed * sin(heading);
  }
}

