class Bot {
  
  float x, y, speed, heading;
  float major, minor;
  // add other variables ?
  color cfill, cstroke;
  float avg_odor;
  int type;
  
  // need to expand constructor and update methods
  
  Bot(int itype){ // 1 ->orthokinesis, 0 ->klinokinesis
    x = random(width);
    y = random(height);
    speed = 2;
    heading = random(TWO_PI);
    major = 10;
    minor = 5;
    cfill = itype == 1 ? color(50,150,200):color(200,150,50);
    cstroke = itype == 1 ? color(25,100,100):color(100,100,25);
    avg_odor = odor.getVal(x,y);
    type = itype;
  }
  
  void update(){
    if (type == 1){
      float thresh = up_thresh - 0.1;
      speed = odor.getVal(x,y) > thresh ? 0.0 : log(8-odor.getVal(x,y));
      heading += 0.1*randomGaussian();
      x += speed * cos(heading);
      y += speed * sin(heading);
    }
    else { // type == 0
      // the following code changes the rate as if one time itervel takes place every frame
      avg_odor = 0.9*avg_odor + 0.1*odor.getVal(x,y);
      boolean gradient = odor.getVal(x,y)>avg_odor;
      //if ((dt+random(0,300))%1000 < 600){ 
      if (!gradient) { // clockwise, more tumbling, less directional swimming
        if (random(0.0,1.0)<0.5) heading += 0.1*random(0,7);
        else {
          x += speed * cos(heading);
          y += speed * sin(heading);
        }
      }
      else { // counter clockwise, less tumbling, more directional swimming
        if (random(0.0,1.0)>0.9) heading -= 0.1*random(0,3);
        else {
          x += speed * cos(heading);
          y += speed * sin(heading);
        }
      }
      /* The following code changes the rate as if more than one time intervel takes place
         in one frame
      if (!gradient) heading += 0.1*random(0,7); // clockwise, more tumbling
      else heading -= 0.1*random(0,3); // counter clockwise, less tumbling
      avg_odor = 0.9*avg_odor + 0.1*odor.getVal(x,y);
      // more directional swimming facing concentraction gradient
      speed = odor.getVal(x,y)>avg_odor?5.0:1.0;
      x += speed * cos(heading);
      y += speed * sin(heading);
      //heading += 0.1; // clockwise spin in place
      */
    }
  }

  void display(){
    pushMatrix();
    translate(x, y);
    rotate(heading);
    stroke(cstroke);
    fill(cfill);
    ellipse(0,0, major, minor);
    popMatrix();
  }
}
