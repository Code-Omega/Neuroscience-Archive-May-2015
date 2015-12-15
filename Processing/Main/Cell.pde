class Cell extends FCircle{
  float radius;
  color cfill;
  float dir;
  PVector target_location;
  MotorSystem motors;
  SensorySystem sensors;
  FSM controller;
  int ticks = 0;
  //Specify States - State 'state' = new State(this, "state", "enterState", "doState", null) CAN BE SPECIFIED IN SUB-CLASSES AS WELL
  State wander = new State(this, "wander", "enterWander", "doWander", null);
  //Constructor (none for parent class)
  
  Cell(float _diameter) {
    super(_diameter);   
  }


  void update() {
    sensors.update();
    controller.update();
    motors.update();
    ArrayList<FBody> contacts = new ArrayList<FBody>();
    contacts = getTouching();
    for(FBody c : contacts) {
      if(c instanceof Cell) {
        bindPathogen(this, c);
        println("Cell binded");
         println(((Cell)c).radius);
      }
      else println("in contact with non-cell");
      
    }
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
    motors.thrust = motors.max_thrust;
    motors.torque = 5*randomGaussian();

    // FSM transitions
    ticks++;
    if (sensors.numContacts > 0) {
      //change state
    }
  }
  
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
  }
}

