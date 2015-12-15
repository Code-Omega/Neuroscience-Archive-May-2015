import fisica.*;
FWorld world;
int NBCELL =30;
int NPATHOGEN_A =20;
int NRCELL =50;
int avgAge;
int total = 0;
//
ArrayList<B_Cell> b_cells = new ArrayList<B_Cell>(NBCELL);
ArrayList<Pathogen> a_pathogens = new ArrayList<Pathogen>(NPATHOGEN_A);
ArrayList<R_Cell> r_cells = new ArrayList<R_Cell>(NRCELL);
float[] numRedCellCount = new float[20];

void setup() {
  setup_world();
  setup_immuneB();
  setup_pathogen();
  setup_walls();
  setup_redBlood();
  for (int i = 0; i < 20; i++) {
    numRedCellCount[i] = r_cells.size();
  }
}
void setup_immuneB() {
  for (int i=0; i<NBCELL; i++) {
    B_Cell b = new B_Cell(12.5, width-i*30-30, height/random(1.4, 2.9), random(TWO_PI));
    b_cells.add(b);
  }
}
void setup_pathogen() {
  for (int i=0; i<NPATHOGEN_A; i++) {
    Pathogen b = new Pathogen(12.5, i*30, height/random(1.4, 2.9), random(TWO_PI), random(0, 4));
    a_pathogens.add(b);
  }
}
void setup_redBlood() {
  for (int i=0; i<NRCELL; i++) {
    R_Cell r = new R_Cell(12.5, width-i*30-30, height/random(1.4, 2.9), random(TWO_PI));
    r_cells.add(r);
  }
}
void setup_world() {
  size(800, 800);
  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0.0, 0.0);


  world.setEdgesFriction(1.0);
  world.setEdgesRestitution(0.1);
}
void setup_walls() {
  float[][] dat = { 
    {
      width*2, 30, width*2, .6666*height, 0
    }
    , 
    {
      width*2, 30, width*2, .33333*height, 0
    }
    , 
    {
      30, height, 3*width, height/2, 0
    }
    , 
    {
      width/1.5, 20., width/3, 0.66666*height, 0
    }
    , 
    {
      width/5, 20., 9*width/10, 0.66666*height, -0
    }
    , 
    {
      width/1.5, 20., 2*width/3, 0.333333*height, 0
    }
    , 
    {
      width/5, 20., width/10, 0.333333*height, -0
    }
    , 
    {
      width, 20., width/2, 0, -0
    }
    , 
    {
      width, 20., width/2, height, -0
    }
    , 
    {
      20, height/3., 0, height/6, -0
    }
    , 
    {
      20, height/3., width/2, 5*height/6, -0
    }
    , 
    {
      20, height/3., width/2, height/6, -0
    }
    , 
    {
      20, height/3., width, 5*height/6, -0
    }
    ,
  };
  for (int i=0; i<dat.length; i++) {
    FBox w = new FBox(dat[i][0], dat[i][1]);
    w.setPosition (dat[i][2], dat[i][3]);
    w.setRotation(dat[i][4]);
    w.setFriction(1.0);
    w.setRestitution(0.1);
    w.setFill(50, 50, 50);
    //w.setDensity(1000.);
    w.setStatic(true);
    w.setName("wall");
    world.add(w);
  }
  /*float[][] dat = { 
   //{20, height/3. ,width/2, height/3,    PI/2},
   {20, height/8. ,width/2-width/10, height/3,    PI/2},
   {20, height/8. ,width/2+width/10, height/3,    PI/2},
   
   {20, height/3. ,width/3, height/2,    -0},
   {20, height/3. ,width/2, 2*height/3,  PI/2},
   {20, height/3. ,2*width/3, height/2,  -0},
   };*/
  for (int i=0; i<dat.length; i++) {
    FBox w = new FBox(dat[i][0], dat[i][1]);
    w.setPosition (dat[i][2], dat[i][3]);
    w.setRotation(dat[i][4]);
    w.setFriction(1.0);
    w.setRestitution(0.1);
    w.setFill(50, 50, 50);
    //w.setDensity(1000.);
    w.setStatic(true);
    w.setName("wall");
    world.add(w);
  }
}
void draw() {
  background(250);
  for (B_Cell b : b_cells) { 
    b.update();
  }
  for (Pathogen p : a_pathogens) {
    p.update();
  }
  for (R_Cell r : r_cells) { 
    r.update();
  }
  world.step();
  world.draw();
  for (int i = 0; i < 19; i++) {
    numRedCellCount[i] = numRedCellCount[i+1];
  }
  numRedCellCount[19] = r_cells.size();
  for (int i = 0; i < 20; i++) {
    print(numRedCellCount[i]);
  }
  println("");
  textSize(20);
  String redCellsCount = "Red Blood Cell Count: " + r_cells.size();
  fill(250, 50, 50);
  text(redCellsCount, 500, 30);
  for (R_Cell r : r_cells) { 
    int curr = r.age;
    total = curr + total;
    avgAge = (total/r_cells.size());
  }
  String redCellsAge = "Red Blood Average Age: " + avgAge;
  fill(250, 50, 50);
  text(redCellsAge, 450, 50);
};

