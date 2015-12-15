class B_Cell extends Cell{
  /* 
    Very similar to parent cell class for now
    can add more differences later
  */
  PImage photo;
  float[] receptorUtility;
  float[] receptorProbablity;
  float lastReceptorType;
  
          //##############################################################################################################
          float FakeReward = 0;
          //##############################################################################################################
  
  B_Cell(float _radius, float _x, float _y, float _heading) {
    super(3.0*_radius);
    type = 4;
        setName("B_Cell");
    beta = random(0,1);
    epsilon = random(0,1);
    // these attributes facilitate cell identification and learning, please edit according to need.  
    numMarkers = 1;
    numReceptors = 2;
    lastReceptorType = 0;
    expRewardDestroy = new float[6];
    expRewardSave = new float[6];
    for(int i = 0; i < 6; i++) expRewardDestroy[i] = 0;
     for(int i = 0; i < 6; i++) expRewardSave[i] = 1;
    photo = loadImage("WhiteBloodCell.png");
    attachImage(photo);
    radius = _radius;
    cfill = color(250, 150, 50);
    //body = new FCircle(2.0*radius);
    target_location = new PVector(0,0);
    setFillColor(cfill);   
    setPosition(_x, _y);
    setRotation(_heading);
    
    // body properties
    setDamping(3.0);
    setAngularDamping(10.0);

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
    setVelocity(-500,0);
    setPosition(width + random (10,100), random(height/3 + 40,2*height/3 - 40));
    setRotation(PI);
  }
  void doSpawn(){
    if(getX() > width){ 
      setVelocity(-100,0);
      //motors.thrust = motors.max_thrust;
    }
    else controller.transitionTo(wander);
  }
  void exitSpawn(){}
  
  void enterCellContact(){
    ticks = 0;
  }
  void doCellContact(){
    ticks++;
    boolean isbinding = false;
    ArrayList<FBody> contacts = new ArrayList<FBody>();
    contacts = getTouching();
    for(FBody c : contacts) {
      //if(c instanceof Pathogen) {
      ////##############################################################################################################
      if(c instanceof Cell) {
        bindPathogen(this, c);
        isbinding = true;
      }
    }
    if (isbinding) controller.transitionTo(cellBehavior);
    else controller.transitionTo(wander);
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
      FJoint j = joints.get(i);
      FBody t = j.getBody2();
      
      // surface marker identification (currently very simple)
      // need to iterate around both arrays (nested for loop)
      // in order to check all possible markers and receptors
      // different markers and receptors should mean different things
      // inplement them either here or by adding more surface protein types in Cell class
      if (t instanceof Cell) {
        //if (((Cell)t).surfaceMarkers[0] == ((Cell)this).surfaceReceptors[1]) {
        int cellType = ((Cell)t).type;
        if (save_destroy(cellType) && cellType < 4) {
          print("match found");
          if (t instanceof Pathogen){
          //t.removeFromWorld();
          world.remove(j);
          //((Pathogen)t).controller.transitionTo(spawn);
          }
        }
        else world.remove(j);
      }
    }
    controller.transitionTo(wander);
  }
  void exitCellBehavior(){}
  
  
  void learningupdate(){
   
  }
  boolean save_destroy(int type){
    float probDestroy = 1/(1+exp(-beta*(expRewardDestroy[type]-expRewardSave[type])));
    return (random(0,1) < probDestroy);
  }
}

