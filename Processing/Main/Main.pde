import fisica.*;
FWorld world;
int NBCELL = 2;
int NPATHOGEN_A = 2;
//
ArrayList<B_Cell> b_cells = new ArrayList<B_Cell>(NBCELL);
ArrayList<Pathogen> a_pathogens = new ArrayList<Pathogen>(NPATHOGEN_A);

void setup() {
  setup_world();
  setup_immuneB();
  setup_pathogen();
  
}
void setup_immuneB(){
  for (int i=0; i<NBCELL; i++) {
    B_Cell b = new B_Cell(12.5, width/random(1,2), height/random(1,2), random(TWO_PI));
    b_cells.add(b);
  }
}
void setup_pathogen(){
  for (int i=0; i<NPATHOGEN_A; i++) {
    Pathogen b = new Pathogen(12.5, width/random(1,2), height/random(1,2), random(TWO_PI));
    a_pathogens.add(b);
  }
  
}
void setup_world() {
  size(700, 700);
  Fisica.init(this);
  world = new FWorld();
  world.setEdges();
  world.setEdgesFriction(0.0);
  world.setEdgesRestitution(0.3);
  world.setGravity(0.0, 0.0);
  world.left.setName("wall");
  world.right.setName("wall");
  world.top.setName("wall");
  world.bottom.setName("wall");
}

void draw(){
  background(50);
  for(B_Cell b : b_cells) b.update();
  world.step();
  world.draw();
}
