class Pathogen extends Cell{
  /* 
    Very similar to parent cell class for now
    can add more differences later
  */
  float spawnArea;
  Pathogen(float _radius, float _x, float _y, float _heading, float _pType) {
    super(2.0*_radius);
    
    // these attributes facilitate cell identification and learning, please edit according to need.  
    numMarkers = 1;
    numReceptors = 1;
    surfaceMarkers = new float[numMarkers];
    surfaceReceptors = new float[numReceptors];
    for (int i = 0; i < numMarkers; i++) {
      surfaceMarkers[i] = 1.0;
    }
    for (int i = 0; i < numReceptors; i++) {
      surfaceReceptors[i] = 0.0;
    }
    
    
    radius = _radius;
    pType = _pType;
    //cfill = color(50, 150, 50);
    //body = new FCircle(2.0*radius);
    if (pType < 1) {
      setVelocity(0.05, 0.1);
      cfill = color(0, 204, 204);
    } else if (pType > 1 && pType < 2) {
      setVelocity(0.1, 0.15);
      cfill = color(127, 0, 255);
    } else if (pType > 2 && pType < 3) {
      setVelocity(0.15, 0.2);
      cfill = color(0, 255, 0);
    } else {
      setVelocity(0.2, 0.25);
      cfill = color(255, 0, 255);
    }
    spawnArea = random(-1, 1);
    if (spawnArea > 0) spawnArea = 1;
    else spawnArea = -1;
    // body properties
    target_location = new PVector(0,0);
    setFillColor(cfill);   
    setPosition(_x, _y);
    setRotation(_heading);
    setName("Pathogen");
    setDamping(3.0);
    setAngularDamping(10.0);
    world.add(this);
    
    // initialize sensory and motor systems
    sensors = new SensorySystem(this);
    motors  = new MotorSystem(this);
    
    // initialize controller
    ticks = 0;
   controller = new FSM(spawn);     
  }
  
  void enterSpawn() {
    ticks = 0;
    spawnCount++;
    //setPosition(width/2 + (spawnArea*(random(50, width/2-50))), height/2 + (spawnArea*(random(height/6, height/3))));
    setPosition(width/2+random(-70,70), height/2+random(-70,70));
  }
  void doSpawn() {
    controller.transitionTo(wander);
  }
  void exitSpawn() {
  }
  
  void enterCellContact(){
    ticks = 0;
  }
  void doCellContact(){
    ticks++;
    ArrayList<FBody> contacts = new ArrayList<FBody>();
    contacts = getTouching();
    for(FBody c : contacts) {
      //pathogen behaviors
      if (c instanceof Cell) {
        if (((Cell)c).surfaceMarkers[0] == ((Cell)this).surfaceReceptors[0]) {
          print("red blood cell found");
          //t.removeFromWorld();
          world.remove(c);
          r_cells.remove(c);
          println(r_cells.size());
        }
      }
    }
    controller.transitionTo(wander);
  }
  void exitCellContact(){}
  
  void enterCellBehavior(){
    ticks = 0;
  }
  void doCellBehavior(){
    ticks++;
    ArrayList<FJoint> joints = new ArrayList<FJoint>();
    joints = getJoints();
    for (int i = joints.size () - 1; i >= 0; i--) {
      //pathogen behaviors 
      
    }
    controller.transitionTo(wander);
  }
  void exitCellBehavior(){}
  
}

