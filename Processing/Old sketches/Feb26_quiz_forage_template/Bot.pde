class Bot {

  FPoly   body;
  color   cfill;
  float   energy;
  PVector nearest_pellet_location;
  PVector target_location;
  float  max_torque = 10.0;
  float  max_thrust = 200.0;

  Bot() {
    // initialization
    cfill = color(200, 150, 50);
    energy = 0.0;
    nearest_pellet_location = new PVector(0.0, 0.0); 
    target_location = new PVector(0.0, 0.0); 

    // make a polygon bug body
    body = new FPoly();
    float hl = 16; // half length
    float hw = 8;  // half width (at center)
    body.vertex(hl, -hw/2);
    body.vertex( 0., -hw);
    body.vertex(-hl, -hw/2);
    body.vertex(-hl-3, 0);  // "tail" extension
    body.vertex(-hl, hw/2);
    body.vertex(0., hw);
    body.vertex(hl, hw/2);

    // set physics properties
    body.setPosition(random(50, width-50), random(50, height-50));
    body.setFillColor(cfill);
    body.setDamping(3.0);
    body.setAngularDamping(10.0);
    world.add(body);
  }

  void update() {
    do_consumption();
    update_nearest_pellet_location(); 

    if (nearest_pellet_location.mag() > 0) {
      // approach nearest pellet
      target_location = nearest_pellet_location.get(); // target_location is used in display() for drawing target_location lines
      approach_target();
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
    ellipse(17, 0, 8, 12);
    // eyes
    fill(0);
    ellipse(18, 5, 4, 4);
    ellipse(18, -5, 4, 4);
    popMatrix();

    // show line to target_location
    if (target_location.mag() > 0) {
      stroke(cfill, 100);
      line(xc, yc, target_location.x, target_location.y);
    }
  }
  
  void approach_target() {
    // *** MODIFY THIS CODE ***
    // apply torque and thrust to approach the "target_location"
    // do not exceed max_torque or max_thrust
    
    // this code just drives the bot in a noisy circle
    float heading = body.getRotation();
    //body.addTorque(random(max_torque));
    PVector dist = new PVector (target_location.x-body.getX(),target_location.y-body.getY());
    PVector dire = new PVector (cos(heading), sin(heading));
    PVector chan = PVector.sub(dist,dire);
      //text("z of cross: "+dist.cross(dire).z, body.getX() + 40, body.getY() + 57); 
      //text("desired heading: "+chan.heading(), body.getX() + 40, body.getY() + 27);
    if (dist.cross(dire).z < 0)
      //body.addTorque(constrain(dist.cross(dire).mag(),0,max_torque));
      body.addTorque(min(dist.cross(dire).mag(),max_torque));
    else if (dist.cross(dire).z > 0)
      //body.addTorque(constrain(-1.0*dist.cross(dire).mag(),0,-1.0*max_torque));
      body.addTorque(max(-1.0*dist.cross(dire).mag(),-1.0*max_torque));
    //body.addForce(max_thrust*cos(heading), max_thrust*sin(heading));
    if (abs(chan.heading()) < PI){
      //body.addTorque(min(dist.cross(dire).mag(),max_torque));
      body.addForce(max_thrust*cos(heading), max_thrust*sin(heading));
    }
    else if (abs(chan.heading()) > PI){
      //body.addTorque(max(-1.0*dist.cross(dire).mag(),-1.0*max_torque));
      body.addForce(-1.0*max_thrust*cos(heading), -1.0*max_thrust*sin(heading));
    }
  }

  //
  // SUPPORTING METHODS
  //

  void do_consumption() {
    // consume pellets and increment bot energy
    ArrayList<FBody> hits = body.getTouching();
    for (int i=0; i<hits.size (); i++) {
      FBody hit = hits.get(i);
      String name = hit.getName();
      if (name != null && name.equals("pellet")) {
        energy += 1.0;
        world.remove(hit);
      }
    }
  }

  

  void update_nearest_pellet_location() {
    // find the location of the nearest pellet
    // and update "nearest_pellet_location" variable

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
        float d = dist(bx, by, px, py);
        if (d < dmin) {
          dmin = d;
          nearest_pellet_location.x = px;
          nearest_pellet_location.y = py;
        }
      }
    }
  }

}

