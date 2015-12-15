class B_Cell extends Cell{
  /* 
    Very similar to parent cell class for now
    can add more differences later
  */
  B_Cell(float _radius, float _x, float _y, float _heading) {
    super(2.0*_radius);
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
    world.add(this);
    
    // initialize sensory and motor systems
    sensors = new SensorySystem(this);
    motors  = new MotorSystem(this);
    
    // initialize controller

   controller = new FSM(wander);    
  }
}

