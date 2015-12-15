class Bot {

  FCircle body;
  color   cfill;
  float   energy;
  PVector nearest_pellet_location;
  PVector target_location;
  float   max_torque = 10.0;
  float   max_thrust = 200.0;
  
  float   wall_delay = 0;
  float   wall_encounter = 0;
  float   invisible_got = 0;
  float   frameinit = 0.0;
  float   old_energy = 0.0;
  float   fetch_direction = 1.0;

  Bot() {
    // initialization
    cfill = color(200, 150, 50);
    energy = 0.0;
    nearest_pellet_location = new PVector(0.0, 0.0); 
    target_location = new PVector(0.0, 0.0); 

    // body
    body = new FCircle(25);
    body.setPosition(width/2, 50);
    body.setRotation(random(TWO_PI));
    body.setFillColor(cfill);
    body.setDamping(3.0);
    body.setAngularDamping(10.0);
    body.setName("bot");
    world.add(body);
  }

  void update() {
    do_consumption();
    update_nearest_pellet_location(); 
    /*if (wall_encounter > 0) wall_encounter-=6;
    text(wall_encounter, body.getX()-20, body.getY() -20);
    text(wall_delay, body.getX()-20, body.getY() -50);
    if (wall_delay > 0){
      follow_wall();
    }*/
    text(old_energy, body.getX(), body.getY() -20);
    if (body.getContacts().size()>0 && ((FBody)body.getTouching().get(0)).getName() == "wall"){
          //wall_encounter += 2;
      fill(250,10,10);
      //text("!", body.getX(), body.getY() -20);
      avoid_wall();
      fetch_direction *= -1.0;
    }
    else if (( energy-5*invisible_got >= 30 || (invisible_got % 4 != 0) || (energy == old_energy+5)) && (invisible_got != 12)) {
      fetch_invisible(); 
    }
    else if (nearest_pellet_location.mag() > 0) {
      // approach nearest pellet
      target_location = nearest_pellet_location.get(); // target_location is used in display() for drawing target_location lines
      approach_target();
      old_energy = energy;
    } else {
      // approach mouse
      target_location.x = mouseX;
      target_location.y = mouseY;
      approach_target();
    }
  }

  void display() {
    // this supplements world.draw()
    float xc = body.getX();
    float yc = body.getY();
    float heading = body.getRotation();

    // show energy
    fill(cfill);
    textAlign(LEFT);
    String estr = "energy: " + nf(energy, 0, 0);
    text(estr, xc + 20, yc + 7); 

    // draw head
    pushMatrix();
    translate(xc, yc);
    rotate(heading);
    fill(cfill);
    stroke(0);
    ellipse(12, 0, 8, 12);
    // eyes
    fill(0);
    ellipse(14, 5, 4, 4);
    ellipse(14, -5, 4, 4);
    popMatrix();

    // show line to target_location
    if (target_location.mag() > 0) {
      stroke(cfill, 100);
      line(xc, yc, target_location.x, target_location.y);
    }
  }

  /*
  ** SUPPORTING METHODS
   */

  void do_consumption() {
    ArrayList<FBody> hits = body.getTouching();
    for (int i=0; i<hits.size (); i++) {
      FBody hit = hits.get(i);
      String name = hit.getName();
      if (name != null && name.equals("pellet")) {
        energy += 1.0;
        old_energy++;
        world.remove(hit);
      }
      if (name != null && name.equals("invisible")) {
        energy += 5.0;
        world.remove(hit);
      }
    }
  }

  void approach_target() {

    // apply torque and thrust to approach
    // the bot's "target_location"

    // compute torque based on delta heading
    float heading = body.getRotation();
    PVector vector_to_target_location = new PVector(target_location.x - body.getX(), target_location.y - body.getY());
    // compute change in heading angle required to aim at target_location (between -PI and PI)
    float delta_heading = (vector_to_target_location.heading() - heading) % TWO_PI;
    if (delta_heading > PI) delta_heading -= TWO_PI;
    if (delta_heading < -PI) delta_heading += TWO_PI;

    // apply a torque based on delta_heading
    float torque = constrain(20*delta_heading, -max_torque, max_torque);
    body.addTorque(torque);

    // apply max_thrust when heading generally in the right direction, otherwise coast 
    if (abs(delta_heading) < HALF_PI) {
      body.addForce(max_thrust*cos(heading), max_thrust*sin(heading));
    }
  }
  
  void fetch_invisible() {
    text (invisible_got % 4, body.getX()-40, body.getY()-10);
    if (invisible_got % 4 != 0) {
      float currframe = ((frameCount/100.0) %10)-frameinit;
      if (energy == old_energy+5) {frameinit = currframe; invisible_got++;}
      old_energy = energy;
      float torque = constrain(fetch_direction*max_torque/currframe, -max_torque, max_torque);
      body.addTorque(torque);

      // apply max_thrust when heading generally in the right direction, otherwise coast
         float heading = body.getRotation(); 
        body.addForce(max_thrust*cos(heading), max_thrust*sin(heading));
    }
    else {
      float torque = constrain(2*random(-max_torque,max_torque), -max_torque, max_torque);
      if (energy == old_energy+5) {invisible_got++;}
      old_energy = energy;
      body.addTorque(torque);
             float heading = body.getRotation(); 
        body.addForce(max_thrust*cos(heading), max_thrust*sin(heading));
    }
  }

  void update_nearest_pellet_location() {

    float dmin = 99999.0; // a large number
    nearest_pellet_location.x = 0.0;
    nearest_pellet_location.y = 0.0;

    float bx = body.getX();
    float by = body.getY();

    // loop over all bodies looking for pellets
    ArrayList<FBody> bodies = world.getBodies();
    for (int i=0; i<bodies.size (); i++) {         
      FBody other = bodies.get(i); 
      String name = other.getName();
      if (name != null && name.equals("pellet")) {
        float px = other.getX();
        float py = other.getY();
        //float d = dist(bx, by, px, py);
        //float d = distVelo(bx, by, px, py, body.getVelocityX(), body.getVelocityY(), 0.0, 0.0);
        float d = distVelo(bx, by, px, py, 
                          cos(body.getRotation()+body.getVelocityX()), 
                          sin(body.getRotation()+body.getVelocityY()), 
                          0.0, 0.0);
        if (d < dmin) {
          dmin = d;
          nearest_pellet_location.x = px;
          nearest_pellet_location.y = py;
        }
      }
    }
  }
  
  float distVelo(float x1,float y1,float x2,float y2,float vx1,float vy1,float vx2,float vy2){
    return sqrt(pow(x1+vx1-x2-vx2,2)+pow(y1+vy1/2-y2-vy2/2,2));
  }
  
  void avoid_wall() {
    //wall_encounter += 2;
    float nX = ((FContact)body.getContacts().get(0)).getNormalX();
    float nY = ((FContact)body.getContacts().get(0)).getNormalY();
    float heading = body.getRotation();
    heading = floor(heading/PI)%2==0? heading : -1*heading;
    PVector normal = new PVector(nX,nY);
    float nH = normal.heading();
    //nH =  (abs(nH)>PI/2 && nH > 0) ? nH-PI/2 : nH+PI/2;
    float nH1 = nH-PI/2;
    float nH2 = nH+PI/2;
    //float delta_heading = (nH - heading) % TWO_PI;
    /*if ((cos(nH1) == cos(body.getRotation()) && sin(nH1) == sin(body.getRotation()))
     || (cos(nH2) == cos(body.getRotation()) && sin(nH2) == sin(body.getRotation()))) {
      float newHeading = body.getRotation();
      body.addForce(max_thrust*cos(newHeading), max_thrust*sin(newHeading));
    }*/
    float nH1T = atan(sin(nH1)/cos(nH1));
    float nH2T = atan(sin(nH2)/cos(nH2));
    float head = atan(sin(body.getRotation())/cos(body.getRotation()));
    //float delta_heading = (nH1T >= head) ? (nH2T - head) : (nH1T - head);
    float delta_headingx = (cos(nH1) - cos(head));
    float delta_headingy = (sin(nH1) - sin(head));
    float delta_heading = nH1T-head <= nH2T-head ? nH1T-head : nH2T-head;
    /*if (delta_heading == 0) {
      float newHeading = body.getRotation();
      body.addForce(max_thrust*cos(newHeading), max_thrust*sin(newHeading));
      return;
    }*/
    //float delta_heading = (abs((nH1 - heading) % TWO_PI) >= abs((nH2 - heading) % TWO_PI)) ? ((nH2 - heading) % TWO_PI) : ((nH1 - heading) % TWO_PI);
    //if (abs(delta_heading) < 0.1) wall_delay += 120-(wall_encounter);
    //if (wall_delay < 0) wall_delay = 0;
    line(body.getX(), body.getY(), body.getX()+100*cos(nH1), body.getY()+100*sin(nH1));
    line(body.getX(), body.getY(), body.getX()+50*cos(nH2), body.getY()+50*sin(nH2));
    line(body.getX(), body.getY(), body.getX()+100*cos(body.getRotation()), body.getY()+100*sin(body.getRotation()));
    text(delta_heading,body.getX()+10,body.getY()-20);
    text(sin(nH1) - sin(head),body.getX()+10,body.getY()-40);
    text(cos(nH1) - cos(head),body.getX()+10,body.getY()-60);
    //if (delta_heading > PI) delta_heading -= TWO_PI;
    //if (delta_heading < -PI) delta_heading += TWO_PI;
    
    //float torque = constrain(20*delta_heading, -max_torque, max_torque);
    //body.addTorque(torque);
    //float newHeading = body.getRotation();
    //body.addForce(max_thrust*cos(newHeading), max_thrust*sin(newHeading));


    /*PVector vector_to_target_location = new PVector(target_location.x - body.getX(), target_location.y - body.getY());
    // compute change in heading angle required to aim at target_location (between -PI and PI)
    float delta_heading2 = (vector_to_target_location.heading() - heading) % TWO_PI;
    if (delta_heading2 > PI) delta_heading2 -= TWO_PI;
    if (delta_heading2 < -PI) delta_heading2 += TWO_PI;*/

    // apply a torque based on delta_heading
    float torque = constrain(20*(delta_heading), -max_torque, max_torque);
    //float torque = constrain(2, -max_torque, max_torque);
    //if (wall_encounter > 60) torque = constrain(20*(3.0*PI/2), -max_torque, max_torque);
    body.addTorque(torque);
    float newHeading = body.getRotation();
    body.addForce(max_thrust*cos(newHeading), max_thrust*sin(newHeading));
    
  }
  void follow_wall() {
    wall_delay--;
    float heading = body.getRotation();
    body.addForce(max_thrust*cos(heading), max_thrust*sin(heading));
  }

}

