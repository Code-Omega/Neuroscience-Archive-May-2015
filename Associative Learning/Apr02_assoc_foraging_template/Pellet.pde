class Pellet {
  
  PVector location;
  float r;
  int type;
  
  Pellet() {
    location = new PVector(random(world_width), random(world_height));
    r = 5;
    type = int(floor(random(3)));
  }
  
  float get_value() {
    if (ticks > 2500 && reassign_after_2500) {
      if (type == 2)     return random(-1,7);
      if (type == 0)     return random(-3,5);
      /*if (type == 1)*/ return random(-8,0);
    } // else if (ticks <= 2500)
    if (type == 0)     return random(-1,7);
    if (type == 1)     return random(-3,5);
    /*if (type == 2)*/ return random(-8,0);
      
    //if (ticks <= 2500) {
      /*if (type == 0)     return random(-1,7);
      if (type == 1)     return random(-3,5);
      // if (type == 2)     
      return random(-8,0);*/
      //if (type == 0)     return 3;
      //if (type == 1)     return 1;
      // if (type == 2)     
      //return -4;
      
    //}
    // else if tick > 2500
    /*if (type == 2)     return random(-1,7);
    if (type == 0)     return random(-3,5);
    // if (type == 1)     
    return random(-8,0);*/
    //if (type == 2)     return 3;
    //if (type == 0)     return 1;
    // if (type == 1)     
    //return -4;
    // return random(10.0);
  }
   
  void display() {
    noStroke();
    if (type == 0) fill(250, 50, 50);
    else if (type == 1) fill(50, 250, 50);
    else if (type == 2) fill(50, 50, 250);
    ellipse(location.x, location.y, 2*r, 2*r);
  }
}
