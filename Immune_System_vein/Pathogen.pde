class Pathogen extends Cell{
  /* 
    Very similar to parent cell class for now
    can add more differences later
  */
  PImage photo;
  PImage photo2;
  PImage photo3;
  PImage photo4;
  
  float spawnArea;
  Pathogen(float _radius, float _x, float _y, float _heading, float _pType) {
    super(2.0*_radius);
    setName("Pathogen");
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
    
    type = int(pType);
    radius = _radius;
    pType = _pType;
    //cfill = color(50, 150, 50);
    //body = new FCircle(2.0*radius);
    if (pType < 1) {
      
      setVelocity(0.05, 0.1);
      photo = loadImage("molecule12.png");
    attachImage(photo);
      cfill = color(0, 204, 204);
    } else if (pType > 1 && pType < 2) {
      setVelocity(0.1, 0.15);
       photo2 = loadImage("life.png");
    attachImage(photo2);
      cfill = color(127, 0, 255);
    } else if (pType > 2 && pType < 3) {
       photo3 = loadImage("cell1.png");
    attachImage(photo3);
      setVelocity(0.15, 0.2);
      cfill = color(0, 255, 0);
    } else {
      setVelocity(0.2, 0.25);
      cfill = color(255, 0, 255);
      photo4 = loadImage("cells.png");
    attachImage(photo4);
    }
    spawnArea = random(-1, 1);
    if (spawnArea > 0) spawnArea = 1;
    else spawnArea = -1;
    // body properties
    target_location = new PVector(0,0);
    setFillColor(cfill);   
    setPosition(_x, _y);
    setRotation(_heading);
    
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
    setPosition(width/2 + (spawnArea*(random(10, width/3-10))), height/2 + (spawnArea*(random(0, height/3))));
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
    println("");
    println("XXXX");
    ArrayList<FBody> contacts = new ArrayList<FBody>();
    contacts = getTouching();
    for(FBody c : contacts) {
      //pathogen behaviors
      if (c instanceof B_Cell) {
        println("            RRRRRRR");
        ((R_Cell)c).controller.transitionTo(spawn);
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

