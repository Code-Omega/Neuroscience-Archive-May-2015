class Cell extends FCircle{
  float pType;
  float radius;
  color cfill;
  float dir;
  int numMarkers;
  int numReceptors;
  float[] surfaceMarkers;
  float[] surfaceReceptors;
  int type;
  int age;
  float[] expRewardDestroy;
  float[] expRewardSave;
  float beta;
  float epsilon;
  PVector target_location;
  MotorSystem motors;
  SensorySystem sensors;
  FSM controller;
  
  
  int spawnCount = 0;
  int turnDuration;
  int turnDirection;
 
  int ticks = 0;
  //Specify States - State 'state' = new State(this, "state", "enterState", "doState", null) CAN BE SPECIFIED IN SUB-CLASSES AS WELL
    State wander = new State(this, "wander", "enterWander", "doWander", null);
  State contact = new State(this, "contact", "enterContact", "doContact", null);
  State cellContact = new State(this, "cellContact", "enterCellContact", "doCellContact", null);
  State cellBehavior = new State(this, "cellBehavior", "enterCellBehavior", "doCellBehavior", null);
  //State destroy = new State(this, "destroy", "enterDestroy", "doDestroy", null);
  State spawnRight = new State(this,"spawnRight", "enterSpawnRight", "doSpawnRight", null);
  State spawn = new State(this, "spawn", "enterSpawn", "doSpawn", null);
  //Constructor (none for parent class)
  
  Cell(float _diameter) {
    super(_diameter);   
    age = 0;
    setName("Cell");
  }


  void update() {
    sensors.update();
    controller.update();
    motors.update();
    if (this instanceof B_Cell) ((B_Cell)this).learningupdate();
     age += 1; 
    
  }

  void display() {
    // get bot position and heading
    float bx = getX();
    float by = getY();
    float heading = getRotation();

    // heading indicator line
    stroke(50);
    line(bx, by, bx+radius*cos(heading), by+radius*sin(heading));

    // state indicator
    pushStyle();
    fill(50);
    // compute offsets to make text visible
    float xoff;
    float yoff;
    if (bx < width/2) {
      textAlign(LEFT);
      xoff = bx + radius + 2;
    } else {
      textAlign(RIGHT);
      xoff = bx - radius - 2;
    }
    if (by < height/2) {
      yoff = by + radius + 2;
    } else {
      yoff = by - radius - 2;
    }
    /* text(controller.getCurrentState().name, xoff, yoff);*/
    popStyle();
  }






  /*PARENTAL FSMs GO HERE!!!! */

  void enterWander() {
    ticks = 0; // reset counter
  }

  void doWander() {   
    // wander
    float heading;
    

if (getY()>height /3 && getY() < 2*height /3) {
      heading = atan(getVelocityY()/getVelocityX());
      float headingTest = randomGaussian()*2;
      if (heading < headingTest && getVelocityX() < 0)motors.torque = (randomGaussian()+1)*motors.max_torque;
      if (heading < headingTest && getVelocityX() > 0)motors.torque = -(randomGaussian()+1)*motors.max_torque;
      if (heading >headingTest && getVelocityX() < 0)motors.torque = -(randomGaussian()+1)*motors.max_torque;
      if (heading > headingTest && getVelocityX() >0)motors.torque = (randomGaussian()+1)*motors.max_torque;

      motors.thrust = motors.max_thrust*(randomGaussian() + 1);
    } else {
      heading = getRotation() % 2*PI;
      motors.thrust = motors.max_thrust;
      motors.torque = 20*randomGaussian();
    }

    // FSM transitions
    ticks++;
    if (getX() < -40) {
      ArrayList<FJoint> joints = new ArrayList<FJoint>();
      joints = getJoints();
      for (int i = joints.size () - 1; i >= 0; i--) {
        world.remove(joints.get(i));
      }
      controller.transitionTo(spawnRight);
    }
    
    // FSM transitions
    ticks++;

    
    
   
    
    for (int i = 0; i < sensors.numContacts; i++) {
      if (sensors.numContacts > 0) {
        boolean tf = sensors.botContacts[i].getBody1().getName().equals("wall");
        if (tf) {  
          controller.transitionTo(contact);
        }
        else controller.transitionTo(cellContact);
      }
    }
  }
  void exitWander() {
  }

  void enterContact() {
    ticks = 0;
    turnDuration = (int)random(20, 40);
    turnDirection = (int)random(-1, 1);
  }
  void doContact() {
    ticks++;
    if (ticks < turnDuration) { 
      motors.torque = motors.max_torque; 
      motors.thrust = -motors.max_thrust;
    } else controller.transitionTo(wander);
  }
  void exitContact() {
  }

void enterSpawnRight (){
  ticks = 0;
  setPosition(width +random(10,200), getY());
}
void doSpawnRight(){
   if(getX() > width){ 
      setVelocity(-100,0);
      //motors.thrust = motors.max_thrust;
    }
    else controller.transitionTo(wander);
  }
  void exitSpawnRight(){}

  
  void bindPathogen(FBody B_Cell_, FBody Pathogen_) {
    FBody B_CELL1 = B_Cell_;
    FBody Pathogen1 = Pathogen_;
    FDistanceJoint j = new FDistanceJoint(B_CELL1, Pathogen1);
    //j.setLength(25);
    j.calculateLength();
    j.setNoStroke();
    j.setStroke(0);
    j.setFill(0);
    j.setDrawable(false);
    j.setFrequency(10);
    world.add(j);
    print("bind");
  }
}

