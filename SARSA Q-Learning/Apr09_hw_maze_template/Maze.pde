class Maze {
  int nx, ny;       // number of cells in each direction
  int w;            // cell size (pixels)
  float[][] xc, yc; // cell coordinates (center)
  int[][] val;      // cell value
  int WALL_VAL = -10;
  int EMPTY_VAL = -1;
  int REWARD_VAL = 100;

  Maze() {
    nx = 10;
    ny = 10;
    w = 50;
    xc = new float[nx][ny];
    yc = new float[nx][ny];
    val = new int[nx][ny];

    for (int j=0; j<ny; j++) {
      for (int i=0; i<nx; i++) {
        xc[i][j] = w*i + w/2;
        yc[i][j] = w*j + w/2;
        val[i][j] = EMPTY_VAL;
      }
    }
    
    // walls
    add_perimeter();
    add_internal();
    
    // place reward in upper right corner
    val[nx-2][1] = REWARD_VAL;
  }

  void add_perimeter() {
    for (int j=0; j<ny; j++) {
      for (int i=0; i<nx; i++) {
        if (i==0 || i == nx-1 || j == 0 || j == ny-1) {
          val[i][j] = WALL_VAL;
        }
      }
    }
  }
  
  void add_internal() {
    for (int i:new int[]{6})           val[i][1] = WALL_VAL;
    for (int i:new int[]{1,2,4,8})     val[i][2] = WALL_VAL;
    for (int i:new int[]{2,4,5,6,})    val[i][3] = WALL_VAL;
    for (int i:new int[]{7})           val[i][4] = WALL_VAL;
    for (int i:new int[]{1,2,3,4,6,8}) val[i][5] = WALL_VAL;
    for (int i:new int[]{8})           val[i][6] = WALL_VAL;
    for (int i:new int[]{2,3,4,5,6,7}) val[i][7] = WALL_VAL;
  }
  
  boolean isWall(int ix, int iy) {
    return (val[ix][iy] == WALL_VAL);
  }
  
  void showReward(float x, float y){
    fill(0, 255,0);
    textAlign(CENTER, CENTER);
    textSize(26);
    text("R", x, y);
  }


  void display() {
    fill(255);
    textAlign(CENTER,CENTER);
    stroke(50);
    for (int j=0; j<ny; j++) {
      for (int i=0; i<nx; i++) {     
        if (val[i][j] == REWARD_VAL) {
          showReward(xc[i][j], yc[i][j]);
        }
        if (val[i][j] == WALL_VAL) {
          fill(100, 150, 250);
          rect(xc[i][j]-w/2, yc[i][j]-w/2, w, w);
        } else {
          fill(255);
          noFill();
          rect(xc[i][j]-w/2, yc[i][j]-w/2, w, w);
        }
        if(showV) {
          fill(255);
          textSize(12);
          text(val[i][j], xc[i][j], yc[i][j]);
        }
        if(showQ) {
          int s = i + ny*j; // state
          if(val[i][j] != WALL_VAL){
            fill(0,255,255);
            textAlign(CENTER, CENTER);
            textSize(9);
            // EAST
            pushMatrix();
            translate(xc[i][j]+20, yc[i][j]);
            rotate(HALF_PI);
            text(nf(bot.Q[s][EAST],0,1), 0, 0);
            popMatrix();
            // SOUTH
            pushMatrix();
            translate(xc[i][j], yc[i][j]+20);
            rotate(0);
            text(nf(bot.Q[s][SOUTH],0,1), 0, 0);
            popMatrix();
            //WEST
            pushMatrix();
            translate(xc[i][j]-20, yc[i][j]);
            rotate(-HALF_PI);
            text(nf(bot.Q[s][WEST],0,1), 0, 0);
            popMatrix();
            // NORTH
            pushMatrix();
            translate(xc[i][j], yc[i][j]-20);
            rotate(0);
            text(nf(bot.Q[s][NORTH],0,1), 0, 0);
            popMatrix();   
          }
        }
      }
    }
  }
}


