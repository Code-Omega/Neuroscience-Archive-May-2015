class FlowField {

  PVector[][] field;
  int cols, rows;
  int res;
 
  FlowField(int _res) {
    res = _res;
    cols = width/res;
    rows = height/res;
    field = new PVector[cols][rows];
    init();
  }
 
  void init() {
    float xoff = random(10000);
    for (int i = 0; i < cols; i++) {
      float yoff = random(10000);
      for (int j = 0; j < rows; j++) {
        //float theta = map(noise(xoff,yoff),0,1,0,TWO_PI);
        //float theta = PI*(1.0*i*res/width*2)-PI;
        //field[i][j] = new PVector(cos(theta),sin(theta));
        field[i][j] = new PVector(1.0*i*res/width-0.5,1.0*j*res/height-0.5);
        field[i][j].rotate(HALF_PI);
        yoff += 0.1;
      }
      xoff += 0.1;
    }
  }
 
  PVector getFlow(PVector _pos) {
 
    int column = int(constrain(_pos.x/res,0,cols-1));
    int row = int(constrain(_pos.y/res,0,rows-1));
    return field[column][row].get();
  }
}
