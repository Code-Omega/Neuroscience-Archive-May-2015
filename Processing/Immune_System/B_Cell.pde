class B_Cell extends Cell{
  /* 
    Very similar to parent cell class for now
    can add more differences later
  */
  PImage photo;
  float[] receptorUtility;
  float[] receptorProbablity;
  float epsilon = 0.1;
  float beta = 0.5;
  float lastReceptorType;
  
          //##############################################################################################################
          float FakeReward = 0;
          //##############################################################################################################
  
  B_Cell(float _radius, float _x, float _y, float _heading) {
    super(2.0*_radius);
    
    // these attributes facilitate cell identification and learning, please edit according to need.  
    numMarkers = 1;
    numReceptors = 2;
    lastReceptorType = 0;
    surfaceMarkers = new float[numMarkers];
    surfaceReceptors = new float[numReceptors];
    receptorUtility = new float[numReceptors];
    receptorProbablity = new float[numReceptors];
    for (int i = 0; i < numMarkers; i++) {
      surfaceMarkers[i] = 2.0;
    }
    for (int i = 0; i < numReceptors; i++) {
      surfaceReceptors[i] = 1.0*i;
      receptorUtility[i] = 0;
      receptorProbablity[i] = 1.0/numReceptors;
    }
    photo = loadImage("a.png");
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
    setPosition(width/6+random(-70,70), height/6+random(-70,70));
    setRotation(TWO_PI);
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
        if (((Cell)t).surfaceMarkers[0] == ((B_Cell)this).selectedCell()) {
          print("match found");
          //t.removeFromWorld();
          world.remove(t);
          a_pathogens.remove(t);
          println(a_pathogens.size());
          lastReceptorType =  ((Cell)t).surfaceMarkers[0];
          //##############################################################################################################
          if (((Cell)t).surfaceMarkers[0] == 0)
            FakeReward = -10;
          if (((Cell)t).surfaceMarkers[0] == 1)
            FakeReward = 10;
          //##############################################################################################################
        }
        else world.remove(j);
      }
    }
    controller.transitionTo(wander);
  }
  void exitCellBehavior(){}
  
  
  void learningupdate(){
    //float reward = numRedCellCount[numRedCellCount.length-1]-numRedCellCount[0];
    if (FakeReward > 0 ) {
    
    float reward = FakeReward;
      
    receptorUtility[(int)floor(lastReceptorType)] += epsilon * (reward - receptorUtility[(int)floor(lastReceptorType)]);

    /*receptorProbablity[0] = 1.0 / (1.0 + 2.0 * exp(beta * ((expected_green + expected_blue)/2 - expected_red)));
    receptorProbablity[1] = ((1.0 - prob_red) / (1.0 + exp(beta * (expected_blue - expected_green))));
    receptorProbablity[2] = 1.0 - prob_red - prob_green;*/
    receptorProbablity[0] = 1.0 / (1.0 + exp(beta * (receptorUtility[1] - receptorUtility[0])));
    receptorProbablity[1] = 1.0 - receptorUtility[0];
    
    FakeReward = 0;
    }
  }
  
  float selectedCell(){
    float selector = random(1.0);
    return (selector < receptorProbablity[0]) ? 0.0 : 1.0;
   
  }
  
}

