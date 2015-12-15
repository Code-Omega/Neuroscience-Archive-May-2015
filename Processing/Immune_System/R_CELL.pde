class R_Cell extends Cell{
  /* 
    Very similar to parent cell class for now
    can add more differences later
  */
  R_Cell(float _radius, float _x, float _y, float _heading) {
    super(2.0*_radius);
    
    // these attributes facilitate cell identification and learning, please edit according to need.  
    numMarkers = 1;
    numReceptors = 0;
    surfaceMarkers = new float[numMarkers];
    surfaceReceptors = new float[numReceptors];
    for (int i = 0; i < numMarkers; i++) {
      surfaceMarkers[i] = 0.0;
    }
    for (int i = 0; i < numReceptors; i++) {
      surfaceReceptors[i] = 0.0;
    }
    radius = _radius;
    cfill = color(250, 50, 50);
    //body = new FCircle(2.0*radius);
    target_location = new PVector(0,0);
    setFillColor(cfill);   
    setPosition(_x, _y);
    setRotation(_heading);
    
    // body properties
    setDamping(3.0);
    setAngularDamping(10.0);
    setName("B_Cell");
    world.add(this);
    
    // initialize sensory and motor systems
    sensors = new SensorySystem(this);
    motors  = new MotorSystem(this);
    
    // initialize controller

   controller = new FSM(spawn);    
  }
  
    /*NEW FSM*/
  void enterSpawn(){
    ticks = 0;
    spawnCount++;
    //setVelocity(-500,0);
    setPosition(width-width/6+random(-70,70), height-height/6+random(-70,70));
    setRotation(PI);
  }
  void doSpawn(){
    /*if(getX() > width){ 
      setVelocity(-100,0);
      //motors.thrust = motors.max_thrust;
    }
    else*/ controller.transitionTo(wander);
  }
  void exitSpawn(){}
  
  void enterCellContact(){
    ticks = 0;
  }
  void doCellContact(){
    /*ticks++;
    boolean isbinding = false;
    ArrayList<FBody> contacts = new ArrayList<FBody>();
    contacts = getTouching();
    for(FBody c : contacts) {
      if(c instanceof Pathogen) {
        bindPathogen(this, c);
        isbinding = true;
      }
    }
    if (isbinding) controller.transitionTo(cellBehavior);
    else */controller.transitionTo(wander);
  }
  void exitCellContact(){}
  
  void enterCellBehavior(){
    ticks = 0;
  }
  void doCellBehavior(){
    /*ticks++;
    ArrayList<FJoint> joints = new ArrayList<FJoint>();
    joints = getJoints();
    for (int i = joints.size () - 1; i >= 0; i--) {
      FJoint j = joints.get(i);
      FBody t = j.getBody2();
      
      // surface marker identification (currently very simple)
      // need to iterate around both arrays (nested for loop)
      // in order to check all possible markers and receptors
      // different markers and receptors should mean different things
      // inplement them either here or by adding more surface protein types in Cell class
      if (t instanceof Cell) {
        if (((Cell)t).surfaceMarkers[0] == ((Cell)this).surfaceReceptors[0]) {
          print("match found");
          //t.removeFromWorld();
          world.remove(t);
          //a_pathogens.remove(t);
          println(a_pathogens.size());
        }
      }
    }*/
    controller.transitionTo(wander);
  }
  void exitCellBehavior(){}
  
}

